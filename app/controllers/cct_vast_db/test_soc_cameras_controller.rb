class CctVastDb::TestSocCamerasController < ApplicationController
  def import
    CctVastDb::TestSocCamera.import(params[:file_test_soc_camera])
    redirect_to import_success_cct_vast_db_test_soc_cameras_path, notice: "Activity Data imported!"
  end

end

