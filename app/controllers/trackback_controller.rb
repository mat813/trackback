class TrackbackController < ApplicationController
  # Remove this line if your controller should only be accessible to users
  # that are logged in:
  no_login_required
  verify :method => :post, :only => [:index], :redirect_to => '/'
  layout nil

  VARS = %w(tb_url tb_title tb_excerpt tb_blog_name)

  def index
    @ret = 0
    if Page.exists?(params[:id]) == false
      @ret = 1
      @message = 'I need a valid id for that to work.'
    elsif (p = Page.find(params[:id])).parts.find(:first, :conditions => "name = 'no_tb'")
      @ret = 1
      @message = 'Sorry, trackbacks are closed for this page.'
    else
      # Charset convert idea shamelessly taken from wordpress
      charsets = if request.content_type =~ /charset=([^ ]+)/
		   [$1]
		 else
		   []
		 end
      charsets += %w(ASCII UTF-8 ISO-8859-1 EUC-JP SJIS)
      charsets.compact!
      charsets.uniq!
      charsets.map! {|c| new_iconv(c)}
      VARS.each do |v|
	instance_variable_set("@#{v}", charsets.inject(nil) do |acc,e|
	  acc ||
	    begin
	      e.iconv(params[v.gsub(/^tb_/, '')])
	    rescue Iconv::IllegalSequence, Iconv::InvalidCharacter, Iconv::OutOfRange
	      # No worries, just go on to the next one.
	    end
	end)
      end
      charsets.each(&:close)
      if @tb_url.nil?
	@ret = 1
	@message = 'This does not look like a trackback at all'
      elsif p.trackbacks.find_by_url(@tb_url)
	@ret = 1
	@message = 'We already have a ping from that URI for this page.'
      else
	p.trackbacks.create(:url => @tb_url, :title => @tb_title, :excerpt => @tb_excerpt, :blog_name => @tb_blog_name)
      end
    end
  end

  private

  def new_iconv(to)
    Iconv.new(default_charset, to)
  rescue
  end
end
