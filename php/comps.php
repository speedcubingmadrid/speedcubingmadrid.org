<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if(isset( $_GET['region']))
    $chosenRegion = $_GET['region'];

if(isset( $_GET['years']))
    $chosenYear = $_GET['years'];

if(! $chosenRegion) $chosenRegion = 'France';
if(! $chosenYear) $chosenYear = date('Y');

$chosenRegion = urlencode($chosenRegion);
$chosenYear = urlencode("only+" + $chosenYear);

$file = fopen("https://www.worldcubeassociation.org/results/competitions.php?regionId=".$chosenRegion."&years=".$chosenYear, "r");

$comps = "[";
$one = false;
while (!feof ($file)) {
    $line = fgets ($file, 8192);

    if (preg_match ("/\<tr(.*)\>\<td\>(.*)\<\/td\>\<td\>(.*)\<\/td\>\<td\>\<a class=(.*) href='\/results\/c.php\?i=(.*)'\>(.*)\<\/a\>\<\/td\>\<td\>\<b\>(.*)\<\/b\>\, (.*)\<\/td\>\<td class\=\"f\"\>(.*)\<\/td\>\<\/tr\>/", $line, $out)) {
        if ($one)
            $comps .= ",";
        $comps .= '{"cid":"'.$out[5].'",';
        $comps .= '"city":"'.$out[8].'",';
        $comps .= '"date":"'.$out[3].'",';
        $comps .= '"year":"'.$out[2].'",';
        $comps .= '"name":"'.$out[6].'"';
        $comps .= '}';
        $one = true;
    }
}
$comps .= ']';
fclose($file);

print $comps;

?>
