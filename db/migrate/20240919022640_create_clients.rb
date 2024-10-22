class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients, id: :uuid do |t|
      t.string :full_name
      t.string :email

      t.timestamps
    end
    add_index :clients, :full_name
    add_index :clients, :email
  end
end
