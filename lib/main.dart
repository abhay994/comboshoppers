import 'package:flutter/material.dart';

import 'package:carousel_pro/carousel_pro.dart';

import 'package:advanced_share/advanced_share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'admob.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primaryColor: new Color(0xffffffff),
        accentColor: new Color(0xFFAB00B5),
      ),
      color: Color(0xFFAB00B5),
      title: 'ComboShopper',
      debugShowCheckedModeBanner: false,
      home:Shop(),




    );
  }
}
class Shop extends StatefulWidget {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> with SingleTickerProviderStateMixin{

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['shop', 'buy', 'ecommerce',"flipkart","combo"],
    birthday: new DateTime.now(),
    childDirected: true,
  );


  /*BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        targetingInfo: targetInfo,

        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }*/
  //ca-app-pub-4855672100917117~9947628709 ,"ca-app-pub-4855672100917117/8397553945","ca-app-pub-4855672100917117/6260499281"

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: "ca-app-pub-4855672100917117/8397553945" ,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = new TabController(vsync: this,initialIndex: 0, length: 5);
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4855672100917117~9947628709");

    Future.delayed(const Duration(milliseconds: 1000*20), () {

// Here you can write your code

      setState(() {
        // Here you can write your code for open new view
        createInterstitialAd()
          ..load()
          ..show();
      });

    });
    setState(() {

    });
  }




  @override
  void dispose() {

    _interstitialAd.dispose();

    super.dispose();
  }

  void handleResponse(response, {String appName}) {
    if (response == 0) {
      print("failed.");
    } else if (response == 1) {
      print("success");
    } else if (response == 2) {
      print("application isn't installed");
      if (appName != null) {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("${appName} isn't installed."),
          duration: new Duration(seconds: 4),
        ));
      }
    }
  }


  @override
  Widget build(BuildContext context) {




    Widget image_carousel = new Container(
      height: 200.0,
      child:  new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/w3.jpeg'),
          AssetImage('images/m1.jpeg'),
          AssetImage('images/c1.jpg'),
          AssetImage('images/w4.jpeg'),
          AssetImage('images/m2.jpg'),

        ],


        autoplay: true,
//      animationCurve: Curves.fastOutSlowIn,
     animationDuration: Duration(milliseconds: 5000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
      ),
    );




    return  SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFE5E5E5),
          appBar: AppBar(
            title: Text("ComboShopper",style: new TextStyle(color: Colors.black,fontSize: 20.0),),
           
            backgroundColor: Colors.white,
             bottom: new TabBar(
               isScrollable: true,
         controller: _tabController,

          indicatorColor: Color(0xFFAB00B5),

          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.dashboard),),
            new Tab(text: "Men"),
            new Tab(
                text: "Women"

            ),
            new Tab(
              text: "kids",
            ),
            new Tab(
              text: "More..",
            ),
          ],





       ),


          ),
          
          body:  new TabBarView(
            controller: _tabController,
            children: <Widget>[
             myproduct(),
             myproductc("m"),
             myproductc("w"),
             myproductc("k"),
             myproductc("o"),
            ],

          ),


         
          floatingActionButton: FloatingActionButton(

            onPressed: () {

               generic();
            },

            tooltip: 'Share',

            backgroundColor: Color(0xFFAB00B5),
            child: Icon(Icons.share),
            elevation: 6.0,
            mini: true,


          ),
          bottomNavigationBar: BottomAppBar(
            color: Color(0xFFFFFFFF),
            shape: CircularNotchedRectangle(),
            child: Container(height: 30.0, ),
            notchMargin: 2.5,



          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

    ),
    );


  }
  void generic() {

    createInterstitialAd()
      ..load()
      ..show();
    AdvancedShare.generic(msg: "avail new combo-deals on e-commerce sites! download the app now link:(https://play.google.com/store/apps/details?id=comboshopper.com.ar.comboshoppers)",).then((response) {
      handleResponse(response);
    });
  }


}



