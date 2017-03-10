class CreateParties < ActiveRecord::Migration[5.0]
  def change
    create_table :parties do |t|
      t.string :host_name
      t.string :host_email
      t.integer :numgsts
      t.text :guest_names
      t.string :venue
      t.string :location
      t.string :theme
      t.datetime :start_time
      t.datetime :end_time
      t.text :descript
      t.timestamps
    end
  end
end
