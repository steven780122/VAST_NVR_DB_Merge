class RenameColumnToCctNvrDbCameraOtherInfo < ActiveRecord::Migration
  def change
    rename_column :cct_nvr_db_camera_other_infos, :cct_nvr_db_cameras_id, :camera_id
  end
end
