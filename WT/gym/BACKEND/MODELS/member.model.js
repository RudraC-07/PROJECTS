const mongoose = require('mongoose');

const MembSchema = new mongoose.Schema({
  Firstname : String,
  Lastname : String,
  EmailAddress : String,
  PhoneNumber : {
    type : Number,
    unique : true
  },
  Gender : String,
  DOB : Date,
  MembershipType : String
})

const Memb = mongoose.model('members',MembSchema)
module.exports = Memb