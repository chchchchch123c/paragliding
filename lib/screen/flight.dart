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
        child: Stack(
          children: [
            Positioned(
              bottom: widthMedia * 0.5,
              left: -widthMedia,
              child: Transform.scale(
                scale: 2,
                child: Image.asset(
                  'assets/cloud.png',
                  width: widthMedia,
                  color: kWhite,
                ),
              ),
            ),
            Positioned(
              bottom: widthMedia * 0.5,
              left: -150,
              child: Transform.scale(
                scale: 2,
                child: Image.asset(
                  'assets/cloud.png',
                  width: widthMedia,
                  color: kWhite,
                ),
              ),
            ),
            Column(
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
                SizedBox(height: 75,),
                Text(
                  'SAFE',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'inter',
                    color: kBlack,
                  ),
                ),
                SizedBox(height: 100,),
                Image.asset(
                  'assets/paraglider_wing.png',
                  width: widthMedia * 0.6,
                ),
                SizedBox(height: 100,),
                Text(
                  '정상적인 비행 중입니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'inter',
                    color: kBlack,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
