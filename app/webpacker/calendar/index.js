import 'fullcalendar';
import { API_COMP_URL } from 'afs/url_utils';

var moment = require("moment");

window.afs = window.afs || {};

window.afs.initCalendar = function() {
  $(".enable-calendar").each(function() {
    $(this).fullCalendar({
      locale: "fr",
      eventDataTransform: externalEventToFcEvent,
      buttonText: {
        today:    'aujourd\'hui',
        month:    'mois',
        week:     'semaine',
        day:      'jour',
        list:     'liste'
      },
      header: {
          left:   'today',
          center: 'prev title next',
          right:  'prevYear,nextYear'
      },
      eventSources: [
        {
          events: getWcaCompetitions,
          color: "#28a745",
        }
      ],
      eventClick: function(event) {
        if (event.url) {
          window.open(event.url);
          return false;
        }
      },
    });
    // Prevent the turbolink reload from enabling twice the calendar on the same element.
    $(this).removeClass("enable-calendar");
  });
}


function getWcaCompetitions(start, end, timezone, callback) {
  let requestUrl = API_COMP_URL;
  let dateFormat = "YYYY-MM-DD";
  requestUrl += `?country_iso2=FR&start=${start.format(dateFormat)}&end=${end.format(dateFormat)}`;
  $.get(requestUrl, function(data) {
    callback(data);
  })
  .fail(function() {
    console.error("Could not fetch data from url '"+requestUrl+"'");
  });
}

function externalEventToFcEvent(eventData) {
  if (eventData.class === "competition") {
    eventData.title = eventData.name;
    eventData.start = eventData.start_date;
    eventData.allDay = true;
    let endDate = moment(eventData.end_date);
    // 'end' is an *exclusive* end date, meaning we need to add one
    endDate.add(1, 'd');
    eventData.end = endDate.format("YYYY-MM-DD");
  }
  return eventData;
}
