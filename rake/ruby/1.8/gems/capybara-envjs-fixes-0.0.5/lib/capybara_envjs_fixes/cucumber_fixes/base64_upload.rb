# Capybara-envjs attempts to upload files encoded in Base64, which Rack doesn't decode
# TODO: extract this to fixes gem
class Base64UploadDecoder
  def initialize(app)
    @app = app
  end

  def call(env)
    Rack::Request.new(env).POST
    if env['rack.request.form_hash']
      decode_base64_uploads(env['rack.request.form_hash'])
    end
    @app.call(env)
  end

  private

  def decode_base64_uploads(hash)
    hash.each do |param, value|
      if Hash === value
        if value[:tempfile]
          if value[:tempfile].read(512).include?('Content-Transfer-Encoding: base64')
            value[:tempfile].rewind
            lines = value[:tempfile].readlines
            while (line = lines.shift) && !line.strip.empty?
            end
            new_temp = Tempfile.new("base64_decode")
            new_temp.write Base64.decode64(lines.join)
            value[:tempfile] = new_temp
          else
            value[:tempfile].rewind
          end
        else
          decode_base64_uploads(value)
        end
      end
    end
  end
end

Capybara.app = Base64UploadDecoder.new(Capybara.app)


