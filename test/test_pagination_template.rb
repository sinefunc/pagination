require 'helper'
require 'nokogiri'
require 'haml'

HamlHere = Haml

class TestPaginationTemplate < Test::Unit::TestCase
  setup do
    @dataset = ['one', 'two', 'three', 'four', 'five']
    @items = Pagination.paginate(@dataset, :per_page => 1, :page => 1)
  end
  
  describe "haml rendering option" do
    setup do
      Object.const_set(:Haml, HamlHere) unless defined?(Haml)
      @render = lambda { Pagination::Template.new(@items).render }
    end
    
    def doc
      Nokogiri(@render.call)
    end

    should "be able to render using haml" do
      assert_nothing_raised do
        @render.call
      end
    end

    should "have a ul > li.prev-link.disabled" do
      assert_equal 1, 
        doc.search('ul.pagination > li.prev-link.disabled > a').length
    end

    should "have a ul > li.next-link with page=2" do
      assert_equal 1, 
        doc.search('ul.pagination > li.next-link > a[href="?page=2"]').length
    end

    should "display the first page as the curretn page" do
      assert_equal 1, 
        doc.search('ul.pagination > li > ul.page-numbers > li > span').length

      assert_equal '1', 
        doc.search('ul.pagination > li > ul.page-numbers > li > span').text
    end

    should "display pages 2 to 5 as links" do
      (2..5).each do |page|
        assert_equal 1, 
          doc.search(%(ul.pagination > li > 
                       ul.page-numbers > li > a[href="?page=#{page}"])).length

        assert_equal page.to_s, 
          doc.search(%(ul.pagination > li > 
                       ul.page-numbers > li > a[href="?page=#{page}"])).text
      end
    end
  end

  describe "erb rendering option" do
    setup do
      Object.send :remove_const, :Haml
    end
  
    should "render without any errors" do
      template = Pagination::Template.new(@items)
      assert_kind_of ERB, template.send(:engine)

      assert_nothing_raised do
        template.render
      end
    end
  end
end

