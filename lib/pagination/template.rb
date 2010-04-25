module Pagination
  # This class can be used by itself, although there's a `Pagination::Helper` 
  # available to provide convenience methods at your disposal.
  #
  # Basic Usage:
  #
  #     collection = Pagination.paginate(dataset, :page => 1)
  #     Pagination::Template.new(collection).render
  #
  class Template
    ROOT = File.join(File.dirname(__FILE__), '..', '..', 'views')
    
    attr :items
  
    # Initialize with your paginated collection.
    #
    # == Paramaters:
    # items::
    #   a `Pagination::Collection` object return by `Pagination.paginate`.
    def initialize(items)
      @items = items
    end
  
    # Displayed the standard pagination markup as provided by the
    # `Pagination` library.
    #
    # This uses Haml if Haml is required already. Else it uses ERB.
    #
    # == Returns:
    # The actual HTML for the pagination.
    def render
      if engine.respond_to?(:render)
        engine.render(Object.new, :items => items)
      else
        engine.result(binding)
      end
    end
  
    # This is used by the command line tool to spit out the markup.
    #
    # == Parameters:
    # type::
    #   either 'haml' or 'erb'
    #
    # == Returns:
    # The actual markup source.
    def self.markup(type)
      puts __send__(type)
    end
  
  protected
    def self.haml
      File.read(File.join(ROOT, 'paginate.haml'))
    end

    def self.erb
      File.read(File.join(ROOT, 'paginate.erb'))
    end

  private
    def engine
      @engine ||= 
        if defined?(Haml)
          Haml::Engine.new(self.class.haml)
        else
          require 'erb' if not defined?(ERB)
          ERB.new(self.class.erb)
        end
    end

  end
end
