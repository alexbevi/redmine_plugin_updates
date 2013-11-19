require 'open-uri'
require 'json'

module Redmine
  class Plugin      

    def latest_version
      # prefer the lookup table's url over the registered one
      scm_url = url_from_lookup_table || url

      message = if scm_url.blank?
        ::I18n.t(:message_no_url_defined) 
      elsif scm_url =~ /github.com/i
        latest_version_from_github(scm_url)
      else
        ::I18n.t(:message_cannot_get_latest_plugin_version)
      end

      "<br><font color='#ff0000'><em>#{message}<em></font>".html_safe
    end    

    private
    
    UPDATE_LOOKUP_TABLE_URL = "https://raw.github.com/alexbevi/redmine_plugin_updates/lookup_table/lookup.json"

    def url_from_lookup_table
      @@lookup_table ||= JSON.parse(open(UPDATE_LOOKUP_TABLE_URL).read)

      result = @@lookup_table.select { |i| i["id"] == id.to_s }

      # FIXME we can have > 1 result for the same id ...
      result.length > 0 ? result.first["url"] : nil
    end


    def perform_version_check(current, external)
      return "" if current == external
      re_semver = /^(\d+\.\d+\.\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$/i

      ::I18n.t(:message_new_version_available, :ver => external) unless current == external
    end

    def latest_version_from_github(scm_url)
      endpoint = [] << "https://raw.github.com" << scm_url.split("/")[-2..-1] << "master", "init.rb"
      
      file_url = endpoint.flatten.join("/")      

      begin
        source = open(file_url).read
        search = source.match(/version\s*[\'|\"](.*?)['|"]/i)

        return ::I18n.t(:message_too_many_potential_versions_found) if search.captures.length > 1
        return perform_version_check(version, search.captures[0])
      rescue OpenURI::HTTPError
        return ::I18n.t(:message_plugin_init_not_found)
      rescue Exception => e
        binding.pry
      end
    end
  end
end