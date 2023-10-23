# Automatically generated controller by Rails's
# script/generate scaffold tag
class TagsController < ApplicationController
  before_action :load_workspace

  def index
    @tags = @workspace.tags

    # Man my named scope isn't working out, oh well.
    if params[:search]
      search_tags = []
      params[:search].to_s.split(/\s+/).map {|t| t.gsub(/^#+/,"")}.each do |term|
        if !term.strip.empty?
          @tags.each do |tag|
            if (tag.name + tag.desc.to_s)[/#{term}/i]
              search_tags << tag unless search_tags.include? tag
            end
          end
        end
      end

      @tags = search_tags
    end

    respond_to do |format|
      format.html
      format.js { render :partial => 'tags', :tags => @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Mdm::Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
    def new
    @tag = Mdm::Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  def edit
    @tag = Mdm::Tag.find(params[:id])
    render :partial => 'form', :layout => false
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Mdm::Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to(@tag) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Mdm::Tag.find(params[:id])

    respond_to do |format|
      if @tag.update(tag_params)
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to(workspace_tags_path(@workspace)) }
        format.xml  { head :ok }
      else
        flash[:error] = 'There was an error saving the tag.'
        format.html { redirect_to(workspace_tags_path(@workspace)) }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    destroyer = TagsDestroyer.new(self)
    destroyer.destroy(params[:tag_ids])
  end

  def destroy_tags_successful(count)
    respond_to do |format|
      format.any(:js, :html) do
        flash[:notice] = view_context.pluralize(count, "tag") + " removed"
        render_js_redirect workspace_tags_path(@workspace)
      end

      format.json do
        render :json => {:success => :ok}
      end
    end
  end

  def destroy_without_tags_failed
    respond_to do |format|
      format.any(:js, :html) do
        flash[:error] = "No tags selected to remove"
        render_js_redirect workspace_tags_path(@workspace)
      end
      format.json do
        render :json => {:success => false, :error => "No tags selected."},
               :status => :bad_request
      end
    end
  end

  def search
    # Replace any unsafe characters with a wildcard
    q = '%' + params[:q].to_s.gsub(/[^A-Za-z0-9\x20\x09]+/, '%') + '%'
    q.gsub!(/\%+/, '%')

    @tags = Mdm::Tag.tags_by_workspace_and_name(@workspace.id, q)


    respond_to do |format|
      format.json { render :partial => "tags", :tags => @tags }
    end
  end

  private

  def tag_params
    params.fetch(:tag, {}).permit!
  end
end
