const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const PatientSchema = new mongoose.Schema({
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
  phone:{
    type:String,
    required:true
  },
  verified:{
    type: Boolean,
    default:true
  },
  password: {
    type: String,
    required: true
  },
  address:{
    type: Map,
    of:String
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
//This is called a pre-hook, before the Patient information is saved in the database
//this function will be called, we'll get the plain text password, hash it and store it.
PatientSchema.pre('save', async function(next){
  //'this' refers to the current document about to be saved
  const Patient = this;
  //Hash the password with a salt round of 10, the higher the rounds the more secure, but the slower
  //your application becomes.
  const hash = await bcrypt.hash(this.password, 10);
  //Replace the plain text password with the hash and then store it
  this.password = hash;
  //Indicates we're done and moves on to the next middleware
  next();
});

//We'll use this later on to make sure that the Patient trying to log in has the correct credentials
PatientSchema.methods.isValidPassword = async function(password){
  const patient = this;
  //Hashes the password sent by the Patient for login and checks if the hashed password stored in the
  //database matches the one sent. Returns true if it does else false.
  const compare = await bcrypt.compare(password, patient.password);
  return compare;
}

const Patient = mongoose.model('Patient', PatientSchema);

module.exports = Patient;
