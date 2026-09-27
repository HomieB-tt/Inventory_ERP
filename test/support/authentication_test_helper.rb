module AuthenticationTestHelper
  # Drives the real sign-in flow (POST to the session endpoint), rather
  # than reaching into Current/session internals directly. Slower than
  # a shortcut, but it means these tests exercise the actual
  # authentication path, not a stand-in for it.
  def sign_in_as(user, password:)
    post session_url, params: { email_address: user.email_address, password: password }
  end
end
