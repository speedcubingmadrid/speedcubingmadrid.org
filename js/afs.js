
function menu_list(data) {
  var htmlmenu = "";
  $.each( data, function( key, val ) {
    htmlmenu += "<li>" + val.date + " " + val.year + "<br/>";
    htmlmenu += "<a href=\"https://www.worldcubeassociation.org/results/c.php?i=";
    htmlmenu += val.cid + " target=\"_blank\">" + val.name + "</a></li>";
  });
  $("#side-compet").html(htmlmenu);
}

function get_comps(year, region, callback) {
  var baseUrl = "http://speedcubingfrance.org/php/comps.php?region=" + region + "&years=" + year;
  $.getJSON(baseUrl, callback);
}
