import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paragliding/provider/flight_provider.dart';
import 'package:paragliding/screen/home.dart';
import 'package:paragliding/screen/widget/tap_tool_tip.dart';

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
      flightProvider.addListener(updateScreen);
      flightProvider.tiltTimer();
  }

  @override
  void dispose() {
    flightProvider.timer.cancel();
    flightProvider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthMedia = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      color: flightProvider.isWarning ? kWarningColor : kGray,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: widthMedia * 0.5,
                left: -widthMedia,
                child: Transform.scale(
                  scale: 2,
                  child: Hero(
                    tag: 'cloud1',
                    child: Image.asset(
                      'assets/cloud.png',
                      width: widthMedia,
                      color: kWhite,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: widthMedia * 0.5,
                left: -150,
                child: Transform.scale(
                  scale: 2,
                  child: Hero(
                    tag: 'cloud2',
                    child: Image.asset(
                      'assets/cloud.png',
                      width: widthMedia,
                      color: kWhite,
                    ),
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
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  flightProvider.isWarning ?
                  Text(
                    'WARNING',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter',
                      color: kWhite,
                    ),
                  ) :
                  Text(
                    'SAFE',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter',
                      color: kBlack,
                    ),
                  ),
                  SizedBox(height: 100,),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: -(flightProvider.tilt[0] / 9.8) * (pi / 4),
                    ),
                    duration: Duration(milliseconds: 400),
                    builder: (context, angle, child) {
                      return Transform.rotate(
                        angle: angle,
                        child: Image.asset(
                          'assets/paraglider_wing.png',
                          width: widthMedia * 0.6,
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 75,),
                  flightProvider.isWarning ?
                  Text(
                    '비정상적인 비행 중입니다',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'inter',
                      color: kBlack,
                    ),
                  ) :
                  Text(
                    '정상적인 비행 중입니다',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'inter',
                      color: kBlack,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 15,
                right: 15,
                child: TapTooltip(
                  message: '꾹 눌러 주세요',
                  child: GestureDetector(
                    onLongPress: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(),));
                    },
                    child: Text(
                      '종료하기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'inter',
                        color: kBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
