class CreateCctVastDbTestSocCameras < ActiveRecord::Migration
  def change
    create_table :cct_vast_db_test_soc_cameras do |t|
      t.string :"CameraModel"
      t.string :"Numberofstreams"
      t.string :"Videocodecsupported"
      t.string :"FOVsupported"
      t.string :"Framesizesupported"
      t.string :"Frameratesupported"
      t.string :"MPEG4maximumframeratesupported"
      t.string :"H264maximumframeratesupported"
      t.string :"SVCmaximumframeratesupported"
      t.string :"JPEGmaximumframeratesupported"
      t.string :"Videoqualitysupported"
      t.string :"Bitratesupported"
      t.string :"Audiosupported"
      t.string :"Audiocodecsupported"
      t.string :"AudiobitratesupportedAAC"
      t.string :"AudiobitratesupportedGSM"
      t.string :"Remotefocussupported"
      t.string :"MozartV1"
      t.string :"MT9P006"
      t.string :"FOVsize"
      t.string :"AudiobitratesupportedG726"
      t.string :"Smartstreamqualitysupported"
      t.string :"Smartstreammaximumbitratesupported"
      t.string :"Numberofsmartstreams"
      t.string :"H265maximumframeratesupported"
      t.string :"Maximumframesize"

      t.timestamps null: false
    end
  end
end
