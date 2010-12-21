// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// HELPERS
Helpers = {
    scrollToElement: function(element){
        $('html,body').animate({
            scrollTop: $(element).offset().top
        }, {
            duration: 'slow',
            easing: 'swing'
        });
    },
    cloneBoxStyle: function(destination, source){
        source = $(source)
        $(destination).css({
            'padding-left': source.css('padding-left'),
            'padding-top': source.css('padding-top'),
            'padding-bottom': source.css('padding-bottom'),
            'padding-right': source.css('padding-right'),
            'margin-left': source.css('margin-left'),
            'margin-top': source.css('margin-top'),
            'text-indent': source.css('text-indent'),
            'font-family': source.css('font-family'),
            'display': 'inline-block',
            'border-width': '1px',
            'border-style': source.css('border-top-style'),
            'border-color': 'transparent',
            'line-height': source.css('line-height')
        });
    },
    // STATUS BAR
    showStatusBar: function(){
        if (!Helpers._statusBar){
            Helpers._statusBar = $('.status_bar');            
        }
        if (!Helpers._statusBarVisible){
            Helpers._statusBarVisible = true;
            Helpers._statusBar.show();
            Helpers._statusBar.animate({bottom : "+=30px"}, 150);
        }
    },
    hideStatusBar: function(){
        if (!Helpers._statusBar){
            Helpers._statusBar = $('.status_bar');            
        }
        if (Helpers._statusBarVisible){
            Helpers._statusBarVisible = false;
            Helpers._statusBar.animate({bottom : "-=30px"}, 150, function(){Helpers._statusBar.hide()});            
        }
    },    
    // AUTOGROW
    // Causes the textarea to grow or shrink with the contents of the textarea
    autoGrowTextAreas: function(selector){
        selector = selector || 'textarea';
        var callback = this._autoGrowGrow;
        $(selector).map(function(index, element){callback(element)});
        $(selector).live('keyup', function(event){callback(this)});
    },
    _autoGrowGrow: function(textarea){
        // Don't do it until we've initialized
        if (!textarea._autogrowSizer){
            textarea._autogrowSizer = $("<div/>", {style:"position:absolute;visibility:hidden;z-index:-10;", 'class':'autogrow_sizer'})[0];
            $(textarea).before(textarea._autogrowSizer);
            $(textarea).css('overflow', 'hidden') // Prevent the scrollbars from appearing momentarily when lines are added
            
            // Set the min height for the text area
            textarea._autogrowMin = $(textarea).outerHeight();
            Helpers.cloneBoxStyle(textarea._autogrowSizer, textarea);

        }

        // Copy the contents to the sizer element
        //
        var html = textarea.value;
        html = html.replace(/[<>]/g,'&gt;'); // Escape all html stuff
        html = html.replace(/\n/g,'<br />'); // Turn newlines into html breaks
        html = html.replace('  ',' &nbsp;'); // Turn newlines into html breaks

        // The non-breaking space ensures Safari will resize box even when
        // the last characters in the textarea are new line characters.
        html += '&nbsp;'

        textarea._autogrowSizer.innerHTML = html;

        textarea._autogrowSizer.style.width = $(textarea).outerWidth() + 'px';

        // Grow the text area if it needs to be larger than the minimum
        var sizerHeight = $(textarea._autogrowSizer).outerHeight() + 30;
        if (sizerHeight > textarea._autogrowMin ){
            textarea.style.height = sizerHeight + 'px';
        } else {
            textarea.style.height = '';
        }
    },
    
    // EVENT INSERTION

    // Inserts the event into the dom at the appropriate place in the timeline.
    // If the timeline has an event with the same id, the event is replaced with the new one.
    // ASSUMPTIONS: Events are interated earliest to latest
    insertEvent: function(eventHTML){
        var newEvent = $(eventHTML)[0];
        var events = $('.event')
        
        // If there are no events just insert it into the events list
        // Else if there are events, find where it should go
        if (events.length == 0){
            $('.events').append(newEvent)
        } else {
            var timestamp = newEvent.getAttribute('data-timestamp');
            var offset = parseInt(newEvent.getAttribute('data-offset'));
            
            events.each(function(index, event){
                var eventTimestamp = event.getAttribute('data-timestamp');
                var eventOffset = parseInt(event.getAttribute('data-offset'));
                
                // If the event has the same timestamp and the same offset, replace the event with the new one
                // Else if the event has the same timestamp and a greater offset Or if the event has a greater timestamp, we should insert before it
                if (event.id == newEvent.id) {
                    $(event).replaceWith(newEvent);
                    return false;
                } else if ((eventTimestamp == timestamp && eventOffset > offset) || eventTimestamp > timestamp){
                    $(event).before(newEvent);
                    return false;
                }
            });            
        }        
    },
    
    // EVENT OVERLAY
    // Makes a lightbox effect when you click on an event
    overlay: $("<div/>", {'class':'event_overlay', style:'display:none'}),
    currentlySelected: null,
    showOverlay: function(){
        Helpers._overlayVisible = true;
        Helpers._resizeOverlay();
        Helpers.overlay.show();
    },
    hideOverlay: function(){
        Helpers._overlayVisible = false;
        Helpers.overlay.hide();
        Helpers.currentlySelected.removeClass('selected');
        Helpers.currentlySelected = null;
    },
    // It's faster to render an absolute positioned div, than a fixed position one,
    // but we need to keep the div covering the document body even when the browser
    // window is resized.
    _resizeOverlay: function(){
        Helpers.overlay.css({'height':$(window.document.body).outerHeight() + 'px'});
    }
}


