# Introduction

Cwatch is a platform for Climate research, education and information. We created this platform in order to bridge the gap between Africa and the rest of the world in climate change research and information. 

Access to air quality data in a region is very important as it enables researchers and the government to carry out experiments and create policies to control the air pollution and predict patterns in the region. For example, some researchers were able to describe the potential damages caused by climate change in a region by examining historical air quality data of the city. Research such as this would better equip the government on how to tackle climate change. However, this is severely lacking in Sub-Saharan Africa. According to the United Nations, some of the main challenges for African countries regarding climate change is low access to technology. This technology comes in various forms, one of the forms is devices for measuring air quality.

An example of this problem can be seen from “waqi.info”. A website that provides real-time air quality information in regions across the world. All the west African states whose data they had come from the US Embassy in that region which provides data of the embassy alone and not of other regions in that state. Another example of this can be seen in “aqicn.org”, another data aggregator whose latest information on Air quality in the Nigerian states came from 2013, and others dating back to 2009. This proves that with such lack of data access, proper research cannot be done which means the government cannot carry out its duties appropriately.

## Our solution

We built inexpensive air quality measuring devices that logs information about the air in an environment. This device measures the air quality and stores the data both locally on an SD card and on the IBM Cloud, measurement occurs as specified intervals which can be altered by the user when they log on to the console from either the website or the mobile app. These devices are placed at various locations across the city and every user has access to each device. Current available countries where the device is active are: Nigeria, Ghana, Ivory Coast.

The device sensors include PM Sensor, Humidity Sensor, Temperature Sensor, Pressure sensor, Ozone Sensor.

It makes use of on Arduino Mega as the controller, the on-board storage is an SD card module and data is sent from the device to the cloud via a SIM card module, Bluetooth and Wi-Fi are also available for remote troubleshooting.
To access the data stored on the cloud, the user has to log in to the mobile app or the web app where a console would be showed to them that has the data of their location of interest. In this case, Abuja, Nigeria.

By giving them access to this information, users can set reminders and check the air situation of a location before visiting there.
Alternate solutions:
There are individual data collectors for very different states in West Africa, however, there is no single platform for data sharing and data research. Our platform aims to close that gap with the developing world.



## Road Map
![Asset 9 (1)](https://user-images.githubusercontent.com/30829595/130590818-119478b2-7e2a-4922-aa92-63155948835f.png)

## Hardware demo:
https://youtu.be/lXsG0UJCAFQ

## Software Demo:
https://youtu.be/vT3eVK5M9GA
