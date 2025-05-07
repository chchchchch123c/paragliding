import 'package:flutter/material.dart';
import 'package:paragliding/common/color.dart';
import 'package:paragliding/provider/home_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _TestState();
}

class _TestState extends State<Home> {

  void updateScreen() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeProvider.addListener(updateScreen);
    },);
  }

  @override
  void dispose() {
    homeProvider.delayTimer?.cancel();
    homeProvider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthMedia = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: widthMedia,
              height: 50,
              child: Row(
                children: [
                  SizedBox(width: 5,),
                  Image.asset(
                    'assets/paraglider.png',
                    width: 50,
                    color: kWhite,
                  ),
                  SizedBox(width: 5,),
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
            Spacer(),
            GestureDetector(
              onTap: () {
                homeProvider.toggle(context);
              },
              child: Container(
                width: widthMedia * 0.6,
                height: widthMedia * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kWhite.withAlpha(150)),
                ),
                child: Center(
                  child: Container(
                    width: widthMedia * 0.5,
                    height: widthMedia * 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kWhite.withAlpha(200)),
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: widthMedia * 0.45,
                        height: widthMedia * 0.45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 3.5,
                            colors: [kWhite, kBlack,],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kShadowColor,
                              blurRadius: homeProvider.isToggled ? 100 : 0,
                              offset: Offset(0, 0)
                            ),
                          ]
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 15,
                              child: Image.asset(
                                'assets/paraglider.png',
                                width: widthMedia * 0.3,
                                height: widthMedia * 0.3,
                              ),
                            ),
                            Positioned(
                              bottom: 40,
                              child: Text(
                                '비행 시작',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'inter',
                                  color: kBlack
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ), // Circle Button
            SizedBox(height: 30,),
            Theme(
              data: ThemeData(
                useMaterial3: false,
              ),
              child: Transform.scale(
                scale: 1.3,
                child: Switch(
                  thumbColor: WidgetStateProperty.resolveWith((Set states) {
                    if (states.contains(WidgetState.selected)) {
                      return kShadowColor;
                    }
                    return kWhite;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((Set states) {
                    if (states.contains(WidgetState.selected)) {
                      return kTrackColor;
                    }
                    return kGray;
                  }),
                  value: homeProvider.isToggled,
                  onChanged: (value) {
                    homeProvider.toggle(context);
                  },
                ),
              ),
            ),
            Spacer(),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child,);
              },
              child: Text(
                key: ValueKey(homeProvider.isToggled),
                homeProvider.isToggled ?
                '안전 비행 모드가 켜져 있습니다' :
                '버튼을 눌러 안전한 비행을 즐기세요',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'inter',
                    color: kWhite
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child,);
              },
              child: Text(
                key: ValueKey(homeProvider.isToggled),
                homeProvider.isToggled ?
                'The Safe Flight Mode is On' :
                'Press the button and enjoy a Safe Flight',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'inter',
                    color: kTextColor
                ),
              ),
            ),
            SizedBox(
              height: 150,
              width: widthMedia,
              child: Stack(
                children: [
                  Positioned(
                    bottom: -65,
                    left: -60,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Image.asset(
                        'assets/cloud.png',
                        width: widthMedia,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -45,
                    left: -215,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Image.asset(
                        'assets/cloud.png',
                        width: widthMedia,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
