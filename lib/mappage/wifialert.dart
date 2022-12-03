

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/locations.dart';

Future<void> wifiAlert(locations,latLng,context) async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 4000));
    int count = getwifilist(locations,latLng);
    if (count > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Wrap(
            runSpacing: 10,
            children: [
              Image.asset("assets/images/logo.png"),
              const Text(
                'Şuanda WizmirNET çekim alanındasınız.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kapat'))
          ],
        ),
      );
    }
  }

   int getwifilist(locations,latLng) {
    List<Locations> wifilist = locations!
        .where((element) => getDist(element.lat, element.lng,latLng) < 0.1)
        .toList();
    return wifilist.length;
  }

    double getDist(lat, lng, latLng) {
    var dist = Geolocator.distanceBetween(
                lat, lng, latLng!.latitude, latLng!.longitude)
            .ceilToDouble() /
        1000;
    return dist.ceilToDouble();
  }