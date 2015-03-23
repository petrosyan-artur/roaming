<?php

namespace Roaming\DbMapper;
use Zend\Db\Sql\Expression;
use Zend\Db\Sql\Select;

/**
 * Description of Rate
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class Rate extends AbstractMapper {

    protected $tblName = 'rate';

    /**
     * @param $phone
     * @param $userId
     * @return bool|null|int
     */
    public function getRate($phone, $userId) {
        $expr = new Expression("LOCATE(code, $phone) = 1");
        $select = new Select();
        $select->from(array('r' => $this->tblName))
            ->columns(array('code', 'price', 'increment'))
            ->order(array(new Expression("LENGTH(r.code) DESC")))
            ->limit(1)
            ->join(array('u' => 'users'), 'r.rate_sheet_id = u.rate_sheet_id', array('id'))
            ->where(
                array(
                    'u.name' => $userId,
                )
            )
           ->where($expr->getExpression());

//        echo($select->getSqlString(new \Zend\Db\Adapter\Platform\Mysql()));die;
        $res = $this->selectWith($select);

        if($res) {
            $price = null;
            foreach($res as $row) {
                $price = $row->price;
                break; //we have only one row
            }
            return $price;
        }

        return null;
    }
    
}
