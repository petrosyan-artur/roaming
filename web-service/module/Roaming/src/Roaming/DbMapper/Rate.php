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
            ->columns(array('name', 'code', 'price', 'increment'))
            ->order(array(new Expression("LENGTH(r.code) DESC")))
            ->limit(1)
            ->join(array('u' => 'users'), 'r.rate_sheet_id = u.rate_sheet_id', array('id'))
            ->where(
                array(
                    'u.name' => $userId,
                )
            )
           ->where($expr->getExpression());

        $res = $this->selectWith($select);

        if($res) {
            $price = null;
            $name = null;
            foreach($res as $row) {
                $price = $row->price;
                $name = $row->name;
                break; //we have only one row
            }
            return array($name, $price);
        }

        return null;
    }
    
}
