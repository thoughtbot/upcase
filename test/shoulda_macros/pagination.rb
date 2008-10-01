class Test::Unit::TestCase
  def self.should_paginate_collection(collection_name)
    should "paginate #{collection_name}" do
      assert collection = assigns(collection_name), "Controller isn't assigning to @#{collection_name}"
      assert_kind_of WillPaginate::Collection, collection
    end
  end

  def self.should_not_paginate_collection(collection_name)
    should "not paginate #{collection_name}" do
      assert collection = assigns(collection_name), "Controller isn't assigning to @#{collection_name}"
      assert_not_equal WillPaginate::Collection, collection.class
    end
  end
end
