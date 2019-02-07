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
require 'fileutils'
require 'browshot'
require 'net/http'
require 'net/ftp'
require 'RMagick'
include Magick

settings = YAML.load_file(File.expand_path('../../../config/settings.yml', __FILE__))
screenshot_id = '433106'
browshot = Browshot.new(settings['browshot_api']['key'])
screenshot_file = ''
final_file = File.expand_path('../../../images/screenshot.png', __FILE__)
widget_file = File.expand_path('../../../images/widget.png', __FILE__)
namespace :create_snapshot do

  desc "Create a snapshot of the JP_ Widget"
  task :snap_it do
    screenshot = browshot.screenshot_create('http://missionaldigerati.org/jp-widget.html', {:cache => 3600, :instance_id => 27});
    screenshot_id = screenshot['id']

    while (screenshot['status'] != 'finished' && screenshot['status'] != 'error')
      puts "Wait...\n";
      sleep(10)
      screenshot = browshot.screenshot_info(screenshot['id'])
    end
    puts "Got an ID: #{screenshot_id}"
    if screenshot['status'] == 'error'
      puts "Houston,  we have a problem."
    elsif screenshot['status'] == 'finished'
      image = browshot.screenshot_thumbnail(screenshot['id'])

      # save the screenshot
      File.open(final_file, 'w') {|f| f.write(image) }
      Rake::Task['create_snapshot:crop_image'].execute
    end
  end

  # crop the image to the correct size
  task :crop_image do
    puts "Cropping final image #{final_file}"
    image = Image.read(final_file).first
    widget = image.trim!
    widget.write(widget_file)
    Rake::Task['create_snapshot:move_file'].execute
  end

  # move the file
  task :move_file do
    if settings['settings']['move_file'] === true
      puts "Moving the file to the new location."
      FileUtils.copy(widget_file, File.join(settings['move_locally']['directory'], 'widget.png'))
    end
  end

end
