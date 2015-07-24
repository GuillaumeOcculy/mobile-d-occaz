;(function($){

    'use strict';

    var currentImageIndex = 0;

    var imageContainer = $('.big div');
    var imagesLinks = $('.thumb a');

    refreshImage();

    imagesLinks.on('click', function(e){
        e.preventDefault();
        
        currentImageIndex = $(this).index();
        refreshImage();
    });

    function refreshImage(){
        imagesLinks.removeClass('active');
        imagesLinks.eq(currentImageIndex).addClass('active');

        imageContainer.css('background-image', 'url(' + imagesLinks.eq(currentImageIndex).attr('href') + ')');
    }

})(jQuery);
