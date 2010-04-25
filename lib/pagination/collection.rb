module Pagination
  class Collection
    Unimplemented = Class.new(StandardError)

    include Enumerable

    attr :page, :per_page, :total

    # When subclassing `Pagination::Collection`, make sure you call super
    # in order to use `page` and `per_page`.
    def initialize(collection, options = {})
      @page       = Integer(options[:page] || 1)
      @per_page   = Integer(options[:per_page] || Pagination.per_page)
    end

    # When there's a valid previous page, returns that number
    #
    # Otherwise returns nil
    #
    def prev_page
      page - 1  if pages.include?(page - 1)
    end

    # When there's a valid next page, returns that number
    #
    # Otherwise returns nil
    def next_page
      page + 1  if pages.include?(page + 1)
    end
  
    # Mainly used as syntatic sugar instead of doing
    #
    #     if items.page == params[:page]
    #
    # for example, you will do
    #
    #     if items.current?(params[:page])
    #
    def current?(other_page)
      page == other_page
    end

    # Provides dirt-simple logic for spitting out page numbers
    # based on the current page.
    #
    # If we have 100 pages for example and we're at page 50,
    # this would simple return 
    #
    #     [50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    #
    # When we're at page 1, it displays 1 to 10.
    #
    # You can pass in a number to limit the total displayed pages.
    # 1 2 3 4 5
    def displayed_pages(limit = 10)
      lower = [page, [pages.last - limit, 0].max + 1].min
      upper = [page + limit - 1, pages.last].min

      (lower..upper).to_a
    end
  
    # Mainly used in the presentation layer as a front-line check if 
    # we should even proceed with all the nitty-gritty details of rendering.
    #
    # This basically returns false when there's only 1 page for the given
    # collection, otherwise returns true.
    def render?
      pages.to_a.size > 1
    end

    def each(&block)
      collection.each(&block) 
    end

  protected
    def collection
      raise Unimplemented, "You must implement collection"  
    end

    def pages
      1..last_page
    end

    def last_page
      (total / per_page.to_f).ceil
    end

  end
end
