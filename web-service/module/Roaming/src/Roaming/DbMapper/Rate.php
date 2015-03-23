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
        $select = new Select();
        $select->from($this->tblName)
            ->columns(array('code', 'price', 'increment'))
            ->order(array(new Expression("LENGTH(code) DESC")))
            ->limit(1)
            ->join(array('user' => 'u'), 'r.rate_sheet_id = u.rate_sheet_id')
            ->where(
                array(
                    'u.id' => $userId,
                )
            )
           ->where->equalTo(new Expression("LOCATE(code, $phone)"), 1);

        echo($select);die;
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
