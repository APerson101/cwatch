import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          child: SingleChildScrollView(
              child: Column(
        children: [whoarewe(), problemweSaw(), oursolution()],
      ))),
    );
  }

  whoarewe() {
    return Column(
      children: [Text("WHO ARE WE"), Text("Bunch of idiots to be frank")],
    );
  }

  problemweSaw() {
    return Column(
      children: [
        Text('PROBLEMS WE SAW'),
        Text(
            "According to the United Nations, one of the major obstacles that prevents Africa from catching up with the rest of the world in Air quality research and climate change actions is due lack of air quality data and air measuring devices. A clear example of this can be seen from the website “aqicn.org” which is a data provider that provides data on air quality around the world. Their most recent data regarding Nigeria and most of the west African countries came from 2013 and 2009. A lot has changed since then but there is no way for aqicn.org to get the latest information on those countries and the air quality situation there. We aim to bridge that gap and provide the data that would help form policies and actions to better handle the poor air quality in Africa."),
        Text(
            "Carrying out machine learning research is one of the major ways in which air quality research is done and the backbone of any machine learning research is data. In 2018, a group of researchers were able to raise awareness of the  future air-pollution-related health damages in eastern United States by training a machine learning model using historical air quality data of the region. This led them to the conclusion that “ without intervention, approximately 5%–9% of exacerbated air-pollution-related mortality will be due to increases in power sector emissions from heat-driven building electricity demand. This analysis highlights the need for cleaner energy sources, energy efficiency, and energy conservation to meet our growing dependence on building cooling systems and simultaneously mitigate climate change”. However, research like that are impossible in sub-saharan Africa. We aim to bridge that gap by providing the data for interested individuals to carry out research and to also carry out research ourselves in order to predict patterns and trends in the air pollution and climate change in Africa."),
        Text(
            "Research shows that poor air quality can trigger asthma. Asthma is one of the neglected diseases in Africa with a high prevalence. Allergic fungal diseases have been reported to complicate asthma progression and treatment outcomes. However, data about fungal asthma and its associated complications are limited in Africa. Asthma patients in other countries rely on local weather data to report on the air quality. However, in Africa there is no such report on the local weather station, we aim to bridge this gap by enabling asthma patients and other users to view live data and set daily notifications for certain conditions. "),
      ],
    );
  }

  oursolution() {
    return Column(
      children: [
        Text("What we are doing about it"),
        Text(
            "We created low cost air quality measuring device that is able to withstand harsh weather conditions and runs on renewable solar energy. These devices are placed in both urban and rural areas in  states in Nigeria, Ghana, Ivory Coast with more countries to be added. Our device senses the following: Particulate Matter, Ozone, Temperature, Humidity, Atmospheric Pressure, gas. It measures them at intervals and sends the data to our database. The user interested in this data can access it via the web or via a mobile app available on Android,  iOS, IpadOS and  HarmonyOS. Our data is downloadable which enables the user use them in machine learning applications. "),
        Text(
            "with the use of Aritifial Intelligence and Machine Learning, we are predicting future air quality and pollution situation of the locations and we are making this data accessible to all individuals especially those we need such information for medical reasons"),
        Text(
            "we are working with research insitutions such as Afe Babalola University to investigate where researchers think our devices are needed more and how to provide more data for the researchers")
      ],
    );
  }
}
