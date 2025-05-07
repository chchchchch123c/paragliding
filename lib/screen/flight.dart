import 'package:flutter/material.dart';
import 'package:paragliding/provider/flight_provider.dart';

import '../common/color.dart';

class Flight extends StatefulWidget {
  const Flight({super.key});

  @override
  State<Flight> createState() => _TestState();
}

class _TestState extends State<Flight> {

  void updateScreen() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      flightProvider.addListener(updateScreen);
    },);
  }

  @override
  void dispose() {
    flightProvider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthMedia = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kGray,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: widthMedia,
              height: 50,
              child: Row(
                children: [
                  SizedBox(width: 15,),
                  Text(
                    'SAFE Paraglider',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'inter',
                        color: kWhite
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
