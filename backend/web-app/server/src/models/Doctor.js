const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const DoctorSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true
  },
  national_id:{
    type:String,
    required:true
  },
  verified:{
    type: Boolean,
    default: false
  },
  represents:{
    type: String,
    required:true,
    enum:['doctor','institution']
  },
  institution:{
    type: Map,
    of:String
  },
  address:{
    type: Map,
    of:String
  },
  password: {
    type: String,
    required: true
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
});
//This is called a pre-hook, before the Doctor information is saved in the database
//this function will be called, we'll get the plain text password, hash it and store it.
DoctorSchema.pre('save', async function(next){
  //'this' refers to the current document about to be saved
  const Doctor = this;
  //Hash the password with a salt round of 10, the higher the rounds the more secure, but the slower
  //your application becomes.
  const hash = await bcrypt.hash(this.password, 10);
  //Replace the plain text password with the hash and then store it
  this.password = hash;
  //Indicates we're done and moves on to the next middleware
  next();
});

//We'll use this later on to make sure that the Doctor trying to log in has the correct credentials
DoctorSchema.methods.isValidPassword = async function(password){
  const Doctor = this;
  //Hashes the password sent by the Doctor for login and checks if the hashed password stored in the
  //database matches the one sent. Returns true if it does else false.
  const compare = await bcrypt.compare(password, Doctor.password);
  return compare;
}

const Doctor = mongoose.model('Doctor', DoctorSchema);

module.exports = Doctor;
