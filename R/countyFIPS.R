#' Identify counties for non-county locations
#'
#' \code{countyFIPS} converts lat/lon coordinates, location names, or
#' place FIPS codes to county-level FIPS codes.
#'
#' @param lat The latitude coordinate for a location
#' @param lon The longitude coordinate for a location
#' @param location The name of a location given as a string
#' @param place The Place FIPS Code given as a string
#' @param key Your Google API key for geocoding location strings and place FIPS
#' @return A dataframe returning the queried coordinates and resulting state, county, and county FIPS
#' @import jsonlite
#' @import ggmap
#' @keywords counties, geocoding, FIPS, API
#' @examples
#' countyFIPS(lat = 39.9526, lon = -75.1652)
#' countyFIPS(location = "Philadelphia, PA", key = "XXXXXXXXXXXXXX")
#' countyFIPS(place = "4260000", key = "XXXXXXXXXXXXXX")
#' @export



countyFIPS <- function(lat, lon, location = NULL, place = NULL, key = NULL, override = FALSE) {
  if (!is.null(location)) {
    if (class(location) != "character") {
      stop("Location must be provided as a string.")
    }
    if (is.null(key)) {
      stop("Must provide a Google API key.")
    }
    message(paste("Gathering coordinates for ", location, ".", sep = ""))
    coordinates <- ggmap::geocode(location = location,
                                  output = "latlon",
                                  source = "google",
                                  inject = paste("key=", key, sep = ""),
                                  override_limit = override)
    lat <- coordinates$lat
    lon <- coordinates$lon
  }
  if (!is.null(place)) {
    if (class(place) != "character") {
      stop("Place FIPS code must be provided as a string.")
    }
    if (is.null(key)) {
      stop("Must provide a Google API key.")
    }
    location <- place_geocodes$full_name[which(place_geocodes$fips == place)]
    message(paste("Gathering coordinates for ", location, ".", sep = ""))
    coordinates <- ggmap::geocode(location = location,
                                  output = "latlon",
                                  source = "google",
                                  inject = paste("key=", key, sep = ""),
                                  override_limit = override)
    lat <- coordinates$lat
    lon <- coordinates$lon
  }
  if (missing(lat)) {
    stop("You need to supply the lattitude coordinate for your location.")
  }
  if (missing(lon)) {
    stop("You need to supply the longitude coordinate for your location.")
  }
  url_query <- paste("https://geo.fcc.gov/api/census/area?lat=",
                     lat,
                     "&lon=",
                     lon,
                     "&format=json",
                     sep = "")
  out <- jsonlite::fromJSON(url_query)
  out_county_fips <- out$results$county_fips[1]
  out_county_name <- out$results$county_name[1]
  out_state_name <- out$results$state_name[1]
  out_results <- data.frame(search_lat = lat,
                            search_lon = lon,
                            result_state = out_state_name,
                            result_county = out_county_name,
                            result_fips = out_county_fips)
  return(out_results)
}
