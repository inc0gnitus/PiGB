<html>
<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
<head>
<style> 
.blue-submit {
  background-color: blue;
  border: none;
  color: white;
  padding: 16px 32px;
  text-decoration: none;
  margin: 4px 2px;
  cursor: pointer;
}
.red-submit {
  background-color: red;
  border: none;
  color: white;
  padding: 16px 32px;
  text-decoration: none;
  margin: 4px 2px;
  cursor: pointer;
}
</style>

</style>
</head>
<body>
<center>
<h1 style="font-size:5vw">PiGB - Raspberry Pi Ghostbox</h1> 
<br><br>
<form action="" method="POST">
<table border=0>
<tr><td>Ghostbox Engine:</td><td><select id="engine" name="engine">
<option value="rtl_gb" <?php if (isset($_POST['engine']) && $_POST['engine'] == "rtl_gb") echo "selected" ?> >rtl_gb - rtlsdrblog</option>
</select></td></tr>
<tr><td>Hop Mode:</td> <td><select id="hopmode" name="hopmode">
<option value="0" <?php if (isset($_POST['hopmode']) && $_POST['hopmode'] == "0") echo "selected" ?> >Hop Random Freqs</option>
<option value="1" <?php if (isset($_POST['hopmode']) && $_POST['hopmode'] == "1") echo "selected" ?>>Hop Sequential</option>
<option value="2" <?php if (isset($_POST['hopmode']) && $_POST['hopmode'] == "2") echo "selected" ?>>Hop Sequential Rev</option>
</select></td></tr>
<tr><td>Modulation:</td><td> <select id="modulation" name="modulation">
<option value="wbfm" <?php if (isset($_POST['modulation']) && $_POST['modulation'] == "wbfm") echo "selected" ?>>WBFM</option>
<option value="fm" <?php if (isset($_POST['modulation']) && $_POST['modulation'] == "fm") echo "selected" ?>>FM</option>
<option value="am" <?php if (isset($_POST['modulation']) && $_POST['modulation'] == "am") echo "selected" ?>>AM</option>
</select></td></tr>
<tr><td>Gain (0 for automatic):</td><td> <input size=3 type=text value="<?php if (isset($_POST['gain'])) { echo $_POST['gain']; } else { echo "0"; }?>" name="gain"></td></tr>
<tr><td>Sample rate:</td><td> <input size=6 type=text value="<?php if (isset($_POST['samplerate'])) { echo $_POST['samplerate']; } else { echo "260k"; }?>" name="samplerate"></td></tr>
<tr><td>Resample rate:</td><td> <input size=6 type=text value="<?php if (isset($_POST['resamplerate'])) { echo $_POST['resamplerate']; } else { echo "32000"; }?>" name="resamplerate"></td></tr>
<tr><td>Frequency range::</td><td> <input size=15 type=text value="<?php if (isset($_POST['frequency'])) { echo $_POST['frequency']; } else { echo "88M:108M:25k"; }?>" name="frequency"></td></tr>
<tr><td>Hop delay (in ms,-1 for random):</td><td> <input size=4 type=text value="<?php if (isset($_POST['hopdelay'])) { echo $_POST['hopdelay']; } else { echo "-1"; }?>" name="hopdelay"></td></tr>
<tr><td>Run time (minutes, 0 to run until manual stop):</td><td> <input size=4 type=text value="<?php if (isset($_POST['minutes'])) { echo $_POST['minutes']; } else { echo "0"; }?>" name="minutes"></td></tr>
<tr><td>Volume (+/-, ex +5):</td><td> <input size=4 type=text value="<?php if (isset($_POST['volume'])) { echo $_POST['volume']; } else { echo "0"; }?>" name="volume"></td></tr>
<tr><td>Noise Reduction Profile:</td><td><select id="noiseprof" name="noiseprof">
<option value="none" <?php if (isset($_POST['noiseprof']) && $_POST['noiseprof'] == "none") echo "selected" ?> >None</option>
<?php
foreach (glob("/var/www/html/gb/noiseprof/*.rnnn") as $filename) {
	$filename = basename($filename);
?>
	<option value=<?php echo $filename ?> <?php if (isset($_POST['noiseprof']) && $_POST['noiseprof'] == basename($filename)) echo "selected" ?>> <?php echo $filename ?> </option>
<?php
}
?>
</select></td></tr>
<tr><td>Record to WAV: </td><td><input type="checkbox" name="record" value="1" <?php if (isset($_POST['record'])) echo "checked" ?>></td></tr>
<tr><td>Stream to Icecast: </td><td><input type="checkbox" name="stream" value="1" <?php if (isset($_POST['stream'])) echo "checked" ?>></td></tr>
<tr><td colspan="2" align="center"><input type="submit" value="Start" name="Start" class="blue-submit"/> <input type="submit" value="Stop" name="Stop" class="blue-submit"/></td></tr>
<tr><td colspan="2" align="center"><input type="submit" value="Shutdown" name="Shutdown" class="red-submit"/> <input type="submit" value="Reboot" name="Reboot" class="red-submit"/> </td></tr>
</table>
</form>
<a href="/gb/recordings">Recordings</a> | <a href="/gb/index.php">SoX Web Interface</a>
<br><br>
</center>
<?php
    if (isset($_POST['Start'])) {
		$output=null;
		$retval=null;
		$dorecord=null;
		$dostream=null;
		if (filter_has_var(INPUT_POST,'record')) {
			$dorecord = "1";
		} else {
			$dorecord = "0";
		}

		if (filter_has_var(INPUT_POST,'stream')) {
			$dostream = "1";
		} else {
			$dostream = "0";
		}


        print "<center>Started</center><br>";
		$cmd="sudo -u pigb /home/pigb/startgb-ffmpeg.sh ".$_POST['hopmode']." ".$_POST['hopdelay']." ".$_POST['minutes']." ".$dorecord." ".$_POST['resamplerate']." ".$_POST['gain']." ".$_POST['frequency']." ".$_POST['samplerate']." ".$_POST['volume']." ".$_POST['modulation']." ".$_POST['engine']." ".$_POST['buffer']." ".$dostream." '".$_POST['noiseprof']."' &";
		exec($cmd, $output, $retval);

		//print($cmd);
    }
    elseif (isset($_POST['Stop'])) {
		$output=null;
		$retval=null;
        print "<center>Stopped</center><br>";
		exec('sudo killall -HUP rtl_gb 2>&1', $output, $retval);
		exec('sudo killall -HUP rtl_gb_keenerd 2>&1', $output, $retval);
    } 
    elseif (isset($_POST['Shutdown'])) {
		$output=null;
		$retval=null;
        print "Shutting down<br>";
		exec('sudo shutdown -h now 2>&1', $output, $retval);
    } 
    elseif (isset($_POST['Reboot'])) {
		$output=null;
		$retval=null;
        print "Rebooting<br>";
		exec('sudo reboot 2>&1', $output, $retval);
    } 
    elseif (isset($_POST['DeleteNoiseProf'])) {
        $output=null;
        $retval=null;
        print "Deleting dynamic noise profiles...<br>";
        exec('sudo rm -f /var/www/html/gb/noiseprof/*noiseprof.wav* 2>&1', $output, $retval);
		header("Location: index.php");
    } 


?>
</script>
</body>
</html>
