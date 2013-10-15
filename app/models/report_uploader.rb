class ReportUploader
  attr_reader :bucket_report_object

  def initialize(report, aws_config)
    @report = report
    @aws_config = aws_config
    @bucket_report_object = bucket_report
  end

  def upload
    upload_to_s3
  end

  private

  def upload_to_s3
    @bucket_report_object.write(csv_string, acl: :public_read)
  end

  def bucket_report
    bucket = s3.buckets[@aws_config[:AWS_BUCKET]]
    bucket.objects["reports/#{@report.report_name}.csv"]
  end

  def csv_string
    CSV.generate do |csv|
      @report.rows.each do |row|
        csv << row
      end
    end
  end

  def s3
    @s3 ||= AWS::S3.new(
      access_key_id: @aws_config[:AWS_ACCESS_KEY_ID],
      secret_access_key: @aws_config[:AWS_SECRET_ACCESS_KEY]
    )
  end
end
