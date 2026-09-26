class CreateNextReleaseProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :next_release_processes do |t|
      t.integer :project_id, null: false
      t.string :name, default: "Proceso de Próximo Lanzamiento"
      t.string :status, default: "in_progress"
      t.text :rejection_reason
      t.timestamps
    end
    add_index :next_release_processes, :project_id
  end
end