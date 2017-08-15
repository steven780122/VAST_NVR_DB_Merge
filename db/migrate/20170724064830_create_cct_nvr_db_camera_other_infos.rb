class CreateCctNvrDbCameraOtherInfos < ActiveRecord::Migration
  def change
    create_table :cct_nvr_db_camera_other_infos do |t|
      t.string :Model_FW_name
      t.string :FW_Ver
      t.string :SW_NVR
      t.string :SW_NVR_Ver
      t.string :VDP_Ver
      t.string :PKG_Ver
      t.string :Tester
      t.string :Note
      t.string :Pass_Fail

      t.timestamps null: false
    end
  end
end
