;(function($){

    'use strict';

    $('.input-file a').on('click', function(e){
        e.preventDefault();

        var $inputContainer = $(this).parent();

        if($inputContainer.hasClass('jt-upload-ready')){
            $inputContainer.find('input').trigger('click');
        }
        else if($inputContainer.hasClass('jt-upload-remove')){
            if(confirm("Êtes-vous sûre de vouloir supprimer cette photo?")){
                removeFile($inputContainer);
            }
        }
    });

    $('.input-file input').on('change', function(){
        var $inputContainer = $(this).parent();
        uploadFile($inputContainer);
    });

    function uploadFile($inputContainer){
        $inputContainer.removeClass('jt-upload-ready');
        var $input = $inputContainer.find('input');

        var postId = window.location.pathname.split('/')[2];
        var uploadURL = '/annonces/' + postId + '/upload.js';

        var formData = new FormData();
        formData.append('file', $input.prop('files')[0]);

        $.ajax({
            type: 'POST',
            url: uploadURL,
            enctype: 'multipart/form-data',
            cache: false,
            contentType: false,
            processData: false,
            data: formData,
            xhr: function(){
                // IE
                if(window.ActiveXObject){
                    return new window.ActiveXObject("Microsoft.XMLHTTP");
                }

                var xhr = new window.XMLHttpRequest();
                xhr.upload.addEventListener("progress", function(evt){
                    if(evt.lengthComputable){
                        var percentComplete = evt.loaded / evt.total;
                        updateInputPercentage($inputContainer, Math.round(percentComplete * 100.0));
                    }
                }, false);

                return xhr;
            }
        }).done(function(data){
            uploadComplete($inputContainer, data);
        });
    }

    function removeFile($inputContainer){
        $inputContainer.removeClass('jt-upload-remove');
        var media_id = null;

        var classes = $inputContainer.attr('class').split(' ');
        for(var i = 0; i < classes.length; ++i){
            var class_name = classes[i];
            if(class_name.indexOf('jt-media-id-') == 0){
                media_id = class_name.replace('jt-media-id-', '');
                break;
            }
        }

        if(!media_id){
            console.error('No media id');
        }

        var postId = window.location.pathname.split('/')[2];
        var removeURL = '/annonces/' + postId + '/remove_media.js?media_id=' + media_id;

        $.ajax({
            type: 'POST',
            url: removeURL
        }).done(function(){
            $inputContainer.removeClass(class_name);
            removeComplete($inputContainer);
        });
    }

    function updateInputPercentage($inputContainer, percentage){
        $inputContainer.find('a').text(percentage + '%');
    }

    function uploadComplete($inputContainer, data){
        var media_id = data.id;
        var media_url = data.url;

        $inputContainer.find('a').text('Supprimer');
        $inputContainer.find('a').addClass('icon-remove');
        $inputContainer.addClass('jt-upload-remove');

        $inputContainer.addClass('jt-media-id-' + media_id);
        $inputContainer.css('background-image', 'url(' + media_url +')');
    }

    function removeComplete($inputContainer){
        $inputContainer.find('a').text('Ajouter une photo');
        $inputContainer.find('a').removeClass('icon-remove');
        $inputContainer.addClass('jt-upload-ready');
        $inputContainer.css('background-image', 'none');
    }

})(jQuery);
