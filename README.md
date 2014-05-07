bgg gem [![Build Status](https://travis-ci.org/jemiahlee/bgg.png?branch=master)](https://travis-ci.org/jemiahlee/bgg) [![Code Climate](https://codeclimate.com/github/jemiahlee/bgg.png)](https://codeclimate.com/github/jemiahlee/bgg)
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

### Example

Most of the documentation right now is in the specs. I will work on
beefing this section up shortly.

```ruby
texasjdl = Bgg::User.find_by_id(39488)
texasjdl.collection.played.each do |item|
  puts "#{item.name} is #{item.owned? ? '' : 'not'} owned."
end
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

