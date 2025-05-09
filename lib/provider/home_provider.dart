import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paragliding/common/color.dart';
import 'package:paragliding/common/string.dart';
import 'package:paragliding/screen/flight.dart';
import 'package:shared_preferences/shared_preferences.dart';

HomeProvider homeProvider = HomeProvider();

class HomeProvider extends ChangeNotifier {

  bool isToggled = false;
  Timer? delayTimer;

  bool _dialogShown = false;

  bool isCheck = false;

  void toggle(BuildContext context) {
    isToggled = !isToggled;
    MethodChannel(channelKey).invokeMethod('isToggled');
    if (isToggled) {
      delayTimer?.cancel();
      delayTimer = Timer(Duration(seconds: 5), () {
        if (isToggled) {
          onToggledHeld(context);
        }
      },);
    } else {
      delayTimer?.cancel();
    }
    notifyListeners();
  }
  
  void onToggledHeld(BuildContext context) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(opacity: animation, child: Flight());
    },
    transitionDuration: Duration(milliseconds: 600)
    ));
  }

  void togglingCheck() {
    isCheck = !isCheck;
    notifyListeners();
  }

  Future<void> showInitialDialog(BuildContext context) async {
    if (_dialogShown) return;
    _dialogShown = true;

    final sharedPref = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final savedDay = sharedPref.getString('hideDate');

    if (savedDay == now.toIso8601String().substring(0, 10)) return;

    Future.microtask(() {
      showDialog(
        barrierDismissible: false,
        context: context, builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).width * 0.85,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.all(Radius.circular(24))
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            child: Image.asset(
                              'assets/warning_dialog.png',
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          ),
                          SizedBox(height: 15,),
                          Text(
                            '위험 경고 시 당황하지 마세요',
                            style: TextStyle(
                              fontFamily: 'inter',
                              color: kBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 6.5,),
                          Text(
                            textAlign: TextAlign.center,
                            '기울기가 이상하면 자동으로\n경고 알람이 울려요.\n정상적인 상황이니 비행을\n계속하셔도 돼요.',
                            style: TextStyle(
                                fontFamily: 'inter',
                                color: kTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              togglingCheck();
                              setState(() {});
                              if (isCheck) {
                                await sharedPref.setString('hideDate', DateTime.now().toIso8601String().substring(0, 10));
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  isCheck ? Icons.check_circle :
                                  Icons.check_circle_outline,
                                  color: kWhite,
                                  size: 18,
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  '오늘 하루 보지 않기',
                                  style: TextStyle(
                                    fontFamily: 'inter',
                                    color: kWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 1,
                            height: 15,
                            color: kWhite,
                          ),
                          Spacer(flex: 3,),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              '닫기',
                              style: TextStyle(
                                  fontFamily: 'inter',
                                  color: kWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Spacer(flex: 3,),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        );
      },);
    },);
  }

}