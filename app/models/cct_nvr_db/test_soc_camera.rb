

class CctNvrDb::TestSocCamera < ActiveRecord::Base
  require 'csv'

  validates_presence_of :"Model_FW_name"     # "Model name" must be written

  def self.import(file)
    CctNvrDb::TestSocCamera.destroy_all

    CSV.foreach(file.path, headers:true, :encoding => 'iso-8859-1:utf-8') do |row|

      CctNvrDb::TestSocCamera.create! row.to_hash

    end
  end


  def self.show_array_of_soc_option
    soc_array = ['', 'Hisilicon', 'Mozart325', 'Mozart330 (V2)', 'Mozart330s (V3)', 'Mozart365',
                 'Mozart370', 'Mozart380', 'Mozart385s (V3)', 'Ti-DM365', 'Ti-DM368', 'Ti-DM369',
                 'Ti-DM385', 'Ti-DM388', 'Rossini', 'Xarina', 'Ambarella', 'Mozart395s', 'Hisilicon 3516', 'Hisilicon 3519']

    soc_array.sort!

    return soc_array
  end


  def self.get_test_camera_model_array
    test_cam_model_array = []

    self.all.each do |test_camera_model|
      test_cam_model_array.append(test_camera_model["Model_FW_name"])

    end

    # sort for option list
    test_cam_model_array.sort!

    return test_cam_model_array
  end


  # for cam which need to be updated info (by keyword)
  def self.search_by_keyword(search)
    if search
      where('Model_FW_name LIKE ?' , "%#{search}%" )
    else
      scoped
    end

  end


  #
  # def self.search_test_cam(query)
  #   where(:"Model_FW_name" => "#{query}")
  # end


  # def self.deal_supported_by_column_name(db_cameras, column_name)
  #   all_array = []
  #
  #   db_cameras.each do |db_camera|
  #     db_camera_column_content = db_camera[column_name]
  #     array_temp = db_camera_column_content.try(:split, ",")
  #     if array_temp != NIL
  #       all_array += array_temp
  #     end
  #
  #   end
  #
  #   # remove duplicated element in array
  #   all_array.uniq!
  #
  #   return all_array
  #
  # end


  def self.get_array_from_string(column_content_str)
    all_array = []
    array_temp = column_content_str.try(:split, ",")
    if array_temp != NIL
      all_array += array_temp
    end

    all_array.uniq!

    return all_array
  end


  def self.update_different_html_tag(db_soc_column_array, test_cam_column_array)
    test_cam_final_array = []

    # if !test_cam_column_array.empty?
    test_cam_column_array.each  do |test_cam_element_str|
      if !db_soc_column_array.include?(test_cam_element_str)
        test_cam_final_array.append("<span class='different_element'>" + test_cam_element_str + "</span>")

      else
        test_cam_final_array.append(test_cam_element_str)
      end
    end

    # test_cam_final_str = "<span class='different_element'>" + test_cam_column_array.join(',') + "</span>"
    # end

    return test_cam_final_array.join(',')
  end


  def self.set_selected_compare_cam_to_hash(test_selected_camera_array)
    selected_index_hash = {}

    if !test_selected_camera_array.empty?
      # Rails.logger.debug("TEST indexed selected cam length!!!: #{cam_num.inspect}")   # ok
      # Rails.logger.debug("TEST indexed class!!!: #{(test_selected_camera_array.class).inspect}")   # ok
      test_selected_camera_array.each_with_index { |selected_cam, index | selected_index_hash[index] = selected_cam }
    end

    return selected_index_hash
  end

end












