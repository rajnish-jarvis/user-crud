class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.date   :dob
      t.boolean :active
      t.timestamps
    end
  end
end
