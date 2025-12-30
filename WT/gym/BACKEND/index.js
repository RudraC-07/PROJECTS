const express = require('express');
const app = express();
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const Memb = require('./MODELS/member.model');
const cors = require('cors')
const connectionString = "mongodb+srv://Rudra:rudrax_07@cluster0.zizuu.mongodb.net/gym_db"

mongoose.connect(connectionString).then(()=>{
  console.log("MongoDB connected Successfully")

  app.use(express.json({ limit: "50mb" }));
  app.use(express.urlencoded({ extended: true, limit: "16kb" }));
  app.use(cors());

  //GetAll
  app.get('/members',async(req,res)=>{
    const data = await Memb.find();
    res.send(data);
  })

  //GetById
  app.get('/members/:id',async(req,res)=>{
    const {id} = req.params
    const data = await Memb.findById(id);
    res.send(data);
  })
  
  //Create
  app.post('/members',async(req,res)=>{
    
    const {Firstname,Lastname,EmailAddress,PhoneNumber,Gender,DOB,MembershipType} = req.body;
    console.log(Firstname,Lastname,EmailAddress,PhoneNumber,Gender,DOB,MembershipType)
    
    // const member = new Memb({...req.body});
    const member = await Memb.create({
      Firstname,
      Lastname,
      EmailAddress,
      PhoneNumber,
      Gender,
      DOB,
      MembershipType
    })
    console.log(member)
    // await member.save();
    res.status(200).json({
      member,
      message : "Member add successfully"
    });
  })

  //Update
  app.patch('/members/:id',async(req,res)=>{
    const { id } = req.params;
    const {Firstname,Lastname,EmailAddress,PhoneNumber,Gender,DOB,MembershipType} = req.body;
    const data = await Memb.findByIdAndUpdate(id,{
      $set : {
        Firstname,
        Lastname,
        EmailAddress,
        PhoneNumber,
        DOB,
        MembershipType
      }
    },{new:true});
    console.log(data)
    res.send("Member updated successfully");
  })

  //Delete
  app.delete('/members/:id',async(req,res)=>{
    const {id} = req.params
    const data = await Memb.findByIdAndDelete(id);
    res.send("Member removed from DB")
  })

})
const port = 4000;
app.listen(4000, () => {
  console.log("Port running at 4000");
});