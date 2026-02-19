class ChangeOverrideIdToString < ActiveRecord::Migration[8.1]
  def change
    change_column :feature_overrides, :override_id, :string
  end
end
