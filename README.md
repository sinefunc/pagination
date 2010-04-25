Pagination: Trying to make the pagination world a better place
==============================================================

Why another pagination library?
-------------------------------

Because I constantly work with designers, who prefer to have their own pagination markup customized to their heart's content. Current problems I have:

1. It is very hard for me to change the markup with the current libraries out there.
2. No Ohm / Redis support available (as far as I know).
3. NIH? 

Name the Niche:
---------------

This is currently streamlined for use with:

1. Sinatra
2. Ohm
3. HAML

How to use?
-----------

    require 'rubygems'
    require 'sinatra'
    require 'pagination'
  
    helpers Pagination::Helpers

    get '/items' do
      # Let's say current_user returns a User model with an items method

      @items = paginate current_user.items, :page => params[:page]

      haml :'items/index'
    end

    # then in your view index.haml

    != pagination @items

Customize the markup?
---------------------

    pagination haml
    # Spits out the pagination haml markup that's being used

    # Or if you prefer erb, you can also do that too...
    pagination erb

    # Then you can just use it as a partial
    pagination haml > app/views/pagination.haml

    # in your view
    != partial :pagination, :items => @items
