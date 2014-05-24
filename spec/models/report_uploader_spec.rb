require 'spec_helper'
require 'pry'

describe ReportUploader do
  describe '#upload' do
    it 'uploads report file to s3' do
      AWS.config(stub_requests: true)

      stubbed_report = double(rows: report_fixture, report_name: 'subscription_count')
      report_uploader = ReportUploader.new(stubbed_report, aws_config)

      aws_report_object = report_uploader.bucket_report_object.expects(:write).with(report_fixture_string, acl: :public_read)

      report_uploader.upload

      AWS.config(stub_requests: nil)
    end
  end

  describe '#bucket_report_object' do
    it 'returns the bucket object with correct key' do
      stubbed_report = double(rows: [], report_name: 'subscription_count')
      report_uploader = ReportUploader.new(stubbed_report, aws_config)

      bucket_object = report_uploader.bucket_report_object

      expect(bucket_object.key).to eq 'reports/subscription_count.csv'
    end
  end

  def aws_bucket
    s3 = AWS::S3.new(access_key_id: aws_config[:AWS_ACCESS_KEY_ID], secret_access_key: aws_config[:AWS_SECRET_ACCESS_KEY])
    s3.buckets[aws_config[:AWS_BUCKET]]
  end

  def aws_config
    {
      AWS_ACCESS_KEY_ID: 'test_id',
      AWS_SECRET_ACCESS_KEY: 'test_access_key',
      AWS_BUCKET: 'test.books.thoughtbot'
    }
  end

  def report_fixture
    @report_fixture ||= CSV.open(File.join(Rails.root, 'spec', 'fixtures', 'reports', 'test_report.csv')).read
  end

  def report_fixture_string
    CSV.generate do |csv|
      report_fixture.each do |row|
        csv << row
      end
    end
  end

end
