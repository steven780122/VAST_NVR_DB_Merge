class CreateCctNvrDbTestSocCameras < ActiveRecord::Migration
  def change
    create_table :cct_nvr_db_test_soc_cameras do |t|
      t.string :Model_FW_name
      t.string :Soc
      t.string :uid_audio_codec
      t.string :uid_video_mode
      t.string :uid_s0_video_codec
      t.string :uid_s0_frame_size
      t.string :uid_s0_mpeg4_max_frame_rate
      t.string :uid_s0_mpeg4_intra_period
      t.string :uid_s0_mpeg4_video_quality
      t.string :uid_s0_mpeg4_bitrate_restriction
      t.string :uid_s0_mpeg4_constant_bitrate
      t.string :uid_s0_mpeg4_constant_bitrate_policy
      t.string :uid_s0_mpeg4_fixed_quality
      t.string :uid_s0_h264_max_frame_rate
      t.string :uid_s0_h264_intra_period
      t.string :uid_s0_h264_video_quality
      t.string :uid_s0_h264_bitrate_restriction
      t.string :uid_s0_h264_constant_bitrate
      t.string :uid_s0_h264_constant_bitrate_policy
      t.string :uid_s0_h264_fixed_quality
      t.string :uid_s0_mjpeg_max_frame_rate
      t.string :uid_s0_mjpeg_video_quality
      t.string :uid_s0_mjpeg_bitrate_restriction
      t.string :uid_s0_mjpeg_constant_bitrate
      t.string :uid_s0_mjpeg_constant_bitrate_policy
      t.string :uid_s0_mjpeg_fixed_quality
      t.string :uid_s0_svc_max_frame_rate
      t.string :uid_s0_svc_intra_period
      t.string :uid_s0_svc_video_quality
      t.string :uid_s0_svc_bitrate_restriction
      t.string :uid_s0_svc_constant_bitrate
      t.string :uid_s0_svc_constant_bitrate_policy
      t.string :uid_s0_svc_fixed_quality
      t.string :uid_s0_h265_max_frame_rate
      t.string :uid_s0_h265_intra_period
      t.string :uid_s0_h265_video_quality
      t.string :uid_s0_h265_bitrate_restriction
      t.string :uid_s0_h265_constant_bitrate
      t.string :uid_s0_h265_constant_bitrate_policy
      t.string :uid_s0_h265_fixed_quality
      t.string :uid_s0_mpeg4_max_vbr_bitrate
      t.string :uid_s0_h264_max_vbr_bitrate
      t.string :uid_s0_mjpeg_max_vbr_bitrate
      t.string :uid_s0_svc_max_vbr_bitrate
      t.string :uid_s0_h265_max_vbr_bitrate
      t.string :uid_s0_h264_smartstream_foreground_quality
      t.string :uid_s0_h264_smartstream_background_quality
      t.string :uid_s0_h264_smartstream_max_bit_rate
      t.string :uid_s0_h264_smartstream_mode
      t.string :uid_s0_h265_smartstream_foreground_quality
      t.string :uid_s0_h265_smartstream_background_quality
      t.string :uid_s0_h265_smartstream_max_bit_rate
      t.string :uid_s0_h265_smartstream_mode
      t.string :uid_min_exposure_time
      t.string :uid_max_exposure_time
      t.string :uid_min_exposure_time_profile
      t.string :uid_max_exposure_time_profile
      t.string :uid_network_rtsp_authmode
      t.string :uid_network_http_authmode
      t.string :uid_audio_g711_mode
      t.string :uid_audio_aac_bitrate
      t.string :uid_audio_gamr_bitrate
      t.string :uid_audio_g726_bitrate

      t.timestamps null: false
    end
  end
end
