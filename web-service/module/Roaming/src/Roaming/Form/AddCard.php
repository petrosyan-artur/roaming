<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Form;

/**
 * Description of AddCard
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class AddCard extends \Zend\Form\Form {
    
    public function __construct($options = array()) {
        parent::__construct('AddCard', $options);
        $this->add(
            array(
                'name' => 'cardholders_name',
                'attributes' => array(
                    'type' => 'text'
                ),
                'options' => array(
                    'label' => 'Cardholder\'s Name'
                )
            )
        );
    }
    
}
