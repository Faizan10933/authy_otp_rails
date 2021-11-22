class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :name
      t.string :country_code
      t.text :phone_number

      t.timestamps
    end
  end
end
