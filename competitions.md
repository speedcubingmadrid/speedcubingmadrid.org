---
layout: page
title: Calendrier des compétitions
section: competitions
permalink: /competitions/
---

Voici un planning des compétitions officielles et non officielles.
Les compétitions officielles sont automatiquement ajoutées ici dès leur parution sur le site de la WCA.
Il est possible d'ajouter un projet de compétition à une certaine date, avant son officialisation, pour aider les autres organisateurs à plannifier leur compétition et pour éviter les chevauchements de compétitions.
Pour ajouter, modifier ou supprimer une compétition, merci d'écrire à notre adresse de [contact](mailto:contact@speedcubingfrance.org).


<form action="javascript:void(0);">
<table id="selector-calendar" class="planning">
</table>
</form><br/><span class='fr'>Compétitions françaises officielles</span><span class='reg'>Compétitions non officielles</span>
<table id="calendar" class="planning">
</table>

<script>
generate_selector("2016", "FR");
loading();
$.getJSON("{{site.baseurl}}/uploads/comps.json", function(data) {
    //Load local unofficial comps and display calendar
    localComps = data;
    get_comps("2016-01-01", "FR", generate_calendar);
});
</script>

