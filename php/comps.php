<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$chosenRegion = 'France';
if(isset($_GET['region']))
    $chosenRegion = $_GET['region'];

$chosenYear = date('Y');
if(isset($_GET['years']))
    $chosenYear = $_GET['years'];


$chosenRegion = urlencode($chosenRegion);
$chosenYear = urlencode($chosenYear);


$file = fopen("https://www.worldcubeassociation.org/competitions?region=".$chosenRegion."&years=".$chosenYear."&list=list", "r");
$months = array_flip( explode( ' ', '. Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec' ));

$comps = "[";
$one = false;

$inComp = false;
$currentComp = array();
while (!feof ($file)) {
    $line = fgets ($file, 8192);
    if (preg_match("/(.*)\<span class=\"date\"\>(.*)\<\/span\>/", $line, $out)) {
        $inComp = true;
        if ($one)
            $comps .= ",";
        $one = true;
        $comps .= '{';
        $matches = explode(",", $out[2]);
        $comps .= '"date":"'.$matches[0].'",';
        $year = str_replace(' ', '', $matches[1]);
        $comps .= '"year":"'.$year.'",';
        $daymonth = explode("-", $matches[0]);
        $daymonth = explode(" ", $daymonth[0]);
        $comps .= '"timestamp":"'.mktime(0, 0, 0, $months[$daymonth[0]], $daymonth[1], $year).'",';
    }
    if (!$inComp)
        continue;

    if (preg_match("/(.*)\<p class=\"competition-link\"\>\<a href=\"\/competitions\/(.*)\"\>(.*)\<\/a\>(.*)/", $line, $out)) {
        $comps .= '"cid":"'.$out[2].'",';
        $comps .= '"name":"'.$out[3].'",';
    }

    if (preg_match("/(.*)\<p class=\"location\"\>\<strong\>(.*)\<\/strong\>, (.*)\<\/p\>/", $line, $out)) {
        $comps .= '"country":"'.$out[2].'",';
        $comps .= '"city":"'.$out[3].'"}';
        $inComp = false;
    }
}
$comps .= ']';
fclose($file);

print $comps;

?>
