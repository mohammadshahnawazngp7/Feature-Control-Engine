class ChangeOverrideIdToInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :feature_overrides, :override_id, :integer
  end
end
