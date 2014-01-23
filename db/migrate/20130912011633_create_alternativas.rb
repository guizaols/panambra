class CreateAlternativas < ActiveRecord::Migration
  def change
    create_table :alternativas do |t|
      t.string :titulo
      t.integer :peso
      t.integer :item_verificacao_id

      t.timestamps
    end
  end
end
