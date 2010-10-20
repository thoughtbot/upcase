class RedirectContentTypeRemover
  def initialize(app)
    @app = app
  end

  def call(env)
    remove_content_type_from_redirect(env)
    @app.call(env)
  end

  private

  def remove_content_type_from_redirect(env)
    if input_blank?(env)
      env.delete('CONTENT_TYPE')
    end
  end

  def input_blank?(env)
    input = env['rack.input']
    return true unless input
    content = input.read
    input.rewind
    content.blank?
  end
end

Capybara.app = RedirectContentTypeRemover.new(Capybara.app)
