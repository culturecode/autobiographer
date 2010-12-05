// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// DOM READY FUNCTION CALLS
$(document).ready(function(){
//    Helpers.autoGrowTextAreas();
});

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
            textarea.style.height = sizerHeight + 'px'
        } else {
            textarea.style.height = '';
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
$(document).ready(function(){
    $(window.document.body).append(Helpers.overlay);
    Helpers.overlay.click(Helpers.hideOverlay);
    
    // Keep the Overlay covering the document even if the window is resized
    $(window).resize(function(){
        if (Helpers._overlayVisible){
            Helpers._resizeOverlay();
        }
    })
});

// EVENT HANDLERS

    // SMOOTH SCROLLING
    // Make all anchor links on the page scroll smoothly
    $('a[href*="#"]').live('click', function(event){
        var target = this.href.replace(/.+?#/,'');
        targetElement = $('[name="' + target + '"]')
        if (targetElement){
            event.preventDefault();
            Helpers.scrollToElement(targetElement);
        }
    });

// EVENTS
(function(){        
    $('.event .clickable').live('click', function(event){
        var eventElement = $(this).parent('.event');
        eventElement.addClass('selected');
        Helpers.showOverlay();
        Helpers.currentlySelected = eventElement;
    });    
}());


//CHAPTERS
(function(){
    // A function to select a chapter subtitle when the focus is in the chapter title input
    var getSubtitleInput = function(titleInput){
        return $(titleInput).closest('header').find('h3 .editable_chapter_heading')[0]
    }

    // Make all chapter headings editable
    $(".editable_chapter_heading").live('change', function(event){
        if (this.value == '')
            return;

        var data = {}
        data[this.name] = this.value
        $.ajax({
            url: "chapters/" + this.getAttribute('data-chapter-id') + ".js",
            data: data,
            type: 'PUT'
        });
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