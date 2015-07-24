;(function($){
    
    'use strict';
    
    if($('#search').length == 0){
        return;
    }

    var map = null;

    $(document).on('google:initialize', function(){
        var params = getURLParameters();
        console.log(params);
        console.log(params['place']);
        if(params['place[lat]'] && params['place[lng]']){
            var center = new google.maps.LatLng(Number(params['place[lat]']), Number(params['place[lng]']));
            loadGoogleMap(center);
        }
    });

    $(document).on('autocomplete:data_changed', function(e, data){
        var center = new google.maps.LatLng(data.lat, data.lng);

        if(!map){
            loadGoogleMap(center);
        }
        else{
            map.setCenter(center);
        }

    });

    function loadGoogleMap(center){
        var mapOptions = {
            zoom: 13,
            disableDefaultUI: true,
            draggable: false,
            scrollwheel: false,
            center: center,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById('map-container'), mapOptions);
    }

    function getURLParameters(){
        var query_string = {};
        var query = decodeURIComponent(window.location.search.substring(1));
        var vars = query.split("&");
        for(var i=0;i<vars.length;i++){
            var pair = vars[i].split("=");
            // If first entry with this name
            if (typeof query_string[pair[0]] === "undefined") {
                query_string[pair[0]] = pair[1];
            // If second entry with this name
            } else if (typeof query_string[pair[0]] === "string") {
                var arr = [ query_string[pair[0]], pair[1] ];
                query_string[pair[0]] = arr;
            // If third or later entry with this name
            } else {
                query_string[pair[0]].push(pair[1]);
            }
        } 
        return query_string;
    }

})(jQuery);
