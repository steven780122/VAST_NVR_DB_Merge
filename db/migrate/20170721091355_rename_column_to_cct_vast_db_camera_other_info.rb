class RenameColumnToCctVastDbCameraOtherInfo < ActiveRecord::Migration
  def change
    rename_column :cct_vast_db_camera_other_infos, :cct_vast_db_cameras_id, :camera_id
  end
end
