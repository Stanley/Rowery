# encoding: utf-8

class MarkersController < ApplicationController

  before_filter :authenticate!, :except => [:index, :show]

  def index
    @markers = Marker.all

    respond_to do |format|
      format.html
      format.json{ render :json => @markers }
    end
  end

  def show
    @marker = Marker.get(params[:id])

    if params[:filename]
      metadata = @marker._attachments[params[:filename]]
      data = Marker.database.fetch_attachment(@marker.id, params[:filename])
      send_data(data, {
        :filename    => params[:filename],
        :type        => metadata['content_type'],
        :disposition => "inline",
      })
      return
    end
  end

  def edit
    @marker = Marker.get(params[:id])
  end

  def update

    attachment = params[:marker].delete('attachment')
    @marker = Marker.get(params[:id])

    unless attachment.blank?
      params[:marker]['_attachments'] ||= {}
      filename = File.basename(attachment.original_filename)

      params[:marker]['_attachments'][filename] = {
        "content_type" => attachment.content_type,
        "data" => attachment.read
      }
    end

    params[:marker].each_pair do |key, val|
      @marker[key] = val
    end

    respond_to do |format|
      if @marker.save 
        flash[:notice] = 'Punkt został uaktualniony.'
        format.html { redirect_to('/') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def new
    raise 'Brak parametru category' if params[:marker].blank? or params[:marker]['category'].blank?
    @marker = Marker.new
  end

  def create
    attachment = params[:marker].delete('attachment')
    @marker = Marker.new(params[:marker])

    unless attachment.blank?
      @marker['_attachments'] ||= {}
      filename = File.basename(attachment.original_filename)

      @marker['_attachments'][filename] = {
        "content_type" => attachment.content_type,
        "data" => attachment.read
      }
    end

    respond_to do |format|
      if @marker.save
        flash[:notice] = 'Sukces. Punkt zostal dodany.'
        format.html { redirect_to('/') }
#        format.xml  { render :xml => @app, :status => :created, :location => @app }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy

    @marker = Marker.get(params[:id])
    @marker.destroy

    respond_to do |format|
      flash[:notice] = 'Punkt zostal usuniety.'
      format.html { redirect_to('/') }
    end
  end

end
