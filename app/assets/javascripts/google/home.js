;(function($){
    
    'use strict';
    
    if($('#home').length == 0){
        return;
    }

    // geoplugin is not available in https
    if(window.location.protocol == "https:"){
        return;
    }

    var geoData = {};
    var geoIpURL = 'http://www.geoplugin.net/json.gp?jsoncallback=?';

    $(document).on('google:initialize', function(){
      $.getJSON(geoIpURL, {format: 'json'}).done(function(data){

            geoData = {
                city: data.geoplugin_city,
                // zip_code: data.geoplugin_,
                // department: data.geoplugin_,
                // department_code: data.geoplugin_,
                // region: data.geoplugin_regionName, // la region n est pas bonne
                // region_code: data.geoplugin_,
                country: data.geoplugin_countryName,
                country_code: data.geoplugin_countryCode,
                lat: Number(data.geoplugin_latitude),
                lng: Number(data.geoplugin_longitude)
            };

            if(!geoData.lat){
                return;
            }

            loadGoogleMap();
            loadPosts();
        });
    });

    function loadGoogleMap(){
        var center = new google.maps.LatLng(geoData.lat, geoData.lng);

        var mapOptions = {
            zoom: 13,
            disableDefaultUI: true,
            draggable: false,
            scrollwheel: false,
            center: center,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById('map-container'), mapOptions);
    }

    function loadPosts(){
         $.ajax({
            url: '/?format=js',
            data: {
                place_lat: geoData.lat,
                place_lng: geoData.lng
            }
        });

        if(!geoData.city || geoData.city.length == 0){
            return;
        }

        var $container = $('#home-search .autocomplete-place-geocode');

        $container.find('input[type="hidden"]').val('');
        
        for(var attr in geoData){
            var value = geoData[attr];
            $container.find('input[type="hidden"][id$="' + attr + '"]').val(value);
        }

        $container.find('input[type="text"]').val(geoData.city + ', ' + geoData.country);
    }

})(jQuery);
