require 'fileutils'

class UpAndRunning

  def initialize(proj_name,ruby_ver,proj_path,server)
    @proj_name = proj_name
    @ruby_ver = ruby_ver
    @proj_path = proj_path
    @server = server
    @proj_folder = "#{proj_path}/#{proj_name}"
  end

  def create_proj_folder
    FileUtils::mkdir_p @proj_folder
  end

  def create_readme
    file_text = "# #{@proj_name} Basic Web Service \n Built with upandrun."
    File.open("#{@proj_folder}/README.md", 'w') {|file| file.write(file_text)}
  end

  def create_procfile_puma
    file_text = 'web: bundle exec puma -C config/puma.rb'
    File.open("#{@proj_folder}/Procfile",'w') { |file| file.write(file_text) }
  end

  def create_procfile_thin
    file_text = 'web: bundle exec rackup config.ru -p $PORT'
    File.open("#{@proj_folder}/Procfile",'w') { |file| file.write(file_text) }
  end

  def create_configru
    file_text = "require_relative 'application_controller'\nrun ApplicationController"
    File.open("#{@proj_folder}/config.ru",'w') { |file| file.write(file_text) }
  end

  def create_app_controller
    file_text = "require 'sinatra/base'\n\nclass ApplicationController < Sinatra::Base\n\n\tget '/' do\n\t\t'#{@proj_name} is up and Running'\n\tend\nend"
    File.open("#{@proj_folder}/application_controller.rb",'w') { |file| file.write(file_text) }
  end

  def create_gemfile
    file_text = "source 'http://rubygems.org'\nruby '#{@ruby_ver}'\n\ngem 'sinatra'\ngem 'thin'\ngem 'json'\ngem 'puma'"
    File.open("#{@proj_folder}/Gemfile",'w') { |file| file.write(file_text) }
  end

  def create_config_puma
    FileUtils::mkdir_p "#{@proj_folder}/config"
    file_text = "workers Integer(ENV['WEB_CONCURRENCY'] || 2)\nthreads_count = Integer(ENV['MAX_THREADS'] || 5)\nthreads threads_count, threads_count\n\npreload_app!\n\nrackup  DefaultRackup\nport  ENV['PORT'] ||  3000\nenvironment ENV['RACK_ENV'] || 'development'"
    File.open("#{@proj_folder}/config/puma.rb",'w') { |file| file.write(file_text) }
  end

  def create_puma
    create_config_puma
    create_procfile_puma
  end

  def prep_ws_files
    begin
      create_proj_folder
      create_readme
      create_gemfile
      create_app_controller
      create_configru
      @server == 'thin' ? create_procfile_thin: create_puma
    rescue => e
      puts e.message
    end
  end

end

begin
  fail ArgumentError, "Usage: upandrun project_name ruby_version path server" if ARGV.count < 4

  proj_name = ARGV[0]
  ruby_ver = ARGV[1]
  path = ARGV[2]
  server = ARGV[3]

  a_web_service = UpAndRunning.new(proj_name, ruby_ver, path, server)

  a_web_service.prep_ws_files

rescue => e
  puts "Well I just broke...you happy? Error: #{e}"
end
