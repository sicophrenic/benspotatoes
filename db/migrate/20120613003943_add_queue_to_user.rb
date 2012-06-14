class AddQueueToUser < ActiveRecord::Migration
  def change
    add_column :users, :queue, :string, :default => ""
  end
end
