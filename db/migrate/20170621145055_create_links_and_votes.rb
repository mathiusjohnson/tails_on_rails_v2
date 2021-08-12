class CreateLinksAndVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url, null: false
      t.string :description, null: false
      t.timestamps
    end

    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :link, null: false, foreign_key: true
      t.index %i(user_id link_id), unique: true
      t.timestamps
    end
  end
end
