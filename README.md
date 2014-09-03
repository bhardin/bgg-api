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

BggApi is the root entry point to the different api calls.

```ruby
BggApi.collection 'username' # Default call 
BggApi.collection('username', { brief: 1 }) # Adding params based on api documentation
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

