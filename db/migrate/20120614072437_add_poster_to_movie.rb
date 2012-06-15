class AddPosterToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :poster, :string, :default => "/assets/defaultposter.png"
  end
end
