;(function($){

    'use strict';

    if($('#post_post_phone_name').length == 0){
        return;
    }

    var $container = $('<div class="jt-autocomplete-container"></div>');
    var $input = $('#post_post_phone_name');
    var $input_value = $('#post_post_phone_id');

    var phones = [];
    var MAX_SUGGESTION = 12;

    $(document).ready(function(){
    	$('body').append($container);
    	hideSuggestions();
    	updatePosition();
    });

    $('#post_post_brand_id').on('change', function(){
    	phones = [];
    	$input_value.val('');

    	var url = '/annonces/' + $(this).val() + '/phones.json';
    	$.ajax(url).done(function(data){
    		phones = data;
    	});
    });

    $(window).on('resize', updatePosition);

    $input.on('input', function(){
    	$input_value.val('');

    	findSuggestions();
    });

    $container.on('click', '.jt-autocomplete-item', function(){
    	var $item = $(this);

    	$input.val($item.find('span').text());
    	$input_value.val($item.find('input').val());
    	$input.trigger('change');

    	hideSuggestions();
    });

    $input.on('focusin', function(){
    	findSuggestions();
    });

    $input.on('focusout', function(){
    	// Sinon le click est intercepté
    	setTimeout(hideSuggestions, 100);
    });

    function updatePosition(){
    	var width = $input.outerWidth() + 'px';
    	var x = ($input.offset().top + $input.height()) + 'px';
    	var y = $input.offset().left + 'px';

    	$container.css('width', width);
    	$container.css('top', x);
    	$container.css('left', y);
    }

    function findSuggestions(){
    	var count = 0;

    	cleanSuggestions();
    	for(var i = 0; i < phones.length; ++i){
    		var phoneArray = phones[i];

    		if(phoneArray[1].toLowerCase().indexOf($input.val().toLowerCase()) == 0){
    			addSuggestion(phoneArray);
    			count++;

    			if(count >= MAX_SUGGESTION){
    				break;
    			}
    		}
    	}

        if(count < MAX_SUGGESTION && $input.val().length > 2){
            for(var i = 0; i < phones.length; ++i){
                var phoneArray = phones[i];

                if(phoneArray[1].toLowerCase().indexOf($input.val().toLowerCase()) > 0){
                    addSuggestion(phoneArray);
                    count++;

                    if(count >= MAX_SUGGESTION){
                        break;
                    }
                }
            }
        }

		if(count > 0){
    		showSuggestions();
    	}
    	else{
    		hideSuggestions();
    	}
    }

    function cleanSuggestions(){
    	$container.html('');
    }

    function addSuggestion(phoneArray){
    	var item = $('<div class="jt-autocomplete-item"></div>');
    	var value = $('<input type="hidden">');
    	var text = $('<span class="jt-autocomplete-item-query"></span>');

    	value.val(phoneArray[0]);
    	text.text(phoneArray[1]);
    	item.append(value);
    	item.append(text);

    	$container.append(item);
    }

    function showSuggestions(){
    	$container.show();
    }

    function hideSuggestions(){
    	$container.hide();
    }
 
})(jQuery);
