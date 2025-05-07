import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paragliding/common/string.dart';
import 'package:paragliding/screen/flight.dart';

HomeProvider homeProvider = HomeProvider();

class HomeProvider extends ChangeNotifier {

  bool isToggled = false;
  Timer? delayTimer;

  void toggle(BuildContext context) {
    isToggled = !isToggled;
    MethodChannel(channelKey).invokeMethod('isToggled', 'isToggled');
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Flight(),));
  }

}