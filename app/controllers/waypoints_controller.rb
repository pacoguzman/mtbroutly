class WaypointsController < ApplicationController
  # GET /waypoints
  # GET /waypoints.xml
  def index
    @waypoints = Waypoint.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @waypoints }
    end
  end

  # GET /waypoints/1
  # GET /waypoints/1.xml
  def show
    @waypoint = Waypoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @waypoint }
    end
  end

  # GET /waypoints/new
  # GET /waypoints/new.xml
  def new
    @waypoint = Waypoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @waypoint }
    end
  end

  # GET /waypoints/1/edit
  def edit
    @waypoint = Waypoint.find(params[:id])
  end

  # POST /waypoints
  # POST /waypoints.xml
  def create
    @waypoint = Waypoint.new(params[:waypoint])

    respond_to do |format|
      if @waypoint.save
        flash[:notice] = 'Waypoint was successfully created.'
        format.html { redirect_to(@waypoint) }
        format.xml  { render :xml => @waypoint, :status => :created, :location => @waypoint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @waypoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /waypoints/1
  # PUT /waypoints/1.xml
  def update
    @waypoint = Waypoint.find(params[:id])

    respond_to do |format|
      if @waypoint.update_attributes(params[:waypoint])
        flash[:notice] = 'Waypoint was successfully updated.'
        format.html { redirect_to(@waypoint) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @waypoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /waypoints/1
  # DELETE /waypoints/1.xml
  def destroy
    @waypoint = Waypoint.find(params[:id])
    @waypoint.destroy

    respond_to do |format|
      format.html { redirect_to(waypoints_url) }
      format.xml  { head :ok }
    end
  end
end
