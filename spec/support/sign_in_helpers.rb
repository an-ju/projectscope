module Features
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in_admin
    user = User.create(provider_username: "Admin", uid: "uadmin", email: 'uadmin@example.com',
                       provider: "developer", role: User::ADMIN, password: Devise.friendly_token[0,20])
    login_as(user, scope: warden_scope(user))
  end

  private
  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end