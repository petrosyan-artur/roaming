<?php

namespace Roaming\DbMapper;

/**
 * Description of PendingUser
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class PendingUser extends AbstractMapper {
    const STATUS_ACTIVE = 1;
    const STATUS_DELETED = 0;
    
    protected $tblName = 'user_pending';
    
    
    public function getUserByIdentity($userIdentity) {
        return $this->select(array('name' => $userIdentity))->current();
    }
    
    public function insert($set) {
        $set['date_created'] = new \Zend\Db\Sql\Expression('now()');
        $set['date_updated'] = new \Zend\Db\Sql\Expression('now()');
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
}
