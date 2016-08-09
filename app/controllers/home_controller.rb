require 'open-uri'

class HomeController < ApplicationController
  def index
  end
  
  def manage
    @key = params[:key]
    unless ENV['MANAGE_ACCESS_KEY'] == @key
      redirect_to "./"
    end
  end
  
  def add_req
    unless params[:category] == "Pub" || params[:category] == "Bar" || params[:category] == "Store" 
      redirect_to "./"
    end
    
    doc = Nokogiri::HTML(open("https://maps.googleapis.com/maps/api/geocode/xml?address=" + URI.encode(params[:address]) + "&key=AIzaSyBFwh5f4ZyyxHLsCvK339Bx2Uu7c4uxK80"))
    
    status = doc.xpath("//status/text()").to_s
    if status == "OK"
      Request.new(category: params[:category], placename: params[:placename], address: params[:address], website: params[:website]).save
    end
    redirect_to "./"
  end
  
  def add_place
    @key = params[:key]
    unless ENV['MANAGE_ACCESS_KEY'] == @key
      redirect_to "./"
    end
    
    req = Request.find_by(id: params[:id])
    doc = Nokogiri::HTML(open("https://maps.googleapis.com/maps/api/geocode/xml?address=" + URI.encode(req.address) + "&key=AIzaSyBFwh5f4ZyyxHLsCvK339Bx2Uu7c4uxK80"))
    
    status = doc.xpath("//status/text()").to_s
    if status == "OK"
      Place.new(category: req.category, latitude: doc.xpath("//location//lat/text()").first, longitude: doc.xpath("//location//lng/text()").first, placename: req.placename, address: req.address, website: req.website, rating: 0, rating_count: 0).save
      req.destroy
    end
    redirect_to "./manage?key=" + @key
  end
  
  def request_delete
    @key = params[:key]
    unless ENV['MANAGE_ACCESS_KEY'] == @key
      redirect_to "./"
    end
    
    req = Request.find_by(id: params[:id])
    req.destroy
    redirect_to "./manage?key=" + @key
  end
  
  def place_delete
    @key = params[:key]
    unless ENV['MANAGE_ACCESS_KEY'] == @key
      redirect_to "./"
    end
    
    place = Place.find_by(id: params[:id])
    place.destroy
    redirect_to "./manage?key=" + @key
  end
  
  def view_place
    @place = Place.find_by(id: params[:id])
  end
  
  def edit_place
    @place = Place.find_by(id: params[:id])
  end
  
  def edit_place_submit
    place = Place.find_by(id: params[:id])
    place.update(website: params[:website], content: params[:content])
    
    if place.save
      redirect_to "../place?id=" + params[:id]
    end
  end
  
  def rating_submit
    rating = Rating.new(place_id: params[:id], score: params[:score], ip: request.remote_ip)
    
    unless Rating.nil?
      Rating.all.each do |r|
        if rating.place_id == r.place_id && rating.ip == r.ip
          redirect_to "./place?id=" + params[:id]
          return
        end
      end
    end
    place = Place.find_by(id: params[:id])
    place.rating += Integer(params[:score])
    place.rating_count += 1
    
    if rating.save && place.save
      redirect_to "./place?id=" + params[:id]
    end
  end
end