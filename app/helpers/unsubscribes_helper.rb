module UnsubscribesHelper
  def unsubscribe_token_verifier
    @_unsubscribe_token_verifier ||= ActiveSupport::MessageVerifier.new(
      ENV.fetch("UNSUBSCRIBE_SECRET_BASE"),
      digest: "SHA256".freeze
    )
  end
end
