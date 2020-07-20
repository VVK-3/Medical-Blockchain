'use strict';

class Doctor {

  constructor(id, name, email, national_id, represents,
     institution_name, institution_number,
      address, city, verified, zip_code ,phone, password, created_at) {

      this.id = id;
      this.name = name;
      this.email = email;
      this.password = password;
      this.created_at = created_at;
      this.updated_at = created_at;
      this.national_id = national_id;
      this.phone = phone;
      this.verified = verified;
      this.represents = represents;
      this.type = 'doctor';
      this.institution = {
        name:institution_name,
        number: institution_number
      };
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
module.exports = Doctor;
