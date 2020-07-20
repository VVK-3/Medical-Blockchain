'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const util = require('util');
const path = require('path');
const fs = require('fs');
const Patient = require('./models/Patient');
const Doctor = require('./models/Patient');
const Record = require('./models/Record');
const Request = require('./models/Request');
const bcrypt = require('bcrypt')
let network = require('./fabric/network.js');
const jwt = require('jsonwebtoken');
const auth = require('./auth/auth')
var multer = require('multer')
const app = express();
var upload = multer();
app.use(upload.array());
app.use(morgan('combined'));
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());


const configPath = path.join(process.cwd(), './config.json');
const configJSON = fs.readFileSync(configPath, 'utf8');
const config = JSON.parse(configJSON);

//use this identity to query
const appAdmin = config.appAdmin;

//get voter info, create voter object, and update state with their voterId
app.post('/register', async (req, res) => {
  // console.log(req.body);
  // To Do Validate Inputs
  if (!req.body.name)
    return res.json({ 'msg': 'name is required' })
  if (!req.body.email)
    return res.json({ 'msg': 'email is required' })
  if (!req.body.national_id)
    return res.json({ 'msg': 'national_id is required' })
  if (!req.body.password)
    return res.json({ 'msg': 'password is required' })
  if (req.body.password != req.body.password_confirmation)
    return res.json({ 'msg': 'passwords do not match' })
  // let voterId = req.body.voterId;
  req.body.password = await bcrypt.hash(req.body.password, 10);
  const hash = req.body.password;
  var newUser = new Patient({
    name: req.body.name,
    email: req.body.email,
    national_id: req.body.national_id,
    address: req.body.address,
    city: req.body.city,
    zip_code: req.body.zip_code,
    password: hash
  });
  req.body.id = newUser.id;
  req.body.created_at = newUser.created_at;
  req.body.updated_at = newUser.updated_at
  console.log(req.body)
  //first create the identity for the voter and add to wallet
  let response = await network.registerParticipant(newUser.id, newUser.name, newUser.email,
    newUser.national_id, newUser.address, newUser.city,
    newUser.zip_code, newUser.password, newUser.created_at);
  console.log('response from registerParticipant: ');
  console.log(response);
  if (response.error) {
    res.send(response.error);
  } else {
    let networkObj = await network.connectToNetwork(newUser.id);
    console.log('networkobj: ');
    console.log(networkObj);
    if (networkObj.error) {
      res.send(networkObj.error);
    }
    console.log('network obj');
    console.log(util.inspect(networkObj));


    req.body = JSON.stringify(req.body);
    let args = [req.body];
    //connect to network and update the state with voterId
    console.log('beffore ')
    console.log(args)
    let invokeResponse = await network.invoke(networkObj, false, 'createPatient', args);
    if (invokeResponse.error) {
      res.send(invokeResponse.error);
    } else {
      console.log('after network.invoke ');
      let parsedResponse = JSON.parse(invokeResponse);
      res.send({ success: true, res: parsedResponse });
    }
  }
});

app.post('/register-doctor', async (req, res) => {
  // console.log(req.body);
  // To Do Validate Inputs
  if (!req.body.name)
    return res.json({ 'msg': 'name is required' })
  if (!req.body.email)
    return res.json({ 'msg': 'email is required' })
  if (!req.body.national_id)
    return res.json({ 'msg': 'national_id is required' })
  if (!req.body.password)
    return res.json({ 'msg': 'password is required' })
  if (req.body.password != req.body.password_confirmation)
    return res.json({ 'msg': 'passwords do not match' })
  // let voterId = req.body.voterId;
  req.body.password = await bcrypt.hash(req.body.password, 10);
  const hash = req.body.password;
  var newUser = new Doctor({
    name: req.body.name,
    email: req.body.email,
    national_id: req.body.national_id,
    address: req.body.address,
    city: req.body.city,
    zip_code: req.body.zip_code,
    represents: req.body.represents,
    institution: {
      'institution_name': req.body.institution_name,
      'institution_number': req.body.institution_number
    },
    password: hash
  });
  req.body.id = newUser.id;
  req.body.created_at = newUser.created_at;
  req.body.updated_at = newUser.updated_at
  console.log(req.body)
  //first create the identity for the voter and add to wallet
  let response = await network.registerParticipant(newUser.id, newUser.name, newUser.email,
    newUser.national_id, newUser.address, newUser.city,
    newUser.zip_code, newUser.password, newUser.created_at);
  console.log('response from registerParticipant: ');
  console.log(response);
  if (response.error) {
    res.send(response.error);
  } else {
    let networkObj = await network.connectToNetwork(newUser.id);
    console.log('networkobj: ');
    console.log(networkObj);

    if (networkObj.error) {
      res.send(networkObj.error);
    }
    console.log('network obj');
    console.log(util.inspect(networkObj));
    req.body = JSON.stringify(req.body);
    let args = [req.body];
    //connect to network and update the state with voterId
    console.log('beffore ')
    console.log(args)
    let invokeResponse = await network.invoke(networkObj, false, 'createDoctor', args);
    if (invokeResponse.error) {
      res.send(invokeResponse.error);
    } else {
      console.log('after network.invoke ');
      let parsedResponse = JSON.parse(invokeResponse);
      res.send({ success: true, res: parsedResponse });
    }
  }

});