Widget myproduct(){

  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('onlinestore').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading...');
        default:

          return new OrientationBuilder(builder: (context,orientation){

            return new GridView.count(

              primary: false,
              crossAxisCount: orientation == Orientation.portrait ? 2:4,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              children: snapshot.data.documents.map((DocumentSnapshot document) {

                String name = document['name'].toString();
                String price_new = document['new'].toString();
                String price_old = document['old'].toString();
                String price_url = document['url'].toString();
                String price_image = document['image'].toString();
                return InkWell(
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 1000*15), () {

// Here you can write your code

                      ads().click();

                    });
                    launch(price_url);
                  },
                  child: Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            document['image'].toString(), fit: BoxFit.fitWidth,
                            height: orientation == Orientation.portrait ? 149:130 ),
                          new Padding(padding: EdgeInsets.all(1.0),
                            child: Row(
                              children: <Widget>[


                                Expanded(child: Text(
                                  "₹" + price_new,
                                  style: TextStyle(
                                      color: Color(0xFFAB00B5),
                                      fontWeight: FontWeight.w500),
                                ),


                                ),

                                Expanded(child: Text(
                                  "₹" + price_old,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      decoration
                                          : TextDecoration.lineThrough),
                                ),
                                ),
                                Expanded(child:GestureDetector(
                                  onTap: (){
                                    AdvancedShare.generic(msg:(price_url)+"\n avail new combo-deals on e-commerce sites! download the app now link:\n(https://play.google.com/store/apps/details?id=comboshopper.com.ar.comboshoppers)").then((response) {
                                      print(response);
                                    });
                                  },
                                  child: Icon(Icons.share,
                                    size: 20.0,),
                                ),


                                ),

                              ],
                            ),
                          )


                        ],
                      )


                  ),
                );



              }).toList(),




            );














          });
      }

    },
  );



}
Widget myproductc(String ca){

  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('onlinestore').where("ca",isEqualTo: ca).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError)
        return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting: return new Text('Loading...');
        default:
//
          return new OrientationBuilder(builder: (context,orientation){

            return GridView.count(

              primary: false,
              crossAxisCount: orientation == Orientation.portrait ? 2:4,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              children: snapshot.data.documents.map((DocumentSnapshot document) {

                String name = document['name'].toString();
                String price_new = document['new'].toString();
                String price_old = document['old'].toString();
                String price_url = document['url'].toString();
                String price_image = document['image'].toString();
                return InkWell(
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 1000*15), () {

// Here you can write your code

                      ads().click();

                    });


                    launch(price_url);
                  },
                  child: Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            document['image'].toString(), fit: BoxFit.contain,
                            height: orientation == Orientation.portrait ? 149:130,),
                          new Padding(padding: EdgeInsets.all(1.0),
                            child: Row(
                              children: <Widget>[


                                Expanded(child: Text(
                                  "₹" + price_new,
                                  style: TextStyle(
                                      color: Color(0xFFAB00B5),
                                      fontWeight: FontWeight.w500),
                                ),


                                ),

                                Expanded(child: Text(
                                  "₹" + price_old,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      decoration
                                          : TextDecoration.lineThrough),
                                ),
                                ),

                                Expanded(child:GestureDetector(
                                  onTap: (){
                                    AdvancedShare.generic(msg:(price_url)+"\n avail new combo-deals on e-commerce sites! download the app now link:\n(https://play.google.com/store/apps/details?id=comboshopper.com.ar.comboshoppers)").then((response) {
                                      print(response);
                                    });
                                  },
                                  child: Icon(Icons.share,
                                    size: 20.0,
                                  ),
                                ),


                                ),


                              ],
                            ),
                          )


                        ],
                      )


                  ),
                );


                /*Card(
                  child: Hero(
                      tag:  document['name'].toString(),
                     child: Image.network(document['image'].toString(),height: 30,)),
                );*/


                /*  child: Image.network(document['image'].toString(), fit: BoxFit.cover,)*/


                /*new ListTile(
                  title: new Text(document['old'].toString()),
                  subtitle: new Text(document['new'].toString()),
                );*/
              }).toList(),




            );







          });
      }

    },
  );


}
int checkorentatio(){


}

