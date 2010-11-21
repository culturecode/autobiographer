// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


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

// Make the chapter subtitle disappear if it is blank when we finish editing the chapter title
$("h2 .editable_chapter_heading").live('blur', function(event){
    var input = $(this);
    setTimeout(function(){
        var subtitle = input.closest('header').find('h3 .editable_chapter_heading')[0];
        if (subtitle.value == '' && !$(subtitle).hasClass('focused')){
            $(subtitle).parent().hide();
        }
    }, 100);
});

// Make the chapter subtitle appear when editing the chapter title
$("h3 .editable_chapter_heading").live('focus', function(event){
    $(this).addClass('focused');
});

$("h3 .editable_chapter_heading").live('blur', function(event){
    $(this).removeClass('focused');
    if (this.value == ''){
        $(this).parent().hide();
    }
});
