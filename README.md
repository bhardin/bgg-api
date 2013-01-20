bgg-api gem
===========
A [boardgamegeek](http://boardgamegeek.com) Ruby wrapper for the [bgg XML Version 2 API](http://boardgamegeek.com/wiki/page/BGG_XML_API2).

## Installing the Gem
Do the following to install the  [bgg-api gem](http://rubygems.org/gems/bgg-api) Ruby Gem. 

Add the following to your `Gemfile`:

```ruby
gem "bgg-api"
```

Then run `bundle install` from the command line:

    bundle install
    
## Using the Gem

Require the gem at the top of any file you want to use.

    require 'bgg-api'
    
Create an object and all the xml2 api's documented [here](http://boardgamegeek.com/wiki/page/BGG_XML_API2) should work.

## Search Example

    bgg = BggApi.new
    bgg.search( {:query => "Burgund", :type => 'boardgame'} )
    => {"total"=>"2", "termsofuse"=>"http://boardgamegeek.com/xmlapi/termsofuse", "item"=>[{"type"=>"boardgame", "id"=>"5", "name"=>[{"type"=>"primary", "value"=>"Acquire"}]}, {"type"=>"boardgame", "id"=>"37491", "name"=>[{"type"=>"primary", "value"=>"Modern Land Battles (MLB): Target Acquired"}]}]} 

## Thing Example

    bgg = BggApi.new
    bgg.thing({:id => "1"})
    => {"termsofuse"=>"http://boardgamegeek.com/xmlapi/termsofuse", "item"=>[{"type"=>"boardgame", "id"=>"1", "thumbnail"=>["http://cf.geekdo-images.com/images/pic159509_t.jpg"], "image"=>["http://cf.geekdo-images.com/images/pic159509.jpg"], "name"=>[{"type"=>"primary", "sortindex"=>"5", "value"=>"Die Macher"}], "description"=>["Die Macher is a game about seven sequential political races in different regions of Germany. Players are in charge of national political parties, and must manage limited resources to help their party to victory. The winning party will have the most victory points after all the regional elections. There are four different ways of scoring victory points. First, each regional election can supply one to eighty victory points, depending on the size of the region and how well your party does in it. Second, if a party wins a regional election and has some media influence in the region, then the party will receive some media-control victory points. Third, each party has a national party membership which will grow as the game progresses and this will supply a fair number of victory points. Lastly, parties score some victory points if their party platform matches the national opinions at the end of the game.&#10;&#10;The 1986 edition featured 4 parties from the old West Germany and supported 3-4 players. The 1997 edition supports up to 5 players in the re-united Germany and updated several features of the rules as well.  The 2006 edition also supports up to 5 players and adds a shorter 5 round variant and additional rules updates by the original designer.&#10;&#10;Die Macher is #1 in the Valley Games Classic Line&#10;&#10;"], "yearpublished"=>[{"value"=>"1986"}], "minplayers"=>[{"value"=>"3"}], "maxplayers"=>[{"value"=>"5"}], "poll"=>[{"name"=>"suggested_numplayers", "title"=>"User Suggested Number of Players", "totalvotes"=>"104", "results"=>[{"numplayers"=>"1", "result"=>[{"value"=>"Best", "numvotes"=>"0"}, {"value"=>"Recommended", "numvotes"=>"1"}, {"value"=>"Not Recommended", "numvotes"=>"63"}]}, {"numplayers"=>"2", "result"=>[{"value"=>"Best", "numvotes"=>"0"}, {"value"=>"Recommended", "numvotes"=>"1"}, {"value"=>"Not Recommended", "numvotes"=>"64"}]}, {"numplayers"=>"3", "result"=>[{"value"=>"Best", "numvotes"=>"0"}, {"value"=>"Recommended", "numvotes"=>"20"}, {"value"=>"Not Recommended", "numvotes"=>"57"}]}, {"numplayers"=>"4", "result"=>[{"value"=>"Best", "numvotes"=>"18"}, {"value"=>"Recommended", "numvotes"=>"67"}, {"value"=>"Not Recommended", "numvotes"=>"10"}]}, {"numplayers"=>"5", "result"=>[{"value"=>"Best", "numvotes"=>"92"}, {"value"=>"Recommended", "numvotes"=>"9"}, {"value"=>"Not Recommended", "numvotes"=>"0"}]}, {"numplayers"=>"5+", "result"=>[{"value"=>"Best", "numvotes"=>"0"}, {"value"=>"Recommended", "numvotes"=>"0"}, {"value"=>"Not Recommended", "numvotes"=>"43"}]}]}, {"name"=>"suggested_playerage", "title"=>"User Suggested Player Age", "totalvotes"=>"22", "results"=>[{"result"=>[{"value"=>"2", "numvotes"=>"0"}, {"value"=>"3", "numvotes"=>"0"}, {"value"=>"4", "numvotes"=>"0"}, {"value"=>"5", "numvotes"=>"0"}, {"value"=>"6", "numvotes"=>"0"}, {"value"=>"8", "numvotes"=>"0"}, {"value"=>"10", "numvotes"=>"0"}, {"value"=>"12", "numvotes"=>"5"}, {"value"=>"14", "numvotes"=>"10"}, {"value"=>"16", "numvotes"=>"4"}, {"value"=>"18", "numvotes"=>"2"}, {"value"=>"21 and up", "numvotes"=>"1"}]}]}, {"name"=>"language_dependence", "title"=>"Language Dependence", "totalvotes"=>"40", "results"=>[{"result"=>[{"level"=>"1", "value"=>"No necessary in-game text", "numvotes"=>"31"}, {"level"=>"2", "value"=>"Some necessary text - easily memorized or small crib sheet", "numvotes"=>"3"}, {"level"=>"3", "value"=>"Moderate in-game text - needs crib sheet or paste ups", "numvotes"=>"6"}, {"level"=>"4", "value"=>"Extensive use of text - massive conversion needed to be playable", "numvotes"=>"0"}, {"level"=>"5", "value"=>"Unplayable in another language", "numvotes"=>"0"}]}]}], "playingtime"=>[{"value"=>"240"}], "minage"=>[{"value"=>"14"}], "link"=>[{"type"=>"boardgamecategory", "id"=>"1021", "value"=>"Economic"}, {"type"=>"boardgamecategory", "id"=>"1001", "value"=>"Political"}, {"type"=>"boardgamemechanic", "id"=>"2012", "value"=>"Auction/Bidding"}, {"type"=>"boardgamefamily", "id"=>"10643", "value"=>"Country: Germany"}, {"type"=>"boardgamefamily", "id"=>"91", "value"=>"Valley Games Classic Line"}, {"type"=>"boardgamedesigner", "id"=>"1", "value"=>"Karl-Heinz Schmiel"}, {"type"=>"boardgameartist", "id"=>"12517", "value"=>"Marcus Gschwendtner"}, {"type"=>"boardgamepublisher", "id"=>"133", "value"=>"Hans im Glück Verlags-GmbH"}, {"type"=>"boardgamepublisher", "id"=>"2", "value"=>"Moskito"}, {"type"=>"boardgamepublisher", "id"=>"5382", "value"=>"Valley Games, Inc."}]}]}

Contributing to bgg-api
----------------------- 

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2012 [Brett Hardin](http://bretthard.in). See LICENSE.txt for further details.

