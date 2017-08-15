class CctVastDb::Camera < ActiveRecord::Base

  require 'csv'

  validates_presence_of :"CameraModel"     # "Model name" must be written

  # has_many :camera_other_infos, autosave: true
  has_many :cct_vast_db_camera_other_infos, :class_name => 'CctVastDb::CameraOtherInfo', autosave: true

  def self.import(file)
    CctVastDb::Camera.destroy_all

    CSV.foreach(file.path, headers:true) do |row|
      new_hash = {}

      # because original VAST DP's column have ' ', '-', '.', so we remove it for convenient
      row.each{|k, v| new_hash[k.delete(' .-')] = v if (k.class != NilClass)}

      CctVastDb::Camera.create! new_hash.slice(
          "CameraModel",
          "Soc",
          "Numberofstreams",
          "Videocodecsupported",
          "FOVsupported",
          "Framesizesupported",
          "Frameratesupported",
          "MPEG4maximumframeratesupported",
          "H264maximumframeratesupported",
          "SVCmaximumframeratesupported",
          "JPEGmaximumframeratesupported",
          "Videoqualitysupported",
          "Bitratesupported",
          "Audiosupported",
          "Audiocodecsupported",
          "AudiobitratesupportedAAC",
          "AudiobitratesupportedGSM",
          "Remotefocussupported",
          "MozartV1",
          "MT9P006",
          "FOVsize",
          "AudiobitratesupportedG726",
          "Smartstreamqualitysupported",
          "Smartstreammaximumbitratesupported",
          "Numberofsmartstreams",
          "H265maximumframeratesupported",
          "Maximumframesize",
      )

      # Camera.create! row.to_hash
    end

    # After import Camera infos, we need to update all association foreign keys!!
    CctVastDb::CameraOtherInfo.update_association_foreign_key

  end


  def self.get_model_name_array(cameras_record)
    model_name_array = []

    cameras_record.each do |camera|
      model_name_array.push(camera.CameraModel)
    end

    return model_name_array
  end


  def self.search_soc(query)
    where(:"Soc" => "#{query}")
  end



  # # original deal_supported_by_column_name
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
  # end


  # here is different from NVR's !!
  def self.deal_supported_by_column_name(db_cameras, column_name)
    all_array = []

    db_cameras.each do |db_camera|
      db_camera_column_content = db_camera[column_name]
      all_array.append(db_camera_column_content)
    end
    # Rails.logger.debug("TESTBUG!!!!!!!!!: #{column_name.inspect}")   # ok
    # Rails.logger.debug("TESTBUGallarray0!!!!!!!!!: #{all_array.inspect}")   # ok

    # remove duplicated element in array
    all_array.uniq!
    # compact is for remove "nil" in array
    all_array.compact!

    # Rails.logger.debug("TESTBUGallarray1!!!!!!!!!: #{all_array.inspect}")   # ok
    return all_array
  end


  def self.transfer_union_string_for_compare_soc(union_string)
    if not union_string.blank?
      if union_string.include? ';'
        after_transferred_string = union_string.gsub! ';', ','
        return after_transferred_string
      else
        return union_string
      end
    else
      return union_string
    end
  end


  def self.transfer_string_to_hash(transferred_string)
    is_hash = TRUE

    if not transferred_string.blank?

      # if the contend supports fov
      if transferred_string.include? '['
        transferred_hash = {}

        split_array_by_bracket = transferred_string.split('[')

        # Rails.logger.debug("TEST splitted bracket!!!!!: #{split_array_by_bracket.inspect}")

        for split_string in split_array_by_bracket
          if split_string.include? ']'
            split_str_array = split_string.split(']')
            split_fov_str = split_str_array[0].downcase
            split_fov_contend_str = split_str_array[1]

            # Rails.logger.debug("TEST split_fov_str!!!!!: #{split_fov_str.inspect}")
            # Rails.logger.debug("TEST split_fov_contend_str!!!!!: #{split_fov_contend_str.inspect}")

            # set fov
            fov = ""
            if split_fov_str.include? 'dual'
              fov = "Dual"
            elsif split_fov_str.include? 'rotation'
              fov = "Rotation"
            elsif split_fov_str.include? 'single'
              fov = "Single"
            elsif (split_fov_str.include? '2-megapixel') || (split_fov_str.include? '2m')
              fov = "2M"
            elsif (split_fov_str.include? '3-m') || (split_fov_str.include? '3m') || (split_fov_str.include? '3.6-m')
              fov = "3M"
            elsif (split_fov_str.include? '4-megapixel') || (split_fov_str.include? '4m')
              fov = "4M"
            elsif (split_fov_str.include? '5-megapixel') || (split_fov_str.include? '5m')
              fov = "5M"
            elsif split_fov_str.include? '720p'
              fov = "720P"
            elsif split_fov_str.include? '960p'
              fov = "960P"
            elsif split_fov_str.include? '1080p'
              fov = "1080P"
            elsif (split_fov_str.include? 'fish') || (split_fov_str.include? 'fe')
              fov = "FE"
            elsif split_fov_str.include? 'all'
              fov = "ALL"
            else
              next
            end


            # fov = ""
            # if (split_fov_str.include? '2-Megapixel') || (split_fov_str.include? '2M')
            #   fov = "2M"
            # elsif (split_fov_str.include? '3-M') || (split_fov_str.include? '3M') || (split_fov_str.include? '3.6-M')
            #   fov = "3M"
            # elsif (split_fov_str.include? '4-Megapixel') || (split_fov_str.include? '4M')
            #   fov = "4M"
            # elsif (split_fov_str.include? '5-Megapixel') || (split_fov_str.include? '5M')
            #   fov = "5M"
            # elsif split_fov_str.include? '720P'
            #   fov = "720P"
            # elsif split_fov_str.include? '960P'
            #   fov = "960P"
            # elsif split_fov_str.include? '1080P'
            #   fov = "1080P"
            # elsif (split_fov_str.include? 'Fish') || (split_fov_str.include? 'FE')
            #   fov = "FE"
            # elsif split_fov_str.include? 'Dual'
            #   fov = "Dual"
            # elsif split_fov_str.include? 'Rotation'
            #   fov = "Rotation"
            # elsif split_fov_str.include? 'Single'
            #   fov = "Single"
            # elsif split_fov_str.include? 'ALL'
            #   fov = "ALL"
            # # else
            # #   next
            # end

            # set string
            if split_fov_contend_str.include? ','
              split_contend_element_array = split_fov_contend_str.split(',')
              split_contend_element_array = split_contend_element_array.reject { |c| c.empty? }
              split_contend_element_array = split_contend_element_array.uniq
              # Rails.logger.debug("TEST split_contend_element_array!!!!!: #{split_contend_element_array.inspect}")
            else
              split_contend_element_array = [].append(split_fov_contend_str)
            end

            # check whether hash the key of fov, if not then create or append
            if transferred_hash.has_key?(fov)
              transferred_hash[fov] += split_contend_element_array
              transferred_hash[fov] = transferred_hash[fov].uniq
              transferred_hash[fov].sort!
              #  if no key
            else
              transferred_hash[fov] = split_contend_element_array
              transferred_hash[fov].sort!
            end

          end
        end

        # sort hash by keys
        transferred_hash = transferred_hash.sort.to_h

        return is_hash, transferred_hash

        # if the contend has no fov, it's a string
      else
        is_hash = FALSE

        if transferred_string.include? ','
          transferred_string_temp_array = transferred_string.split(',')
          transferred_string_temp_array = transferred_string_temp_array.uniq
          transferred_string = transferred_string_temp_array.join(",")
        end

        return is_hash, transferred_string
      end

      # if import string is blank string
    else
      is_hash = FALSE
      return is_hash, transferred_string
    end
  end


  # for exporting transferred-hash   (without updating differential)
  def self.export_transferred_hash_to_html(transferred_hash)
    final_html_str = ""

    if !transferred_hash.empty?
      for fov_key, value in transferred_hash
        final_html_str += ("<b>" + fov_key + "</b>")
        final_html_str += ":"
        fov_contend_array = transferred_hash[fov_key]
        fov_contend_string = fov_contend_array.join(",")
        final_html_str += fov_contend_string
        final_html_str += "<br><br>"
      end
    end

    return final_html_str
  end


  # update different html, import_cam_hash_or_str is a hash
  def self.update_cam_different_html_from_hash(db_union_hash_or_str, import_cam_hash_or_str)
    final_html_str = ""

    if !import_cam_hash_or_str.empty?
      # if db_union_hash_or_str is a hash
      if !db_union_hash_or_str.instance_of? String
        # final_html_str += "1111111"
        for fov_key, value in import_cam_hash_or_str
          final_html_str += ("<b>" + fov_key + "</b>")
          final_html_str += ":"
          fov_contend_array = import_cam_hash_or_str[fov_key]

          if !db_union_hash_or_str.has_key?(fov_key)
            fov_contend_string = fov_contend_array.join(",")
            final_html_str += ("<span class=\"different_element\">" + fov_contend_string + "</span>")
            final_html_str += "<br><br>"
            # db union have the fov
          else
            temp_fov_contend_array = []
            # loop every element in specific fov
            for fov_contend_array_element in fov_contend_array
              if db_union_hash_or_str[fov_key].include? (fov_contend_array_element)
                temp_fov_contend_array.append(fov_contend_array_element)
              else
                temp_fov_contend_array.append("<span class=\"different_element\">" + fov_contend_array_element + "</span>")
              end
            end

            final_html_str += temp_fov_contend_array.join(",")
          end

          final_html_str += "<br><br>"
        end

        # if db_union_hash_or_str is string, than we set it all red
      else
        for fov_key, value in import_cam_hash_or_str
          final_html_str += ("<b>" + fov_key + "</b>")
          final_html_str += ":"
          fov_contend_array = import_cam_hash_or_str[fov_key]
          fov_contend_string = fov_contend_array.join(",")
          final_html_str += ("<span class=\"different_element\">" + fov_contend_string + "</span>")
          # fov_contend_string
          final_html_str += "<br><br>"
        end
      end
    end

    return final_html_str
  end

  # update different html, import_cam_hash_or_str is a string
  def self.update_cam_different_html_from_string(db_union_hash_or_str, import_cam_hash_or_str)
    final_html_str = ""

    if !import_cam_hash_or_str.blank?


      # if db_union is a hash or others, than we set all are different
      if !db_union_hash_or_str.instance_of? String
        temp_cam_contend_array = []

        cam_contend_array = import_cam_hash_or_str.split(",")
        for cam_contend_array_element in cam_contend_array
          temp_cam_contend_array.append("<span class=\"different_element\">" + cam_contend_array_element + "</span>")
        end

        final_html_str += temp_cam_contend_array.join(",")

        # db_union is a string, than we do loop element
      else
        temp_cam_contend_array = []

        cam_contend_array = import_cam_hash_or_str.split(",")
        db_contend_array = db_union_hash_or_str.split(",")

        for cam_contend_array_element in cam_contend_array
          # if the element is in db
          if db_contend_array.include? (cam_contend_array_element)
            temp_cam_contend_array.append(cam_contend_array_element)
            # if the element is not in db
          else
            temp_cam_contend_array.append("<span class=\"different_element\">" + cam_contend_array_element + "</span>")
          end
        end

        final_html_str += temp_cam_contend_array.join(",")

      end
    end

    return final_html_str

  end

  ########################################################

  # for cam which need to be updated info (by option)
  def self.get_update_cam_array
    model_name_array = []

    self.all.each do |camera|
      model_name_array.push(camera.CameraModel)
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
      where('CameraModel LIKE ?' , "%#{search}%" )
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

      if match2 = camera_obj["CameraModel"].match(/(.*)_(.*)/i)
        model_name_str2, fw_str = match2.captures
      else
        model_name_str2 = camera_obj["CameraModel"]
      end


      if model_name_str2 == model_name_str
        if_existed = TRUE
      end

    end

    # model name could be ModelName_FW, but we don't care the FW, so separate it.
    # compare_model_obj_array.each do |camera_obj|
    #
    #   if camera_obj["CameraModel"] == model_name_str
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


  # private
  #
  # def remove_illegal_char()
  #
  #
  #
  #
  # end


end




























