<?php

$zfDir = __DIR__ . '/../vendor';
$appleLibraryDir = $zfDir . '/zendframework/zendservice-apple-apns/library/ZendService/Apple';
$zendDbDir = $zfDir . '/zendframework/zendframework/library/Zend/Db';
$appDir = __DIR__ . '/../module/Roaming/src/Roaming';

$dbConfigContainer = require(__DIR__ . '/../config/autoload/global.php');

$certificate = '../config/cert.pem';

require("$appleLibraryDir/apns/Client/AbstractClient.php");
require("$appleLibraryDir/apns/Client/Message.php");
require("$appleLibraryDir/Exception/RuntimeException.php");

require("$zendDbDir/Adapter/Profiler/ProfilerAwareInterface.php");
require("$zendDbDir/Adapter/Driver/Feature/DriverFeatureInterface.php");
require("$zendDbDir/Adapter/Driver/DriverInterface.php");
require("$zendDbDir/Adapter/Driver/ConnectionInterface.php");
require("$zendDbDir/Adapter/StatementContainerInterface.php");
require("$zendDbDir/Adapter/ParameterContainer.php");
require("$zendDbDir/Adapter/Driver/StatementInterface.php");
require("$zendDbDir/Adapter/Driver/Pdo/Statement.php");
require("$zendDbDir/Adapter/Driver/Pdo/Connection.php");
require("$zendDbDir/Adapter/Driver/ResultInterface.php");
require("$zendDbDir/Adapter/Driver/Pdo/Result.php");
require("$zendDbDir/Adapter/Driver/Pdo/Pdo.php");
require("$zendDbDir/Adapter/AdapterInterface.php");
require("$zendDbDir/Adapter/StatementContainer.php");
require("$zendDbDir/Exception/ExceptionInterface.php");
require("$zendDbDir/Adapter/Exception/ExceptionInterface.php");
require("$zendDbDir/Exception/UnexpectedValueException.php");
require("$zendDbDir/Adapter/Exception/UnexpectedValueException.php");
require("$zendDbDir/Adapter/Exception/InvalidQueryException.php");
require("$zendDbDir/Adapter/Adapter.php");
require("$zendDbDir/Adapter/Platform/PlatformInterface.php");
require("$zendDbDir/Adapter/Platform/Mysql.php");
require("$zendDbDir/ResultSet/ResultSetInterface.php");
require("$zendDbDir/ResultSet/AbstractResultSet.php");
require("$zendDbDir/ResultSet/ResultSet.php");

require("$zendDbDir/TableGateway/TableGatewayInterface.php");
require("$zendDbDir/TableGateway/AbstractTableGateway.php");
require("$zendDbDir/TableGateway/Feature/FeatureSet.php");
require("$zendDbDir/Sql/PreparableSqlInterface.php");
require("$zendDbDir/Sql/SqlInterface.php");
require("$zendDbDir/Sql/Platform/PlatformDecoratorInterface.php");
require("$zendDbDir/Sql/Platform/AbstractPlatform.php");
require("$zendDbDir/Sql/ExpressionInterface.php");
require("$zendDbDir/Sql/Predicate/PredicateInterface.php");
require("$zendDbDir/Sql/Predicate/PredicateSet.php");
require("$zendDbDir/Sql/Predicate/Predicate.php");
require("$zendDbDir/Sql/Where.php");
require("$zendDbDir/Sql/AbstractSql.php");
require("$zendDbDir/Sql/Having.php");
require("$zendDbDir/Sql/Select.php");
require("$zendDbDir/Sql/Platform/Mysql/SelectDecorator.php");
require("$zendDbDir/Sql/Ddl/SqlInterface.php");
require("$zendDbDir/Sql/Ddl/CreateTable.php");
require("$zendDbDir/Sql/Platform/Mysql/Ddl/CreateTableDecorator.php");
require("$zendDbDir/Sql/Platform/Mysql/Mysql.php");
require("$zendDbDir/Sql/Platform/Platform.php");
require("$zendDbDir/Sql/Sql.php");
require("$zendDbDir/Sql/Expression.php");
require("$zendDbDir/Sql/Insert.php");
require("$zendDbDir/TableGateway/TableGateway.php");
require("$appDir/DbMapper/AbstractMapper.php");
require("$appDir/DbMapper/PushNotification.php");


$phoneNumber = @$_GET['phone'];

if(!$phoneNumber) {
    return false;
}

$dbConfig = $dbConfigContainer['db'];

$dbAdapter = new \Zend\Db\Adapter\Adapter($dbConfig);

$statement = $dbAdapter->query("SELECT * FROM user WHERE phone=?");
$user = $statement->execute(array($phoneNumber))->current();

if(!$user) {
    return false;
}


$pushNotificationTableGateway = new \Roaming\DbMapper\PushNotification($dbAdapter);
$inserted = $pushNotificationTableGateway->insert(
    array(
        'user_id' => $user['id']
    )
);

if(!$inserted) {
    return false;
}

$pushNotificationId = $pushNotificationTableGateway->lastInsertValue;

$client = new \ZendService\Apple\Apns\Client\Message();
$client->open(ZendService\Apple\Apns\Client\Message::SANDBOX_URI, $certificate);
$message = new \ZendService\Apple\Apns\Message();
$message->setId($pushNotificationId);
$message->setToken($user['device_token']);

// simple alert:
$message->setAlert('You have new call');
// complex alert:
$alert = new Alert();
$alert->setBody('You have new call');
$alert->setActionLocKey('View Call');
$message->setAlert($alert);

try {
    $response = $client->send($message);
} catch (\ZendService\Apple\Apns\Exception\RuntimeException $e) {
    $pushNotificationTableGateway->update(
        array(
            'status' => \Roaming\DbMapper\PushNotification::STATUS_UNDELIVERED
        ),
        array(
            'id' => $pushNotificationId
        )
    );
    return false;
}

$client->close();

if ($response->getCode() != \ZendService\Apple\Apns\Response\Message::RESULT_OK) {
     switch ($response->getCode()) {
         case \ZendService\Apple\Apns\Response\Message::RESULT_PROCESSING_ERROR:
             // you may want to retry
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_MISSING_TOKEN:
             // you were missing a token
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_MISSING_TOPIC:
             // you are missing a message id
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_MISSING_PAYLOAD:
             // you need to send a payload
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_INVALID_TOKEN_SIZE:
             // the token provided was not of the proper size
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_INVALID_TOPIC_SIZE:
             // the topic was too long
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_INVALID_PAYLOAD_SIZE:
             // the payload was too large
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_INVALID_TOKEN:
             // the token was invalid; remove it from your system
             break;
         case \ZendService\Apple\Apns\Response\Message::RESULT_UNKNOWN_ERROR:
             // apple didn't tell us what happened
             break;
     }
} else {
    
}
