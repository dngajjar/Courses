var height;
var width;
var currentImage;

$(document).ready(function() {
    $("#slider").slider({
        slide: function(event, ui){
            resizeImage(1-ui.value*.01);
        }
    });
    selectImage(1);
});

function loadImg(url, height, width, id, func) {
    var img = new Image();
    img.onload = func;
    img.id = id;
    img.src = url;
    if(width == 0){
        img.height = height;
    }
    else{ // TOTAL HACK
        img.width = width;
    }
    return img;
};

function loadImageParams() {
    height = $(this).height();
    width = $(this).width();
};

function resizeImage(percent) {
    var newHeight = height*percent;
    var newWidth = width*percent;
    $("#currentImage").css({height: newHeight, width: newWidth});
    var verticalMargin = (height-newHeight)/2;
    $("#currentImage").css({top: verticalMargin, bottom: verticalMargin});
};

function selectImage(imageNum) {
    $("#currentImage").remove();
    var newImage = loadImg("results/"+imageNum+".jpg", 400, 0, "currentImage", loadImageParams);
    newImage.style.position = "relative";
    $(newImage).appendTo("#imageResize");
    loadSourceImages(imageNum);
    $("#slider").slider("option", "value", 0);
};

