# Get Device Location from GPS-sensor or settings and asks google maps for the location
if ($env:DOTFILES_SKIP_DEVICE_LOCATION) { return }

if (("{0}" -f $env:GOOGLE_MAPS_API_KEY) -eq "") {
    Write-Host "No Google Maps API key found. Please set the environment variable GOOGLE_MAPS_API_KEY to your Google Maps API key."
    return
}

# set this to your "fallback", or home location
$home_latitude = 51.23548
$home_longitude = 6.839653
$home_city = "Dusseldorf"
$home_country = "DE"

try { $connected = Test-Connection -Count 1 -ComputerName maps.googleapis.com -Quiet -InformationAction Ignore } catch { $connected = $false }
if (!$connected) { Write-Warning "No Connection to GEOCODING-API possible"; return }

if ($connected) {
    Add-type -AssemblyName System.Device
    $gps_location = New-Object System.Device.Location.GeoCoordinate
    $latitude = if (![System.Double]::IsNaN($gps_location.latitude)) {$gps_location.latitude} else {$home_latitude}
    $longitude = if (![System.Double]::IsNaN($gps_location.longitude)) { $gps_location.longitude } else { $home_longitude }

    # Retrieve Geolocation from Google Geocoding API
    $url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_MAPS_API_KEY"

    # TODO: catch network-errors
    $APIResults = ((Invoke-WebRequest $url).Content | ConvertFrom-Json | Select Results)

    if ($APIResults.results) {
        $GEO_country = $APIResults.results[0].address_components[-2].short_name
        $GEO_city = $APIResults.results[0].address_components[-4].long_name
    }

    # Fallback to defaults if no location found
    if(-Not $GEO_country -or $GEO_country -eq $null){ $GEO_country = $home_country }
    if(-Not $GEO_city -or $GEO_city -eq $null){ $GEO_city = $home_city }

    $position = New-Object -TypeName PSObject
    $position | Add-Member -MemberType NoteProperty -Name city -Value $GEO_city
    $position | Add-Member -MemberType NoteProperty -Name country -Value $GEO_country
}
