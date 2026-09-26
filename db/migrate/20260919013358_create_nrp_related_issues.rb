class CreateNrpRelatedIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :nrp_related_issues do |t|
      t.integer :next_release_process_id, null: false
      t.integer :issue_id, null: false
      t.timestamps
    end
    add_index :nrp_related_issues, :next_release_process_id
    add_index :nrp_related_issues, :issue_id
    add_index :nrp_related_issues, [:next_release_process_id, :issue_id], unique: true, name: 'index_nrp_issues_unique'
  end
end
