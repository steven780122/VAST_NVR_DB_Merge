class CctNvrDb::CameraOtherInfo < ActiveRecord::Base
  require 'csv'
  validates_presence_of :"Model_FW_name"     # "Model name" must be written
  belongs_to :cct_nvr_db_camera


  def self.import(file)
    CctNvrDb::CameraOtherInfo.destroy_all

    CSV.foreach(file.path, headers:true, :encoding => 'iso-8859-1:utf-8') do |row|
      # move update foreign key to controller (after file name analyze)

      # # when create other info into db, it need to save association's camera_id
      # camera_other_info_hash = row.to_hash
      # camera_other_info_model_name = camera_other_info_hash["Model_FW_name"]
      #
      # camera_other_info_new_hash = camera_other_info_hash
      # match_camera_obj = Camera.find_by_Model_FW_name(camera_other_info_model_name)
      # camera_other_info_new_hash[:camera_id] = match_camera_obj.id
      # # Rails.logger.debug("TEST camera other info row hash: #{camera_other_info_hash.inspect}")   # ok
      # # Rails.logger.debug("TEST camera other info row hash: #{camera_other_info_new_hash.inspect}")   # ok
      #
      # CameraOtherInfo.create(camera_other_info_new_hash)
      #

      CctNvrDb::CameraOtherInfo.create! row.to_hash    # ori OK!! (but no association when create db!)


    end
  end


  def self.update_association_foreign_key
    camera_other_infos_obj = self.all

    camera_other_infos_obj.each do |camera_other_info|
      camera_other_info_model_name = camera_other_info["Model_FW_name"]
      match_camera_obj = CctNvrDb::Camera.find_by_Model_FW_name(camera_other_info_model_name)

      # if camera other info's cameras model name are not in cameras' model name, then we pass it, but will show warning
      # when create camera info at import success page!!
      if !match_camera_obj.nil?
        camera_other_info.update_attribute  :camera_id, match_camera_obj.id
      else
        next
      end
    end
  end


  def self.get_add_camera_other_info_hash_array(
      selected_model_name_hidden_str_array, temp_camera_other_info_without_model_name_hash)

    add_camera_other_info_hash_array = []


    Rails.logger.debug("hidden function selected array: #{selected_model_name_hidden_str_array.inspect}")   # OK
    # Rails.logger.debug("hidden function selected model name: #{temp_camera_other_info_without_model_name_hash.inspect}") # ok

    if !selected_model_name_hidden_str_array.empty?

      selected_model_name_hidden_str_array.each do |selected_model_name_hidden_str|
        temp_model_name_hash = {}
        temp_model_name_hash["Model_FW_name"] = selected_model_name_hidden_str

        # must set association camera_other_info camera_id's info!
        temp_model_name_hash[:camera_id] = CctNvrDb::Camera.find_by_Model_FW_name(selected_model_name_hidden_str).id

        temp_model_name_hash.merge!(temp_camera_other_info_without_model_name_hash)
        add_camera_other_info_hash_array.append(temp_model_name_hash)

      end

    end

    return add_camera_other_info_hash_array
  end


  def self.check_all_other_info_model_existed()
    existed_bool = TRUE
    other_info_not_existed_array = []

    if CctNvrDb::CameraOtherInfo.exists?
      total_camera_other_infos = CctNvrDb::CameraOtherInfo.all
      total_camera_infos = CctNvrDb::Camera.all

      # set other info cam name
      total_camera_other_infos_array = []
      total_camera_other_infos.each do |camera|
        total_camera_other_infos_array.append(camera["Model_FW_name"])
      end

      # set cam info name
      total_camera_infos_array = []
      total_camera_infos.each do |camera|
        total_camera_infos_array.append(camera["Model_FW_name"])
      end

      Rails.logger.debug("TEST total info model name: #{total_camera_infos_array.inspect}")   # ok
      Rails.logger.debug("TEST other info model name: #{total_camera_other_infos_array.inspect}") # ok

      # check if all other info cameras existed in total camera
      total_camera_other_infos_array.each do |other_cam_str|
        if !total_camera_infos_array.include?(other_cam_str)
          other_info_not_existed_array.append(other_cam_str)
          existed_bool = FALSE
        end
      end

    end

    # Rails.logger.debug("TEST existed_bool: #{existed_bool.inspect}")   # ok
    # Rails.logger.debug("TEST not existed array: #{other_info_not_existed_array.inspect}")   # ok

    return existed_bool, other_info_not_existed_array
  end


  def self.to_csv
    attributes = column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end

  end


end