app.post('/create-record', auth, async (req, res) => {
  // To Do Validate Inputs
  if (!req.body.national_id)
    return res.json({ 'msg': 'national_id is required' })
  if (!req.body.data)
    return res.json({ 'msg': 'record data are required' })

  console.log(req.body)
  console.log(req.user)
  if (req.user.type != 'doctor')
    return res.json({ success: false, msg: 'User must be a doctor to create a record' })
  // get patient
  let networkObj = await network.connectToNetwork('admin');
  console.log('networkobj: ');
  console.log(util.inspect(networkObj));
  if (networkObj.error) {
    res.send(networkObj);
  }
  var invokeResponse = await network.invoke(networkObj, true, 'queryByData',
    JSON.stringify({ type: 'patient' }));

  var parsedResponse = await JSON.parse(JSON.parse(invokeResponse));

  if (parsedResponse.error) {
    res.send(parsedResponse.error);
  } else {
    if (parsedResponse.length == 0)
      return res.json({ success: false, 'msg': 'no patients with this national_id' })

    var patient = parsedResponse[0]['Record'];
    console.log(parsedResponse)

    var record = new Record({
      patient_id: patient.id,
      doctor_id: req.user.id,
      data: req.body.data
    });
    req.body.id = record.id;
    req.body.patient_id = record.patient_id;
    req.body.doctor_id = record.doctor_id;

    req.body.created_at = record.created_at;
    req.body.updated_at = record.updated_at;
    req.body.data = JSON.stringify(req.body.data)
    console.log(req.body)


    let networkObj = await network.connectToNetwork(req.user.id);
    console.log('networkobj: ');
    console.log(networkObj);

    if (networkObj.error) {
      res.send(networkObj.error);
    }
    console.log('network obj');
    console.log(util.inspect(networkObj));
    req.body = JSON.stringify(req.body);
    let args = [req.body];
    //connect to network and update the state with voterId
    console.log('beffore ')
    console.log(args)
    let invokeResponse = await network.invoke(networkObj, false, 'createRecord', args);
    if (invokeResponse.error) {
      res.send(invokeResponse.error);
    } else {
      console.log('after network.invoke ');
      let parsedResponse = JSON.parse(invokeResponse);
      res.send({ success: true, res: parsedResponse });
    }
  }

});


app.post('/create-request', auth, async (req, res) => {
  // To Do Validate Inputs
  if (!req.body.national_id)
    return res.json({ 'msg': 'national_id is required' })

  console.log(req.body)
  console.log(req.user)
  if (req.user.type != 'doctor')
    return res.json({ success: false, msg: 'User must be a doctor to create a record' })
  // get patient
  let networkObj = await network.connectToNetwork('admin');
  console.log('networkobj: ');
  console.log(util.inspect(networkObj));
  if (networkObj.error) {
    res.send(networkObj);
  }
  var invokeResponse = await network.invoke(networkObj, true, 'queryByData',
    JSON.stringify({ type: 'patient' }));

  var parsedResponse = await JSON.parse(JSON.parse(invokeResponse));

  if (parsedResponse.error) {
    res.send(parsedResponse.error);
  } else {
    if (parsedResponse.length == 0)
      return res.json({ success: false, 'msg': 'no patients with this national_id' })

    var patient = parsedResponse[0]['Record'];
    console.log(parsedResponse)

    var request = new Request({
      patient_id: patient.id,
      doctor_id: req.user.id,
    });
    req.body.id = request.id;
    req.body.patient_id = request.patient_id;
    req.body.doctor_id = request.doctor_id;

    req.body.created_at = request.created_at;
    req.body.updated_at = request.updated_at;
    console.log(req.body)


    let networkObj = await network.connectToNetwork(req.user.id);
    console.log('networkobj: ');
    console.log(networkObj);

    if (networkObj.error) {
      res.send(networkObj.error);
    }
    console.log('network obj');
    console.log(util.inspect(networkObj));
    req.body = JSON.stringify(req.body);
    let args = [req.body];
    //connect to network and update the state with voterId
    console.log('beffore ')
    console.log(args)
    let invokeResponse = await network.invoke(networkObj, false, 'createRequest', args);
    if (invokeResponse.error) {
      res.send(invokeResponse.error);
    } else {
      console.log('after network.invoke ');
      let parsedResponse = JSON.parse(invokeResponse);
      res.send({ success: true, res: parsedResponse });
    }
  }
});

