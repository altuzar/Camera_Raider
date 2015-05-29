require 'rubygems'
require "bundler/setup"
require 'commander/import'
require 'fileutils'
require "mini_magick"

program :name, "Camera Linker"
program :version, '1.0.0'
program :description, 'Moves the jpgs from the cameras to folders in Rails/Public with the proper format, with resizing of the thumbnails and stuff like that'
default_command :create

command :create do |c|
  c.syntax = 'camera_linker create'
  c.description = 'Moves the jpgs from the cameras to folders in Rails/Public with the proper format, with resizing of the thumbnails and stuff like that'
  c.option '--source_dir STRING', String, 'Directorio del que se van a tomar las imagenes de las tiendas'
  c.option '--target_dir STRING', String, 'Directorio al que se van a poner las imagenes de las tiendas'
  c.option '--delete STRING', String, 'Si no debe borrar las imagenes despues de pasarlas (--delete no)'
  c.option '--debug STRING', String, 'Debug and verbose mode (--debug yes)'
  c.action do |args, options|

    beginning_time = Time.now

    source_dir = "../../../../tests/cams/ftpusers/"
    target_dir = "../../../../tests/cams/public_cams/"
    # source_dir = "/home/ftpusers/"
    # target_dir = "/home/master/rails/public/cameras/"

    if !options.source_dir.nil?
      source_dir = options.source_dir
    end

    if !options.target_dir.nil?
      target_dir = options.target_dir
    end

    delete = true
    if !options.delete.nil? && options.delete == 'no'
      delete = false
    end

    debug_mode = false
    if !options.debug.nil? && options.debug == 'yes'
      debug_mode = true
    end

    files_to_leave_on_target = 120

    MiniMagick.processor = :gm

    puts "Opening dir: #{source_dir} and reading contents."

    if !File.directory?(source_dir)
      puts "The source directory doesn't exist: #{source_dir}."
      exit
    end

    sucs  = []
    files = {}
    if File.directory?(source_dir)

      # las carpetas deben llamarse "suc000-0"
      sucs = Dir.entries(source_dir).sort.find_all{|f| f.to_s.length == 8 }.find_all{|f| File.directory?(source_dir + f) }

      sucs.each do |suc|

        other_dir = ""

        if Dir.entries(source_dir + suc).find_all{|f| File.directory?(source_dir + suc + "/" + f) }.find_all{|f| f.to_s.length > 10 }.count == 1
          # encuentra el /suc000-0/VSTC024366VYBCG/ que a veces dejan las camaras
          other_dir = "/" + Dir.entries(source_dir + suc).find_all{|f| File.directory?(source_dir + suc + "/" + f) }.find_all{|f| f.to_s.length > 10 }[0] 
        end 

        files[suc] = Dir.entries(source_dir + suc + other_dir).sort.reverse.find_all{|f| f.to_s.length > 50 }.find_all{|f| f.to_s.end_with?(".jpg") }.map{|f| "#{other_dir.length > 0 ? other_dir[1..-1] + "/" : ""}" + f }

      end

    end

    puts sucs.inspect if debug_mode
    puts files.inspect if debug_mode

    if !File.directory?(target_dir)
      puts "The target directory doesn't exist: #{target_dir}."
      exit
    end

    puts "Copying and resizing images to: #{target_dir}."

    moved = 0
    errors = 0

    sucs.each do |suc|

      files[suc].each do |file|

        Dir.mkdir(target_dir+suc)             if !Dir.exist?(target_dir+suc)
        Dir.mkdir(target_dir+suc+"/original") if !Dir.exist?(target_dir+suc+"/original")
        # Dir.mkdir(target_dir+suc+"/low")      if !Dir.exist?(target_dir+suc+"/low")

        source_file = source_dir+suc+"/"+file
        puts "Reading: " + source_file if debug_mode

        # AQUI DEBE TOMAR LA HORA EN LA QUE EL ARCHIVO FUE ESCRITO
        # la_hora = DateTime.parse( file.split("_")[-2] ) rescue 0
        la_hora = File.ctime( source_file ) rescue 0

        puts "La hora: " + la_hora.to_s if debug_mode

        image = MiniMagick::Image.open(source_file) rescue "ERROR"

        if la_hora != 0

          if image != "ERROR"

            target_file = target_dir+suc+"/original/"+la_hora.to_s.gsub("-","").gsub("T","").gsub(" ","").gsub(":","")[0..13] + ".jpg"
            puts "Writing: " + target_file if debug_mode

            image.write target_file

            target_file_low = target_dir+suc+"/"+la_hora.to_s.gsub("-","").gsub("T","").gsub(" ","").gsub(":","")[0..13] + ".jpg"
            puts "Resizing and Writing: " + target_file_low if debug_mode

            image2 = MiniMagick::Image.open(target_file)
            image2.resize "256x192"
            image2.write target_file_low

            puts "Deleting: " + source_file if debug_mode && delete
            FileUtils.rm(source_file) if delete

            moved = moved + 1

          else

            puts "Error in the following image. File not recognized as image: " + source_dir+suc+"/"+file
            errors = errors + 1

          end

        else

          puts "Error in the following image. Date not recognized: " + source_dir+suc+"/"+file
          errors = errors + 1

        end

      end

    end

    deleted = 0

    puts "Deleting old files from target dir. Keeping only latest #{files_to_leave_on_target} images."

    sucs = Dir.entries(target_dir).sort.find_all{|f| f.to_s.length == 8 }.find_all{|f| File.directory?(source_dir + f) }

    sucs.each do |suc|
      
      target_files = Dir.entries(target_dir + suc).sort.reverse.find_all{|f| f.to_s.length == 18 }.find_all{|f| f.to_s.end_with?(".jpg") }

      if target_files.count > files_to_leave_on_target + 1

        # Borra el exceso de archivos en Original y en small
        files_to_delete = target_files[files_to_leave_on_target..-1]

        files_to_delete.each do |file|

          target_file     = target_dir+suc+"/original/"+file
          target_file_low = target_dir+suc+"/"+file

          if File.exist?(target_file_low)
            puts "Deleting: #{target_file_low}" if debug_mode
            FileUtils.rm(target_file_low)
          end

          if File.exist?(target_file)
            puts "Deleting: #{target_file}" if debug_mode
            FileUtils.rm(target_file)
          end

          deleted = deleted + 1

        end

      end

    end

    puts "Finished: Sucs: #{sucs.count}, Files: #{files.values.flatten.count}, Moved: #{moved}, Errors: #{errors}, OldDeleted: #{deleted}"

    if Time.now - beginning_time > 120
      puts "Time elapsed #{((Time.now - beginning_time)/60).to_i} minutes"
    else
      puts "Time elapsed #{(Time.now - beginning_time).to_i} seconds"
    end
 
  end

end

def dump_to_file(filename,txt)
  File.open(filename, 'w') {|f| f.write(txt) }
end

def is_numeric?(s)
    !!Float(s) rescue false
end