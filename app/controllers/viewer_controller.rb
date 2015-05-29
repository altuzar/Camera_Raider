class ViewerController < ApplicationController

  def index
    @tags = Camera.select("distinct tags").map{|t| t.tags }.sort

    @filtros = []
    @filtros.push("cameras.id > 0")
    if params.has_key?(:tag) && params[:tag].to_s.length > 0 && @tags.include?(params[:tag].to_s)
        @filtros.push("cameras.tags like '%#{params[:tag].to_s}%'")
        @tag = params[:tag].to_s
    end  

    @cameras = Camera.where(@filtros.join(" AND ")).order(:sucursal)
    @footer_cameras = Camera.order(:sucursal)
    @cameras_img    = {}
    @cameras_feed   = {}

    @browser = browser_detection

    @cameras.each do |camera|
      suc_cam = "#{camera.sucursal}-#{camera.numcamera}"
      @cameras_img[suc_cam] = "/def_img.jpg"
      dir_name = "suc#{camera.sucursal.to_s.rjust(3, '0')}-#{camera.numcamera}"
      if File.directory?("public/cameras/#{dir_name}")
        ff = Dir.entries("public/cameras/#{dir_name}")
                .find_all{|f| f.to_s.end_with?(".jpg") }.sort.last
        if ff.to_s.length > 10
          @cameras_img[suc_cam] = "/cameras/#{dir_name}/#{ff}"
        end
      end
      @cameras_feed[suc_cam] = "http://#{camera.user}:#{camera.pass}@#{camera.ipaddress.gsub("http://","").gsub("/","")}/"
      @cameras_feed[suc_cam] = "#{@cameras_feed[suc_cam]}monitor.htm"  if @browser == 'ie'
      @cameras_feed[suc_cam] = "#{@cameras_feed[suc_cam]}monitor2.htm" if @browser == 'firefox'
      @cameras_feed[suc_cam] = "#{@cameras_feed[suc_cam]}pda.htm"      if @browser == 'ios'      
    end

  end

  def show
    @footer_cameras = Camera.order(:sucursal)
    @tags = Camera.select("distinct tags").map{|t| t.tags }.sort

    sucursal  = 0
    numcamera = 0
    if params.has_key?(:sucursal)
      sucursal  = params[:sucursal].to_s.split("-")[0] 
      numcamera = params[:sucursal].to_s.split("-")[1] rescue 0
    end
    return redirect_to root_path, alert: "Sucursal no encontrada" if sucursal.to_i < 1

    @cameras = Camera.where("sucursal = #{sucursal.to_i} and numcamera = #{numcamera.to_i}")
    return redirect_to root_path, alert: "Cámara no encontrada" if @cameras.count != 1

    @camera_imgs = []
    dir_name = "suc#{@cameras[0].sucursal.to_s.rjust(3, '0')}-#{@cameras[0].numcamera}"
    if File.directory?("public/cameras/#{dir_name}")
      @camera_imgs = Dir.entries("public/cameras/#{dir_name}").sort.reverse.find_all{|f| f.to_s.length > 10 }.map{ |f| "/cameras/#{dir_name}/#{f}" }[0..49]
    end
    @camera_imgs.push("/def_img.jpg") if @camera_imgs.count == 0

    @browser  = browser_detection
    @feed_url = get_feed

  end

  def detail
    @footer_cameras = Camera.order(:sucursal)
    @tags = Camera.select("distinct tags").map{|t| t.tags }.sort
    
    sucursal  = 0
    numcamera = 0
    if params.has_key?(:sucursal)
      sucursal  = params[:sucursal].to_s.split("-")[0] 
      numcamera = params[:sucursal].to_s.split("-")[1] rescue 0
    end
    return redirect_to root_path, alert: "Sucursal no encontrada" if sucursal.to_i < 1

    @cameras = Camera.where("sucursal = #{sucursal.to_i} and numcamera = #{numcamera.to_i}")
    return redirect_to root_path, alert: "Cámara no encontrada" if @cameras.count != 1

    img = params[:img] rescue ""
    return redirect_to root_path, alert: "Imagen no encontrada" if img.length < 14

    dir_name = "suc#{@cameras[0].sucursal.to_s.rjust(3, '0')}-#{@cameras[0].numcamera}"
    @camera_img = "/cameras/#{dir_name}/original/#{img}.jpg"

    @browser  = browser_detection
    @feed_url = get_feed

  end

end