class HostedBookUrl
  attr_reader :book

  def initialize(book)
    @book = book
  end

  def epub
    url_for_format(:epub)
  end

  def pdf
    url_for_format(:pdf)
  end

  def kindle
    url_for_format(:mobi)
  end

  def releases
    "#{book.github_url}/tree/master/release"
  end

  private

  def url_for_format(format)
    s3_files["#{book.book_filename}.#{format}"].url_for(:read, expires: 10.minutes).to_s
  end

  def s3_bucket_name
    ENV['AWS_BUCKET']
  end

  def s3_files
    AWS::S3.new.buckets[s3_bucket_name].objects
  end
end
