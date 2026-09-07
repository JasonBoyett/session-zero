class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and
  # :omniauthable
  devise :recoverable,
    :rememberable,
    :omniauthable,
    omniauth_providers: [:discord]
    # TODO: set up google as omniauth provider

  if Rails.env.production?
    devise :database_authenticatable,
      :registerable,
      :validatable
  end
  has_many :game_master_profiles, dependent: :destroy
  has_many :player_profiles, dependent: :destroy
end
