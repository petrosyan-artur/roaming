<?php

namespace Roaming\DbMapper;

/**
 * Description of PinRequest
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class PinRequest extends AbstractMapper {

    const STATUS_ACTIVE = 1;
    
    protected $tblName = 'pin_request';
    
//    protected function getEntity() {
//        return new \Roaming\Entity\PinRequest();
//    }
    
    public function insert($set) {
        $set['date_created'] = new \Zend\Db\Sql\Expression('now()');
        $set['date_updated'] = new \Zend\Db\Sql\Expression('now()');
        $set['status'] = self::STATUS_ACTIVE;
        parent::insert($set);
    }
    
    public function getUserRequestCountPeruentDay($userId) {
        $res = $this->getAdapter()->query('select count(*) as ccc from pin_request where id = ' . (int) $userId, \Zend\Db\Adapter\Adapter::QUERY_MODE_EXECUTE);
        foreach ($res as $value) {
            var_dump($value);
        }
        die;
        var_dump($res->ccc);
    }
    
}
