<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Roaming\Entity;

/**
 * Description of PinRequest
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class PinRequest {
    
    const STATUS_PENDING = 1;
    const STATUS_SENT = 1;
    
    protected $id;
    protected $status;
    protected $user_id;
    protected $date_requested;
    protected $date_created;
    protected $date_updated;
    
    public function exchangeArray($data) {
        $this->id = (!empty($data['id'])) ? $data['id'] : null;
        $this->status = (!empty($data['status'])) ? $data['status'] : null;
        $this->user_id = (!empty($data['user_id'])) ? $data['user_id'] : null;
        $this->date_requested = (!empty($data['date_requested'])) ? $data['date_requested'] : null;
        $this->date_created = (!empty($data['date_created'])) ? $data['date_created'] : null;
        $this->date_updated = (!empty($data['date_updated'])) ? $data['date_updated'] : null;
    }
}
