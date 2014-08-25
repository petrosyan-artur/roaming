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
    'di' => array(
        'instance' => array(
            'cron' => array(
                'parameters' => array(
                    /**
                     * how long ahead to schedule cron jobs
                     *
                     * @var int (minute)
                     */
                    'scheduleAhead' => 60,
                    /**
                     * how long before a scheduled job is considered missed
                     *
                     * @var int (minute)
                     */
                    'scheduleLifetime' => 60,
                    /**
                     * maximum running time of each cron job
                     *
                     * @var int (minute)
                     */
                    'maxRunningTime' => 60,
                    /**
                     * how long to keep successfully completed cron job logs
                     *
                     * @var int (minute)
                     */
                    'successLogLifetime' => 300,
                    /**
                     * how long to keep failed (missed / error) cron job logs
                     *
                     * @var int (minute)
                     */
                    'failureLogLifetime' => 10080,
                ),
            ),
        ),
    ),
    'db' => array(
        'username' => 'root',
        'password' => '',
        'driver' => 'Pdo',
        'dsn' => 'mysql:dbname=telasco-roaming;host=localhost',
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
