require 'helper'
require 'nokogiri'
require 'haml'

HamlHere = Haml

class TestPaginationTemplate < Test::Unit::TestCase
  setup do
    @dataset = ['one', 'two', 'three', 'four', 'five']
    @items = Pagination.paginate(@dataset, :per_page => 1, :page => 1)
  end

  def doc
    Nokogiri(@render.call)
  end
 
  describe "haml rendering option" do
    setup do
      Object.const_set(:Haml, HamlHere) unless defined?(Haml)
      @render = lambda { Pagination::Template.new(@items).render }
    end
    

    should "be able to render using haml" do
      assert_nothing_raised do
        @render.call
      end
    end

    should "have no .pagination > a.prev-link" do
      assert_equal 0, doc.search('.pagination > a.prev-link').length
    end

    should "have a ul > li.next-link with page=2" do
      assert_equal 1, 
        doc.search('nav.pagination > a.next-link[href="?page=2"]').length
    end

    should "display the first page as the current page" do
      assert_equal 1, doc.search('nav.pagination > nav.page-numbers > ul > li > span').length

      assert_equal '1', doc.search('nav.pagination > nav.page-numbers > ul > li > span').text
    end

    should "display pages 2 to 5 as links" do
      (2..5).each do |page|
        assert_equal 1, 
          doc.search(%(nav.pagination > nav.page-numbers > ul > li > 
                       a[href="?page=#{page}"])).length

        assert_equal page.to_s, 
          doc.search(%(nav.pagination > nav.page-numbers > ul > li > 
                       a[href="?page=#{page}"])).text
      end
    end
  end

  describe "erb rendering option" do
    setup do
      if defined?(Haml)
        Object.send :remove_const, :Haml
      end

      @template = Pagination::Template.new(@items)
      @render = lambda { @template.render }
    end
  
    should "render without any errors" do
      assert_kind_of ERB, @template.send(:engine)

      assert_nothing_raised do
        @render.call
      end
    end

    should "have no .pagination > a.prev-link" do
      assert_equal 0, doc.search('.pagination > a.prev-link').length
    end

    should "have a ul > li.next-link with page=2" do
      assert_equal 1, 
        doc.search('div.pagination > a.next-link[href="?page=2"]').length
    end

    should "display the first page as the current page" do
      assert_equal 1, doc.search('div.pagination > ul > li > span').length

      assert_equal '1', doc.search('div.pagination > ul > li > span').text
    end

    should "display pages 2 to 5 as links" do
      (2..5).each do |page|
        assert_equal 1, 
          doc.search(%(div.pagination > ul > li > 
                       a[href="?page=#{page}"])).length

        assert_equal page.to_s, 
          doc.search(%(div.pagination > ul > li > 
                       a[href="?page=#{page}"])).text
      end
    end

  end
end

