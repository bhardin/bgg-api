module Bgg
  class Search
    def self.query(search_string)
      do_the_search(search_string)
    end

    def self.exact_query(search_string)
      results = do_the_search(search_string, true)
      results[0]
    end

    private

    def self.do_the_search(search_string, exact=false)
      unless search_string.is_a?(String) and search_string.length > 0
        raise ArgumentError.new('search string must be a non-empty string!')
      end

      if exact
        search_results = BggApi.search({query: search_string, exact: 1})
      else
        search_results = BggApi.search({query: search_string})
      end

      unless search_results.fetch('item', false)
        return []
      end

      search_results['item'].map{ |result|
        Bgg::Search::Result.new(result)
      }
    end
  end
end
