/* eslint-disable max-len */
/* eslint-disable @typescript-eslint/no-var-requires */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// import * as moment from "moment";
import * as moment from "moment-timezone";
import * as axios from "axios";
const ax=axios.default;
// eslint-disable-next-line max-len

// eslint-disable-next-line no-multi-str
// eslint-disable-next-line max-len
// eslint-disable-next-line require-jsdoc

admin.initializeApp({
  credential: admin.credential.cert(require("../src/cwatch-2c7b9-firebase-adminsdk-276kr-7f08e4774b.json")),
  databaseURL: "https://cwatch-2c7b9-default-rtdb.firebaseio.com/",
});
// admin.initializeApp();
export const sendFakeData=functions.
    https.onCall((requestData)=> {
      const sentData=requestData["data"];
      // console.log(sentData);
      const reference=admin.database().ref("Database");
      reference.set(sentData);
    }
    );

export const getWeatherAPI=functions.https.onCall(async (request)=>{
  const location=request.location;
  const dateTime=request.date;

  const stuff=await admin.firestore().doc(`${location}/${dateTime}`).get()
      .then(async (val)=>{
        if (val.exists) {
          return val.data();
        } else {
          const latitude=request.latitude;
          const APIKEY = "6489a7ca3aa40421818eb351a8f77b6a";
          const longitude=request.longitude;
          const url =
          `https://api.openweathermap.org/data/2.5/onecall?lat=${latitude}&lon=${longitude}&exclude={minutely,hourly,alerts}&appid=${APIKEY}`;
          const data= await ax.get(url).then(async (value)=>{
            await admin.firestore().doc(`${location}/${dateTime}`).set(value.data);
            return value.data;
          });
          return data;
        }
      });
  return stuff;
});
export const retrieveParticularData=functions.
    https.onCall(async (request)=>{
      const location=request["location"];
      const date=request["date"];
      const value=await admin.database().ref(`Database/allData/${location}/${date}`).get()
          .then((data)=>{
            if (data.exists()) {
              return data.val();
            }
          }).catch((error)=>console.log(error));
      return value;
    });
export const retrieveAllData=functions.
    https.onCall(async (requestData)=>{
      const dates:string[]=requestData["dates"];
      const reference=admin.database().ref("Database/allData");
      // reference.transaction((db){
      // })
      //  if it's today's data the user wants to see, then ref.on child added at today's date
      console.log(`looking for: ${dates[0]}`);
      const dayValues=new Map();
      let thing :{[index: string]:any}={};
      if (dates.length>1) {
        console.log("getting all data");
        thing= reference.once("value").then((snap)=>{
          console.log(snap.val());
          return snap.val();
        });
        return thing;
      } else if (dates.length==1) {
        let reference=admin.database().ref(`Database/allData/Abidjan/${dates[0]}`);
        let value= await reference.get().
            then((data)=>{
              if (data.exists()) {
                return data.val();
              } else console.log("data doesnt exist");
            })
            .catch((error)=>console.log(error));
        reference.once("child_added", (snapshot)=>{
          return snapshot.val();
        });
        dayValues.set("Abidjan", value);
        reference=admin.database().ref(`Database/allData/Abuja/${dates[0]}`);
        value= await reference.get().
            then((data)=>{
              if (data.exists()) {
                return data.val();
              } else console.log("data doesnt exist");
            })
            .catch((error)=>console.log(error));
        reference.once("child_added", (snapshot)=>{
          return snapshot.val();
        });
        dayValues.set("Abuja", value);
        reference=admin.database().ref(`Database/allData/Accra/${dates[0]}`);

        value= await reference.get().
            then((data)=>{
              if (data.exists()) {
                return data.val();
              } else console.log("data doesnt exist");
            })
            .catch((error)=>console.log(error));
        reference.once("child_added", (snapshot)=>{
          return snapshot.val();
        });
        dayValues.set("Accra", value);
        const object:{[index: string]:any}={};
        // console.log(JSON.stringify(dayValues.entries()));
        // let jsonObject;
        dayValues.forEach((value, key) => {
          object[key] = value;
        });
        console.log(object);
        return object;
      }
      return [];
    });


