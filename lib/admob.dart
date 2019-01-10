import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
class ads {
  InterstitialAd myInterstitial;
  MobileAdTargetingInfo targetingInfo;


  ads() {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4855672100917117~9947628709");
   this.myInterstitial = InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: "ca-app-pub-4855672100917117/8397553945",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
   this.targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flipkart', 'amazon', 'buy', 'e commerce', 'shop'],

      childDirected: true,

      testDevices: <String>[], // Android emulators are considered test devices
    );
  }

  void click(){
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
      );
  }
}
