Joshua Project Widget Snapshot Rake Script
==========================================

This Rakefile generates a snapshot of the [Joshua Project's](http://www.joshuaproject.net/) widget and crops the image appropriately.  The purpose is to circumvent the restrictions on WordPress.com websites that only allow static images in the widget area.

Usage
-----

To run this script,  from terminal use the following command:

`rake create_snapshot:snap_it -f lib/tasks/create_snapshot.rake`

Requirements
------------

* Ruby 1.8.7
* Bundler
* All gems in the Gemfile

Development
-----------

Questions or problems? Please post them on the [issue tracker](). You can contribute changes by forking the project and submitting a pull request.

This script is created by Johnathan Pulos and is under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0-standalone.html).