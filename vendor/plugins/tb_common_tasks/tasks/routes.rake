desc "Print out all the currently defined routes, with names."
task :routes => :environment do
  name_col_width = ActionController::Routing::Routes.named_routes.routes.keys.sort {|a,b| a.to_s.size <=> b.to_s.size}.last.to_s.size
  ActionController::Routing::Routes.routes.each do |route|
    name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
    name = name.ljust(name_col_width + 1)
    puts "#{name}#{route}"
  end
end