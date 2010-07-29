module Pagination
  class SunspotAdapter < Collection
    attr :dataset
    attr :sort_by
    attr :order

    def initialize(dataset, options = {})
      super

      @dataset = dataset
      @total   = dataset.total
      @sort_by = options[:sort_by]
      @order   = options[:order]
  
      reset_memoized_vars_in_dataset

      dataset.query.paginate(page, per_page)
      sort_results
      dataset.execute
    end

    def results
      @dataset.results
    end

  private
    def setup
      dataset.instance_variable_get(:@setup)
    end
    
    def sort_results
      if sort_by
        sort =
          if special = Sunspot::Query::Sort.special(sort_by)
            special.new(order)
          else
            Sunspot::Query::Sort::FieldSort.new(
              setup.field(sort_by), order
            )
          end
        dataset.query.add_sort(sort)
      end
    end

    def reset_memoized_vars_in_dataset
      dataset.instance_variable_set(:@results, nil)
      dataset.instance_variable_set(:@hits, nil)
      dataset.instance_variable_set(:@verified_hits, nil)
      dataset.instance_variable_set(:@solr_response, nil)
    end
  end
end
