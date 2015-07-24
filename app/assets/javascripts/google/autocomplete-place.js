;(function($){

    'use strict';

    $(document).on('google:initialize', function(){
        $('.autocomplete-place-cities').each(function(i, container){
            setupInput($(container), '(cities)'); // Only cities
        });
        $('.autocomplete-place-geocode').each(function(i, container){
            setupInput($(container), 'geocode'); // Every address
        });
    });

    function setupInput($container, type){
        var $input = $container.find('input[type="text"]');

        $input.on('input', function(){
            inputChanged($container, {});
        });
        $input.on('change', function(){
            inputChanged($container, {});
        });

        var autocomplete = new google.maps.places.Autocomplete($input[0], {
            types: [type],
            componentRestrictions: { country: 'fr' }
        });

        google.maps.event.addListener(autocomplete, 'place_changed', function(){
            var place = autocomplete.getPlace();
            var data = {};

            if(!place.geometry){
                dataChanged($container, {});
                return;
            }

            data['lat'] = place.geometry.location.lat();
            data['lng'] = place.geometry.location.lng();

            for(var i = 0; i < place.address_components.length; ++i){
                if(place.address_components[i].types[0] == 'country'){
                    data['country'] = place.address_components[i].long_name;
                    data['country_code'] = place.address_components[i].short_name;
                }
                else if(place.address_components[i].types[0] == 'administrative_area_level_1'){
                    data['region'] = place.address_components[i].long_name;
                    data['region_code'] = place.address_components[i].short_name;
                }
                else if(place.address_components[i].types[0] == 'administrative_area_level_2'){
                    data['department'] = place.address_components[i].long_name;
                    data['department_code'] = place.address_components[i].short_name;
                }
                else if(place.address_components[i].types[0] == 'locality' ||
                    place.address_components[i].types[0] == 'administrative_area3'){
                    data['city'] = place.address_components[i].long_name;
                }
               else if(place.address_components[i].types[0] == 'postal_code'){
                    data['zip_code'] = place.address_components[i].long_name;
                }
            }

            dataChanged($container, data);
        });
    }

    function inputChanged($container){
        var $input = $container.find('input[type="text"]');

        if($input.val().length == 0){
            dataChanged($container, {});
        }
    }

     function updateInputs($container, data){
        $container.find('input[type="hidden"]').val('');

        for(var attr in data){
            var value = data[attr];
            $container.find('input[type="hidden"][id$="' + attr + '"]').val(value);
        }
    }

    function dataChanged($container, data){
        updateInputs($container, data);
        $(document).trigger('autocomplete:data_changed', data);
    }

})(jQuery);
