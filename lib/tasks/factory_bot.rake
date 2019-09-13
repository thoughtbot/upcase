namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    if Rails.env.test?
      printf "Linting factories..."
      ActiveRecord::Base.transaction do
        FactoryBot.lint
        raise ActiveRecord::Rollback
      end
      printf " done\n"
    else
      system("bundle exec rake factory_bot:lint RAILS_ENV='test'")
      fail if $?.exitstatus.nonzero?
    end
  end
end
