<?php
/**
 * Global Configuration Override
 *
 * You can use this file for overriding configuration values from modules, etc.
 * You would place values in here that are agnostic to the environment and not
 * sensitive to security.
 *
 * @NOTE: In practice, this file will typically be INCLUDED in your source
 * control, so do not include passwords or other sensitive information in this
 * file.
 */

 return array(
     'db' => array(
         'username' => 'root',
         'password' => '',
         'driver'         => 'Pdo',
         'dsn'            => 'mysql:dbname=telasco-roaming;host=localhost',
         'driver_options' => array(
             PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\''
         ),
     ),
     'service_manager' => array(
         'factories' => array(
             'Zend\Db\Adapter\Adapter'
                     => 'Zend\Db\Adapter\AdapterServiceFactory',
             'Twilio\Options\ModuleOptions' => 'Twilio\Options\Factory\ModuleOptionsFactory',
             'Twilio\Service\TwilioService' => 'Twilio\Service\Factory\TwilioServiceFactory'
         ),
     ),
    'twilio' => array(
        /**
         * The SID to for your Twilio account.
         */
        'sid' => 'AC0dc9286611754ba4c9b8d97501c8e20a',

        /**
         * The token for your Twilio account.
         */
        'token' => '56d41f22456b57eb4eaf6f2f84ffed0a',
    )
 );
