function Get-Weather {
# originally published under MIT License (Copyright (c) 2016 Nick Tamm)
# derived from https://github.com/obs0lete/Get-Weather modified by oryon/dominik
param(
    [string]$City,
    [string]$Country)
# open-weathermap API-Key
$OPEN_WEATHERMAP_API_KEY = $Env:OPEN_WEATHERMAP_API_KEY

$error_free = $true

$JSONurl = "api.openweathermap.org/data/2.5/weather?q=$City,$Country&units=metric&type=accurate&mode=json&APPID=$OPEN_WEATHERMAP_API_KEY"
$XMLurl = "api.openweathermap.org/data/2.5/weather?q=$City,$Country&units=metric&type=accurate&mode=xml&APPID=$OPEN_WEATHERMAP_API_KEY"


try {

    $time = Get-Date -DisplayHint Time

    $JSONresponse = Invoke-WebRequest $JSONurl
    $JSONData = ConvertFrom-Json $JSONresponse.Content

    [xml]$XMLrepsonse = Invoke-WebRequest $XMLurl
    $XMLdata = $XMLrepsonse.current

    $sunrise = [TimeZone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($JSONData.sys.sunrise))
    $varsunset = [TimeZone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($JSONData.sys.sunset))
    $sunrise =  "{0:HH:mm:ss tt}" -f (Get-Date $sunrise)
    $varsunset = "{0:HH:mm:ss tt}" -f (Get-Date $varsunset)

    $thunder = "200","201","202","210","211","212","221","230","231","232"
    $drizzle = "300","301","302","310","311","312","313","314","321","500","501","502"
    $rain = "503","504","520","521","522","531"
    $lightSnow = "600","601"
    $heavySnow = "602","622"
    $snowAndRain = "611","612","615","616","620","621"
    $atmosphere = "701","711","721","731","741","751","761","762","771","781"
    $clear = "800"
    $partlyCloudy = "801","802","803"
    $cloudy = "804"
    $windy = "900","901","902","903","904","905","906","951","952","953","954","955","956","957","958","959","960","961","962"

    $weather = (Get-Culture).textinfo.totitlecase($XMLdata.weather.value.tolower())
    $currentTemp = "Current Temp: " + [Math]::Round($XMLdata.temperature.value, 0) + [char] 176 + "c"
    $high = "Today's High: " + [Math]::Round($XMLdata.temperature.max, 0) + [char] 176 + "c"
    $low = "Today's Low: " + [Math]::Round($XMLdata.temperature.min, 0) + [char] 176 + "c"
    $humidity = "Humidity: " + $XMLdata.humidity.value + $XMLdata.humidity.unit
    $windSpeed = "Wind Speed: " + ([math]::Round(([decimal]$XMLdata.wind.speed.value * 1.609344),1)) + " km/h" + " - Direction: " + $XMLdata.wind.direction.code
    $windCondition = "Wind Condition: " + (Get-Culture).textinfo.totitlecase($XMLdata.wind.speed.name.tolower())
    $sunrise = "sunrise: " + $sunrise
    $sunset = "sunset: " + $varsunset

} catch {
    # TODO: catch specific error messages and give adequate feedback
    # if openweather is completely offline, same error-message(!)
    Write-Host $City $_.Exception.Response.StatusCode "in Country" $Country "(usage: weather <City> <Country>)"
    $error_free = $false
}

IF ($error_free) {

    Write-Host $weather -f yellow -nonewline; Write-Host " in " $XMLdata.city.name;
    Write-Host ""

    IF ($thunder.Contains($XMLdata.weather.number))
    {
        Write-Host "     .-(    ).         " -f gray -nonewline;   Write-Host "$currenttemp        $humidity" -f white;
        Write-Host "    (___.__)__)        " -f gray -nonewline;   Write-Host "$high        $windspeed" -f white;
        Write-Host "      /_   /_          " -f yellow -nonewline; Write-Host "$low        $windcondition" -f white;
        Write-Host "       /    /          " -f yellow -nonewline; Write-Host "$sunrise        $sunset" -f white;
    }
        ELSEIF ($drizzle.Contains($XMLdata.weather.number))
            {
                Write-Host "     (   ).         " -f gray -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "    (___(__)        " -f gray -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "     / / /             " -f cyan -nonewline; Write-Host "$low        $windcondition" -f white;
                Write-Host "      /              " -f cyan -nonewline; Write-Host "$sunrise        $sunset" -f white;
            }
        ELSEIF  ($rain.Contains($XMLdata.weather.number))
            {
                Write-Host "       (   ).         " -f gray -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "      (___(__)        " -f gray -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "     ////////         " -f cyan -nonewline; Write-Host "$low        $windcondition" -f white;
                Write-Host "     ///////         " -f cyan -nonewline; Write-Host "$sunrise        $sunset" -f white;
            }
        ELSEIF  ($lightSnow.Contains($XMLdata.weather.number))
            {
                Write-Host "     (   ).         " -f gray -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "    (___(__)        " -f gray -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "     *  *  *        $low        $windcondition"
                Write-Host "    *  *  *         $sunrise        $sunset"
            }
        ELSEIF  ($heavySnow.Contains($XMLdata.weather.number))
            {
                Write-Host "     (   ).         " -f gray -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "    (___(__)        " -f gray -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "    ********        $low        $windcondition"
                Write-Host "    ********        $sunrise        $sunset"
            }
        ELSEIF  ($snowAndRain.Contains($XMLdata.weather.number))
            {
                Write-Host "     (   ).         " -f gray -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "    (___(__)        " -f gray -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "     */ */*         $low        $windcondition"
                Write-Host "    * /* /*         $sunrise        $sunset"
            }
        ELSEIF  ($atmosphere.Contains($XMLdata.weather.number))
            {
                Write-Host "    _ - _ - _ -        " -f gray -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "     _ - _ - _         " -f gray -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "    _ - _ - _ -        " -f gray -nonewline; Write-Host "$low        $windcondition" -f white;
                Write-Host "     _ - _ - _         " -f gray -nonewline; Write-Host "$sunrise        $sunset" -f white;
            }
        <#
            The following will be displayed on clear evening conditions
            It is set to 18:00:00 (6:00PM). Change this to any value you want.
        #>
        ELSEIF  ($clear.Contains($XMLdata.weather.number) -and $time -gt $varsunset)
            {
                Write-Host "        *  --.          $currenttemp        $humidity"
                Write-Host "            \  \  *     $high        $windspeed"
                Write-Host "       *    ./ /        $low        $windcondition"
                Write-Host "           ---'  *      $sunrise        $sunset"
            }
        ELSEIF  ($clear.Contains($XMLdata.weather.number))
            {
                Write-Host "       \ | /          " -f Yellow -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "        .-.           " -f Yellow -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "    -- (   ) --        " -f Yellow -nonewline; Write-Host "$low        $windcondition" -f white;
                Write-Host "       / | \          " -f Yellow -nonewline; Write-Host "$sunrise        $sunset" -f white;
            }
        ELSEIF ($partlyCloudy.Contains($XMLdata.weather.number))
            {
                Write-Host "       \ | /           " -f Yellow -nonewline; Write-Host "$currenttemp        $humidity" -f white;
                Write-Host "        .-.--          " -f Yellow -nonewline; Write-Host "$high        $windspeed" -f white;
                Write-Host "       .-(    ).         $low        $windcondition"
                Write-Host "      (___.__)__)        $sunrise        $sunset"
            }
        ELSEIF ($cloudy.Contains($XMLdata.weather.number))
            {
            Write-Host "        .--.           $currenttemp        $humidity"
            Write-Host "     .-(    ).         $high        $windspeed"
            Write-Host "    (___.__)__)        $low        $windcondition"
            Write-Host "                        $sunrise        $sunset"
            }
        ELSEIF ($windy.Contains($XMLdata.weather.number))
            {
            Write-Host "    ~~~~      .--.       $currenttemp        $humidity"
            Write-Host "     ~~~~~ .-(    ).     $high        $windspeed"
            Write-Host "    ~~~~~ (___.__)__)    $low        $windcondition"
            Write-Host "                         $sunrise        $sunset"
            }
    }

    Write-Host ""
}
