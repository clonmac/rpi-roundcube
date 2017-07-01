<?php

$config = array();

$config['db_dsnw'] = 'sqlite:////var/www/db/sqlite.db';

$config['default_host'] = '%s';

$config['smtp_server'] = 'localhost';
$config['smtp_port'] = 587;
$config['smtp_user'] = '%u';
$config['smtp_pass'] = '%p';

$config['support_url'] = '';
$config['product_name'] = 'Roundcube Webmail';

$config['log_dir'] = 'logs/';
$config['temp_dir'] = 'temp/';
$config['login_lc'] = 0;

$config['language'] = 'fr_FR';
$config['enable_spellcheck'] = false;
$config['prefer_html'] = false;
$config['display_next'] = false;
$config['message_cache_lifetime'] = '10d';


$config['des_key'] = 'rcmail-!24ByteDESkey*Str';

$config['plugins'] = array('carddav', 'maskasjunk2', 'filters');

// skin name: folder from skins/
$config['skin'] = 'larry';
