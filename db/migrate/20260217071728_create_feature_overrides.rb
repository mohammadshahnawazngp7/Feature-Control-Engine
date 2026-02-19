class CreateFeatureOverrides < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_overrides do |t|
      t.references :feature, null: false, foreign_key: true
      t.string :override_type
      t.integer :override_id
      t.boolean :state

      t.timestamps
    end
  end
end
