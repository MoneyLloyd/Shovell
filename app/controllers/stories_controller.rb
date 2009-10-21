class StoriesController < ApplicationController
   before_filter :login_required, :only => [ :new, :create ]
  # GET /stories
  # GET /stories.xml
  def index
    @current_time = Time.now
    fetch_stories 'votes_count >= 5'

    #@stories = Story.find :all, :order => 'id DESC', :conditions => 'votes_count >= 5'
    #respond_to do |format|
      #format.html # index.html.erb
      #format.xml  { render :xml => @stories }
    #end
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.xml
  def new
    @story = Story.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /stories
  # POST /stories.xml
  def create
    #@story = Story.new(params[:story])
    @story = @current_user.stories.build params[:story]
    
    respond_to do |format|
      if @story.save
        flash[:notice] = 'Story was successfully created.'
        format.html { redirect_to stories_path }
        format.xml  { render :xml => stories_path, :status => :created, :location => stories_path }
        #format.html { redirect_to(@story) }
        #format.xml  { render :xml => @story, :status => :created, :location => @story }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        flash[:notice] = 'Story was successfully updated.'
        format.html { redirect_to(@story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end

  def bin
    fetch_stories 'votes_count < 5'
    render :action => 'index'
  end

   protected
   def fetch_stories(conditions)
    @stories = Story.find :all, :order => 'id DESC', :conditions => conditions
   end
  #def show
    #@story = Story.find(params[:id])
  #end
end
