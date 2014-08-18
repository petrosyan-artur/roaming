<?php

namespace Roaming\DbMapper;

/**
 * Description of PushNotification
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class PushNotification extends AbstractMapper {

    const STATUS_PENDING = 1;
    const STATUS_SENT = 2;
    const STATUS_UNDELIVERED = 4;
    const STATUS_READ = 5;
    
    const TYPE_CALL = 1;
    
    protected $tblName = 'push_notification';
    
//    protected function getEntity() {
//        return new \Roaming\Entity\PinRequest();
//    }
    
    public function insert($set) {
        $set['date_created'] = new \Zend\Db\Sql\Expression('now()');
        $set['date_updated'] = new \Zend\Db\Sql\Expression('now()');
        $set['status'] = self::STATUS_PENDING;
        $set['type'] = self::TYPE_CALL;
        return parent::insert($set);
    }
    
    public function update($set, $where = null) {
        $set['date_updated'] = new \Zend\Db\Sql\Expression('now()');
        parent::update($set, $where);
    }
    
}
