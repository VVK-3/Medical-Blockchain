'use strict';

class Patient {

  constructor(id, name, email, national_id ,address, city, verified, zip_code ,phone, password, created_at) {

      this.id = id;
      this.name = name;
      this.email = email;
      this.password = password;
      this.created_at = created_at;
      this.updated_at = created_at;
      this.national_id = national_id;
      this.phone = phone;
      this.verified = verified;
      this.type = 'patient'
      this.address = {
        address: address,
        city: city,
        zip_code: zip_code
      };
      if (this.__isContract) {
        delete this.__isContract;
      }
      return this;

  }

}
module.exports = Patient;
