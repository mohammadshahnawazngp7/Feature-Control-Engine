require "rails_helper"

RSpec.describe User, type: :model do
  let!(:group) { Group.create!(name: "Beta") }

  it "is valid with a name and group" do
    user = User.new(name: "John", group: group)
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(group: group)
    expect(user).to_not be_valid
  end
end
