class CreateNrpSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :nrp_solutions do |t|
      t.integer :nrp_execution_id, null: false
      t.string :name
      t.boolean :selected, default: false
      t.text :solution_data # Almacena la estructura anidada de cortes alfa (JSON)
      t.timestamps
    end
    add_index :nrp_solutions, :nrp_execution_id
  end
end
