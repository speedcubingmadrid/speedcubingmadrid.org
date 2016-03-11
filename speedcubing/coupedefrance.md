---
layout: page
title: Coupe de France
section:
    - speedcubing
permalink: /speedcubing/coupedefrance/
---
La coupe de France de cube est une épreuve annuelle autour des compétitions officielles de Rubik's Cube. Elle prend la forme d'un classement général pour différentes épreuves officielles de la WCA.

Ce classement prend en compte les résultats des compétitions se tenant sur le sol français dans une même année civile, à savoir du 1er janvier au 31 décembre de la même année, la remise des prix ayant lieu lors de la dernière compétition française chaque année.

La Coupe est un événement organisé par l'AFS. Tout compétiteur sera automatiquement inscrit et classé pour la coupe de France, en revanche un malus sera attribué aux non-membres de l'AFS.

La finalité est d'avoir une continuité entre toutes les compétitions françaises d'une même année et ainsi de récompenser les personnes les plus régulièrement présentes et performantes, par opposition aux championnats ou tournois qui consacrent un vainqueur ponctuel relativement aux adversaires présents
ce jour-là.

Le [présent règlement]({{site.baseurl}}/uploads/reglementCDFDC_2015.pdf) définit l'ensemble des éléments permettant le déroulement de cette Coupe de France Kingscube. Il est établi pour l'ensemble de la Coupe, et donc l'année en cours.


### Classement

<span style="color:red">Attention : le malus de 10pts pour les non-adhérents n'est pas encore pris en compte.</span>


<script src="{{site.baseurl}}/js/jquery-1.12.1.min.js"></script>
<script src="{{site.baseurl}}/js/cdf.js"></script>
<script>
$.getJSON("{{site.baseurl}}/uploads/rankings.json", cdf_load_json);
</script>


<h4 id="score-title">Classement</h4>

<form method="get" action="">
<table id="planning" cellspacing="0" cellpadding="0">
<tr>
<th>Catégorie : </th>
<td><select id="select-event" class="drop" name="event" onChange="load_rankings(this.options[this.selectedIndex].id, '', true);">
<option id="">Sélectionnez...</option>
</select>
</td>
<th>Compétiteur :</th>
<td><select id="select-person" name="person" class="drop" onChange="load_rankings('', this.options[this.selectedIndex].id, true);">
<option id="">Sélectionnez...</option>
</select>
</td>
</tr>
</table>
</form>



<table id="planning" style="width:100%;font-size: 0.8em;">
<tbody id="tbody-score">
</tbody>
</table>

**Légende** : S = Score, V = Victoires. Compétitions <span class='opensize0'>mineures</span>, <span class='opensize1'>intermédiaires</span> et <span class='opensize2'>majeures</span>.



