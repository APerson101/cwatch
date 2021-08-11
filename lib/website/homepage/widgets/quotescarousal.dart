import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class QuotesCarousal extends StatelessWidget {
  double carousalheight;
  QuotesCarousal({Key? key, required this.carousalheight}) : super(key: key);
  List<Quote> allqoutes = [];

  @override
  Widget build(BuildContext context) {
    allqoutes.add(Quote(
        mainQuote:
            'There is a high prevalence of fungal sensitization among Africans with asthma. Fungal asthma is a significant problem in Africa but there remains a paucity of data on the epidemiology and associated complications. There is urgent need for national epidemiological studies to estimate the actual burden of fungal asthma in Africa.',
        source: "US National Library of Medicine Research",
        link: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6521988/"));
    allqoutes.add(Quote(
        mainQuote:
            'From the standpoint of the Economic Commission for Africa (ECA), some of the main challenges to responding to climate change in Africa are the low levels of access to technology…',
        source: "United Nations",
        link:
            "https://www.un.org/en/chronicle/article/climate-change-around-world-view-un-regional-commissions"));
    allqoutes.add(Quote(
        mainQuote:
            'Unfortunately, there is not any kind of information available from the Federal Ministry of the Environment (www.environment.gov.ng) about Air Quality, whether it relates to a possible monitoring network, or to the actual values recorded by this monitoring network. To our current knowledge, there should most likely not be any kind of automated monitoring network available.',
        source: "aqicn.org on Nigeria",
        link: "https://aqicn.org/country/nigeria/"));
    allqoutes.add(Quote(
        mainQuote:
            'In 2015, exposure to particulate matter in sub-Saharan Africa led to 400,000 otherwise preventable infant deaths',
        source: "Stanford University.",
        link:
            "https://news.stanford.edu/2018/06/27/air-pollution-major-cause-infant-deaths-sub-saharan-africa/"));
    return CarouselSlider(
      options: CarouselOptions(
          height: carousalheight,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 7)),
      items: allqoutes.map((e) {
        return Builder(builder: (BuildContext context) {
          return Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(e.mainQuote),
              Text('source ' + e.source),
              Text(e.link),
            ],
          ));
        });
      }).toList(),
    );
  }
}

class Quote {
  String mainQuote;
  String source;
  String link;
  Quote({
    required this.mainQuote,
    required this.source,
    required this.link,
  });
}
