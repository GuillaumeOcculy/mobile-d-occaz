;(function($){

    'use strict';

    if($('.new-post-form').length == 0){
        return;
    }

    var $mapContainer = $('#input-map-container').parents('.row');
    var map = null;

    $(document).on('google:initialize', function(){
        var data = {};
        data.lat = $('#post_post_place_lat').val();
        data.lng = $('#post_post_place_lng').val();

        $(document).trigger('autocomplete:data_changed', data);
    });

    $(document).on('autocomplete:data_changed', function(e, data){
        if(!data || !data.lat || data.lat.length == 0){
            hideMap();
            return;
        }

        var center = new google.maps.LatLng(data.lat, data.lng);;

        if(!map){
            createMap(center);
        }

        showMap(center);
    });

    function createMap(center){
        var mapOptions = {
            zoom: 14,
            disableDefaultUI: true,
            draggable: false,
            scrollwheel: false,
            center: center,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById('input-map-container'), mapOptions);
    }

    function showMap(center){
        map.setCenter(center);

        if($mapContainer.hasClass('hidden')){
            $mapContainer.removeClass('hidden');
            $mapContainer.slideDown(function(){
                google.maps.event.trigger(map, 'resize');
            });
        }
        else{
            google.maps.event.trigger(map, 'resize');
        }
    }

    function hideMap(){
        $mapContainer.slideUp({ done: function(){
            $mapContainer.addClass('hidden');
        }});
    }

})(jQuery);
