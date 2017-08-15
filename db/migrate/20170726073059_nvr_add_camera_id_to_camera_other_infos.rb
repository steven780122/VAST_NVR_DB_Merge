class NvrAddCameraIdToCameraOtherInfos < ActiveRecord::Migration
  def change
    add_reference :cct_nvr_db_camera_other_infos, :cct_nvr_db_cameras, index: {:name => "cct_nvr_db_cameras_id"}
  end
end

