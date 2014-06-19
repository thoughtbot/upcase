module PathHelpers
  def be_the_dashboard
    eq(dashboard_path)
  end
end
