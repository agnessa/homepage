var Homepage = {
  init: function(){
    $('#roundabout').roundabout({
      shape : 'tearDrop',
      minScale : 0.6
    });
    Homepage.populateDataSources();
  },
  populateDataSources: function(){
    $('.info_box').each(function(idx, ele){
      $.ajax({
        url: '/info/'+ele.id,
        dataType: 'json',
        success: function(data){
          $.each(data, function(key, value){
            var element = $('#'+key);
            var tagName = (element.length == 0 ? '' : element[0].tagName.toLowerCase());
            if(tagName == 'img'){
              element.attr('src', value);
            } else if(tagName == 'a'){
              element.attr('href', value);
            } else if(tagName == 'table'){
              $.each(value, function(idx, item){
                element.append('<tr><th>' + item[0] + '</th><td>' + item[1] + '</td></tr>');
              });
            } else {
              element.text(value);
            }
          })
        }
    });

    });
  }
}

$(document).ready(function() {
  Homepage.init();
});