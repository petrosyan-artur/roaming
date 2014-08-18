<?php

/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Roaming;

use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;

class Module {

    public function onBootstrap(MvcEvent $e) {
        $eventManager = $e->getApplication()->getEventManager();
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManager);
    }

    public function getConfig() {
        return include __DIR__ . '/config/module.config.php';
    }

    public function getAutoloaderConfig() {
        return array(
            'Zend\Loader\StandardAutoloader' => array(
                'namespaces' => array(
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ),
            ),
        );
    }

    public function getServiceConfig() {
        return array(
            'factories' => array(
                '\Roaming\Model\User' => function($sm) {
                    $tableGateway = $sm->get('\Roaming\DbMapper\User');
                    $model = new \Roaming\Model\User($tableGateway, $sm);
                    return $model;
                },
                '\Roaming\Model\Mor' => function($sm) {
                    $model = new \Roaming\Model\Mor($sm);
                    $model->setApiSec('aram22aram');
                    $model->setServerIP('95.211.27.30');
                    $model->setBaseUrl('http://95.211.27.30/billing/');
                    $model->setUniqueHash('b95389e1cf');
                    return $model;
                },
                '\Roaming\DbMapper\User' => function ($sm) {
                    $adapter = $sm->get('Zend\Db\Adapter\Adapter');
                    return new \Roaming\DbMapper\User($adapter);
                },
                '\Roaming\DbMapper\PinRequest' => function ($sm) {
                    $adapter = $sm->get('Zend\Db\Adapter\Adapter');
                    return new \Roaming\DbMapper\PinRequest($adapter);
                },
                '\Roaming\Auth\AuthStorage' => function($sm){
                    return new \Roaming\Auth\AuthStorage('auth');  
                },
                '\Roaming\Auth\AuthService' => function($sm) {
                    $dbAdapter           = $sm->get('Zend\Db\Adapter\Adapter');
                    $dbTableAuthAdapter  = new Auth\CustomCredentialTreatmentAdapter($dbAdapter, 
                                                      'user','phone','pin', 'MD5(?)');

                    $authService = new \Zend\Authentication\AuthenticationService();
                    $authService->setAdapter($dbTableAuthAdapter);
                    $authService->setStorage($sm->get('\Roaming\Auth\AuthStorage'));

                    return $authService;
                },
            ),
        );
    }
}