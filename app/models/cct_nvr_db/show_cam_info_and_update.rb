class CctNvrDb::ShowCamInfoAndUpdate < ActiveRecord::Base
  require 'csv'

  validates_presence_of :"Model_FW_name"     # "Model name" must be written

  def self.import(file)
    CctNvrDb::ShowCamInfoAndUpdate.destroy_all

    CSV.foreach(file.path, headers:true, :encoding => 'iso-8859-1:utf-8') do |row|

      CctNvrDb::ShowCamInfoAndUpdate.create! row.to_hash

    end
  end


  def self.get_model_name_array(cameras_record)
    model_name_array = []

    cameras_record.each do |camera|
      model_name_array.push(camera.Model_FW_name)
    end

    return model_name_array
  end



  # for cam which need to be updated info (by keyword)
  def self.search_by_keyword(search)
    if search
      where('Model_FW_name LIKE ?' , "%#{search}%" )
    else
      scoped
    end

  end

  # def self.update_different_html_tag(import_cam_column_array, db_cam_column_array)
  #   db_cam_final_array = []
  #
  #   db_cam_column_array.each  do |db_cam_element_str|
  #     if !import_cam_column_array.include?(db_cam_element_str)
  #       db_cam_final_array.append("<span class='different_element'>" + db_cam_element_str + "</span>")
  #
  #     else
  #       db_cam_final_array.append(db_cam_element_str)
  #     end
  #   end
  #
  #   return db_cam_final_array.join(',')
  #
  # end


  def self.update_different_html_tag2(import_cam_column_str, db_cam_column_str)
    db_cam_column_array = db_cam_column_str.split(",")
    import_cam_column_array = import_cam_column_str.split(",")
    db_cam_final_array = []


    db_cam_column_array.each  do |db_cam_element_str|
      if !import_cam_column_array.include?(db_cam_element_str)
        db_cam_final_array.append("<span class='different_element'>" + db_cam_element_str + "</span>")

      else
        db_cam_final_array.append(db_cam_element_str)
      end
    end

    return db_cam_final_array.join(',')

  end


  def self.get_db_camera_name_obj_array(checked_model_array)
    db_camera_name_obj_array = []
    checked_model_array.each_with_index {|model_name_obj, model_index| db_camera_name_obj_array[model_index] = model_name_obj}

    return db_camera_name_obj_array
  end


  def self.get_import_cameras_obj_array(import_update_cameras, checked_model_name_str_array)
    import_cameras_obj_array = []
    import_update_cameras.each do |import_update_camera_obj|
      if checked_model_name_str_array.include? import_update_camera_obj["Model_FW_name"]
        import_cameras_obj_array.append(import_update_camera_obj)
      end
    end

    return import_cameras_obj_array
  end

  #
  # # the output we need is like: [{:Model_FW_name: "XXX1", :Soc : "s1"},{:Model_FW_name: "XXX2", :Soc : "s2"}]
  # def self.get_selected_to_add_cam_hash_array(selected_cam_obj_instances, soc_name_str)
  #   final_cam_add_array = []
  #
  #   selected_cam_obj_instances.each do |selected_cam_obj|
  #     temp_cam_hash = {}
  #
  #       # if the camera is already in Camera, then not put it in
  #       if !Camera.find_by_Model_FW_name(selected_cam_obj["Model_FW_name"])
  #
  #         Camera.column_names.each do |column_name|
  #           if column_name != "id" and column_name != "created_at" and column_name != "updated_at"
  #             if column_name != "Soc"
  #               temp_cam_hash[column_name] = selected_cam_obj[column_name].to_s
  #             else
  #               temp_cam_hash[column_name] = soc_name_str
  #             end
  #           end
  #         end
  #
  #       end
  #
  #     final_cam_add_array << temp_cam_hash
  #   end
  #
  #   return final_cam_add_array
  # end


  # the output we need is like: [{:Model_FW_name: "XXX1", :Soc : "s1"},{:Model_FW_name: "XXX2", :Soc : "s2"}]
  def self.get_selected_to_add_cam_hash_array(selected_cam_obj_instances, soc_name_str)
    final_cam_add_array = []

    selected_cam_obj_instances.each do |selected_cam_obj|
      temp_cam_hash = {}

      # if the camera is already in Camera, then not put it in
      if !CctNvrDb::Camera.find_by_Model_FW_name(selected_cam_obj["Model_FW_name"])
        CctNvrDb::Camera.column_names.each do |column_name|
          if column_name != "id" and column_name != "created_at" and column_name != "updated_at"
            if column_name != "Soc"
              temp_cam_hash[column_name] = selected_cam_obj[column_name].to_s
            else
              temp_cam_hash[column_name] = soc_name_str
            end
          end
        end
      end

      final_cam_add_array << temp_cam_hash
    end

    return final_cam_add_array
  end





  def self.get_selected_to_update_cam_without_soc_hash_hash(db_cam_updated_target_objs_array, import_update_sources_objs_array)
    # Rails.logger.debug("My object1: #{db_cam_updated_target_objs_array.inspect}")   # ok
    # Rails.logger.debug("My object2: #{import_update_sources_objs_array.inspect}")   # ok

    final_updated_targets_hash = {}

    db_cam_updated_target_objs_array.each do |updated_target_cam_obj|
      target_id = updated_target_cam_obj["id"]
      target_cam_name_str = updated_target_cam_obj["Model_FW_name"]

      temp_cam_info_for_updated_hash = {}

      import_update_sources_objs_array.each do |import_source_cam_obj|
        if import_source_cam_obj["Model_FW_name"] == target_cam_name_str
          self.column_names.each do |column_name|
            if column_name != "id" and column_name != "created_at" and column_name != "updated_at" and column_name != "Soc"
              temp_cam_info_for_updated_hash[column_name] = import_source_cam_obj[column_name]
            end
          end
        end
      end

      final_updated_targets_hash[target_id] = temp_cam_info_for_updated_hash
    end

    # Rails.logger.debug("My HASH: #{final_updated_targets_hash.inspect}")

    return final_updated_targets_hash
  end


  def self.get_selected_to_update_soc_hash_hash(soc_to_be_updated_id_array, soc_option_str)
    # Rails.logger.debug("test db global instance: #{db_camera_name_obj_array.inspect}")
    # Rails.logger.debug("test import global instance: #{import_cameras_obj_array.inspect}")
    final_updated_soc_hash = {}

    # every hash is the same
    soc_hash = {}
    soc_hash["Soc"] = soc_option_str

    soc_to_be_updated_id_array.each do |id_int|
      final_updated_soc_hash[id_int] = soc_hash
    end

    # Rails.logger.debug("My HASH: #{final_updated_targets_hash.inspect}")

    return final_updated_soc_hash

  end



end


