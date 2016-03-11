//Build the score table from the rankings' json
//Please see https://github.com/speedcubingfrance/coupedefrance/script
//This whole stuff assumes there is a competitors selector with id "select-person",
//an event selector with id "select-event", and that the table body has id "tbody-score".
//It also there is an element with id "score-title" to be the placeholder for
//the table title.
//
// /!\ Depends on jQuery. /!\
//
//You can do whatever you want with this script, it's messy but it works,
//for questions please contact Philippe Virouleau (https://github.com/viroulep).
//(but be warned, I don't know javascript)

//Pretty names of event
var eventsNames = {"333":"Rubik's Cube",
                   "444":"4x4 Cube",
                   "222":"2x2 Cube",
                   "333bf":"3x3 Blindfolded",
                   "333oh":"3x3 One-Handed",
                   "pyram":"Pyraminx"
                   };

//Ordered events
var eventsIds = ["333", "444", "222", "333bf", "333oh", "pyram"]

//Array of ordered competitions
//The ranking-generating script export them sorted ! 
var competitionsInfo = [];

//Array of competitors {wcaId, name}, sorted by name
//Used by the selector
var competitors = [];

//Optionnal dictionary for competitors name : wcaId -> name
//Used to avoid searching the whole competitors array everytime we want a name
var competitorsNameFromId = {};

//Dictionary of competitors results, indexed on their wcaId
//wcaId -> {eventId -> (total_score, event_pos,
//                      comp_list[cid, score, counting, pos])}
var competitorsResults = {};

//Callback for jQuery's JSON loader
function cdf_load_json(data) {
  $.each( data, function( key, val ) {
    if (key == "competitions")
      competitionsInfo = val;
    if (key == "competitors")
      $.each(val, function(wcaId, field) {
        competitors.push({"wcaId":wcaId, "name":field.name});
        competitorsNameFromId[wcaId] = field.name;
        delete field.name;
        competitorsResults[wcaId] = field;
      });
    competitors.sort(comparePerson);
  });
  load_rankings("333", "", false)
}


//Format the name so that it fits in the array
function prettyName(fullName) {
  var retName = fullName.replace(" Open Rubik", "");
  retName = retName.replace(" 2015", "");
  retName = retName.replace(" 2016", "");
  retName = retName.replace(" Open", "");
  retName = retName.replace(" MariCubik", "");
  retName = retName.replace(" Megaminx", "");
  retName = retName.replace("Chambéry Cube", "Chambéry");
  retName = retName.replace("Open Cube Project", "OCP");
  retName = retName.replace(" Jeu et Jouet", "");
  retName = retName.replace("Galeries Dorian", "GD");
  retName = retName.replace("La Montagne", "LM");
  retName = retName.replace("V-CUBE ", "");
  retName = retName.replace("Galeries Lafayette", "GL");
  retName = retName.trim();
  retName = retName.replace(" ", "&nbsp;");
  return retName;
}

//To sort people by name
function comparePerson(a,b) {
  if (a.name < b.name)
    return -1;
  else if (a.name > b.name)
    return 1;
  else
    return 0;
}

//To sort a person's competitions by top rank
function compareCompetitionRanking(a, b) {
  if (a.event_pos < b.event_pos)
    return -1;
  else if (a.event_pos > b.event_pos)
    return 1;
  else
    return 0;
}

//Get a given competition's results from a competitions list
function getResForComp(comp_list, cid) {
  for (var i = 0; i < comp_list.length; i++)
    if (comp_list[i].comp_id == cid)
      return comp_list[i];
  return null;
}

function clear_html() {
  var defaultOption = "<option id=''>Sélectionnez...</option>";
  $("#select-person").empty();
  $("#select-person").append(defaultOption);
  $("#select-event").empty();
  $("#select-event").append(defaultOption);
  $("#tbody-score").empty();
  $("#score-title").empty();
}

//Fill in both selectors with competitors and events, selecting the one appropriate
function load_selectors(eventSelected, personSelected) {
  for (var i = 0; i < competitors.length; i++) {
    var selected = "";
    var html = "<option id='" + competitors[i].wcaId + "' ";
    if (competitors[i].wcaId == personSelected)
      html += "selected='selected'";
    html += " >" + competitors[i].name + "</option>"
    $("#select-person").append(html);
  }

  for (var i = 0; i < eventsIds.length; i++) {
    var selected = "";
    var html = "<option id='" + eventsIds[i] + "' ";
    if (eventsIds[i] == eventSelected)
      html += "selected='selected'";
    html += " >" + eventsNames[eventsIds[i]] + "</option>"
    $("#select-event").append(html);
  }
}