export const setData=functions.pubsub.schedule("0 * * * *")
    .timeZone("Africa/Lagos")
    .onRun((context)=>{
      // 0 * * * *
      // const currentDateTIme=moment().tz("Africa/Lagos");
      // ( context.timestamp);
      // if current hour=between this and that.
      const hourString=moment(context.timestamp).tz("Africa/Lagos").format("H");
      const hourFormat=moment(context.timestamp).tz("Africa/Lagos").format("MMM DD YYYY H:00:00:0000");
      const dayFormat=moment(context.timestamp).tz("Africa/Lagos").format("MMM DD YYYY 00:00:00:0000");
      const hourEpoch=moment(hourFormat).tz("Africa/Lagos").valueOf()*1000;
      const dayEpoch=moment(dayFormat).tz("Africa/Lagos").valueOf()*1000;

      const hour=Number.parseInt(hourString);

      const locations=["Abuja", "Abidjan", "Accra"];
      // console.log(`context. timestamp is: ${context.timestamp}`);
      // const date=moment(context.timestamp).tz("Africa/Lagos");
      // const day=moment(context.timestamp).tz("Africa/Lagos");
      // convert hour to timestamp

      // const iotTime=Number.parseInt(moment(context.timestamp).tz("Africa/Lagos").format("H"));
      // const jsonString=JSON.stringify(hourlyData);

      // set data
      locations.forEach((city) => {
        const hourlyData=getData(hour);
        const reference=admin.database().ref(`Database/allData/${city}/${dayEpoch}/${hourEpoch}`);
        reference.set(hourlyData);
        console.log(`current hour data for hour ${hour} in epoch it is ${hourEpoch}, for day: ${dayEpoch}, for location: ${city}`);
      });
    });


export const getPrediction=functions.
    https.onCall(async (requestData)=>{
      const location=requestData.location;
      const previous5days:[string]=requestData.previousDaysEpoch;
      const previous5hoursEpoch:[string]=requestData.hourEpoch;
      const all5daysData:any[]=[];
      // console.log(location);
      // console.log(previous5days);
      // console.log(previous5hoursEpoch);
      for (let index = 0; index < 5; index++) {
        const day = previous5days[index];
        const currentTimeDay = previous5hoursEpoch[index];
        // get previous 5 days
        // console.log(`Database/allData/${location}/${day}/${currentTimeDay}`);
        await admin.database().
            ref(`Database/allData/${location}/${day}/${currentTimeDay}`).get()
            .then((value)=> {
              console.log(value.val());
              all5daysData.push(value.val());
            }).catch((error)=>console.log(error));
      }
      console.log(all5daysData);
      return all5daysData;
    });


// eslint-disable-next-line require-jsdoc
function getData(hour:number) {
  const hourlyData:{[index: string]:any}={};
  let minTemp:number;
  let maxTemp:number;
  let temperature = 0;
  let atmPressure = 0;
  let pm25=0;
  let ozone=0;
  atmPressure=Math.floor(Math.random() * (32 - 23 + 1) + 23);
  ozone=Math.random()* (0.054 - 0.049)+ 0.049;
  const humidity=Math.floor(Math.random() * (91 - 85 + 1) + 85);


  if (hour>=21 || hour <=6) {
    // coldest
    minTemp = Math.ceil(21);
    maxTemp = Math.floor(25);
    temperature=Math.floor(Math.random() * (maxTemp - minTemp + 1) + minTemp);
    pm25=Math.floor(Math.random()* (55-40)+40);
  }

  if (hour>=7 && hour<=9) {
    // warmer
    minTemp = Math.ceil(23);
    maxTemp = Math.floor(27);
    temperature=Math.floor(Math.random() * (maxTemp - minTemp + 1) + minTemp);
    pm25=Math.floor(Math.random()* (65-60)+60);
  }

  if ( hour>=10 && hour <=14) {
    // hottest
    minTemp = Math.ceil(28);
    maxTemp = Math.floor(32);
    temperature=Math.floor(Math.random() * (maxTemp - minTemp + 1) + minTemp);
    pm25=Math.floor(Math.random()* (70-65)+65);
  }

  if (hour>=15 && hour<= 17) {
    // coming down
    minTemp = Math.ceil(23);
    maxTemp = Math.floor(27);
    temperature=Math.floor(Math.random() * (maxTemp - minTemp + 1) + minTemp);
    pm25=Math.floor(Math.random()* (70-65)+65);
  }

  if (hour>=18 && hour <= 20) {
    // coming down again
    minTemp = Math.ceil(23);
    maxTemp = Math.floor(27);
    temperature=Math.floor(Math.random() * (maxTemp - minTemp + 1) + minTemp);
    pm25=Math.floor(Math.random()* (70-65)+65);
  }
  hourlyData["temperature"]=temperature.toString();
  hourlyData["pressure"]=atmPressure.toString();
  hourlyData["pm"]=pm25.toString();
  hourlyData["ozone"]=ozone.toFixed(2).toString();
  hourlyData["humidity"]=humidity.toString();
  return hourlyData;
}

