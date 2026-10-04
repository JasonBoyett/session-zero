class GameMasterProfile < ApplicationRecord
  include ProfileRepresentable

  self.api_only_attributes = %w[
    updated_at
    user_id
  ].freeze
  self.owner_only_attributes = %w[
    created_at
    last_used_at
  ].freeze
  self.updatable_attributes = %w[
    last_used_at
    bio
    is_user_public
    systems
    name
    profile_picture
  ]

  belongs_to :user
  has_many :games, dependent: :destroy

  private

  def profile_api_only_attributes
    return super unless is_user_public

    super - [ "user_id" ]
  end

  def profile_owner?(current_user_id)
    user_id == current_user_id
  end
end
