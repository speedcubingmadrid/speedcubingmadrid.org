
var wcaBaseUrlComp = "https://www.worldcubeassociation.org/competitions/";
var localComps = {};

//Create a menu from official comps data
function menu_list(fullYear, region, data) {
  var htmlmenu = "";
  $.each( data, function( key, val ) {
    var s = val.start_date.split("-")
    var e = val.end_date.split("-")
    // We most likely won't have a competition on new year's eve.
    var year = s[0];
    var month = s[1];
    var day = s[2];
    var e_day = e[2];
    var e_month = e[1];
    console.log(e_month);
    console.log(mois(0));
    htmlmenu += "<li>" + day;
    if (month != e_month)
      htmlmenu += " " + mois(parseInt(month)-1);
    htmlmenu += " - " + e_day + " " + mois(parseInt(e_month)-1) + " " + year + "<br/>";
    htmlmenu += "<a href=\"" + wcaBaseUrlComp;
    htmlmenu += val.id + "\" target=\"_blank\">" + val.name + "</a></li>";
  });
  $("#side-compet").html(htmlmenu);
}

//Get monday in a given week
function mondayInWeek(year, week) {
  var first_date = new Date(year, 0, 4, 0, 0, 0);
  var weekday = first_date.getDay();
  first_date.setTime(first_date.getTime() - 86400000 * (weekday - 1) + 604800000 * (week - 1));
  first_date.setHours(0);
  first_date.setMinutes(0);
  first_date.setSeconds(0);
  return first_date;
}

//Get sunday in a given week
function sundayInWeek(year, week) {
  var monday = mondayInWeek(year, week);
  //Go forward to sunday
  monday.setTime(monday.getTime() + 86400000 * 6);
  return monday;
}

//Translation int->label table
function mois(month){
  var moiss = 'Jan. Fév. Mars Avril Mai Juin Juil. Août Sept. Oct. Nov. Déc.'.split(' ');
  return moiss[month];
}

//Generate the region/year selector for the calendar
function generate_selector(year, region) {
  var currentYear = new Date().getFullYear();
  var html = "<tr><label for='region'><th>Region : </th>";

  //Selector for regions
  html += "<td><select id='region' name='region'>";
  //FIXME using no country id is "broken", we need to go through all the pages.
  var regions = {"FR":"France"};

  $.each(regions, function(key, val) {
    html += "<option value='" + key + "' ";
    if (region == key)
      html += "selected='selected' ";
    html += ">" + val + "</option>";
  });
  html += "</select></td></label>";

  //Selector for years
  html += "<label for='years'><th> - Année : </th>";
  html += "<td><select id='years' name='years'>";

  for (var i = currentYear - 1; i <= currentYear + 1; i++) {
    html += "<option value='" + i + "-01-01' ";
    if (parseInt(year) == i)
      html += "selected='selected' ";
    html += ">" + i + "</option>";
  }
  html += "</select></td></label>";

  //Form validation
  html += "<td><input onclick='loading();";
  html += "get_comps($(\"#years\").val(), $(\"#region\").val(), generate_calendar);";
  html += "' type='submit' id='filter' name='filter' value='Filtrer' /></td></tr>";
  $("#selector-calendar").html(html);
}

//Main logic to generate the calendar
function generate_calendar(fullYear, region, data) {
  var html = "<tr>";
  var year = fullYear.split("-")[0];
  var week = 0;
  var currentMonth = -1;
  //Hihi
  while (1) {
    var monday = mondayInWeek(year, week);
    var sunday = sundayInWeek(year, week);
    //Unfortunately, I don't think someone can play with it and get an infinite loop
    if (sunday.getFullYear() != parseInt(year))
      break;
    if (currentMonth != sunday.getMonth()) {
      //We reached the beginning of a month, new row+header
      currentMonth = sunday.getMonth();
      html += "</tr><tr><th>" + mois(currentMonth) + "</th>";
    }
    html += "<td style='width:20%;'><a class='mod'>";
    //Trick to left-pad the days
    html += ("0" + monday.getDate()).slice(-2) + "/";
    html += ("0" + (monday.getMonth() + 1)).slice(-2) + " - ";
    html += ("0" + sunday.getDate()).slice(-2) + "/";
    html += ("0" + (sunday.getMonth() + 1)).slice(-2);
    html += "</a><br/>";
    //Save official names, so that we don't display the same "local" comp
    var names = [];

    //Look for potential official comps to display
    $.each(data, function(key, val) {
      var datecomp = new Date(val.start_date);
      if (datecomp >= monday && datecomp < mondayInWeek(year, week+1)) {
        //Change the class depending on the country
        html += '<span class="' + ((val.country_iso2 == "FR")?'fr':'other') + '">';
        html += '<a href="' + wcaBaseUrlComp + val.id + '" target="_blank">' + val.short_name + '</a> - ';
        html += (val.country_iso2 == "FR")?val.city:val.country_iso2;
        html += '</span>';
        names.push(val.short_name);
      }
    });

    //Look for potential unofficial comps to display
    $.each(localComps, function(key, val) {
      var valDate = new Date(val.year, (val.month - 1), val.day);
      if (valDate.getTime() >= monday.getTime() && valDate.getTime() <= sunday.getTime() &&
          names.indexOf(val.name) == -1) {
        html += '<span class="reg">';
        html += val.name + ' - ';
        html += val.city;
        html += '</span>';
      }
    });
    html += "</td>";
    week++;
  }
  html += "</tr>";
  $("#calendar").html(html);
}

function get_comps(year, region, callback) {
  // Use WCA API to get the list of competitions.
  var baseUrl = "https://www.worldcubeassociation.org/api/v0/competitions?sort=-start_date&country_iso2=" + region + "&start=" + year;
  $.getJSON(baseUrl, function(data) {
    callback(year, region, data);
  });
}

function loading() {
  $("#calendar").html("<tr><th>Chargement en cours...</th></tr>");
}
