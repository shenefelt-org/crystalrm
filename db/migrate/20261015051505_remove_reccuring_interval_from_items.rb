class RemoveReccuringIntervalFromItems < ActiveRecord::Migration[8.1]
  def change
    remove_column :items, :reccuring_interval, :string
  end
end
