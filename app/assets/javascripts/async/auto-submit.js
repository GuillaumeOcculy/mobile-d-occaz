;(function($){
    
	'use strict';

	var DELAY = 250;
 
	$('form.jt-auto-submit').each(function(){
		var context = {
			form: $(this),
			isSubmiting: false,
			needNewSubmit: false,
			timerId: null
		};

		context.form.find('input,select,textarea').on('change', function(){
			submit(context);
		});

		context.form.find('input,select,textarea').on('input', function(){
			submit(context);
		});

		context.form.on('ajax:before', function(){
			return onSubmit(context);
		});

		context.form.on('ajax:complete', function(){
			onComplete(context);
		});
	});

	function submit(context){
		if(context.timerId){
			clearInterval(context.timerId);
			context.timerId = null;
		}

		context.timerId = setTimeout(function(){
			context.timerId = null;
			context.form.submit();
		}, DELAY);
	}

	function onSubmit(context){
		if(context.isSubmiting){
			context.needNewSubmit = true;
			return false;
		}

		context.isSubmiting = true;
		return true;
	}

	function onComplete(context){
		context.isSubmiting = false;

		if(context.needNewSubmit){
			context.needNewSubmit = false;
			submit(context);
		}
	}

})(jQuery);