app.post('/update-record', auth, async (req, res) => {
  // To Do Validate Inputs
  if (!req.body.id)
    return res.json({ 'msg': 'record id is required' })

  console.log(req.body)
  console.log(req.user)
  if (req.user.type != 'patient')
    return res.json({ success: false, msg: 'User must be a patient to update the record' })
  // get patient
  let networkObj = await network.connectToNetwork('admin');
  console.log('networkobj: ');
  console.log(util.inspect(networkObj));
  if (networkObj.error) {
    res.send(networkObj);
  }
  var invokeResponse = await network.invoke(networkObj, true, 'queryByData',
    JSON.stringify({ type: 'record', id: req.body.id, patient_id: req.user.id }));

  var parsedResponse = await JSON.parse(JSON.parse(invokeResponse));

  if (parsedResponse.error) {
    res.send(parsedResponse.error);
  } else {
    if (parsedResponse.length == 0)
      return res.json({ success: false, 'msg': 'you have no records with this id' })

    var record = parsedResponse[0]['Record'];
    console.log(parsedResponse)

    if (req.body.status != 'ACCEPTED' && req.body.status != "REJECTED")
      return res.json({ success: false, msg: 'Status Must Be ACCEPTED or REJECTED' })

    req.body.record = record;
    req.body.status = req.body.status;

    req.body.updated_at = Date.now;


    let networkObj = await network.connectToNetwork(req.user.id);
    console.log('networkobj: ');
    console.log(networkObj);

    if (networkObj.error) {
      res.send(networkObj.error);
    }
    console.log('network obj');
    console.log(util.inspect(networkObj));
    req.body = JSON.stringify(req.body);
    let args = [req.body];
    //connect to network and update the state with voterId
    console.log('beffore ')
    console.log(args)
    let invokeResponse = await network.invoke(networkObj, false, 'updateRecord', args);
    if (invokeResponse.error) {
      res.send(invokeResponse.error);
    } else {
      console.log('after network.invoke ');
      let parsedResponse = JSON.parse(invokeResponse);
      res.send({ success: true, res: parsedResponse });
    }
  }
});

app.post('/update-request', auth, async (req, res) => {
  // To Do Validate Inputs
  if (!req.body.id)
    return res.json({ 'msg': 'request id is required' })

  console.log(req.body)
  console.log(req.user)
  if (req.user.type != 'patient')
    return res.json({ success: false, msg: 'User must be a patient to update the record' })
  // get patient
  let networkObj = await network.connectToNetwork('admin');
  console.log('networkobj: ');
  console.log(util.inspect(networkObj));
  if (networkObj.error) {
    res.send(networkObj);
  }
  var invokeResponse = await network.invoke(networkObj, true, 'queryByData',
    JSON.stringify({ type: 'request', id: req.body.id, patient_id: req.user.id }));

  var parsedResponse = await JSON.parse(JSON.parse(invokeResponse));

  if (parsedResponse.error) {
    res.send(parsedResponse.error);
  } else {
    if (parsedResponse.length == 0)
      return res.json({ success: false, 'msg': 'you have no records with this id' })

    var request = parsedResponse[0]['Record'];
    console.log(parsedResponse)

    if (req.body.status != 'ACCEPTED' && req.body.status != "REJECTED")
      return res.json({ success: false, msg: 'Status Must Be ACCEPTED or REJECTED' })


    req.body.request = request;
    req.body.status = req.body.status;

    req.body.updated_at = Date.now;


    let networkObj = await network.connectToNetwork(req.user.id);
    console.log('networkobj: ');
    console.log(networkObj);

    if (networkObj.error) {
      res.send(networkObj.error);
    }
    console.log('network obj');
    console.log(util.inspect(networkObj));
    req.body = JSON.stringify(req.body);
    let args = [req.body];
    //connect to network and update the state with voterId
    console.log('beffore ')
    console.log(args)
    let invokeResponse = await network.invoke(networkObj, false, 'updateRequest', args);
    if (invokeResponse.error) {
      res.send(invokeResponse.error);
    } else {
      console.log('after network.invoke ');
      let parsedResponse = JSON.parse(invokeResponse);
      res.send({ success: true, res: parsedResponse });
    }
  }
});
//get all assets in world state
app.get('/requests', async (req, res) => {
  let networkObj = await network.connectToNetwork(appAdmin);
  let response = await network.invoke(networkObj, true, 'queryAll', '');
  let parsedResponse = await JSON.parse(response);
  res.send(parsedResponse);

});

