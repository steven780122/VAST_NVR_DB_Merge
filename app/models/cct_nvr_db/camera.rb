class CctNvrDb::Camera < ActiveRecord::Base
  require 'csv'

  validates_presence_of :"Model_FW_name"     # "Model name" must be written

  has_many :cct_nvr_db_camera_other_infos, :class_name => 'CctNvrDb::CameraOtherInfo', autosave: true


  def self.import(file)
    CctNvrDb::Camera.destroy_all

    CSV.foreach(file.path, headers:true, :encoding => 'iso-8859-1:utf-8') do |row|
      CctNvrDb::Camera.create! row.to_hash
    end

    # After import Camera infos, we need to update all association foreign keys!!
    CctNvrDb::CameraOtherInfo.update_association_foreign_key

  end


  def self.get_model_name_array(cameras_record)
    model_name_array = []

    cameras_record.each do |camera|
      model_name_array.push(camera.Model_FW_name)
    end

    return model_name_array
  end


  def self.search_soc(query)
    where(:"Soc" => "#{query}")
  end


  def self.deal_supported_by_column_name(db_cameras, column_name)
    all_array = []

    db_cameras.each do |db_camera|
      db_camera_column_content = db_camera[column_name]
      array_temp = db_camera_column_content.try(:split, ",")
      if array_temp != NIL
        all_array += array_temp
      end

    end

    # remove duplicated element in array
    all_array.uniq!

    return all_array
  end

  # for cam which need to be updated info (by option)
  def self.get_update_cam_array
    model_name_array = []

    self.all.each do |camera|
      model_name_array.push(camera.Model_FW_name)
    end

    return model_name_array.sort!

  end

  # for cam which need to be updated info (by keyword)
  def self.search_by_soc(search)
    if search
      where('Soc LIKE ?' , "%#{search}%" )
    else
      scoped
    end

  end



  # for cam which need to be updated info (by keyword)
  def self.search_by_keyword(search)
    if search
      where('Model_FW_name LIKE ?' , "%#{search}%" )
    else
      scoped
    end

  end


  def self.update_target(targets)
    targets.update_all(Soc: "X____9.1DDD")
  end


  def self.if_excluded_model_name_html(model_name_str, compare_model_obj_array)
    if_existed = FALSE

    if match = model_name_str.match(/(.*)_(.*)/i)
      model_name_str, fw_str = match.captures
    end

    # model name could be ModelName_FW, but we don't care the FW, so separate it.
    compare_model_obj_array.each do |camera_obj|

      if match2 = camera_obj["Model_FW_name"].match(/(.*)_(.*)/i)
        model_name_str2, fw_str = match2.captures
      else
        model_name_str2 = camera_obj["Model_FW_name"]
      end


      if model_name_str2 == model_name_str
        if_existed = TRUE
      end

    end

    # model name could be ModelName_FW, but we don't care the FW, so separate it.
    # compare_model_obj_array.each do |camera_obj|
    #
    #   if camera_obj["Model_FW_name"] == model_name_str
    #     if_existed = TRUE
    #   end
    # end

    return if_existed
  end

  def self.get_model_name_without_fw(model_fw_name_str)
    model_name_str = model_fw_name_str

    if match2 = model_fw_name_str.match(/(.*)_(.*)/i)
      model_name_str, fw_str = match2.captures
    end

    return model_name_str
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




























