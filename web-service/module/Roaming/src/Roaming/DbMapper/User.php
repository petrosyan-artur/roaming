<?php

namespace Roaming\DbMapper;

/**
 * Description of User
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class User extends AbstractMapper {

    const STATUS_PENDING = 1;
    const STATUS_ACTIVE = 2;
    const STATUS_DELETED = 0;
    
    protected $tblName = 'user';
    
//    protected function getEntity() {
//        return new \Roaming\Entity\User;
//    }
    
    public function getUserByIdentity($userIdentity) {
        return $this->select(array('phone' => $userIdentity))->current();
    }
    
    public function insert($set) {
        $set['date_created'] = new \Zend\Db\Sql\Expression('now()');
        $set['date_updated'] = new \Zend\Db\Sql\Expression('now()');
        $set['country_id'] = 1;
        parent::insert($set);
    }
    
    /**
     * 
     * @param type $userIdentity
     * @param type $pin
     * @return bool
     */
    public function updatePin($userIdentity, $pin) {
        return $this->update(array('pin' => md5($pin)), array('phone' => $userIdentity));
    }
    
}
