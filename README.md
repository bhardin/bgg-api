bgg gem [![Build Status](https://travis-ci.org/jemiahlee/bgg.svg)](https://travis-ci.org/jemiahlee/bgg) [![Code Climate](https://codeclimate.com/github/jemiahlee/bgg.png)](https://codeclimate.com/github/jemiahlee/bgg)
===========

An object-oriented API for interacting with the [boardgamegeek](http://boardgamegeek.com) [XML Version 2 API](http://boardgamegeek.com/wiki/page/BGG_XML_API2).

This is based on a fork of earlier work I had done on
[bgg-api](http://github.com/bhardin/bgg-api), along with Brett and a few
other contributors.

## Versions supported

Please note that this code uses Ruby 1.9 hash syntax and thus does not
support versions earlier than that.

## Installing the Gem

Do the following to install the  [bgg gem](http://rubygems.org/gems/bgg) Ruby Gem.

Add the following to your `Gemfile`:

```ruby
gem "bgg"
```

Then run `bundle install` from the command line:

    bundle install

## Using the Gem

Require the gem at the top of any file you want to use.

    require 'bgg'

You can either use the low level basic api and then parse the XML document in a way that suits your needs,
or you can use the specialized methods

There are object types and subtypes for many of the APIs documented at
[BGG_XML_API2](http://boardgamegeek.com/wiki/page/BGG_XML_API2), but not all of them are implemented.
Everything around a user and their game collection should work, as well
as generalized searching for board games.

### Requesting Data

There are a few ways to request data from the api.

#### Simple requests

BggApi is the root entry point to the different api calls.

```ruby
BggApi.collection 'username' # Default call 
BggApi.collection('username', { brief: 1 }) # Adding params based on api documentation
```

#### Predefined requests

These are here to make it so you do not need to know the bgg xml api. To
get the same as above.

```ruby
Bgg::Request::Collection.board_games('username').brief.get
Bgg::Request::Collection.board_games('username', { brief: 1 }).get # You can still pass params here if you want
```

#### The long way

If you would like to pass around the request objects, this is a longer
method to do so.

```ruby
my_request = Bgg::Request::Collection.new('username')
my_request.add_params({ brief: 1 })
my_collection = my_request.get
```

### Working with Results

Each api method has it's own data structure, although there is some
common themes.

There is a possibilty that there may be data for
one item and not another if the original bgg record is missing it.  For
instance a user has not rated an item in their collection.  In these
cases we return nil.

Another possible reason to get nil is if you pull a data item from the
result set when there is a needed request param.  For example, to get
the user_rating for a collection item you need to specify stats: 1, or
all_fields.

#### Enumerated Objects

Most results return an enumerated root object (Although not all).
The child object will always inherit from Bgg::Result::Item.

```ruby
my_collection.count
my_collection.first.user_rating  # Returns a collection item object
```

#### Custom methods

Weather or not they are enumerated all have their own attributes and/or methods.

```ruby
my_collection.played # Returns array of played items
```

#### XML always available

Sometimes it is easier to pull out what you want specifically then
to try and get only what the objects provide.  So if you need it
the XML is always available at any level.  Since we are using Nokogiri
this will enable it's methods and return values to you.

```ruby
my_collection.xml.xpath('items/item/stats/@minplayers') # All items minimum number of players
my_collection.first.xml.xpath('stats/ranks/rank/@value') # All rankings for an item
```

### Collection

Objects for collection

#### Bgg::Request::Collection

```ruby
request = Bgg::Request::Collection.board_games('username', { params: hash })
request = Bgg::Request::Collection.board_game_expansions('username', { params: hash })
request = Bgg::Request::Collection.rpgs('username', { params: hash })
request = Bgg::Request::Collection.video_games('username', { params: hash })
request.all_fields # Adds params to the bgg call that will request all data possible, returns self
request.brief # Adds params to the bgg call that will request a smaller subset of data, returns self
request.add_params( { params: to_add } ) # Adds params to the bgg call
result = request.get # Execute bgg call and return result
```

#### Bgg::Result::Collection

These might return nil if missing data or request params.  See [Working with Results](#working-with-results)

* Methods
  * owned, items marked as owned
  * played, items that have at least one play
  * user_rated, items that have a user_rating
  * user_rated 5, items that have a value of 5 (with decimal places dropped) 
  * user_rated 3..5, items that are between 3 and 5 (with decimal places dropped) 

#### Bgg::Result::Collection::Item

These might return nil if missing data or request params.  See [Working with Results](#working-with-results)

* Attributes
  * Array: theme_ranks (array of Rank objects)
  * Floats: average_rating, bgg_rating, user_rating
  * Integers: collection_id, id, own_count, play_count, play_time, type_rank, year_published
  * Range: players (minimum..maximum players)
  * Strings: comment, image, name, thumbnail, type
  * Time: last_modified
* Methods
  * Booleans: for_trade?, owned?, played?, preordered?, published?,
    wanted? want_to_buy?, want_to_play?

#### Bgg::Result::Collection::Item::Rank

* Attributes
  * Float: rating
  * Integers: id (ID of theme), rank
  * String: title (Title of theme)

### Hot

Objects for hot items

#### Bgg::Request::Hot

```ruby
request = Bgg::Request::Hot.board_game_companies
request = Bgg::Request::Hot.board_game_people
request = Bgg::Request::Hot.board_games
request = Bgg::Request::Hot.rpg_companies
request = Bgg::Request::Hot.rpg_people
request = Bgg::Request::Hot.rpgs
request = Bgg::Request::Hot.video_game_companies
request = Bgg::Request::Hot.video_games
request = Bgg::Request::Hot.new( { type: 'boardgamecompany' } ) # Instead of using built in method
request = Bgg::Request::Hot.new # Defaults to board games
result = request.get # Execute bgg call and return result
```

#### Bgg::Result::Hot

* Attributes
  * Strings: type

#### Bgg::Result::Hot::Item

* Attributes
  * Integers: id, rank, year_published
  * Stings: name, thumbnail, type
* Methods
  * game - request game based on id

### Plays

Objects for plays are a little deep.  Plays has a play and a play has players and players have a player.

#### Bgg::Request::Plays
Must have either username or thing id present, or both

```ruby
request = Bgg::Request::Plays.board_game_expansions 'username', 1234 #Thing ID
request = Bgg::Request::Plays.board_game_implementations 'username', nil
request = Bgg::Request::Plays.board_games nil, 1234 #Thing ID
request = Bgg::Request::Plays.rpgs 'username', nil
request = Bgg::Request::Plays.video_games 'username', nil, { params: hash }
request = Bgg::Request::Plays.new( 'username', nil, { type: 'boardgame' } ) # Instead of using built in method
request.date Date.parse('01-01-2001)  # Adds a date to restrict to
request.date Range  # Can be a date range as well
request.page 2 # Restricts to which page to pull back, pages are limited to 100 items
result = request.get # Execute bgg call and return result
```

#### Bgg::Result::Plays

* Attributes
  * Integers: page, thing_id, total_count
  * Strings: username
* Methods
  * find_by_date - search current results page for date or date range
  * find_by_location - search current results page for location
  * find_by_thing_id - search current results page for thing_id
  * find_by_thing_name - search current results page for thing_name
  * board_game_expansions - search current results page for board game expansions
  * board_game_implementations
  * board_games
  * rpg_items
  * video_games

#### Bgg::Result::Plays::Play

* Attributes
  * Array: types
  * Dates: date
  * Integers: id, length, quantity
  * Stings: comment, location, name
* Methods
  * Booleans: now_in_stats?, incomplete?
  * type - first subtype
  * game - request game based on id
  * players - enumerable of all the players

#### Bgg::Result::Plays::Play::Player
* Attributes
  * Float: rating
  * Integer: id, score
  * String: color, name, start_position, username
* Methods
  * Booleans: new?, winner?

### Search

Objects for search

#### Bgg::Request::Search

```ruby
request = Bgg::Request::Search.board_games('query', { params: hash })
request = Bgg::Request::Search.board_game_expansions('query', { params: hash })
request = Bgg::Request::Search.rpg_issues('query', { params: hash })
request = Bgg::Request::Search.rpg_items('query', { params: hash })
request = Bgg::Request::Search.rpg_periodicals('query', { params: hash })
request = Bgg::Request::Search.rpgs('query', { params: hash })
request = Bgg::Request::Search.video_games('query', { params: hash })
request.exact # Adds params to the bgg call that will request an exact match only, returns self
request.add_params( { params: to_add } ) # Adds params to the bgg call
result = request.get # Execute bgg call and return result
```

#### Bgg::Result::Search

* Methods
  * Select item type from result set:  board_games, board_game_expansions, rpg_issues, rpg_items, rpg_periodicals, rpgs, video_games

#### Bgg::Result::Search::Item

* Attributes
  * Integers: id, year_published
  * Stings: name, type
* Methods
  * game, request game based on id

Contributing to bgg
-----------------------

* Fork the project
* Start a feature/bugfix branch
* Test whatever you are committing. Ensure this test is a specification
  of the behavior of the functionality, not just an error case or
  success case.
* Commit and push until you are happy with your contribution
* Submit a pull request. Squash commits that should be squashed (it is
  not necessary for you to have just one commit to your pull request,
  but have each commit be a logical piece of work.)

Copyright
---------

Copyright (c) 2014 [Jeremiah Lee](https://github.com/jemiahlee), [Brett Hardin](http://bretthard.in), and [Marcello Missiroli](https://github.com/piffy). See LICENSE.txt for further details.

