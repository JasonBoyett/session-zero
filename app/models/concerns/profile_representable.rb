module ProfileRepresentable
  extend ActiveSupport::Concern

  included do
    class_attribute :api_only_attributes, default: []
    class_attribute :owner_only_attributes, default: []
    class_attribute :updatable_attributes, default: []
  end

  def profile_attributes_for(current_user_id)
    excluded_attributes = profile_api_only_attributes.dup

    unless profile_owner?(current_user_id)
      excluded_attributes.concat(self.class.owner_only_attributes)
    end

    attributes.except(*excluded_attributes)
      .merge(can_edit: profile_can_edit?(current_user_id))
  end

  def update_allowed_for?(current_user_id)
    profile_owner?(current_user_id)
  end

  private

  def profile_api_only_attributes
    self.class.api_only_attributes
  end

  def profile_owner?(current_user_id)
    id == current_user_id
  end

  def profile_can_edit?(current_user_id)
    profile_owner?(current_user_id)
  end
end
