<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\DbMapper;

/**
 * Description of Abstract
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
abstract class AbstractMapper extends \Zend\Db\TableGateway\TableGateway{
    
    protected $tblName = '';
    
    public function __construct(\Zend\Db\Adapter\Adapter $adapter) {
//        $resultSetPrototype = new \Zend\Db\ResultSet\ResultSet();
//        $resultSetPrototype->setArrayObjectPrototype($this->getEntity());
        parent::__construct($this->tblName, $adapter, null/*, $resultSetPrototype*/);
    }
    
//    abstract protected function getEntity();
    
}
