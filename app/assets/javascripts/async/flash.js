;(function($){

    'use strict';

    $('.flash .close').on('click', function(e){
        e.preventDefault();

        var container = $(this).parents('.flash');
        container.slideUp();
    });
   
})(jQuery);
