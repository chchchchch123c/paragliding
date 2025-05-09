import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paragliding/common/string.dart';

FlightProvider flightProvider = FlightProvider();

class FlightProvider extends ChangeNotifier {

  List<double> tilt = [0, 0, 0];
  late Timer timer;

  Timer? delayTimer;
  bool isWarning = false;

  Future<List<double>> getTilt() async {
    final List<dynamic> result = await MethodChannel(channelKey).invokeMethod('getTilt');
    return result.map((e) => e as double).toList();
  }

  void tiltTimer() {
    bool overThreshold = false;
    DateTime? thresholdStart;

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      List<double> tilt = await getTilt();
      this.tilt = tilt;

      final double x = tilt[0].abs();
      final DateTime now = DateTime.now();

      if (x >= 5) {
        if (!overThreshold) {
          overThreshold = true;
          thresholdStart = now;
        } else if (now.difference(thresholdStart!).inSeconds >= 5 && !isWarning) {
          isWarning = true;
          await playBeeping();
          notifyListeners();
        }
      } else {
        if (overThreshold) {
          overThreshold = false;
          thresholdStart = now;
        } else if (thresholdStart != null && now.difference(thresholdStart!).inSeconds >= 3 && isWarning) {
          isWarning = false;
          await pauseBeeping();
          notifyListeners();
        }
      }
      notifyListeners();
    });
  }

  Future<void> playBeeping() async {
    MethodChannel(channelKey).invokeMethod('isToggled');
    await MethodChannel(channelKey).invokeMethod('playBeeping', 'beeping');
    notifyListeners();
  }

  Future<void> pauseBeeping() async {
    await MethodChannel(channelKey).invokeMethod('pauseBeeping');
    notifyListeners();
  }

  void vibrate() {
    MethodChannel(channelKey).invokeMethod('isToggled');
    notifyListeners();
  }

}