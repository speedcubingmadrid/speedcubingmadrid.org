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
    if (preg_match("/(.*)\<span class=\"date\"\>(.*)/", $line, $out)) {
        $inComp = true;
        if ($one)
            $comps .= ",";
        $one = true;
        $comps .= '{';
    }
    if (!$inComp)
        continue;
    if (feof($file))
        break;

    // Consume <i title=blabla
    $line = fgets ($file, 8192);

    // Consume the line date
    $line = fgets ($file, 8192);
    $matches = explode(",", $line);
    $year = trim($matches[1]);
    $comps .= '"date":"'.trim($matches[0]).'",';
    $comps .= '"year":"'.$year.'",';
    $daymonth = explode("-", trim($matches[0]));
    $daymonth = explode(" ", $daymonth[0]);
    $comps .= '"timestamp":"'.mktime(0, 0, 0, $months[$daymonth[0]], $daymonth[1], $year).'",';

    // Consume until the competition link
    while (!feof($file) &&
           !preg_match("/(.*)\<a href=\"\/competitions\/(.*)\"\>(.*)\<\/a\>(.*)/", $line, $out))
        $line = fgets($file, 8192);
    $comps .= '"cid":"'.$out[2].'",';
    $comps .= '"name":"'.$out[3].'",';

    // Consume until the location
    while (!feof($file) &&
           !preg_match("/(.*)\<p class=\"location\"\>\<strong\>(.*)\<\/strong\>, (.*)\<\/p\>/", $line, $out))
        $line = fgets($file, 8192);
    $comps .= '"country":"'.$out[2].'",';
    $comps .= '"city":"'.$out[3].'"}';
    $inComp = false;
}
$comps .= ']';
fclose($file);

print $comps;

?>
