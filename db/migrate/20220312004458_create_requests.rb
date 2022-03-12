class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests, id: :uuid do |t|
      t.uuid :tracking_request_id
      t.string :bill_of_lading, null: false
      t.string :scac, null: false
      t.text :container_numbers, array: true, default: []

      t.timestamps
    end
  end
end
