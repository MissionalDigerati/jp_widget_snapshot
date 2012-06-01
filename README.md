Joshua Project Widget Snapshot Rake Script
==========================================

This Rakefile generates a snapshot of the [Joshua Project's](http://www.joshuaproject.net/) widget and crops the image appropriately.  The purpose is to circumvent the restrictions on WordPress.com websites that only allow static images in the widget area.  To see the final result,  check out the following [image](http://widget.missionaldigerati.org/widget.png).

Usage
-----

To run this script,  from terminal use the following command:

`rake create_snapshot:snap_it -f lib/tasks/create_snapshot.rake`

Notes
-----

To run Bundler on a shared host, use the following command:

`bundle install --gemfile /directory/of/your/Gemfile --path /directory/to/vendor/gems`

If you choose to install your gems in a local directory,  make sure to run the rake command with bundle exec.

Requirements
------------

* Ruby 1.8.7
* Bundler
* All gems in the Gemfile
* A [Browshot](http://browshot.com) Account

Development
-----------

Questions or problems? Please post them on the [issue tracker](https://github.com/MissionalDigerati/jp_widget_snapshot/issues). You can contribute changes by forking the project and submitting a pull request.

This script is created by Missional Digerati and is under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0-standalone.html).