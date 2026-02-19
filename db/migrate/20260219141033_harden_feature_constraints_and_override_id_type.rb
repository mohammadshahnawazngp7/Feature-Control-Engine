class HardenFeatureConstraintsAndOverrideIdType < ActiveRecord::Migration[8.1]
  def up
    change_column :feature_overrides, :override_id, :string

    change_column_null :features, :name, false
    change_column_null :features, :default_state, false

    change_column_null :feature_overrides, :override_type, false
    change_column_null :feature_overrides, :override_id, false
    change_column_null :feature_overrides, :state, false

    add_index :features, :name, unique: true
    add_index :feature_overrides, [ :feature_id, :override_type, :override_id ],
      unique: true,
      name: "index_feature_overrides_uniqueness"
  end

  def down
    remove_index :feature_overrides, name: "index_feature_overrides_uniqueness"
    remove_index :features, :name

    change_column_null :feature_overrides, :state, true
    change_column_null :feature_overrides, :override_id, true
    change_column_null :feature_overrides, :override_type, true

    change_column_null :features, :default_state, true
    change_column_null :features, :name, true

    change_column :feature_overrides, :override_id, :integer
  end
end
