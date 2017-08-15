class CreateCctVastDbCameraOtherInfos < ActiveRecord::Migration
  def change
    create_table :cct_vast_db_camera_other_infos do |t|
      t.string :"CameraModel"
      t.string :"FW_Ver"
      t.string :"VAST_Ver"
      t.string :"VDP_Ver"
      t.string :"PKG_Ver"
      t.string :"Tester"
      t.string :"Note"
      t.string :"Pass_Fail"

      t.timestamps null: false
    end
  end
end
