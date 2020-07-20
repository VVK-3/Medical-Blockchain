/*
 * SPDX-License-Identifier: Apache-2.0
 */

 'use strict';



//import Hyperledger Fabric 1.4 SDK
const { Contract } = require('fabric-contract-api');
const path = require('path');
const fs = require('fs');



//import our file which contains our constructors and auxiliary function
let Request = require('./Request.js');
let Doctor = require('./Doctor.js');
let Patient = require('./Patient.js');
let Record = require('./Record.js');

class MyAssetContract extends Contract {

  /**
   *
   * init
   *
   * This function creates voters and gets the application ready for use by creating
   * an election from the data files in the data directory.
   *
   * @param ctx - the context of the transaction
   * @returns the voters which are registered and ready to vote in the election
   */
  async init(ctx) {

    console.log('instantiate was called!');

    let patients = [];
    let doctors = [];
    let elections = [];
    let election;
    //create patients
    let patient1 = await new Patient('1', 'eslam', 'koko@koko.com',
    '123456','Dakados - Saad Zagloul St','Mit Ghamr',true,'35611','01018211946',
     '$2y$10$V215oJ40PXyM57EFdl/3TOhZ0Wcy2vLhLItROh6ofxMV.Im9joyWa','today');
    let patient2 = await new Patient('2', 'eslam2', 'koko2@koko.com',
    '123456','Dakados - Saad Zagloul St','Mit Ghamr',true,'35611','01018211946',
     '$2y$10$V215oJ40PXyM57EFdl/3TOhZ0Wcy2vLhLItROh6ofxMV.Im9joyWa','today');

     let doctor1 = await new Doctor('1', 'doctor', 'doctor@koko.com',
     '123456', 'doctor', '', '','Dakados - Saad Zagloul St','Mit Ghamr',true,'35611','01018211946',
      '$2y$10$V215oJ40PXyM57EFdl/3TOhZ0Wcy2vLhLItROh6ofxMV.Im9joyWa','today');
     let doctor2 = await new Doctor('2', 'doctor2', 'doctor2@koko.com',
     '123456', 'institution', 'Mit Ghamr Public Hospital', '2541233','Dakados - Saad Zagloul St','Mit Ghamr',true,'35611','01018211946',
      '$2y$10$V215oJ40PXyM57EFdl/3TOhZ0Wcy2vLhLItROh6ofxMV.Im9joyWa','today');

    //update voters array
    patients.push(patient1);
    patients.push(patient2);

    doctors.push(doctor1);
    doctors.push(doctor2);
    console.log(patients)
    console.log(doctors)
    //add the voters to the world state, the election class checks for registered voters
    await ctx.stub.putState(patient1.id, Buffer.from(JSON.stringify(patient1)));
    await ctx.stub.putState(patient2.id, Buffer.from(JSON.stringify(patient2)));
    await ctx.stub.putState(doctor1.id, Buffer.from(JSON.stringify(doctor1)));
    await ctx.stub.putState(doctor2.id, Buffer.from(JSON.stringify(doctor2)));



    return [doctors,patients];

  }


  async createRecord(ctx, args) {

    args = JSON.parse(args);
    // createRecord
    let record = await new Record(args.id, args.patient_id, args.doctor_id, args.created_at, args.data);


    // //update state with ballot object we just created
    await ctx.stub.putState(record.id, Buffer.from(JSON.stringify(record)));

    return {success:true,record:record}
  }

  async updateRecord(ctx, args) {

    args = JSON.parse(args);
    let record = args.record
    record.status = args.status;


    // //update state with ballot object we just created
    await ctx.stub.putState(record.id, Buffer.from(JSON.stringify(record)));

    return {success:true,record:record}
  }

  async createRequest(ctx, args) {

    args = JSON.parse(args);

    // createRecord
    let request = await new Request(args.id ,args.patient_id, args.doctor_id, args.created_at);


    // //update state with ballot object we just created
    await ctx.stub.putState(request.id, Buffer.from(JSON.stringify(request)));

    return {success:true,request:request}
  }

