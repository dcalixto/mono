class CreateUsers < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :users do |t|
      t.timestamps null: false

      t.string :name,  limit: 200, null: false
      t.string :username, limit: 200, null: false
      t.string :email, null: false
      t.string :password_digest, limit: 128, null: false

      t.string :avatar
      t.text :bio, limit: 250
      t.string :slug

      t.string :phone, limit: 128
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.string :website

      t.float :logitude
      t.float :latitude

      t.string :ip_address
      t.datetime :login_at
      
      t.string :auth_token, limit: 128 
      t.string :password_reset_token, limit: 128 
      t.datetime :password_reset_sent_at

      t.string :confirmation_token, limit: 128
      
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :slug

   
    
  end
end


