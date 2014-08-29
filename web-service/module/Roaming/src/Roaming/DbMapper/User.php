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
    const STATUS_TEMPORARY_BLOCKED = 3;
    const STATUS_DELETED = 0;
    
    protected $tblName = 'users';
    
//    protected function getEntity() {
//        return new \Roaming\Entity\User;
//    }
    
    public function getUserByIdentity($userIdentity) {
        return $this->select(array('name' => $userIdentity))->current();
    }
    
    public function insert($set) {
        $set['date_created'] = new \Zend\Db\Sql\Expression('now()');
        $set['date_updated'] = new \Zend\Db\Sql\Expression('now()');
        $set['country_id'] = 1;
        parent::insert($set);
    }
    
    public function update($set, $where = null) {
        $set['date_updated'] = new \Zend\Db\Sql\Expression('now()');
        return parent::update($set, $where);
    }
    
    /**
     * 
     * @param type $userIdentity
     * @param type $pin
     * @return bool
     */
    public function updatePin($userIdentity, $pin) {
        $a = $this->update(array('pin' => md5($pin)), array('name' => $userIdentity));
        return $a;
    }

    public function incrementFailLogin($phone) {
        return $this->update(array('login_failure' => new \Zend\Db\Sql\Expression('login_failure + 1')), array('name' => $phone));
    }
    
    public function resetLoginFailure($phone) {
        return $this->update(array('login_failure' => 0), array('name' => $phone));
    }    
}
