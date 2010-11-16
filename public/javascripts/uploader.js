$(function() {
    var csrf_param = $('meta[name=csrf-param]').attr('content');
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    var multipart_params = {"format" : "js"};
    multipart_params[csrf_param] = csrf_token;
    
    var uploader = new plupload.Uploader({
        runtimes : 'gears,html5,flash,silverlight,browserplus',
        browse_button : 'pickfiles',
        drop_element: 'dropfiles',
        container : 'container',
        max_file_size : '20mb',
        url : '/uploads/photos',
        flash_swf_url : '/plupload/plupload.flash.swf',
        silverlight_xap_url : '/plupload/plupload.silverlight.xap',
        filters : [
        {title : "Image files", extensions : "jpg,gif,png"},
        {title : "Zip files", extensions : "zip"}
        ],
        multipart: true,  
        multipart_params : multipart_params,
        resize : {width : 320, height : 240, quality : 90}
    });

    uploader.bind('Init', function(up, params) {
        $('#filelist').html("<div>Current runtime: " + params.runtime + "</div>");
    });

    uploader.init();

    uploader.bind('FilesAdded', function(up, files) {
        $.each(files, function(i, file) {
            $('#filelist').append(
                '<div id="' + file.id + '">' +
                file.name + ' (' + plupload.formatSize(file.size) + ') <b></b>' +
                '</div>');
            });

            up.refresh(); // Reposition Flash/Silverlight
            up.start();
        });

        uploader.bind('UploadProgress', function(up, file) {
            $('#' + file.id + " b").html(file.percent + "%");
        });

        uploader.bind('Error', function(up, err) {
            $('#filelist').append("<div>Error: " + err.code +
            ", Message: " + err.message +
            (err.file ? ", File: " + err.file.name : "") +
            "</div>"
        );

        up.refresh(); // Reposition Flash/Silverlight
    });

    uploader.bind('FileUploaded', function(up, file, response) {
        console.log(response.response);
        $('#' + file.id + " b").html("100%");
    });
});