const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const RequestSchema = new mongoose.Schema({
  patient_id: {
    type: String,
    required: true
  },
  doctor_id: {
    type: String,
    required: true
  },
  status:{
    type:String,
    enum:['PENDING','ACCEPTED','REJECTED'],
    default: 'PENDING',
  },
  data:{
    type: Array,
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




const Request = mongoose.model('Request', RequestSchema);

module.exports = Request;
