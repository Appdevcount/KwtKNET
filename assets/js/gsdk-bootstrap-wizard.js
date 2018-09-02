/*!

 =========================================================
 * Bootstrap Wizard - v1.1.1
 =========================================================
 
 * Product Page: https://www.creative-tim.com/product/bootstrap-wizard
 * Copyright 2017 Creative Tim (http://www.creative-tim.com)
 * Licensed under MIT (https://github.com/creativetimofficial/bootstrap-wizard/blob/master/LICENSE.md)
 
 =========================================================
 
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 */

// Get Shit Done Kit Bootstrap Wizard Functions

searchVisible = 0;
transparent = true;

$(document).ready(function(){

    /*  Activate the tooltips      */
    $('[rel="tooltip"]').tooltip();

    // Code for the Validator
    var $validator = $('.wizard-card form').validate({
		//   rules: {
		//     firstname: {
		//       required: true,
		//       minlength: 3
		//     },
		//     lastname: {
		//       required: true,
		//       minlength: 3
		//     },
		//     email: {
		//       required: true,
		//       minlength: 3,
		//     }
        // }
        rules: {
            TIRCNumber: "required",
            SecurityCode: "required",
            Mobile: {
                required: true,
                minlength: 2,
                digits: true
            },
            Email: {
                required: true,
                minlength: 2,
                email:true
            }
        },
        messages: {
            TIRCNumber: "Please enter your TIRCNumber",
            SecurityCode: "Please enter your SecurityCode",
            Mobile: {
                required: "Please enter your Mobile Number",
                minlength: "Please enter your Mobile Number"
            },
            Email: {
                required: "Please enter a valid email address",
                minlength: "Please enter a valid email address"
            }
        },
        errorElement: "em",
        errorPlacement: function (error, element) {
            // Add the `help-block` class to the error element
            error.addClass("help-block");

            // Add `has-feedback` class to the parent div.form-group
            // in order to add icons to inputs
            //element.parents(".col-sm-5").addClass("has-feedback");
            if (element.prop("type") === "checkbox" | element.prop("type") === "radio") {
                element.parent().parent().addClass("has-feedback");
            }
            else {
                element.parent().addClass("has-feedback");
            }

            //if (element.prop("type") === "checkbox") {
            //    error.insertAfter(element.parent("label"));
            //} else {
            //    error.insertAfter(element);
            //}
            if (element.prop("type") === "checkbox" | element.prop("type") === "radio") {
                error.insertAfter(element.parent("div").parent());
            }
            else {
                error.insertAfter(element);
            }

            // Add the span element, if doesn't exists, and apply the icon classes to it.

            //console.log("error" + $(element).next("span")[0]);
            if (!element.next("span")[0]) {
                //element.next("span")[0].remove();
                //$("<span class='glyphicon glyphicon-remove form-control-feedback'></span>").insertAfter(element);
                $("<span class='fa  fa-times-circle fa-2x form-control-feedback'></span>").insertAfter(element);
            }
            ////if (element.prop("type") === "checkbox" | element.prop("type") === "radio") {
            ////    if (!element.parent().parent().next("span")[0]) {
            ////        $("<span class='glyphicon glyphicon-remove form-control-feedback'></span>").insertAfter(element.parent().parent());
            ////    }
            ////}
            ////else {
            ////    if (!element.next("span")[0]) {
            ////        $("<span class='glyphicon glyphicon-remove form-control-feedback'></span>").insertAfter(element);
            ////    }
            ////}

        },
        success: function (label, element) {
            // //Add the span element, if doesn't exists, and apply the icon classes to it.
            //console.log($(element));
            //console.log($(element).next());
            //console.log("success"+$(element).next("span")[0]);

            if (!$(element).next("span")[0]) {
                //element.next("span")[0].remove();
                //console.log($(element));
                //$("<span class='glyphicon glyphicon-ok form-control-feedback'></span>").insertAfter($(element));
                $("<span class='fa  fa-check-circle fa-2x form-control-feedback'></span>").insertAfter($(element));
                //console.log($(element).next());
                //console.log($(element).next().next());
                //$("<span class='glyphicon glyphicon-ok form-control-feedback'></span>").insertAfter($(element));
            }
            //if (element.prop("type") === "checkbox" | element.prop("type") === "radio") {
            //    if (!$(element.parent().parent()).next("span")[0]) {
            //        $("<span class='glyphicon glyphicon-ok form-control-feedback'></span>").insertAfter($(elementparent().parent()));
            //    }
            //}
            //else {
            //    if (!$(element).next("span")[0]) {
            //        $("<span class='glyphicon glyphicon-ok form-control-feedback'></span>").insertAfter($(element));
            //    }
            //}
        },
        highlight: function (element, errorClass, validClass) {
            //$(element).parents(".IP").addClass("has-error").removeClass("has-success");
            ////$(element).next("span").addClass("glyphicon-remove").removeClass("glyphicon-ok");
            ////$( element ).next( "span" ).removeClass( "glyphicon-ok" );
            $(element).parents(".IP").addClass("has-error").removeClass("has-success");
            $(element).next("span").addClass("fa-times-circle").removeClass("fa-check-circle");
        },
        unhighlight: function (element, errorClass, validClass) {
            //$(element).parents(".IP").addClass("has-success").removeClass("has-error");
            ////$(element).next("span").addClass("glyphicon-ok").removeClass("glyphicon-remove");
            ////$( element ).next( "span" ).addClass( "glyphicon-ok" );
            $(element).parents(".IP").addClass("has-success").removeClass("has-error");
            $(element).next("span").addClass("fa-check-circle").removeClass("fa-times-circle");
        }
	});

    // Wizard Initialization
  	$('.wizard-card').bootstrapWizard({
        'tabClass': 'nav nav-pills',
        'nextSelector': '.btn-next',
        'previousSelector': '.btn-previous',

        onNext: function(tab, navigation, index) {
        	 var $valid = $('.wizard-card form').valid();
        	 if(!$valid) {
        	 	$validator.focusInvalid();
        	 	return false;
        	 }

            //console.log("INDEX =" + index);
            if (index == 1) {
                //PaymentVerifierOnStart("FROM TEST");
                var Proceed = ReceiptValidatorCall();
                //console.log("gsdk" + Proceed);
                //return Proceed;
                return Proceed;
            }
            event.preventDefault();//To avoid postback on buttonclick ,.. If we use input type=button then no issues
            //ReceiptValidatorCall();
        },

        onInit : function(tab, navigation, index){

          //check number of tabs and fill the entire row
          var $total = navigation.find('li').length;
          $width = 100/$total;
          var $wizard = navigation.closest('.wizard-card');

          $display_width = $(document).width();

          if($display_width < 600 && $total > 3){
              $width = 50;
          }

           navigation.find('li').css('width',$width + '%');
           $first_li = navigation.find('li:first-child a').html();
           $moving_div = $('<div class="moving-tab">' + $first_li + '</div>');
           $('.wizard-card .wizard-navigation').append($moving_div);
           refreshAnimation($wizard, index);
           $('.moving-tab').css('transition','transform 0s');
       },

        onTabClick : function(tab, navigation, index){

            //alert("TEST");
            return false;
            // var $valid = $('.wizard-card form').valid();

            if(!$valid){
                return false;
            } else {
                return true;
            }
        },

        onTabShow: function(tab, navigation, index) {
            var $total = navigation.find('li').length;
            var $current = index+1;

            var $wizard = navigation.closest('.wizard-card');

            // If it's the last tab then hide the last button and show the finish instead
            if($current >= $total) {
                $($wizard).find('.btn-next').hide();
                $($wizard).find('.btn-finish').show();
            } else {
                $($wizard).find('.btn-next').show();
                $($wizard).find('.btn-finish').hide();
            }

            button_text = navigation.find('li:nth-child(' + $current + ') a').html();

            setTimeout(function(){
                $('.moving-tab').text(button_text);
            }, 150);

            var checkbox = $('.footer-checkbox');

            if( !index == 0 ){
                $(checkbox).css({
                    'opacity':'0',
                    'visibility':'hidden',
                    'position':'absolute'
                });
            } else {
                $(checkbox).css({
                    'opacity':'1',
                    'visibility':'visible'
                });
            }

            refreshAnimation($wizard, index);
        }
  	});


    // Prepare the preview for profile picture
    $("#wizard-picture").change(function(){
        readURL(this);
    });

    $('[data-toggle="wizard-radio"]').click(function(){
        wizard = $(this).closest('.wizard-card');
        wizard.find('[data-toggle="wizard-radio"]').removeClass('active');
        $(this).addClass('active');
        $(wizard).find('[type="radio"]').removeAttr('checked');
        $(this).find('[type="radio"]').attr('checked','true');
    });

    $('[data-toggle="wizard-checkbox"]').click(function(){
        if( $(this).hasClass('active')){
            $(this).removeClass('active');
            $(this).find('[type="checkbox"]').removeAttr('checked');
        } else {
            $(this).addClass('active');
            $(this).find('[type="checkbox"]').attr('checked','true');
        }
    });

    $('.set-full-height').css('height', 'auto');

});



 //Function to show image before upload

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#wizardPicturePreview').attr('src', e.target.result).fadeIn('slow');
        }
        reader.readAsDataURL(input.files[0]);
    }
}

$(window).resize(function(){
    $('.wizard-card').each(function(){
        $wizard = $(this);
        index = $wizard.bootstrapWizard('currentIndex');
        refreshAnimation($wizard, index);

        $('.moving-tab').css({
            'transition': 'transform 0s'
        });
    });
});

function refreshAnimation($wizard, index){
    total_steps = $wizard.find('li').length;
    move_distance = $wizard.width() / total_steps;
    step_width = move_distance;
    move_distance *= index;

    $wizard.find('.moving-tab').css('width', step_width);
    $('.moving-tab').css({
        'transform':'translate3d(' + move_distance + 'px, 0, 0)',
        'transition': 'all 0.3s ease-out'

    });
}

function debounce(func, wait, immediate) {
	var timeout;
	return function() {
		var context = this, args = arguments;
		clearTimeout(timeout);
		timeout = setTimeout(function() {
			timeout = null;
			if (!immediate) func.apply(context, args);
		}, wait);
		if (immediate && !timeout) func.apply(context, args);
	};
};
