class CreateNrpExecutions < ActiveRecord::Migration[5.2]
  def change
    create_table :nrp_executions do |t|
      t.integer :next_release_process_id, null: false
      t.string :algorithm_name, default: "Consonant NRP Solver"
      t.string :status, default: "pending"
      t.float :p1, null: false # Presupuesto difuso inferior imposible
      t.float :p2, null: false # Presupuesto difuso inferior posible
      t.float :p3, null: false # Presupuesto difuso superior posible
      t.float :p4, null: false # Presupuesto difuso superior imposible
      t.string :alpha_cuts, default: "0.2,0.4,0.6,0.8,1.0"
      t.integer :max_execution_time, default: 60
      t.float :expected_profit
      t.timestamps
    end
    add_index :nrp_executions, :next_release_process_id
  end
end
