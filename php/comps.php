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


$file = fopen("https://www.worldcubeassociation.org/results/competitions.php?regionId=".$chosenRegion."&years=only%2B".$chosenYear."&list=list", "r");
$months = array_flip( explode( ' ', '. Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec' ));

$comps = "[";
$one = false;
while (!feof ($file)) {
    $line = fgets ($file, 8192);

    if (preg_match ("/\<tr(.*)\>\<td\>(.*)\<\/td\>\<td\>(.*)\<\/td\>\<td\>\<a class=(.*) href='\/results\/c.php\?i=(.*)'\>(.*)\<\/a\>\<\/td\>\<td\>\<b\>(.*)\<\/b\>\, (.*)\<\/td\>\<td class\=\"f\"\>(.*)\<\/td\>\<\/tr\>/", $line, $out)) {
        if ($one)
            $comps .= ",";
        $date = $out[3];
        $t = explode( ' ', $date);
        $month = $months[$t[0]];
        $t = explode( '-', $t[1] );
        $day = $t[0];
        $comps .= '{"cid":"'.$out[5].'",';
        $comps .= '"city":"'.$out[8].'",';
        $comps .= '"timestamp":"'.mktime( 0, 0, 0, $month, $day, $chosenYear).'",';
        $comps .= '"date":"'.$date.'",';
        $comps .= '"year":"'.$out[2].'",';
        $comps .= '"country":"'.$out[7].'",';
        $comps .= '"name":"'.$out[6].'"';
        $comps .= '}';
        $one = true;
    }
}
$comps .= ']';
fclose($file);

print $comps;

?>