app.get('/user', auth, async (req, res) => {
  res.send(req.user)
})
//query for certain objects within the world state
app.post('/queryWithQueryString', async (req, res) => {
  let networkObj = await network.connectToNetwork(appAdmin);
  let response = await network.invoke(networkObj, true, 'queryByObjectType', req.body.selected);
  let parsedResponse = await JSON.parse(response);
  res.send(parsedResponse);
});



//used as a way to login the voter to the app and make sure they haven't voted before
app.post('/login', async (req, res) => {
  console.log('req.body: ');
  console.log(req.body)
  let networkObj = await network.connectToNetwork('admin');
  console.log('networkobj: ');
  console.log(util.inspect(networkObj));
  if (networkObj.error) {
    res.send(networkObj);
  }
  var invokeResponse = await network.invoke(networkObj, true, 'queryByData',
    JSON.stringify({ email: req.body.email, type: 'doctor' }));
  if (invokeResponse.error) {
    res.send(invokeResponse);
  } else {
    console.log('after network.invoke ');
    console.log(invokeResponse)
    var parsedResponse = await JSON.parse(JSON.parse(invokeResponse));
    console.log(parsedResponse)
    if (parsedResponse.length == 0) {
      invokeResponse = await network.invoke(networkObj, true, 'queryByData',
        JSON.stringify({ email: req.body.email, type: 'patient' }));
      parsedResponse = await JSON.parse(JSON.parse(invokeResponse));
    }
    if (parsedResponse.length == 0)
      return res.json({ success: false, msg: 'Wrong Credentials' })
    let user = parsedResponse[0]['Record'];
    console.log(user.password)
    console.log(req.body.password)
    await bcrypt.compare(req.body.password, user.password)
      .then(isMatch => {
        if (!isMatch) return res.status(400).json({ msg: 'Invalid credentials' });
        var userData = user;
        delete userData.password
        jwt.sign(
          userData,
          "top_secret",
          { expiresIn: 3600 },
          (err, token) => {
            if (err) throw err;
            res.json({
              token,
              user
            });
          }
        )
      });
  }
});

app.post('/queryByKey', async (req, res) => {
  console.log('req.body: ');
  console.log(req.body);

  let networkObj = await network.connectToNetwork(appAdmin);
  console.log('after network OBj');
  let response = await network.invoke(networkObj, true, 'readMyAsset', req.body.key);
  response = JSON.parse(response);
  if (response.error) {
    console.log('inside eRRRRR');
    res.send(response.error);
  } else {
    console.log('inside ELSE');
    res.send(response);
  }
});

app.post('/requests', auth, async (req, res) => {
  console.log('req.body: ');
  console.log(req.body);

  let networkObj = await network.connectToNetwork(appAdmin);
  console.log('after network OBj');
  if (req.user.type == 'patient')
    var response = await network.invoke(networkObj, true, 'queryByData', JSON.stringify({ type: 'request', patient_id: req.user.id }));
  else
    var response = await network.invoke(networkObj, true, 'queryByData', JSON.stringify({ type: 'request', doctor_id: req.user.id }));
  response = JSON.parse(JSON.parse(response));
  return res.send(response);
});
app.post('/records', auth, async (req, res) => {
  console.log('req.body: ');
  console.log(req.body);

  let networkObj = await network.connectToNetwork(appAdmin);
  console.log('after network OBj');
  if (req.user.type == 'patient')
    var response = await network.invoke(networkObj, true, 'queryByData', JSON.stringify({ type: 'record', patient_id: req.user.id }));
  else
    var response = await network.invoke(networkObj, true, 'queryByData', JSON.stringify({ type: 'record', doctor_id: req.user.id }));

  response = JSON.parse(JSON.parse(response));
  return res.send(response);
});

app.listen(process.env.PORT || 8081);
