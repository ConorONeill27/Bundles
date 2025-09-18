class AddOwnerToOrganizations < ActiveRecord::Migration[8.0]
  def change
    add_reference :organizations, :owner, null: false, foreign_key: true
  end
end
