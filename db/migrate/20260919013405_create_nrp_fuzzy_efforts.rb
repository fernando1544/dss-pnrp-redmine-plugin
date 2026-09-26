class CreateNrpFuzzyEfforts < ActiveRecord::Migration[5.2]
  def change
    create_table :nrp_fuzzy_efforts do |t|
      t.integer :next_release_process_id, null: false
      t.integer :issue_id, null: false
      t.float :e1, null: false # Esfuerzo imposible inferior máximo
      t.float :e2, null: false # Esfuerzo posible inferior (óptimo)
      t.float :e3, null: false # Esfuerzo posible superior (conservador)
      t.float :e4, null: false # Esfuerzo imposible superior mínimo
      t.float :real_effort, default: 0.0
      t.timestamps
    end
    add_index :nrp_fuzzy_efforts, :next_release_process_id
    add_index :nrp_fuzzy_efforts, :issue_id
    add_index :nrp_fuzzy_efforts, [:next_release_process_id, :issue_id], unique: true, name: 'index_nrp_fuzzy_efforts_unique'
  end
end
