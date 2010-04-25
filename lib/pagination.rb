module Pagination
  autoload :OhmAdapter, 'pagination/adapters/ohm'
  autoload :Collection, 'pagination/collection'
  autoload :Template,   'pagination/template'
  autoload :Helpers,    'pagination/helpers'

  extend self

  def paginate(collection, options = {})
    adapter.new(collection, options)
  end

  def per_page(per_page = nil)
    @per_page = per_page if per_page
    @per_page
  end

  def adapter(adapter = nil)
    if adapter
      @adapter = adapter 
    else
      const_get(@adapter) if @adapter
    end
  end

  # Set the default to 15
  # You can easily override this by putting the following somewhere in your code:
  #     Pagination.per_page 10
  #
  per_page 15

  # Currently we default to Ohm for various reasons.
  #
  # If you want to make your own adapter, simply subclass Pagination::Collection
  # and use `OhmAdapter` as the basis to determine the requirements needed.
  #
  # Make sure you put your Adapter under the `Pagination` module 
  # (i.e. Pagination::MongoAdapter).
  adapter  :OhmAdapter
end
