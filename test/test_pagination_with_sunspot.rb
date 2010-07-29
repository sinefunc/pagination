require "helper"
require "ohm"
require "sunspot"
require "ruby-debug"

class OhmInstanceAdapter < Sunspot::Adapters::InstanceAdapter
  def id
    @instance.id
  end
end

class OhmDataAccessor < Sunspot::Adapters::DataAccessor
  def load(id)
    @clazz[id]
  end
end

Sunspot::Adapters::InstanceAdapter.register(OhmInstanceAdapter, Ohm::Model)
Sunspot::Adapters::DataAccessor.register(OhmDataAccessor, Ohm::Model)

class Post < Ohm::Model
  attribute :category
  attribute :title
  attribute :content
end

Sunspot.setup(Post) do
  string :category
  text   :content
  text   :title
  string :title
end

class PaginationWithSunspotTest < Test::Unit::TestCase
  setup do
    Ohm.flush
    Sunspot.remove_all
  end
  
  def index(*args)
    args.each { |e| Sunspot.index(e) }
    Sunspot.commit
  end
  
  # Notes: 
  # res.execute

  test "basic pagination" do
    post1 = Post.create(:category => "Cars", :title => "the best subaru",
                        :content => "This is by far the most Amazing car!")
    post2 = Post.create(:category => "Gadgets", :title => "iPhone 4",
                        :content => "Controversial device of 2010")
  
    index(post1, post2)
  
    set = Pagination.paginate(Sunspot.search(Post), :per_page => 1, :page => 1,
                              :sort_by => :title)
  
    assert_equal 2, set.total
    assert_equal 1, set.results.size
    assert_equal post2, set.results.first
  end
end

