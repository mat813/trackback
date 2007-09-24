class TrackbackSnippet < ActiveRecord::Migration
  def self.up
    Snippet.create(:name => 'trackbacks',
		   :filter_id =>'',
		   :content => <<-eot)
<div id="trackbacks">
  <!--
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
             xmlns:dc="http://purl.org/dc/elements/1.1/"
             xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
    <rdf:Description
        rdf:about="<r:trackbacks:root /><r:url />"
        dc:identifier="<r:trackbacks:root /><r:url />"
        dc:title="<r:escape_html><r:title /></r:escape_html>"
        trackback:ping="<r:trackbacks:root /><r:trackbacks:url />" />
    </rdf:RDF>
  -->
  <h3><a id="trackbacks_anchor">Trackbacks<r:if_trackbacks> (<r:trackbacks:count />)</r:if_trackbacks></a></h3>
  <p>Use the following link to trackback from your own site:<br />
    <r:trackbacks:root /><r:trackbacks:url />
  </p><r:if_trackbacks>
  <ul><r:trackbacks:each>
    <li>
      <div class="author">
        <r:tb_link />
        <abbr>From <cite><r:tb_blog_name /></cite></abbr>
      </div>
      <div class="content"><r:tb_excerpt /></div>
    </li>
  </r:trackbacks:each></ol></r:if_trackbacks>
</div>
    eot
  end

  def self.down
    Snippet.find(:first, :conditions => ['name = ?', 'trackbacks']).destroy
  end
end
