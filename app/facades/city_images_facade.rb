class CityImagesFacade

  def initialize(location)
    @location = location
  end


  def return_lat_long
    google_geocode_service.lat_long_obj[:results][0][:geometry][:location]
  end

  def return_slug_url
    if teleport_location_service.closest_urban_area[:_embedded][:"location:nearest-urban-areas"] == []
      no_images_response = {
        message: "There are no images available for this city."
      }
    else
      teleport_location_service.closest_urban_area[:_embedded][:"location:nearest-urban-areas"][0][:_links][:"location:nearest-urban-area"][:href]
    end
  end

  def return_images
    if teleport_images_service.return_slug.class == String
      teleport_images_service.images_response[:photos][0][:image]
    else
      teleport_images_service.return_slug
    end
  end

  private

  attr_reader :location

  def teleport_images_service
    TeleportImagesService.new(return_slug_url)
  end

  def google_geocode_service
    GoogleGeocodeApiService.new(location)
  end

  def teleport_location_service
    TeleportLocationService.new(return_lat_long)
  end

end
