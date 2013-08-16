class FakeTrailMap
  attr_reader :resource_id, :resource_title, :validation_id, :validation_title, :name

  def initialize
    @resource_id = '2f720eaa8bcd602a7dc731feb224ff99bb85a03c'
    @resource_title = 'Try Git'
    @validation_id = 'cab73a959ee344204b0a6d9778d589c4298dd9d3'
    @validation_title = 'Create a commit'
    @name = 'Git'
  end

  def trail
    {
       'name' => @name,
       'description' => 'Description of Git',
       'steps' => [
         {
           'name' => 'Beginning Git',
           'resources' => [
             {
               'title' => resource_title,
               'uri' => 'http://try.github.com',
               'id' => resource_id
             }
           ],
           'validations' => [
             {
               'title' => validation_title,
               'id' => validation_id
             }
           ]
         }
       ]
     }
  end
end
