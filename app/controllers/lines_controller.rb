class LinesController < ApplicationController

  before_filter :authenticate!, :except => [:index, :show]

  def index
    @lines = Line.by_lat_lng

    respond_to do |format|
      format.json{ render :json => @lines }
    end
  end

  def show
    @line = Line.get(params[:id])

    if params[:filename]
      metadata = @line._attachments[params[:filename]]
      data = Marker.database.fetch_attachment(@line.id, params[:filename])
      send_data(data, {
        :filename    => params[:filename],
        :type        => metadata['content_type'],
        :disposition => "inline",
      })
      return
    end
  end

  def edit
    @line = Line.get(params[:id])
  end

  def update
  end

  def new
    @line = Line.new
  end

  def create

    attachment = params[:line].delete('attachment')
    params[:line]['polyline'] = params[:line]['polyline'][1..-1].split("],[").map{|x| x.split(",").map{|y| y.to_f}}
    @line = Line.new(params[:line])

    unless attachment.blank?
      @line['_attachments'] ||= {}
      filename = File.basename(attachment.original_filename)

      @line['_attachments'][filename] = {
        "content_type" => attachment.content_type,
        "data" => attachment.read
      }
    end    

    respond_to do |format|
      if @line.save
        flash[:notice] = "Linia zostala dodana."
        format.html { redirect_to('/') }
#        format.xml  { render :xml => @app, :status => :created, :location => @app }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy

    @line = Line.get(params[:id])
    @line.destroy

    respond_to do |format|
      flash[:notice] = 'Linia zostala usunieta.'
#      format.html { render :text => '' }
      format.html { redirect_to('/') }
    end
  end

end
