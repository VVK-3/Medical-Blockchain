'use strict';

class Record {

  constructor(id , patient_id, doctor_id, created_at, data) {

      //create the election object
      this.id = id;
      this.patient_id = patient_id;
      this.doctor_id = doctor_id;
      this.status = "PENDING";
      this.created_at = created_at;
      this.updated_at = created_at;
      this.data = data;
      this.type = 'record';
      if (this.__isContract) {
        delete this.__isContract;
      }
      return this;

  }

}
module.exports = Record;