  async updateRequest(ctx, args) {

    args = JSON.parse(args);

    let request = args.request;
    request.status = args.status;
    if(request.status == "ACCEPTED"){
      let queryString = {
        selector: {
          patient_id: request.patient_id,
          status:'ACCEPTED',
          type: 'record'
        }
      };

      let queryResults = await this.queryWithQueryString(ctx, JSON.stringify(queryString));

      const records = queryResults;

      request.data = records;
    }

    // //update state with ballot object we just created
    await ctx.stub.putState(request.id, Buffer.from(JSON.stringify(request)));

    return {success:true,request};

  }
  async createPatient(ctx, args) {

    args = JSON.parse(args);

    //create a new voter
    let patient = await new Patient(args.id, args.name, args.email, args.national_id ,args.address, args.city, args.verified, args.zip_code ,args.phone, args.password, args.created_at);

    //update state with new voter
    await ctx.stub.putState(patient.id, Buffer.from(JSON.stringify(patient)));


    return {success:true,patient};
  }


  async createDoctor(ctx, args) {

    args = JSON.parse(args);

    //create a new voter
    let doctor = await new Doctor(args.id,args.name,
      args.email,
      args.national_id ,
      args.represents,
      args.institution_name,
      args.institution_number,
      args.address,
      args.city,
      args.verified,
      args.zip_code ,
      args.phone,
      args.password,
      args.created_at);

    //update state with new voter
    await ctx.stub.putState(doctor.id, Buffer.from(JSON.stringify(doctor)));


    return {success:true,doctor};
  }



  /**
   * Query and return all key value pairs in the world state.
   *
   * @param {Context} ctx the transaction context
   * @returns - all key-value pairs in the world state
  */
  async queryAll(ctx) {

    let queryString = {
      selector: {}
    };

    let queryResults = await this.queryWithQueryString(ctx, JSON.stringify(queryString));
    return queryResults;

  }

  /**
     * Evaluate a queryString
     *
     * @param {Context} ctx the transaction context
     * @param {String} queryString the query string to be evaluated
    */
  async queryWithQueryString(ctx, queryString) {

    console.log('query String');
    console.log(JSON.stringify(queryString));

    let resultsIterator = await ctx.stub.getQueryResult(queryString);

    let allResults = [];

    // eslint-disable-next-line no-constant-condition
    while (true) {
      let res = await resultsIterator.next();

      if (res.value && res.value.value.toString()) {
        let jsonRes = {};

        console.log(res.value.value.toString('utf8'));

        jsonRes.Key = res.value.key;

        try {
          jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
        } catch (err) {
          console.log(err);
          jsonRes.Record = res.value.value.toString('utf8');
        }

        allResults.push(jsonRes);
      }
      if (res.done) {
        console.log('end of data');
        await resultsIterator.close();
        console.info(allResults);
        console.log(JSON.stringify(allResults));
        return JSON.stringify(allResults);
      }
    }
  }

  /**
  * Query by the main objects in this app: ballot, election, votableItem, and Voter.
  * Return all key-value pairs of a given type.
  *
  * @param {Context} ctx the transaction context
  * @param {String} objectType the type of the object - should be either ballot, election, votableItem, or Voter
  */
  async queryByObjectType(ctx, objectType) {

    let queryString = {
      selector: {
        type: objectType
      }
    };

    let queryResults = await this.queryWithQueryString(ctx, JSON.stringify(queryString));
    return queryResults;

  }
  async queryByData(ctx, data) {

    let queryString = {
      selector: {
        ...JSON.parse(data)
      }
    };

    let queryResults = await this.queryWithQueryString(ctx, JSON.stringify(queryString));
    return queryResults;

  }
}
module.exports = MyAssetContract;
