# app/models/feature.rb
class Feature < ApplicationRecord
  has_many :feature_overrides, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :default_state, inclusion: { in: [ true, false ] }

  after_commit :invalidate_feature_cache

  private

  def invalidate_feature_cache
    FeatureControlEngine::CacheStore.invalidate(id)
  end
end
