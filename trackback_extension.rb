# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

require 'iconv'

class TrackbackExtension < Radiant::Extension
  version "1.0"
  description "Allow to give trackback urls in your pages"
  url "http://mat.cc/dev/radiant/trackback"

  define_routes do |map|
    map.trackback 'trackback/:id', :controller => 'trackback'
    map.connect 'admin/trackback/:action', :controller => 'admin/trackback'
    map.connect 'admin/trackback/:action/:id', :controller => 'admin/trackback'
  end

  def activate
    admin.tabs.add "Trackback", "/admin/trackback", :after => "Pages", :visibility => [:all]
    Page.send :has_many, :trackbacks
    Page.send :has_many, :visible_trackbacks, :class_name => 'Trackback', :conditions => "approved = 't'"
    Page.send :include, TrackbackTagExtensions
  end

  def deactivate
    admin.tabs.remove "Trackback"
  end

end