//Build and fill the score table's headers.
function load_table_header(eventSelected, personSelected) {
  var scoreHeader = "<tr><th>";
  scoreHeader += (personSelected.length == 0)?"#":"Position";
  scoreHeader += "</th><th>";
  scoreHeader += (personSelected.length == 0)?"Compétiteur":"Catégorie";
  scoreHeader += "<th>S</th>";
  scoreHeader += "</th>";
  for (var i = 0; i < competitionsInfo.length; i++) {
      scoreHeader += "<th class=\"opensize" + competitionsInfo[i].rank
		     + "\">&nbsp;" + prettyName(competitionsInfo[i].name) + "&nbsp;</th>";
  }
  scoreHeader += "<th>V</th></tr>";
  $("#tbody-score").prepend(scoreHeader);
}

//Build the score per competition list (rightmost part of the table)
function build_complist_scores(compList) {
  var html = "";
  //Count first places
  var nFirst = 0;
  for (var j = 0; j < competitionsInfo.length; j++) {
    var curCid = competitionsInfo[j].cid;
    var comp_res = getResForComp(compList, curCid);
    html += "<td>";
    if (comp_res) {
      if (comp_res.pos == 1)
        nFirst++;
      if (!comp_res.counting)
        html += "<s>";
      html += comp_res.score + " (" + comp_res.pos+ ")";
      if (!comp_res.counting)
        html += "</s>";
    } else
      html += "-";
    html += "</td>";
  }
  //Display first places
  html += "<td>";
  for (var j=0; j < nFirst; j++)
    html += "*";
  html += "</td>";
  return html;
}

function load_competitor_ranking(personSelected) {
  var resultsForPerson = competitorsResults[personSelected];
  //Build an event array to sort them by top ranked
  var eventArray = [];
  $("#score-title").append("Compétiteur " + competitorsNameFromId[personSelected]);
  $.each(resultsForPerson, function(eId, results) {
    eventArray.push({"eid":eId, "event_pos":results.event_pos});
  });
  eventArray.sort(compareCompetitionRanking);
  var scoreRows = "";
  for (var i = 0; i < eventArray.length; i++) {
    var curEid = eventArray[i].eid;
    var totalScore = resultsForPerson[curEid].total_score;
    var compListForEvent = resultsForPerson[curEid].comp_list;
    //TODO alternate color
    scoreRows += "<tr align='center'>";
    scoreRows += "<td>" + eventArray[i].event_pos + "</td>";
    scoreRows += "<td><a href=\"javascript:load_rankings('" + curEid + "', '', true)\">";
    scoreRows += eventsNames[curEid] + "</a>";
    scoreRows += "</td>";
    scoreRows += "<td>" + totalScore + "</td>";
    scoreRows += build_complist_scores(compListForEvent);
    scoreRows += "</tr>";
  }

  $("#tbody-score").append(scoreRows);
}

function load_event_rankings(eventSelected) {
  var resultsForEvent = [];
  $("#score-title").append("Catégorie " + eventsNames[eventSelected]);
  $.each(competitorsResults, function(wcaId, field) {
    var eventRes = field[eventSelected];
    if (eventRes)
      resultsForEvent.push({"wcaId":wcaId,
                            "total_score":eventRes.total_score,
                            "event_pos":eventRes.event_pos,
                            "comp_list":eventRes.comp_list});
  });
  resultsForEvent.sort(compareCompetitionRanking);
  var scoreRows = "";
  for (var i = 0; i < resultsForEvent.length; i++) {
    var nFirst = 0;
    scoreRows += "<tr align='center'>";
    var curRes = resultsForEvent[i];
    scoreRows += "<td>" + curRes.event_pos + "</td>";
    scoreRows += "<td><a href=\"javascript:load_rankings('', '" + curRes.wcaId + "', true)\">";
    scoreRows += competitorsNameFromId[curRes.wcaId];
    scoreRows += "</td>";
    scoreRows += "<td>" + curRes.total_score + "</td>";
    scoreRows += build_complist_scores(curRes.comp_list);
    scoreRows += "</tr>";
  }
  $("#tbody-score").append(scoreRows);
}

function load_rankings(eventSelected, personSelected, jumpToResults) {
  //FIXME for selectors we could just unselect/select the correct one instead
  //of rebuilding the whole thing
  clear_html();
  load_selectors(eventSelected, personSelected);
  load_table_header(eventSelected, personSelected);
  if (eventSelected.length > 0)
    load_event_rankings(eventSelected);
  else if (personSelected.length > 0)
    load_competitor_ranking(personSelected);
  else
    $("#tbody-score").append("<tr><td>No event or competitor selected !</td></tr>");
  if (jumpToResults)
    location.hash = "#planning";
}
