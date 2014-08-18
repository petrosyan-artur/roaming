<?php

namespace Roaming\Entity;

/**
 * Description of UserRegisterResponseEntity
 *
 * @author Aram Tadevosyan (aramtadevosyan [at] gmail.com)
 */
class MorUserRegisterResponse {
    
    const STATUS_SUCCESS = 1;
    const STATUS_FAILD = 0;
    
    /**
     *
     * @var DeviceEntity
     */
    protected $deviceEntity;
    
    protected $moreUserId;
    
    protected $status;
    
    public function __construct($defaultDeviceName = 'My first device') {
        $this->deviceEntity = new MorDevice();
        $this->deviceEntity->setName($defaultDeviceName);
    }
    
    /**
     * 
     * @return \Roaming\Entity\MorDevice
     */
    public function getDeviceEntity() {
        return $this->deviceEntity;
    }

    public function getMoreUserId() {
        return $this->moreUserId;
    }

    public function getStatus() {
        return $this->status;
    }

    public function setDeviceEntity(MorDevice $deviceEntity) {
        $this->deviceEntity = $deviceEntity;
    }

    public function setMoreUserId($moreUserId) {
        $this->moreUserId = $moreUserId;
    }

    public function setStatus($status) {
        $this->status = $status;
    }

}
