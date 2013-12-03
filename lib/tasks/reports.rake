namespace :reports do
  desc 'Generate active users report'
  task subscribers: :environment do
    puts 'Generating Subscription Count report'
    subscriber_counts_report = SubscriptionCountReport.new
    report_generator = ReportGenerator.new subscriber_counts_report, aws_config

    report_generator.upload
    puts 'Uploaded reports'
  end

  def aws_config
    {
      AWS_ACCESS_KEY_ID: ENV['AWS_ACCESS_KEY_ID'],
      AWS_SECRET_ACCESS_KEY: ENV['AWS_SECRET_ACCESS_KEY'],
      AWS_BUCKET: ENV['AWS_BUCKET']
    }
  end

end
