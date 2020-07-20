'use strict';

class Request {

  constructor(id ,patient_id, doctor_id, created_at) {

    this.id = id
    this.patient_id = patient_id;
    this.doctor_id = doctor_id;
    this.status = "PENDING";
    this.created_at = created_at;
    this.updated_at = created_at;
    this.type = 'request';
    if (this.__isContract) {
      delete this.__isContract;
    }
    return this;
  }


}
module.exports = Request;
