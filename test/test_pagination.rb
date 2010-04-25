require 'helper'

class TestPagination < Test::Unit::TestCase
  should "respond to #paginate" do
    assert_respond_to Pagination, :paginate
  end
  
  context "since we're assume OhmAdapter by default" do
    should "at minimum accept a collection" do
      assert_nothing_raised do
        Pagination.paginate([])
      end
    end
  end

  context "given an empty collection" do
    setup do
      @collection = Pagination.paginate([])
    end

    should "default to page 1" do
      assert_equal 1, @collection.page 
    end

    should "be current?(1)" do
      assert @collection.current?(1)
    end

    should "default to 15 per page" do
      assert_equal 15, @collection.per_page
    end

    should "have no prev page sinced it's page 1" do
      assert_nil @collection.prev_page
    end

    should "have no next page since the collection passed was empty" do
      assert_nil @collection.next_page
    end

    should "not render" do
      assert ! @collection.render?
    end
  end

  context "given 2 items, page 1, per_page 1" do
    setup do
      @collection = Pagination.paginate(['first', 'second'], :per_page => 1)
    end
    
    should "have no prev page" do
      assert_nil @collection.prev_page
    end

    should "have a next page of 2" do
      assert_equal 2, @collection.next_page
    end

    context 'when we set page to 2' do
      setup do
        @collection = Pagination.paginate(['f', 's'], :page => 2, :per_page => 1)
      end
      
      should "have a prev page of 1" do
        assert_equal 1, @collection.prev_page
      end

      should "have no next page" do
        assert_nil @collection.next_page
      end
    end
  end
  
  context "given we have 100 pages and we're at page 1" do
    setup do
      @collection = Pagination.paginate((1..100).to_a, :per_page => 1)
    end
    
    should "have 1 to 10 of displayed_pages" do
      assert_equal (1..10).to_a, @collection.displayed_pages
    end
  end

  context "given we have 100 pages and we're at page 50" do
    setup do
      @collection = Pagination.paginate((1..100).to_a, :per_page => 1, :page => 50)
    end
    
    should "have 50 to 59 of displayed_pages" do
      assert_equal (50..59).to_a, @collection.displayed_pages
    end
  end

  context "given we have 100 pages and we're at pages 91 up to 99" do
    should "start with the 91 end with 100" do
      (91..99).each do |p|
        collection = Pagination.paginate((1..100).to_a, :per_page => 1, :page => p)
        assert_equal (91..100).to_a, collection.displayed_pages
      end
    end
  end
  
  context "given we have 5 pages and we're at page 2 up to 5" do
    should "always display the 5 pages" do
      (1..5).each do |p|
        collection = Pagination.paginate((1..100).to_a, :per_page => 20, :page => p)
        assert_equal (1..5).to_a, collection.displayed_pages
      end

    end
  end
end
