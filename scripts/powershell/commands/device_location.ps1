# gets devices location from GPS-sensor or from 

# TODO: hint to GEOCODING-API key
$home_latitude = $settings.coordinates[0]
$home_longitude = $settings.coordinates[1]
$home_city = $settings.residence[0]
$home_country = $settings.residence[1]

Add-type -AssemblyName System.Device
$gps_location = New-Object System.Device.Location.GeoCoordinate

$latitude = $gps_location.latitude
$longitude = $gps_location.longitude

try {
    $connected = Test-Connection -Count 1 -ComputerName google.de -Quiet -InformationAction Ignore
}
catch {
    $connected = false
}


if ($connected) {
    if ([System.Double]::IsNaN($latitude)){
        $latitude = $home_latitude
    }
    if ([System.Double]::IsNaN($longitude)){
        $longitude = $home_longitude
    }

    if (-Not [System.Double]::IsNaN($latitude) -and -Not [System.Double]::IsNaN($longitude))
        {
            # Retrieve Geolocation from Google Geocoding API
            $url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GEOCODING_KEY"

            
            # TODO: catch no network-error
            $APIResults = ((Invoke-WebRequest $url).Content | ConvertFrom-Json | Select Results)
            
            if ($APIResults.results) {
                $GEO_country = $APIResults.results[0].address_components[-2].short_name
                $GEO_city = $APIResults.results[0].address_components[-4].long_name
            }
                
            if(-Not $GEO_country -or $GEO_country -eq $null){ $GEO_country = $home_country }
            if(-Not $GEO_city -or $GEO_city -eq $null){ $GEO_city = $home_city }

            $position = New-Object -TypeName PSObject
            $position | Add-Member -MemberType NoteProperty -Name city -Value $GEO_city
            $position | Add-Member -MemberType NoteProperty -Name country -Value $GEO_country

        }
    Else { Write-Warning "Latitude or Longitude data missing" }
}
Else {
    Write-Host "No Connection to GEOCODING-API possible"
}
