// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void distance(double ulat, ulon, slat, slong) {
    distanceInMeters = Geolocator.distanceBetween(ulat, ulon, slat, slong);
    bearing = Geolocator.bearingBetween(ulat, ulon, slat, slong);
    if (bearing < 0) {
      setState(() {
        bearing = 360 + bearing;
      });
    }
    return;
  }

  TextEditingController latController = TextEditingController();
  TextEditingController lanController = TextEditingController();
  double mLat = 0;
  double sitLat = 0;
  double sitLong = 0;
  double distanceInMeters = 0;
  double bearing = 0;
  double angle = 0;
  double mLong = 0;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        title: Text(
          '‏إعداد وتطوير الرائد حمزة الغويري',
          style: titlestyleCategory,
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: isloading
            ? const LinearProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Column(
                              children: [
                                TextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  controller: latController,
                                ),
                                Text('‏شرقيات', style: titlestyle),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Column(
                              children: [
                                TextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  controller: lanController,
                                ),
                                Text(' ‏شماليات', style: titlestyle),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Neomphorm(
                          child:
                              Text(mLat.toStringAsFixed(5), style: titlestyle),
                          width: .4,
                        ),
                        Neomphorm(
                          child:
                              Text(mLong.toStringAsFixed(5), style: titlestyle),
                          width: .4,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NeomphormDark(
                        child: Text(
                            'Distance is ${distanceInMeters.toStringAsFixed(1)}',
                            style: titlestyle),
                        width: .7,
                        color: Colors.red.shade200,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NeomphormDark(
                        child: Text(
                            'Angle is ${bearing.toStringAsPrecision(3)}',
                            style: titlestyle),
                        width: .7,
                        color: Colors.green.shade200,
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });

                          Position position = await _determinePosition();
                          setState(() {
                            isloading = false;
                            sitLat =
                                // latController.text as double;
                                double.parse(latController.text.toString());
                            assert(sitLat is double);
                            sitLong =
                                //  lanController.text as double;

                                double.parse(lanController.text.toString());
                            assert(sitLong is double);
                            mLat = position.latitude;
                            mLong = position.longitude;
                          });
                          // print(sitLat.toString());
                          // print(sitLong.toString());
                          distance(mLat, mLong, sitLat, sitLong);
                          // angle = (atan((mLong - sitLong) / (mLat - sitLat)));
                          // print(atan((1 / sqrt(3))).toString());
                          // print(atan(30 * pi / 180));
                          // print(bearing.toString());
                        },
                        icon: const Icon(Icons.map),
                        label: NeomphormDark(
                          child: Text('Calculate', style: titlestyle),
                          color: Colors.yellow.shade200,
                          width: .5,
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  var titlestyle = const TextStyle(
    decorationColor: Colors.red,
    color: Colors.indigo,
    decorationThickness: 3,
    fontStyle: FontStyle.normal,
    // fontFamily: 'NizarBBCKurdish',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  var titlestyleCategory = const TextStyle(
    decorationColor: Colors.green,
    color: Colors.blue,
    decorationThickness: 3,
    fontStyle: FontStyle.normal,
    fontFamily: 'NizarBBCKurdish',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

class Neomphorm extends StatelessWidget {
  // final String title;
  final double width;
  final Widget child;
  const Neomphorm(
      {Key? key,
      // required this.title,
      required this.width,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * width,
        child: Center(child: child),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          // shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(4, 7),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white12,
              offset: Offset(-7, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class NeomphormDark extends StatelessWidget {
  // final String title;
  final double width;
  final Widget child;
  final Color color;
  const NeomphormDark(
      {Key? key,
      // required this.title,
      required this.width,
      required this.child,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * width,
        child: Center(child: child),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
          // shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: color,
              offset: const Offset(4, 7),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white12,
              offset: Offset(-7, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
