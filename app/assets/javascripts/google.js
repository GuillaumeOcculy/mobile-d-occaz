//= require_self
//= require_tree ./google

;(function($){

    'use strict';

    window.googleMapInitialize = function(){
    	$(document).trigger('google:initialize');
    };

})(jQuery);