// DOM READY FUNCTION CALLS
$(document).ready(function(){
//    Helpers.autoGrowTextAreas();

    // OVERLAY EVENT HANDLERS
    $(window.document.body).append(Helpers.overlay);
    Helpers.overlay.click(Helpers.hideOverlay);

    // Keep the Overlay covering the document even if the window is resized
    $(window).resize(function(){
        if (Helpers._overlayVisible){
            Helpers._resizeOverlay();
        }
    })

    // FAKE PLACEHOLDERS
    if (!('placeholder' in document.createElement('input'))){
        var selector = 'input[placeholder], textarea[placeholder]'; // Selector for elements to generate placeholders
        var showPlaceholder = function(input){
            input.value = input.getAttribute('placeholder');
            $(input).addClass('fake_placeholder');            
        }
        var hidePlaceholder = function(input){
            input.value =  '';
            $(input).removeClass('fake_placeholder');            
        }        
        // Initialize the placeholders
        $(selector).each(function(index, input){
            if (input.value === ''){
                showPlaceholder(input);
            }
        })
        // Hide placeholder when the element gains focus
        $(selector).live('focus', function(event){
            if (this.value == this.getAttribute('placeholder')){
                hidePlaceholder(this);
            }
        });
        // Show placeholder if the element is blurred and the input is empty
        $(selector).live('blur', function(event){
            var input = this;
            if (input.value === ''){
                // Wait a moment so any onblur event handlers can fire before we change the
                // text back to the placeholder text in case we submit the value on blur
                setTimeout(function(){showPlaceholder(input)}, 100);
            }
        });        
        // Disable any elements with a fake placeholder if they are being submitted
        $('form').live('submit', function(event){
            $(this).find('.fake_placeholder').each(function(index, input){
                hidePlaceholder(input);
            })
        });
    }

    // FANCYBOX ON PHOTOGROUPS
	$(".photo .thumbnail").fancybox({
		'transitionIn'	:	'fade',
		'transitionOut'	:	'fade',
		'speedIn'		:	200, 
		'speedOut'		:	200,
		'overlayColor'  :   'black',
		'overlayOpacity':   0.5,
		'overlayShow'	:	true
	});    
});

