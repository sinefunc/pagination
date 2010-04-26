module Pagination
  class OhmAdapter < Collection
    def initialize(dataset, options = {})
      super

      @dataset = dataset
      @total   = dataset.size
      @order   = options[:order]
      @start   = (page - 1) * per_page
    end

    def empty?
      @total.zero?
    end

  protected
    def collection
      if @dataset.respond_to?(:sort) 
        @dataset.sort sort_options
      else
        @dataset.all @start, per_page
      end
    end

    def sort_options
      { :start => @start,
        :limit => @per_page,
        :order => 'DESC',
        :by    => @order
      }
    end
  end
end
