# app/models/feature_override.rb
class FeatureOverride < ApplicationRecord
  belongs_to :feature

  before_validation :stringify_override_id

  VALID_TYPES = %w[user group region]

  validates :override_type, presence: true, inclusion: { in: VALID_TYPES }
  validates :override_id, presence: true
  validates :state, inclusion: { in: [ true, false ] }

  validates :feature_id, uniqueness: { scope: [ :override_type, :override_id ], message: "override already exists for this scope" }

  after_commit :invalidate_feature_cache

  private

  def stringify_override_id
    self.override_id = override_id.to_s if override_id.present?
  end

  def invalidate_feature_cache
    FeatureControlEngine::CacheStore.invalidate(feature_id)
  end
end
