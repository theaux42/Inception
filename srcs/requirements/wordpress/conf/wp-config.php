<?php
/**
 * Custom WordPress configurations on "wp-config.php" file.
 *
 * This file has the following configurations: MySQL settings, Table Prefix, Secret Keys, WordPress Language, ABSPATH and more.
 * For more information visit {@link https://codex.wordpress.org/Editing_wp-config.php Editing wp-config.php} Codex page.
 * Created using {@link http://generatewp.com/wp-config/ wp-config.php File Generator} on GenerateWP.com.
 *
 * @package WordPress
 * @generator GenerateWP.com
 */


/* MySQL settings */
define( 'DB_NAME',     'database_name_here' );
define( 'DB_USER',     'username_here' );
define( 'DB_PASSWORD', 'password_here' );
define( 'DB_HOST',     'localhost' );
define( 'DB_CHARSET',  'utf8mb4' );


/* MySQL database table prefix. */
$table_prefix = 'wp_';

$env_wp_url = getenv('WP_URL');
if ($env_wp_url) {
	define('WP_HOME', $env_wp_url);
	define('WP_SITEURL', $env_wp_url);
}


/* Authentication Unique Keys and Salts. */
/* https://api.wordpress.org/secret-key/1.1/salt/ */
define('AUTH_KEY',         'T:Vmwwle+~-zli7u]<sY~s^l^>5&a+FaTj?,8oDsy.v`yz)u^ q7e>I6@WXB_7Xt');
define('SECURE_AUTH_KEY',  'B(~l>-nE|:?Y=sV6gKc_ZQ=IL)|s0PkTod6f`.-Y*O-ZsJ?|%LdJ/JW+QW-}6AZa');
define('LOGGED_IN_KEY',    'EhC_4.8bpTx/mc=As(aetE|5V,=SaP?,FhwXw^Ib1Aol}2k#f1})O[mCa-X;{fq>');
define('NONCE_KEY',        '{}#` Muw<pUS[!EYl7A9O*f8ou7a0JPx!u-J[-eXR7he.uFODnnoEPB.sB0?y_A;');
define('AUTH_SALT',        '#&AK.wHk^A?X0*]*iBhaXGz9}xX]7JE0@a*Y,&10rAz7Jm -?3f7H[h#=DG3pHmT');
define('SECURE_AUTH_SALT', ':7>kr2NAdxSF>&9i,Hut#H&W3q;snP}wcD&qR@N3S~^RrtdPCvo)?ftgRE-|b2>q');
define('LOGGED_IN_SALT',   'S)D,y2 K]#]}QAL2Aj{u*a^Cs14!J}> P!>Wf0|FOlwt5X_Bf6yiWZM-* }WLvw}');
define('NONCE_SALT',       'xA|%4P~&Qd IQ4wR)apsn5YfM7]t`;vcw_ig|%y]t^sG;];Khw&DZkc24pb7mFNd');


/* Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/* Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
