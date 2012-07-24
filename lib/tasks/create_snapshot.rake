# This file is part of JP Widget Snapshot.
# 
# JP Widget Snapshot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# JP Widget Snapshot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see 
# <http://www.gnu.org/licenses/>.
# @author Johnathan Pulos <johnathan@missionaldigerati.org>
# @copyright Copyright 2012 Missional Digerati
#
require 'rubygems'
require 'yaml'
require 'browshot'
require 'net/http'
require 'RMagick'
include Magick

settings = YAML.load_file(File.expand_path('../../../config/settings.yml', __FILE__))
screenshot_id = '433106'
browshot = Browshot.new(settings['browshot_api']['key'])
screenshot_file = ''
final_file = File.expand_path('../../../images/screenshot.png', __FILE__)
namespace :create_snapshot do
	
	desc "Create a snapshot of the JP_ Widget"
	task :snap_it do
		screenshot = browshot.screenshot_create('http://www.codemis.com/jp_widget.html', {:cache => 3600, :instance_id => 27});
		screenshot_id = screenshot["id"]
		puts "Got an ID: #{screenshot_id}"
		Rake::Task['create_snapshot:screenshot_status'].execute
	end
	
	# Checks the status of a given screenshot
	task :screenshot_status do
		puts "Calling Screenshot Status on ID: #{screenshot_id}"
		info = browshot.screenshot_info(screenshot_id)
		if info['status'] == 'error'
			puts "Houston,  we have a problem."
		elsif info['status'] == 'finished'
			screenshot_file = info['screenshot_url']
			Rake::Task['create_snapshot:download_file'].execute
		else
			puts "Need to sleep,  it is not complete."
			sleep 60
			Rake::Task['create_snapshot:screenshot_status'].execute
		end
	end
	
	# download the correct file
	task :download_file do
		puts "Downloading the image located at #{screenshot_file}"
		parsed_uri = URI.parse(screenshot_file)
		Net::HTTP.start(parsed_uri.host) do |http|
		  resp = http.get(parsed_uri.request_uri)
		  open(final_file, "wb") do |file|
		    file.write(resp.body)
		  end
		end
		Rake::Task['create_snapshot:crop_image'].execute
	end
	
	# crop the image to the correct size
	task :crop_image do
		puts "Cropping final image #{final_file}"
		widget_file = File.expand_path('../../../images/widget.png', __FILE__)
		image = Image.read(final_file).first
		widget = image.crop!(0,0,217,355)
		widget.write(widget_file)
	end
	
end