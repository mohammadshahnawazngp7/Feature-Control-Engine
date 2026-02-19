# spec/models/feature_spec.rb
require 'rails_helper'

RSpec.describe Feature, type: :model do
  it "is valid with valid attributes" do
    feature = Feature.new(name: "dark_mode", default_state: true)
    expect(feature).to be_valid
  end

  it "is invalid without a name" do
    feature = Feature.new(default_state: true)
    expect(feature).to_not be_valid
  end

  it "is invalid with duplicate name" do
    Feature.create!(name: "dark_mode", default_state: true)
    feature2 = Feature.new(name: "dark_mode", default_state: false)
    expect(feature2).to_not be_valid
  end
end
