class CreatePersistedData < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.string :type
      t.string :count
      t.boolean :green
      t.date :date

      t.timestamps
    end
  end
end
