<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Entity;

/**
 * Description of User
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class User {
    
    protected $id;
    protected $status;
    protected $phone;
    protected $pin;
    protected $first_name;
    protected $last_name;
    protected $country_id;
    protected $date_created;
    protected $date_updated;
    
    public function exchangeArray($data) {
        $this->id = (!empty($data['id'])) ? $data['id'] : null;
        $this->status = (!empty($data['status'])) ? $data['status'] : null;
        $this->phone = (!empty($data['name'])) ? $data['name'] : null;
        $this->pin = (!empty($data['pin'])) ? $data['pin'] : null;
        $this->first_name = (!empty($data['first_name'])) ? $data['first_name'] : null;
        $this->last_name = (!empty($data['last_name'])) ? $data['last_name'] : null;
        $this->country_id = (!empty($data['country_id'])) ? $data['country_id'] : null;
        $this->date_created = (!empty($data['date_created'])) ? $data['date_created'] : null;
        $this->date_updated = (!empty($data['date_updated'])) ? $data['date_updated'] : null;
    }
}
