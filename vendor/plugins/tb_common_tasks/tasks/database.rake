namespace :db do
  desc 'Creates the databases defined in your config/database.yml (unless they already exist)'
  task :create => :environment do 
    ActiveRecord::Base.configurations.each_value do |config|
      begin
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection
      rescue
        case config['adapter']
        when 'mysql'
          ActiveRecord::Base.establish_connection(config.merge({'database' => nil}))
          ActiveRecord::Base.connection.create_database config['database']
          ActiveRecord::Base.establish_connection(config)
        when 'postgresql'
          `createdb "#{config['database']}" -E utf8`
        end
      end
    end
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV || 'development'])
  end
  
  desc 'Drops the database for your currenet RAILS_ENV as defined in config/database.yml'
  task :drop => :environment do
    config = ActiveRecord::Base.configurations[RAILS_ENV || 'development']
    case config['adapter']
    when 'mysql'
      begin 
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection.current_database
        ActiveRecord::Base.connection.drop_database config['database']  
      rescue  
      end
    when 'sqlite3'
      FileUtils.rm_f File.join(RAILS_ROOT, config['database'])
    when 'postgresql'
      `dropdb "#{config['database']}"`
    end
  end
  
  desc 'Drops, creates and then migrates the database for your current RAILS_ENV. Target specific version with VERSION=x'
  task :reset => ['db:drop', 'db:create', 'db:migrate']
  
  desc 'Launches the database shell using the values defined in config/database.yml'
  task :shell => :environment do
    config = ActiveRecord::Base.configurations[RAILS_ENV || 'development']
    command = ""
    
    case config['adapter']
      when 'mysql'
        command << "mysql "
        command << "--host=#{config['host'] || 'localhost'} "
        command << "--port=#{config['port'] || 3306} "
        command << "--user=#{config['username'] || 'root'} "
        command << "--password=#{config['password'] || ''} "
        command << config['database']
      when 'postgresql'
        puts 'You should consider switching to MySQL or get off your butt and submit a patch'    
      else
        command << "echo Unsupported database adapter: #{config['adapter']}"
    end
    
    system command
  end
end