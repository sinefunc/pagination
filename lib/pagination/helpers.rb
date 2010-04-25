module Pagination
  # This module is mostly intended for use with Sinatra.
  # 
  # The classic sinatra application follows:
  #
  #     require 'rubygems'
  #     require 'sinatra'
  #     require 'pagination'
  #
  #     helpers Pagination::Helpers
  #
  #     get '/items' do
  #       @items = paginate current_user.items, :page => params[:page]
  #     end
  #
  # and then in your view
  #
  #     = pagination @items
  #
  module Helpers
    # This method accepts a dataset which depends entirely on your current adapter.
    # By default the `Pagination::OhmAdapter` is used, which assumes you are
    # passing in sets.
    #
    # There's nothing stopping you from building your own adapter.
    # See Pagination::OhmAdapter for details.
    def paginate(dataset, options = {})
      Pagination.paginate(dataset, options) 
    end
  
    # As of now this displays a canned markup. The best way to actually customize 
    # the markup is to use a partial and just pass in the collection as a local i.e.
    #
    #     partial :pagination, :items => @items
    #
    # The actual templates used are in `views/paginate.haml` and `views/paginate.erb`
    def pagination(paginated_collection)
      Pagination::Template.new(paginated_collection).render 
    end
  end
end


