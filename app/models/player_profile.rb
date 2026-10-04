class PlayerProfile < ApplicationRecord
  include ProfileRepresentable

  self.api_only_attributes = %w[
    game_id
    updated_at
    user_id
  ].freeze
  self.owner_only_attributes = %w[
    created_at
    last_used_at
  ].freeze
  self.updatable_attributes = %w[
    character_image
    character_name
    is_user_public
    character_description
    character_sheet_link
  ]

  belongs_to :user
  belongs_to :game

  has_many :player_notes, dependent: :destroy

  def profile_attributes_for(current_user_id)
    super(current_user_id)
      .merge(
        can_accept: is_acceptable_by?(current_user_id)
      )
  end

  private

  def profile_api_only_attributes
    return super unless is_user_public

    super - [ "user_id" ]
  end

  def profile_owner?(current_user_id)
    user_id == current_user_id
  end

  def is_acceptable_by?(current_user_id)
    game.game_master_profile.user_id == current_user_id
  end
end
