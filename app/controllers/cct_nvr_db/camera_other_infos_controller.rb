class CctNvrDb::CameraOtherInfosController < ApplicationController
  def import
    CctNvrDb::CameraOtherInfo.import(params[:file_camera_others])

    existed_all_bool, @other_info_not_existed_array = CctNvrDb::CameraOtherInfo.check_all_other_info_model_existed

    Rails.logger.debug("TEST existed_bool: #{existed_all_bool.inspect}")
    Rails.logger.debug("TEST not existed array: #{@other_info_not_existed_array.inspect}")

    # if not all CameraOtherInfo you import are in CameraInfo's model name, then delete!
    if !existed_all_bool
      # delete all CameraOtherInfo You import!!
      CctNvrDb::CameraOtherInfo.destroy_all
      render "camera_other_infos/import_fail"
      # if all CameraOtherInfo you import are in CameraInfo's model name, then update all foreign key !!
    else
      CctNvrDb::CameraOtherInfo.update_association_foreign_key

      redirect_to import_success_cct_nvr_db_camera_other_infos_path, notice: "Activity Data imported!"
    end

  end


  def index
    @cameras_other_info = CctNvrDb::CameraOtherInfo.all

    respond_to do |format|
      format.html
      format.csv { send_data @cameras_other_info.to_csv, filename: 'total_camera_other_info.csv'}
    end
  end


  #
  # def new
  #   @camera_other_info = CameraOtherInfo.new
  # end
  #
  #

end

