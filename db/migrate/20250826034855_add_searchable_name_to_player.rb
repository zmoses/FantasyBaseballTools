class AddSearchableNameToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :searchable_name, :string
    add_index :players, [ :searchable_name, :team ], unique: true
  end
end
