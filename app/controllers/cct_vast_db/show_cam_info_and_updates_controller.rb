class CctVastDb::ShowCamInfoAndUpdatesController < ApplicationController

  def import
    CctVastDb::ShowCamInfoAndUpdate.import(params[:file_update_cam_info])
    redirect_to import_success_cct_vast_db_camera_other_infos_path, notice: "Activity Data imported!"
  end

end

