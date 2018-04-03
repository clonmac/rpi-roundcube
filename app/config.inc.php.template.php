<?php

function random_key($len=10) {
  $table = "0123456789abcedefghjiklmnopqrstuvwxyz!*-&#";
  $k = null;
  for ($x=0; $x < $len; $x++) {
      $c = substr($table, rand(0, strlen($table)),1);
      $k .= ((rand(0, 3) == 0) ? strtoupper($c) : $c);
  }
  print($k);
}

function p_env($envvar, $default_value) {
  $x = getenv($envvar);
  if($x === false) print ($default_value);
  else print ($x);
}

print("<?php\n");
?>

$config = array();

$config['db_dsnw'] = 'sqlite:////var/www/db/sqlite.db';

$config['default_host'] = '<?php p_env("RC_DEFAULT_HOST", "%s") ?>';

$config['smtp_server'] = '<?php p_env("RC_SMTP_SERVER", "localhost") ?>';
$config['smtp_port'] = <?php p_env("RC_SMTP_PORT", "465") ?>;
$config['smtp_user'] = '<?php p_env("RC_SMTP_USER", "%u") ?>';
$config['smtp_pass'] = '<?php p_env("RC_SMTP_PASS", "%p") ?>';

$config['smtp_auth_type'] = 'PLAIN';

$config['smtp_conn_options'] = array(
  'ssl'         => array(
     'verify_peer'      => false,
     'verify_peer_name' => false,
  ),
);

$config['support_url'] = '';
$config['product_name'] = '<?php p_env("RC_PRODUCT_NAME", "Roundcube Webmail") ?>';

$config['log_dir'] = '<?php p_env("RC_LOG_DIR", "logs/") ?>';
$config['temp_dir'] = '<?php p_env("RC_TEMP_DIR", "temp/") ?>';
$config['login_lc'] = 0;

$config['language'] = '<?php p_env("RC_LANGUAGE", "fr_FR") ?>';
$config['enable_spellcheck'] = false;
$config['prefer_html'] = <?php p_env("RC_PREFER_HTML", "false") ?>;
$config['display_next'] = <?php p_env("RC_DISPLAY_NEXT", "false") ?>;
$config['message_cache_lifetime'] = '<?php p_env("RC_MESSAGE_CACHE_LIFETIME", "10d") ?>';


$config['des_key'] = '<?php random_key(20); ?>';

$config['plugins'] = array('carddav', 'markasjunk2', 'filters');

// skin name: folder from skins/
$config['skin'] = '<?php p_env("RC_SKIN", "larry") ?>';
