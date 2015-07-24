//= require jquery.scrollTo.min

;(function($){

    'use strict';

    if($('.jt-panel').length == 0){
        return;
    }

    $('.jt-panel').hide();

    var currentPanelIndex = 0;
    var panels = $('.jt-panel');
    var nextButton = $('.jt-panel-next');

    refreshPanels();

    nextButton.on('click', function(e){
        e.preventDefault();

        if(currentPanelIndex + 1 >= panels.length){
            return;
        }

        if(haveError()){
            return;
        }

        currentPanelIndex++;
        refreshPanels();
    });

    $('.new-post-form button').on('click', function(e){
        if(haveError()){
            e.preventDefault();
        }
    });

    $('.jt-panel-label a').on('click', function(e){
        e.preventDefault();
  
        currentPanelIndex = $(this).parent().index();
        refreshPanels();
    });

    function haveError(){
        var currentPanelView = $('.jt-panel').eq(currentPanelIndex);
        var inputs = currentPanelView.find('input[id],select,textarea');
        inputs.trigger('jt:validate');

        var haveError = false;

        for(var i = 0; i < inputs.length; ++i){
            var $input = currentPanelView.find('input[id],select,textarea').eq(i);
            var element = $input.parent();
            if(element.hasClass('error')){
                haveError = true;
                break;
            }
        }

        return haveError;
    }

    function refreshPanels(){
        $('.jt-panel').hide();
        $('.jt-panel').eq(currentPanelIndex).show();

        $('.jt-panel-label a').removeClass('active');
        $('.jt-panel-label a').eq(currentPanelIndex).addClass('active');
        
       if(currentPanelIndex + 1 >= panels.length){
            nextButton.hide();
        }
        else{
            nextButton.show();
        }

        if(currentPanelIndex > 0){
            $.scrollTo('#post_menu');
        }
    }

})(jQuery);
