<?php

function p_env($envvar, $default_value) {
  $x = getenv($envvar);
  if($x === false) print ($default_value);
  else print ($x);
}

print("<?php\n");
?>

$prefs['_GLOBAL']['fixed'] = false;
