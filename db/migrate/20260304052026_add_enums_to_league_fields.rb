class AddEnumsToLeagueFields < ActiveRecord::Migration[8.1]
  def change
    create_enum :platforms, [ "Fantrax", "ESPN" ]
    create_enum :scoring_format, [ "points", "categories" ]

    remove_column :leagues, :platform
    remove_column :leagues, :scoring_format

    change_table :leagues do |t|
      t.enum :platform, enum_type: "platforms", null: false, default: "Fantrax"
      t.enum :scoring_format, enum_type: "scoring_format", null: false, default: "points"
    end
  end
end
