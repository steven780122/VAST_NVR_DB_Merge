class CctVastDb::CamerasController < ApplicationController

  # def  test_update
  #
  #   @cam_update_targets = CctVastDb::Camera.where(:Model_FW_name => params[:check_box_ids_array])
  #   CctVastDb::Camera.update_target(@cam_update_targets)
  #
  #   redirect_to update_cam_info_index_cameras_path
  #
  #   # if @cam_update_targets.update(camera_adding_params)
  #   #     redirect_to :back   # if write #show_cam_info_cameras_path >>> have issue!!!
  #   # end
  #
  # end


  def index
    @cameras = CctVastDb::Camera.all
    # @cameras_other_info = CctVastDb::CameraOtherInfo.all

    respond_to do |format|
      format.html
      format.csv { send_data @cameras.to_csv, filename: 'total_camera_info.csv'}
    end
  end


  def import
    # CctVastDb::Camera.import(params[:file_cameras])
    # # flash[:success] = "import success!!!!!!!!!!!!!!!!!!!!!!!!"
    # existed_all_bool, @other_info_not_existed_array = CctVastDb::CameraOtherInfo.check_all_other_info_model_existed
    #
    # if existed_all_bool
    #   redirect_to create_database_index_cameras_path
    # else
    #   redirect_to import_cameras_path
    # end

    # ori
    CctVastDb::Camera.import(params[:file_cameras])
    existed_all_bool, @other_info_not_existed_array = CctVastDb::CameraOtherInfo.check_all_other_info_model_existed
  end


  def new
    @camera = CctVastDb::Camera.new
  end

  # issue here
  def show
    redirect_to root_path
  end


  def new
    @post = []
    2.times do
      @post << CctVastDb::Camera.new
    end

  end


  def create

    # get new ids from hidden_field_tag in form
    new_cam_ids_array_str = params[:new_cam_ids_str_array]
    new_cam_ids_array = new_cam_ids_array_str.split(" ")
    # Rails.logger.debug("TEST new cam ids array from string HASH!!: #{new_cam_ids_array.inspect}")   # ok

    # get new cam record from ids
    new_cam_objs = CctVastDb::ShowCamInfoAndUpdate.find(new_cam_ids_array)
    Rails.logger.debug("TEST new cam objs from string HASH!!: #{new_cam_objs.inspect}")   # ok

    # added_soc_hash = CctVastDb::ShowCamInfoAndUpdate.get_selected_to_add_cam_hash_array(new_cam_objs, params[:soc_option])
    added_soc_hash = CctVastDb::ShowCamInfoAndUpdate.get_selected_to_add_cam_hash_array(new_cam_objs, params[:soc_option])

    if added_soc_hash == [{}]
      flash[:new_and_update_notice] = "Camera Name 重複，未新增，請確認！"
    elsif params[:soc_option] == ""
      flash[:new_and_update_notice] = "新增進DB成功，但Soc為空，請確認！"
    else
      flash[:new_and_update_notice] = "新增進DB成功！"
    end

    CctVastDb::Camera.create(added_soc_hash)

    redirect_to new_and_update_cam_info_index_cct_vast_db_cameras_path

    # ori
    # if test_add_array is not null (for protecting)
    # if !params[:test_add_array].nil?
    #   CctVastDb::Camera.create(camera_create_params)
    # else
    #   redirect_to new_and_update_cam_info_index_cameras_path
    #   return
    # end
    # redirect_to new_cam_info_index_cameras_path
  end


  # update multi record by hash
  def update
    # @find_camera = CctVastDb::Camera.find(645)
    # test_hash = {645 => {:uid_s0_frame_size => "X____update.1DD"}, 646 => {:uid_s0_mpeg4_max_frame_rate => "tete2"}}
    # CctVastDb::Camera.update(test_hash.keys, test_hash.values)
    # the array only has one hash
    get_id_with_caminfo_hash = params[:test_hashhash][0]

    # pass value from hiden_field_tag id is string array, so we need to transfer type to int first
    get_id_key = []
    get_id_with_caminfo_hash.keys.each do |id_str|
      get_id_key.append(id_str.to_i)
    end

    # pass value from hiden_field_tag is string array, so we need to transfer type to hash first
    get_cam_value_hash_array = []
    get_id_with_caminfo_hash.values.each do |cams_info_hash_str|
      get_cam_value_hash_array.append(eval(cams_info_hash_str))
    end

    # Rails.logger.debug("TEST PARAMS HASH!!: #{get_id_with_caminfo_hash.inspect}")   # ok
    # Rails.logger.debug("TEST PARAMS HASH KEYS!!: #{get_id_key.inspect}")   # ok
    # Rails.logger.debug("TEST PARAMS HASH KEYS!!: #{get_cam_value_hash_array.inspect}")   # ok

    CctVastDb::Camera.update(get_id_key, get_cam_value_hash_array)

    # original:
    # CctVastDb::Camera.update(@get_id_with_caminfo_hash.keys, @get_id_with_caminfo_hash.values)

    redirect_to :back
  end


  def update_soc
    @cameras = CctVastDb::Camera.all

    # id array is from hidden_field_array, and change string into int array
    soc_to_be_updated_id_str = params[:soc_to_be_updated_id_array]
    soc_to_be_updated_id_array = []
    soc_to_be_updated_id_temp_array = soc_to_be_updated_id_str.split(" ")
    soc_to_be_updated_id_temp_array.each do |soc_id_str|
      soc_to_be_updated_id_array.append(soc_id_str.to_i)
    end

    # Rails.logger.debug("TEST SOC ID PARAMS: #{soc_to_be_updated_id_array.inspect}")   # ok
    soc_option_str = params[:soc_to_be_updated]
    # Rails.logger.debug("TEST SOC PARAMS: #{soc_option_str.inspect}")   # ok

    cam_soc_to_updated_hash_hash = CctVastDb::ShowCamInfoAndUpdate.get_selected_to_update_soc_hash_hash(soc_to_be_updated_id_array, soc_option_str)
    Rails.logger.debug("TEST SOC FINAL PARAMS: #{cam_soc_to_updated_hash_hash.inspect}")   # ok

    CctVastDb::Camera.update(cam_soc_to_updated_hash_hash.keys, cam_soc_to_updated_hash_hash.values)

    redirect_to :back
  end


  def show_cam_info_index
    @cameras = CctVastDb::Camera.all
    @model_name_array = CctVastDb::Camera.get_model_name_array(@cameras)
    @soc_array = CctVastDb::TestSocCamera.show_array_of_soc_option()

    # if search by soc option
    if params[:search_by_soc_option]
      @selected_keyword_models = CctVastDb::Camera.search_by_soc(params[:search_by_soc_option])
    end

    # if search by keyword
    if params[:search_update_cam_by_keyword]
      @selected_keyword_models = CctVastDb::Camera.search_by_keyword(params[:search_update_cam_by_keyword])
    end
  end


  def show_cam_info
    @cameras = CctVastDb::Camera.all
    @cameras_other_info = CctVastDb::CameraOtherInfo.all


    if params[:search_update_cam]
      @selected_camera_model_fw_name = params[:search_update_cam]
    end

    # from check box checked value to get model array to be updated
    if params[:check_box_ids_array]
      # @checked_model_array = params[:check_box_ids_array]
      @checked_model_array = CctVastDb::Camera.find(params[:check_box_ids_array])

      @db_camera_name_obj_array = CctVastDb::ShowCamInfoAndUpdate.get_db_camera_name_obj_array(@checked_model_array)

    end

  end


  def show_soc_info_index
    # @start_soc_compare_index_time = Time.now


    @soc_array = CctVastDb::TestSocCamera.show_array_of_soc_option()
    @test_cam_array = CctVastDb::TestSocCamera.get_test_camera_model_array()


    # the following is processing
    if params[:search_compare_cam_by_keyword]
      @imported_keyword_models = CctVastDb::TestSocCamera.search_by_keyword(params[:search_compare_cam_by_keyword])
    end

  end


  def show_soc_info

    # from check box checked value to get model array to be updated
    if params[:check_box_ids_array]

      @time1 = Time.now


      # Rails.logger.debug("TESTTEST!!!: #{params[:check_box_ids_array].inspect}")   # ok
      # Rails.logger.debug("search soc string!!!: #{params[:search_soc].inspect}")   # ok

      # soc info
      @db_cameras_by_soc = CctVastDb::Camera.search_soc(params[:search_soc])
      @soc_name_str = params[:search_soc]

      # for show soc's total info
      CctVastDb::Camera.column_names.each do |column_name|

        if column_name == "id" || column_name == "created_at" || column_name == "updated_at"
          next
        else
          # we can use instance_variable_set to create instance_variable_set  by string name and
          # we can put function to set value of instance variable
          instance_variable_set("@db_#{column_name}", CctVastDb::Camera.deal_supported_by_column_name(@db_cameras_by_soc, column_name))

        end

      end

      # ----------------------------------------------------------------------------------------------------------
      # camera info

      # Rails.logger.debug("TEST import soc cam!!!: #{params[:check_box_ids_array].inspect}")   # ok

      @test_selected_camera_array = CctVastDb::TestSocCamera.find(params[:check_box_ids_array])
      @selected_indexed_hash = CctVastDb::TestSocCamera.set_selected_compare_cam_to_hash(@test_selected_camera_array)



      # time2 = Time.now
      #
      #
      # timedif = time2 - time1

      #
      # url = "http://172.19.16.106/toolkits/add_record?name=VAST_DevicePack_Database_2.0&function="+ "show_soc_info" + "&duration=" + timedif.to_s
      # response = open(url) {|io| io.read}



    end

  end


  def new_and_update_cam_info_index
    @import_update_cameras = CctVastDb::ShowCamInfoAndUpdate.all

    # get import model name array
    @new_import_model_name_array = CctVastDb::ShowCamInfoAndUpdate.get_model_name_array(@import_update_cameras)

    # get camera to be updated
    @update_cam_array = CctVastDb::Camera.get_update_cam_array()

  end


  def new_cam_info_index

    @import_update_cameras = CctVastDb::ShowCamInfoAndUpdate.all

    # get import model name array
    @new_import_model_name_array = CctVastDb::ShowCamInfoAndUpdate.get_model_name_array(@import_update_cameras)

    # get camera to be updated
    @update_cam_array = CctVastDb::Camera.get_update_cam_array()

    # if search by keyword
    if params[:search_update_cam_by_keyword]
      # new ver.
      @imported_keyword_models = CctVastDb::ShowCamInfoAndUpdate.search_by_keyword(params[:search_update_cam_by_keyword])

    end

    @soc_array = CctVastDb::TestSocCamera.show_array_of_soc_option()

  end


  def new_cam_info
    # if search by option
    if params[:search_update_cam]
      @selected_camera_model_fw_name = params[:search_update_cam]
    end

    # from check box checked value to get model array to be updated
    if params[:check_box_ids_array]
      # @checked_model_array = params[:check_box_ids_array]
      @checked_model_array = CctVastDb::Camera.where(:CameraModel => params[:check_box_ids_array])

    end

    # test for update
    @cam_add_targets = CctVastDb::ShowCamInfoAndUpdate.find(params[:check_box_ids_array])
    @soc_array = CctVastDb::TestSocCamera.show_array_of_soc_option()


  end


  def update_cam_info_index
    @soc_array = CctVastDb::TestSocCamera.show_array_of_soc_option()
    @import_update_cameras = CctVastDb::ShowCamInfoAndUpdate.all

    # get camera to be updated
    @update_cam_array = CctVastDb::Camera.get_update_cam_array()


    # if search by soc option
    if params[:search_by_soc_option]
      @selected_keyword_models = CctVastDb::Camera.search_by_soc(params[:search_by_soc_option])
    end


    # if search by keyword
    if params[:search_update_cam_by_keyword]
      @selected_keyword_models = CctVastDb::Camera.search_by_keyword(params[:search_update_cam_by_keyword])
    end
  end


  def update_cam_info
    # if search by option
    if params[:search_update_cam]
      @selected_camera_model_fw_name = params[:search_update_cam]
    end

    # from check box checked value to get model array to be updated
    if params[:check_box_ids_array]
      # @checked_model_array = params[:check_box_ids_array]
      @checked_model_array = CctVastDb::Camera.find(params[:check_box_ids_array])

      # put Camera's selected model_fw_name into an array
      @checked_model_name_str_array = []
      @checked_model_array.each do |cheked_model_obj|
        @checked_model_name_str_array.append(cheked_model_obj["CameraModel"])
      end

      # put Camera's selected id into an array
      @checked_model_id_array = []
      @checked_model_array.each do |cheked_model_obj|
        @checked_model_id_array.append(cheked_model_obj["id"])
      end

    end

    @import_update_cameras = CctVastDb::ShowCamInfoAndUpdate.all
    @soc_array = CctVastDb::TestSocCamera.show_array_of_soc_option()

    @db_camera_name_obj_array = CctVastDb::ShowCamInfoAndUpdate.get_db_camera_name_obj_array(@checked_model_array)
    @import_cameras_obj_array = CctVastDb::ShowCamInfoAndUpdate.get_import_cameras_obj_array(@import_update_cameras, @checked_model_name_str_array)




  end


  def update_cam_other_info_index
    @camera_other_info = CctVastDb::CameraOtherInfo.new
    @import_update_cameras = CctVastDb::ShowCamInfoAndUpdate.all
    @cameras = CctVastDb::Camera.all

    @soc_array = @soc_array = CctVastDb::TestSocCamera.show_array_of_soc_option()

    # get import model name array
    @new_import_model_name_array = CctVastDb::ShowCamInfoAndUpdate.get_model_name_array(@cameras)

    # if search by soc option
    if params[:search_by_soc_option]
      @selected_keyword_models = CctVastDb::Camera.search_by_soc(params[:search_by_soc_option])

      Rails.logger.debug("TEST SELECTED  KEYWORD : #{@selected_keyword_models.inspect}")   # ok


    end

    # if search by keyword
    if params[:search_update_cam_by_keyword]
      # new ver.
      @selected_keyword_models = CctVastDb::Camera.search_by_keyword(params[:search_update_cam_by_keyword])
      # @imported_keyword_models = CctVastDb::ShowCamInfoAndUpdate.search_by_keyword(params[:search_update_cam_by_keyword])
    end

  end

  def update_cam_other_info
    @pass_fail_array = ['', 'Pass', 'Fail']
    @tester_array = ['', 'Ting Liao', 'Blue Yang', 'Kay Chao', 'David']
    # @sw_nvr_array = ['', 'ND9541', 'ND8322P', 'Shepherd']

    @import_update_cameras = CctVastDb::ShowCamInfoAndUpdate.all

    @checked_model_for_other_info_name_str_array = []

    if params[:check_box_ids_array]
      @checked_model_id_array = params[:check_box_ids_array]
      @checked_model_id_array.each do |cheked_model_id|
        cheked_model_obj = CctVastDb::Camera.find(cheked_model_id)
        # cheked_model_obj = CctVastDb::ShowCamInfoAndUpdate.find(cheked_model_id)
        @checked_model_for_other_info_name_str_array.append(cheked_model_obj["CameraModel"])
      end
    end

    Rails.logger.debug("TEST CHECKBOX idPARAMS: #{params[:check_box_ids_array].inspect}")   # ok
    Rails.logger.debug("TEST CHECKBOX objPARAMS: #{@checked_model_obj_array.inspect}")   # ok
    Rails.logger.debug("TEST CHECKBOX namePARAMS: #{@checked_model_for_other_info_name_str_array.inspect}")   # ok

    # Rails.logger.debug("TEST OTHERINFO PARAMS: #{test.inspect}")   # ok
    # watch out: can't type "@cameras_other_info", it shoud be odd number
    # @camera_other_info = CctVastDb::CameraOtherInfo.new(create_other_info_params)    #OK
    # @camera_other_info.save   #OK


    # redirect_to :back
  end


  def create_camera_other_info
    selected_model_name_hidden_str = params[:selected_model_name]
    selected_model_name_hidden_str_array = selected_model_name_hidden_str.split(" ")

    other_info_fw_str = params[:FW_Ver]
    # other_info_sw_nvr_str = params[:SW_NVR]
    other_info_sw_nvr_ver_str = params[:VAST_Ver]
    other_info_vdp_str = params[:VDP_Ver]
    other_info_pkg_str = params[:PKG_Ver]
    other_info_tester_str = params[:Tester]
    other_info_pass_fail_str = params[:Pass_Fail]
    other_info_note_str = params[:Note]

    temp_camera_other_info_without_model_name_hash = {}
    temp_camera_other_info_without_model_name_hash["FW_Ver"] = other_info_fw_str
    # temp_camera_other_info_without_model_name_hash["SW_NVR"] = other_info_sw_nvr_str
    temp_camera_other_info_without_model_name_hash["VAST_Ver"] = other_info_sw_nvr_ver_str
    temp_camera_other_info_without_model_name_hash["VDP_Ver"] = other_info_vdp_str
    temp_camera_other_info_without_model_name_hash["PKG_Ver"] = other_info_pkg_str
    temp_camera_other_info_without_model_name_hash["Tester"] = other_info_tester_str
    temp_camera_other_info_without_model_name_hash["Pass_Fail"] = other_info_pass_fail_str
    temp_camera_other_info_without_model_name_hash["Note"] = other_info_note_str

    # Rails.logger.debug("hidden selected: #{selected_model_name_hidden_str_array.inspect}")  # ok
    # Rails.logger.debug("hidden fw selected: #{other_info_fw_str.inspect}") # ok

    add_camera_other_info_hash_array = CctVastDb::CameraOtherInfo.get_add_camera_other_info_hash_array(
        selected_model_name_hidden_str_array, temp_camera_other_info_without_model_name_hash)

    Rails.logger.debug("hidden hash array selected: #{add_camera_other_info_hash_array.inspect}")  # ok

    if !add_camera_other_info_hash_array.nil?
      CctVastDb::CameraOtherInfo.create(add_camera_other_info_hash_array)
    else
      redirect_to update_cam_other_info_index_cameras_path
      return
    end

    redirect_to new_and_update_cam_info_index_cct_vast_db_cameras_path

  end


  def export_csv_index_cameras

    @cameras = CctVastDb::Camera.all
    @cameras_other_info = CctVastDb::CameraOtherInfo.all


  end


  private


  #
  def camera_update_test_params
    params.require(:camera).permit(:Soc)
  end

  # def camera_create_params
  #
  #   # because :test_add_array is a array which include hash, so we need to do this.
  #   params.require(:test_add_array).map do |u|
  #     ActionController::Parameters.new(u.to_hash).permit(:CameraModel, :Soc, :uid_audio_codec, :uid_video_mode,
  #     :uid_s0_video_codec, :uid_s0_frame_size, :uid_s0_mpeg4_max_frame_rate, :uid_s0_mpeg4_intra_period,
  #     :uid_s0_mpeg4_video_quality, :uid_s0_mpeg4_bitrate_restriction, :uid_s0_mpeg4_constant_bitrate,
  #     :uid_s0_mpeg4_constant_bitrate_policy, :uid_s0_mpeg4_fixed_quality, :uid_s0_h264_max_frame_rate,
  #     :uid_s0_h264_intra_period, :uid_s0_h264_video_quality, :uid_s0_h264_bitrate_restriction,
  #     :uid_s0_h264_constant_bitrate, :uid_s0_h264_constant_bitrate_policy, :uid_s0_h264_fixed_quality,
  #     :uid_s0_mjpeg_max_frame_rate, :uid_s0_mjpeg_video_quality, :uid_s0_mjpeg_bitrate_restriction,
  #     :uid_s0_mjpeg_constant_bitrate, :uid_s0_mjpeg_constant_bitrate_policy, :uid_s0_mjpeg_fixed_quality,
  #     :uid_s0_svc_max_frame_rate, :uid_s0_svc_intra_period, :uid_s0_svc_video_quality, :uid_s0_svc_bitrate_restriction,
  #     :uid_s0_svc_constant_bitrate, :uid_s0_svc_constant_bitrate_policy, :uid_s0_svc_fixed_quality,
  #     :uid_s0_h265_max_frame_rate, :uid_s0_h265_intra_period, :uid_s0_h265_video_quality, :uid_s0_h265_bitrate_restriction,
  #     :uid_s0_h265_constant_bitrate, :uid_s0_h265_constant_bitrate_policy, :uid_s0_h265_fixed_quality,
  #     :uid_s0_mpeg4_max_vbr_bitrate, :uid_s0_h264_max_vbr_bitrate, :uid_s0_mjpeg_max_vbr_bitrate, :uid_s0_svc_max_vbr_bitrate,
  #     :uid_s0_h265_max_vbr_bitrate, :uid_s0_h264_smartstream_foreground_quality, :uid_s0_h264_smartstream_background_quality,
  #     :uid_s0_h264_smartstream_max_bit_rate, :uid_s0_h264_smartstream_mode, :uid_s0_h265_smartstream_foreground_quality,
  #     :uid_s0_h265_smartstream_background_quality, :uid_s0_h265_smartstream_max_bit_rate, :uid_s0_h265_smartstream_mode,
  #     :uid_min_exposure_time, :uid_max_exposure_time, :uid_min_exposure_time_profile, :uid_max_exposure_time_profile,
  #     :uid_network_rtsp_authmode, :uid_network_http_authmode, :uid_audio_g711_mode, :uid_audio_aac_bitrate,
  #     :uid_audio_gamr_bitrate, :uid_audio_g726_bitrate)
  #
  #   end
  #
  # end



end

