class User < ApplicationRecord
  include ProfileRepresentable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and
  # :omniauthable

  UPDATABLE_ATTRIBUTES = %w[name profile_picture].freeze
  self.api_only_attributes = %w[
    encrypted_password
    remember_created_at
    reset_password_sent_at
    reset_password_token
  ].freeze
  self.owner_only_attributes = %w[
    email
    created_at
    updated_at
  ].freeze

  PUBLIC_ATTRIBUTES = %w[
    id
    name
    profile_picture
  ].freeze

  USER_VISIBLE_ATTRIBUTES = [
    *PUBLIC_ATTRIBUTES,
    "email",
    "created_at",
    "updated_at"
  ].freeze

  def self.public_attributes
    PUBLIC_ATTRIBUTES
  end

  def self.user_visible_attributes
    USER_VISIBLE_ATTRIBUTES
  end

  def self.updatable_attributes
    UPDATABLE_ATTRIBUTES
  end

  def self.updatable_attributes_for_openapi
    UPDATABLE_ATTRIBUTES.to_h do |attribute|
      [
        attribute.camelize(:lower).to_sym,
        { type: :string, nullable: true }
      ]
    end
  end


  def self.public_attributes_for_openapi
    PUBLIC_ATTRIBUTES.map { |attribute| attribute.camelize(:lower) }
  end

  def self.user_visible_attributes_for_openapi
    USER_VISIBLE_ATTRIBUTES.map { |attribute| attribute.camelize(:lower) }
  end

  def public_attributes
    attributes.slice(*PUBLIC_ATTRIBUTES)
  end

  def user_visible_attributes
    attributes.slice(*USER_VISIBLE_ATTRIBUTES)
  end

  devise :recoverable,
    :rememberable,
    :omniauthable,
    omniauth_providers: [ :discord ]
  # TODO: set up google as omniauth provider

  if not Rails.env.production?
    devise :database_authenticatable,
      :registerable,
      :validatable
  end
  has_many :game_master_profiles, dependent: :destroy
  has_many :player_profiles, dependent: :destroy
  has_many :user_identities, dependent: :destroy

  validates :profile_picture,
  format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "must be a valid image URL"
  },
  allow_blank: true

  protected

  def email_required?
    user_identities.empty?
  end
end
