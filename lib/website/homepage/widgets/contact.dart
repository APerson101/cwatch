import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("email:abdulhadih48@gmail.com"),
        Text("block 3, boffa close, mombassa street, zone 5, wuse"),
        Text("abuja, Nigeria")
      ],
    ));
  }
}
