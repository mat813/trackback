module TrackbackTagExtensions
  include Radiant::Taggable

  desc %{
    Gives access to a page's trackback.

    *Usage:*
    <pre><code><r:trackbacks>...</r:trackbacks></code></pre>
  }
  tag 'trackbacks' do |tag|
    tag.locals.trackbacks = tag.locals.page.visible_trackbacks
    tag.expand
  end

  desc %{
    Gives the url of the trackback for the page.

    *Usage:*
    <pre><code><r:trackbacks:url /></code></pre>
  }
  tag 'trackbacks:url' do |tag|
    eval "class ::#{tag.locals.page.response.template.controller.class}; public :trackback_path; end"
    tag.locals.page.response.template.controller.trackback_path(tag.locals.page.id)
  end

  desc %{
    Gives the root url for the web site, ie http://bar.com/

    *Usage:*
    <pre><code><r:trackback:root /></code></pre>
  }
  tag 'trackbacks:root' do |tag|
    eval "class ::#{tag.locals.page.response.template.controller.class}; public :trackback_path, :trackback_url; end"
    tag.locals.page.response.template.controller.trackback_url(tag.locals.page.id).gsub(/#{tag.locals.page.response.template.controller.trackback_path(tag.locals.page.id)}/, '')
  end

  desc %{
    Renders the total number of trackbacks.
  }
  tag 'trackbacks:count' do |tag|
    tag.locals.trackbacks.count
  end

  desc %{
    Cycles through each trackback, inside this tag, you can use the other
    tags link in the example.

    *Usage:*
    <pre><code><r:trackback:each [order="asc|desc"]>
    </r:trackback:each></code></pre>
  }
  tag 'trackbacks:each' do |tag|
    options = trackback_each_find_options(tag)
    result = []
    trackbacks = tag.locals.trackbacks
    trackbacks.find(:all, options).each do |item|
      tag.locals.trackback = item
      result << tag.expand
    end
    result
  end

  Trackback.column_names.each do |col|
    module_eval <<-eoe
      desc %{
	Access the #{col} attribute of the trackback
      }
      tag 'trackbacks:each:tb_#{col}' do |tag|
	tag.locals.trackback.#{col}
      end
    eoe
  end

  desc %{
    Generates a link to the trackbacked post
  }
  tag 'trackbacks:each:tb_link' do |tag|
    attributes = ''
    text = tag.double? ? tag.expand : tag.locals.trackback.title.nil? ? tag.render('tb_url') : tag.render('tb_title')
    %{<a href="#{tag.render('tb_url')}"#{attributes}>#{text}</a>}
  end

  private

  def trackback_each_find_options(tag)
    attr = tag.attr.symbolize_keys
    options = {}

    by = (attr[:by] || 'created_at').strip
    order = (attr[:order] || 'asc').strip
    order_string = ''
    if self.attributes.keys.include?(by)
      order_string << by
    else
      raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
    end
    if order =~ /^(asc|desc)$/i
      order_string << " #{$1.upcase}"
    else
      raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
    end
    options[:order] = order_string

    options
  end
end
