<?php
$dt = new DateTime();
echo "Today is ". date("l"). " " . date("d-m-Y") . "<br>";
echo "And time now is ". $dt->format('H:i:s');
?>
