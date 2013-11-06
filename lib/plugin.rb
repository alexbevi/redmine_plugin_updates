require 'open-uri'

module Redmine
  class Plugin    

    def latest_version
      message = if url.blank?
        ::I18n.t(:message_no_url_defined) 
      elsif url =~ /github.com/i
        latest_version_from_github
      else
        ::I18n.t(:message_cannot_get_latest_plugin_version)
      end

      "<br><font color='#ff0000'><em>#{message}<em></font>".html_safe
    end    

    private

    def latest_version_from_github
      endpoint = [] << "https://raw.github.com" << url.split("/")[-2..-1] << "master", "init.rb"
      
      file_url = endpoint.flatten.join("/")      
      
      begin
        source = open(file_url).read
        search = source.match(/version\s*[\'|\"](.*?)['|"]/i)

        return ::I18n.t(:message_too_many_potential_versions_found) if search.captures.length > 1
        
        v = search.captures[0]
        
        return ::I18n.t(:message_version_mismatch, :ver => v) unless v == version
      rescue OpenURI::HTTPError
        return ::I18n.t(:message_plugin_init_not_found)
      rescue Exception => e
        binding.pry
      end
    end
  end
end