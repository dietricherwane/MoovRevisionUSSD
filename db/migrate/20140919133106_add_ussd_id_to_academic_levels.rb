class AddUssdIdToAcademicLevels < ActiveRecord::Migration
  def change
    add_column :academic_levels, :ussd_id, :integer
  end
end
