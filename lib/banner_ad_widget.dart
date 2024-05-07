import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidget();
}

class _BannerAdWidget extends State<BannerAdWidget> {
  late final BannerAd banner;

  @override
  void initState() {
    super.initState();

    final adUnitId = Platform.isIOS
    ? 'ca-app-pub-3940256099942544/2934735716'  //temp iOS id
    : 'ca-app-pub-4116817706973954/5644190177'; //Android ad id //message_bottle

    //광고 생성
    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,

      listener: BannerAdListener(onAdFailedToLoad: (ad, error){
        ad.dispose();
      }),
      request: AdRequest(),
    );

    banner.load();
  }

  @override
  void dispose() {
    banner.dispose();   //위젯 dispose되면 광고도 dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,

      child: AdWidget(ad: banner),
    );
  }


}
