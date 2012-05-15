#if Rails.env == "test" || Rails.env == "development"
#  AWS::S3::Base.establish_connection!(:access_key_id => "123",
#                                    :secret_access_key => "abc",
#                                    :server => "localhost",
#                                    :port => "4567")
#end
