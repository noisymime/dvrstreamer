<?php
$root = __DIR__;
$root = "/var/www/security";

$year = $_GET["year"];
$month = $_GET["month"];
$day = $_GET["day"];

$path = "/archive/".$year."/".$month."/".$day;

function is_in_dir($file, $directory, $recursive = true, $limit = 1000) {
    $directory = realpath($directory);
    $parent = realpath($file);
    $i = 0;
    while ($parent) {
        if ($directory == $parent) return true;
        if ($parent == dirname($parent) || !$recursive) break;
        $parent = dirname($parent);
    }
    return false;
}
/*
$path = null;
if (isset($_GET['file'])) {
    $path = $_GET['file'];
    if (!is_in_dir($_GET['file'], $root)) {
        $path = null;
    } else {
        $path = '/'.$path;
    }
}
*/
if (is_file($root.$path)) {
    readfile($root.$path);
    return;
}

?>
<form action="index.php" method="GET">

Year: <select name="year">
<option value="13">2013</option>
</select><br />
Month: <select name="month">
<option value="01">1</option>
<option value="02">2</option>
<option value="03">3</option>
<option value="04">4</option>
<option value="05">5</option>
<option value="06">6</option>
<option value="07">7</option>
<option value="08">8</option>
<option value="09">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
</select><br />
Day: <select name="day">
<option value="01">1</option>
<option value="02">2</option>
<option value="03">3</option>
<option value="04">4</option>
<option value="05">5</option>
<option value="06">6</option>
<option value="07">7</option>
<option value="08">8</option>
<option value="09">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
</select><br />

<input type="submit" value="Refresh">

</form>

<table>
<?php
$counter = 0;
echo  $root.$path.'/*';
foreach (glob($root.$path.'/*') as $file) {
    $file = realpath($file);
    $link = substr($file, strlen($root) + 1);
    
    if($counter == 3) {
        echo '</tr><tr>';
        $counter = 0;
    }

    echo '<td>';
    echo '<a href="?file='.urlencode($link).'">'.basename($file).'</a><br />';
    echo '<video width="320" height="240" preload="none" controls>'; 
    echo '<source src="/security'.$path.'/'.urlencode(basename($file)).'" type="video/mp4">'.basename($file).'</source>';
    echo '</video>';
    echo '</td>';

    $counter += 1;
}
?>
</table>
