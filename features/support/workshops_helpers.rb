module WorkshopsHelpers
  def type_of_related_workshop_named(name)
    within '.related-products' do
      find('li', text: name).find('h5').text.strip
    end
  end
end

World(WorkshopsHelpers)
