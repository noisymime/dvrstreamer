<head>
<link rel="stylesheet" type="text/css" href="screen.css">
</head>

<?php
$root = __DIR__;
$root = "/var/www/security";

$year = date("y");
$month = date("m");
$day = date("d");

if(isset($_GET['year'])) { $year = $_GET["year"]; }
if(isset($_GET['month'])) { $month = $_GET["month"]; }
if(isset($_GET['day'])) { $day = $_GET["day"]; }

$month = str_pad($month,2,'0',STR_PAD_LEFT);
$day = str_pad($day,2,'0',STR_PAD_LEFT);

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

function human_filesize($bytes, $decimals = 2) {
    $sz = 'BKMGTP';
    $factor = floor((strlen($bytes) - 1) / 3);
    return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor)) . @$sz[$factor];
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
<option value="<?php echo date("y") ?>"><?php echo date("Y") ?></option>
</select><br />
Month: <select name="month">
<?php
for ($i = 1; $i <= 12; $i++) {
  if ($i == intval($month) ) { echo "<option selected='selected' value=".$i.">".$i."</option>"; }
  else { echo "<option value=".$i.">".$i."</option>"; }
}
?>
</select><br />
Day: <select name="day">
<?php
for ($i = 1; $i <= 31; $i++) {  
  if ($i == intval($day) ) { echo "<option selected='selected' value=".$i.">".$i."</option>"; }
  else { echo "<option value=".$i.">".$i."</option>"; }
}
?>
</select><br />

<input type="submit" value="Refresh">

</form>

<center>
<table id="video-table">
<?php

$date_string = new DateTime($month.'/'.$day.'/'.$year);
$date_string = date_format($date_string, 'l \t\h\e jS \o\f F');
echo '<tr><th colspan=3>'.$date_string.'</th></tr>';

$counter = 0;
foreach (glob($root.$path.'/*') as $file) {
    $file = realpath($file);
    $link = substr($file, strlen($root) + 1);
    
    if($counter == 3) {
        echo '</tr><tr>';
        $counter = 0;
    }

    echo '<td><center>';
    echo '<a href="/security'.$path.'/'.urlencode(basename($file)).'">'.basename($file).' ('.human_filesize(filesize($file)).')</a><br />';
    echo '<video width="320" height="240" preload="none" controls>'; 
    echo '<source src="/security'.$path.'/'.urlencode(basename($file)).'" type="video/mp4">'.basename($file).'</source>';
    echo '</video>';
    echo '</center></td>';

    $counter += 1;
}
?>
</table>
</center>
