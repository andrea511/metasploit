class WebController < ApplicationController
  before_action :load_workspace
  before_action :gather_web_summary_info, :only => [:index]

  def index
    @search = params[:search]
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @sites_per_page = (params[:n] || 20).to_i
    @stats = @workspace.stats
    @sort_dir = (params[:sort_dir] || "asc").downcase

    conditions = nil

    @sites_count = @sites.length
    @num_pages = 1 + ((@sites_count-1) / @sites_per_page)

    # Make sure the page number is sane before calculating the offset
    @page = @num_pages if @page > @num_pages and @num_pages > 0
    @sites_offset = (@page-1) * @sites_per_page

    sort_by = params[:sort_by] || "vulns"
    @sites_sorted = @sites.sort do |ak,bk|
      a, b = if @sort_dir == "asc"
        [ak, bk]
      else
        [bk, ak]
      end

      case sort_by
      when 'address'
        a.service.host.address_int <=> b.service.host.address_int
      when 'risk'
        av = a.web_vulns.map{|v| v.risk}
        bv = b.web_vulns.map{|v| v.risk}
        if (av.empty? and bv.empty?)
          # Sort so that "Unaudited" has lower priority than "None"
          a.web_forms.length <=> b.web_forms.length
        else
          (av.max || 0) <=> (bv.max || 0)
        end
      when 'url'
        a.to_url.to_s <=> b.to_url.to_s
      when 'service'
        a.service.info.to_s <=> b.service.info.to_s
      when 'pages'
        b.page_count <=> a.page_count
      when 'forms'
        b.form_count <=> a.form_count
      when 'vulns'
        b.vuln_count <=> a.vuln_count
      else
        a.service.host.address_int <=> b.service.host.address_int
      end
    end

    @licensed = License.get.supports_webapp_exploitation?

    respond_to do |format|
      format.html
      #format.js { render :partial => 'sites', :sites => @sites }
    end
  end

  def vulns
    @site = Mdm::WebSite.find(params[:site_id])
    if not @site
      redirect_to :action => :index
      return
    end
    # sort to match order of columns in table in view
    @vulns = @site.web_vulns.sort_by { |web_vuln|
      [
          # - so highest risk is first
          -web_vuln.risk,
          web_vuln.category_label,
          web_vuln.name,
          web_vuln.path,
          web_vuln.confidence,
          web_vuln.method,
          web_vuln.pname,
          web_vuln.proof
      ]
    }
  end

  def vuln
    @vuln = Mdm::WebVuln.find(params[:vuln_id])

    if @vuln
      @vuln_action = "#{@vuln.web_site.to_url}#{@vuln.path}"

      if @vuln.method == 'PATH'
        param = @vuln.params[0]
        value = param[1]
        @vuln_action += value
      end
    else
      render :plain => 'Vulnerability Not Found'
    end
  end

  def forms
  end

  def form
  end


  def delete_sites
    sites    = []
    host_ids = []

    if params[:site_ids]
      site_ids = params[:site_ids]
    end

    if site_ids.length.zero?
      flash[:error] = "No sites selected to delete"
    else
      r = 0
      site_ids.each {|sid| Mdm::WebSite.destroy(sid) and (r +=1 ) }
      flash[:notice] = view_context.pluralize(r, "site") + " deleted"
    end

    render_js_redirect(web_sites_path(@workspace))
  end


  def delete_vulns
    vulns = []
    site  = nil

    if params[:vuln_ids]
      vulns = params[:vuln_ids]
    end

    if vulns.length.zero?
      flash[:error] = "No vulns selected to delete"
      return
    else
      site = Mdm::WebVuln.find(vulns)[0].web_site
      r = 0
      vulns.each {|vid| Mdm::WebVuln.destroy(vid) and (r +=1 ) }
      flash[:notice] = view_context.pluralize(r, "vuln") + " deleted"
    end

    render_js_redirect(web_vulns_path(@workspace, site))
  end

private

  def gather_web_summary_info
    @sites = @workspace.web_sites
  end

end

