class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:github]

  has_and_belongs_to_many :projects

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.expires_at = auth[:credentials][:expires_at]
      user.client_token = auth[:credentials][:token]
      user.client_secret = auth[:credentials][:secret]
    end
  end
end
