require 'redmine'
require_dependency "plugin"
require_dependency "semantic/version"

Redmine::Plugin.register :redmine_plugin_updates do
  name        'Plugin Update Checker'
  author      'Alex Bevilacqua'
  author_url  "http://www.alexbevi.com"
  description 'Check if any registered plugins have updates available'
  url         'https://github.com/alexbevi/redmine_plugin_updates'
  version     '1.0.0-devel'

  requires_redmine :version_or_higher => '2.0.0'  
end