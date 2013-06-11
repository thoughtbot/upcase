module FakeTrailMap
  def fake_trail_map
    {
      'name' => "Git",
      'description' => 'Description of Git',
      'steps' => [
        {
          'name' => "Beginning Git",
          'resources' => [
            {
              'title' => "Try Git",
              'uri' => "http://try.github.com",
              'id' => "2f720eaa8bcd602a7dc731feb224ff99bb85a03c"
            }
          ],
          'validations' => [
            {
              'title' => 'Know Git'
            }
          ]
        }
      ]
    }
  end
end
