import 'package:flutter/material.dart';

class OurSolution extends StatelessWidget {
  const OurSolution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("What we are doing about it"),
        Text(
            "We created low cost air quality measuring device that is able to withstand harsh weather conditions and runs on renewable solar energy. These devices are placed in both urban and rural areas in  states in Nigeria, Ghana, Ivory Coast with more countries to be added. Our device senses the following: Particulate Matter, Ozone, Temperature, Humidity, Atmospheric Pressure, gas. It measures them at intervals and sends the data to our database. The user interested in this data can access it via the web or via a mobile app available on Android,  iOS, IpadOS and  HarmonyOS. Our data is downloadable which enables the user use them in machine learning applications. "),
        Text(
            "with the use of Aritifial Intelligence and Machine Learning, we are predicting future air quality and pollution situation of the locations and we are making this data accessible to all individuals especially those we need such information for medical reasons"),
        Text(
            "we are working with research insitutions such as Afe Babalola University to investigate where researchers think our devices are needed more and how to provide more data for the researchers")
      ],
    ));
  }
}
