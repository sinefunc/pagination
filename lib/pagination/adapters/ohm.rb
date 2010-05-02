module Pagination
  class OhmAdapter < Collection
    def initialize(dataset, options = {})
      super

      @dataset = dataset
      @total   = dataset.size
      @sort_by = options[:sort_by]
      @order   = options[:order]
      @start   = (page - 1) * per_page
    end

    def empty?
      @total.zero?
    end

  protected
    def collection
      if @sort_by
        @dataset.sort_by @sort_by, sort_options
      elsif @dataset.respond_to?(:sort) && !@dataset.method(:sort).arity.zero?
        @dataset.sort sort_options
      else
        @dataset.all sort_options
      end
    end

    def sort_options
      { :start => @start,
        :limit => @per_page,
        :order => @order
      }
    end
  end
end
