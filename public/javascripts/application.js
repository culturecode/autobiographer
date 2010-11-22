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
    }    
}

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


//CHAPTERS
// Make all chapter headings editable
$(".editable_chapter_heading").live('change', function(event){
    if (this.value == '')
        return;
        
    var data = {}
    data[this.name] = this.value
    $.ajax({
        url: "chapters/" + this.getAttribute('data-chapter-id'),
        data: data,
        type: 'PUT'
    });
});

// Make the chapter subtitle appear when editing the chapter title
$("h2 .editable_chapter_heading").live('focus', function(event){
    $(this).closest('header').children('h3').show();
});

// Make the chapter subtitle disappear if it is blank when we finish editing the chapter title, unless it has focus
$("h2 .editable_chapter_heading").live('blur', function(event){
    var input = $(this);
    // Wait a moment in case the user has clicked on the subtitle (we don't want to hide the subtitle in that case)
    setTimeout(function(){
        var subtitle = input.closest('header').find('h3 .editable_chapter_heading')[0];
        if (subtitle.value == '' && !$(subtitle).hasClass('focused')){
            $(subtitle).parent().hide();
        }
    }, 100);
});

// Track when the subtitle gains focus
$("h3 .editable_chapter_heading").live('focus', function(event){
    $(this).addClass('focused');
});

// Track when the subtitle loses focus and hide it when it does if it has no contents
$("h3 .editable_chapter_heading").live('blur', function(event){
    $(this).removeClass('focused');
    if (this.value == ''){
        $(this).parent().hide();
    }
});

// Open the chapters menu when the user clicks the chapters link
$('#chapter_index').click(function(event){
    event.preventDefault();
    $(this).toggleClass('open');
    $('#chapter_menu').toggle();
    
});

// OUTSIDE CLICKS
$(window.document.body).click(function(event){
    // Close the chapters menu when the user clicks outside of the menu
    if ($(event.target).closest('#chapter_index').length == 0){
        $('#chapter_index').removeClass('open');
        $('#chapter_menu').hide();
    }
});