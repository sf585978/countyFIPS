# countyFIPS
An R package to look up the county-level FIPS codes for non-county locations.

## Purpose
countyFIPS serves the highly specific purpose of looking up the county and county-level FIPS code for locations.

## Functionality
countyFIPS can take locations in the form of latitude-longitude pairs, location names as strings, and Place FIPS codes as strings. The package function ultimately geocodes any non-coordinate data and uses the coordinates to query the FCC Area API, which returns the associated state and county information.

To use countyFIPS fully, [you need to sign up for a Google API key](https://developers.google.com/maps/documentation/geocoding/get-api-key).

## Installation
To install countyFIPS, run the following code:
```r
# install.packages("devtools")
library(devtools)
install_github("sf585978_countyFIPS")
```

## Use
countyFIPS has a single function that takes input and returns a single row dataframe with the query coordinates and resulting state, county, and county-level FIPS.

```r
countyFIPS(lat = 39.9526, lon = -75.1652)
```

If you don't already have the latitude-longitude coordinates, you can give a location name or the Place FIPS code. The function will then use ```ggmap``` and the Google Geocoding API to retrieve the coordinates for the location. You will need to provide a Google API key to use these features.

```r
countyFIPS(location = "Philadelphia, PA", key = "XXXXXXXXXXXXXX")
countyFIPS(place = "4260000", key = "XXXXXXXXXXXXXX")
```
