class Admin::TrackbackController < ApplicationController
  # Remove this line if your controller should only be accessible to users
  # that are logged in:
  no_login_required

  def initialize
    super
    @cache = ResponseCache.instance
  end

  def index
    @trackback_pages, @trackbacks = paginate :trackbacks, :order => 'approved DESC, page_id', :per_page => 20
  end

  def approve
    @cache.expire_response(Trackback.update(params[:id], :approved => params[:approved]).page.url)
    render :nothing => true
  end

  def destroy
    @cache.expire_response(Trackback.destroy(params[:id]).page.url)
    render :nothing => true
  end
end
