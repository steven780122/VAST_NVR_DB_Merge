class CctNvrDb::ShowCamInfoAndUpdatesController < ApplicationController

  def import
    CctNvrDb::ShowCamInfoAndUpdate.import(params[:file_update_cam_info])
    redirect_to import_success_cct_nvr_db_show_cam_info_and_updates_path, notice: "Activity Data imported!"
  end

end

