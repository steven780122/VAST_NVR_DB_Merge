class AddCameraIdToCameraOtherInfos < ActiveRecord::Migration
  def change
    add_reference :cct_vast_db_camera_other_infos, :cct_vast_db_cameras, index: {:name => "cct_vast_db_cameras_id"}
  end
end