// SMOOTH SCROLLING
// Make all anchor links on the page scroll smoothly
$('a[href*="#"]').live('click', function(event){
    var target = this.href.replace(/.+?#/,'');
    targetElement = $('#' + target)
    if (targetElement.length > 0){
        event.preventDefault();
        Helpers.scrollToElement(targetElement);
    }
});

// EVENTS
(function(){        
    $('.event .clickable').live('click', function(event){
        // Select the event if the user clicks on an event (but not an image in an event)
        if (event.target.nodeName != 'IMG'){
            var eventElement = $(this).parent('.event');
            eventElement.addClass('selected');
            Helpers.showOverlay();
            Helpers.currentlySelected = eventElement;
        }
    });
    // Remove the chapter from the DOM when the event is hidden
    $('.hide_event_link').live('click', function(event){
        $(this).parents('.event').remove();
        Helpers.hideOverlay();
    });                
}());


//CHAPTERS
(function(){
    // A function to select a chapter subtitle when the focus is in the chapter title input
    var getSubtitleInput = function(titleInput){
        return $(titleInput).closest('header').find('h3 .editable_chapter_heading')[0]
    }
    
    var updateChapter = function(chapter_id, attribute, value){
        var data = {}
        data[attribute] = value
        $.ajax({
            url: "chapters/" + chapter_id + ".js",
            data: data,
            type: 'PUT'
        });        
    }

    // Make all chapter titles editable, but ignore the update if the chapter title is empty
    $("h2 .editable_chapter_heading").live('change', function(event){
        if (this.value !== ''){
            updateChapter(this.getAttribute('data-chapter-id'), this.name, this.value);
        }
    });

    // Make all chapter subtitles editable
    $("h3 .editable_chapter_heading").live('change', function(event){
        updateChapter(this.getAttribute('data-chapter-id'), this.name, this.value);
    });

    // Track when the subtitle gains focus
    $("h3 .editable_chapter_heading").live('focus', function(event){
        $(this).addClass('focused');
    });

    // Track when the subtitle loses focus and hide it when it does if it has no contents
    $("h3 .editable_chapter_heading").live('blur', function(event){
        $(this).removeClass('focused');
        if (this.value == ''){
            $(this).parent().addClass('empty');
        } else {
            $(this).parent().removeClass('empty');
        }
    });

    // Make the subtitle focused when the user presses enter within a title
    $("h2 .editable_chapter_heading").live('keypress', function(event){
        if (event.keyCode == "13") {
            getSubtitleInput(this).focus();
        } 
    });

    // Blur the subtitle when the user presses enter
    $("h3 .editable_chapter_heading").live('keypress', function(event){
        if (event.keyCode == "13") {
            this.blur();
        } 
    });

    // Open the chapters menu when the user clicks the chapters link
    $('#chapter_index').click(function(event){
        event.preventDefault();
        $(this).toggleClass('open');
        $('#chapter_menu').toggle();
    });
    
    // Hide remove the chapter heading from the dom when the user deletes a chapter
    $('.delete_chapter_link').live('click', function(event){
        $(this).parents('.event').remove();
        Helpers.hideOverlay();
    });        
}());

// NOTES
(function(){
    $(".editable_note").live('change', function(event){
        var form = $(this).parents('form');
        var note = $(this).parents('.note');
        if (this.value === ''){
            note.addClass('empty');
        } else {
            note.removeClass('empty');
        }
        
        $.ajax({
            url: form[0].getAttribute('action'),
            data: form.serialize(),
            type: form[0].getAttribute('method')
        });
    });    
}());

// PHOTOS
(function(){
    // Remove the photo from the dom when the user clicks the delete photo link
    // Also remove the event from the dom if there are no other photos in the photo_group
    $(".delete_photo_link").live('click', function(event){
        var link = $(this);
        if (link.parents('.photo_group').find('.photo').length == 1){
            link.parents('.event').remove();
            Helpers.hideOverlay();
            event.stopPropagation(); // Prevent the event from receiving a click and turning the overlay on again.
        } else {
            link.parents('.photo').remove();            
        }
    });
}());


// OUTSIDE CLICKS
(function(){
    $(window.document.body).click(function(event){
        // Close the chapters menu when the user clicks outside of the menu
        if ($(event.target).closest('#chapter_index').length == 0){
            $('#chapter_index').removeClass('open');
            $('#chapter_menu').hide();
        }
    });
}());

// USERVOICE FEEDBACK
var uservoiceOptions = {
    key: 'autobiographer',
    host: 'autobiographer.uservoice.com', 
    forum: '90939',
    alignment: 'left',
    background_color:'#bd3131', 
    text_color: 'white',
    hover_color: '#0066CC',
    lang: 'en',
    showTab: true
  };
  function _loadUserVoice() {
    var s = document.createElement('script');
    s.src = ("https:" == document.location.protocol ? "https://" : "http://") + "cdn.uservoice.com/javascripts/widgets/tab.js";
    document.getElementsByTagName('head')[0].appendChild(s);
  }
  _loadSuper = window.onload;
  window.onload = (typeof window.onload != 'function') ? _loadUserVoice : function() { _loadSuper(); _loadUserVoice(); };
