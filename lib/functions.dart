// ignore_for_file: overridden_fields, duplicate_ignore

import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as maplauncher;
import 'dart:ui' as ui;

const String iamhere = 'assets/icons/buradayim.svg';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
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
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

class CustomBoxShadow extends BoxShadow {
  // ignore: overridden_fields
  @override
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}

bool toBoolean(String str, [bool strict = false]) {
  if (strict == true) {
    return str == '1' || str == 'true';
  }
  return str != '0' && str != 'false' && str != '';
}

Future<Future> showmodalmaps(lat, lng, name, context) async {
  var google =
      await maplauncher.MapLauncher.isMapAvailable(maplauncher.MapType.google);
  var apple =
      await maplauncher.MapLauncher.isMapAvailable(maplauncher.MapType.apple);
  var yandex = await maplauncher.MapLauncher.isMapAvailable(
      maplauncher.MapType.yandexMaps);
  var yandexnavi = await maplauncher.MapLauncher.isMapAvailable(
      maplauncher.MapType.yandexNavi);
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
             Text(
              "chooseapp".tr(),
              style:const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            apple!
                ? ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/mapicons/apple.svg",
                      height: 30,
                    ),
                    title: const Text('Apple Haritalar'),
                    onTap: () async {
                      await maplauncher.MapLauncher.showMarker(
                        mapType: maplauncher.MapType.apple,
                        coords: maplauncher.Coords(lat, lng),
                        title: name,
                      );
                    },
                  )
                : const Center(),
            const SizedBox(
              height: 4,
            ),
            google!
                ? ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/mapicons/google.svg",
                      height: 30,
                    ),
                    title:  Text('googlemaps'.tr()),
                    onTap: () async {
                      await maplauncher.MapLauncher.showMarker(
                        mapType: maplauncher.MapType.google,
                        coords: maplauncher.Coords(lat, lng),
                        title: name,
                      );
                    },
                  )
                : const Center(),
            const SizedBox(
              height: 4,
            ),
            yandex!
                ? ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/mapicons/yandex.svg",
                      height: 30,
                    ),
                    title:  Text('yandexmaps'.tr()),
                    onTap: () async {
                      await maplauncher.MapLauncher.showMarker(
                        mapType: maplauncher.MapType.yandexMaps,
                        coords: maplauncher.Coords(lat, lng),
                        title: name,
                      );
                    },
                  )
                : const Center(),
            yandexnavi!
                ? ListTile(
                    leading: SvgPicture.asset(
                      "assets/icons/mapicons/yandexnavi.svg",
                      height: 30,
                    ),
                    title: const Text('Yandex Navi'),
                    onTap: () async {
                      await maplauncher.MapLauncher.showMarker(
                        mapType: maplauncher.MapType.yandexNavi,
                        coords: maplauncher.Coords(lat, lng),
                        title: name,
                      );
                    },
                  )
                : const Center(),
            const SizedBox(
              height: 30,
            )
          ],
        );
      });
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName, int size) async {
  var svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  var svgDrawableRoot = await svg.fromSvgString(svgString, assetName);
  // ignore: use_build_context_synchronously
  var queryData = MediaQuery.of(context);
  var devicePixelRatio = queryData.devicePixelRatio;
  var width = size * devicePixelRatio;
  var height = size * devicePixelRatio;
  var picture = svgDrawableRoot.toPicture(size: Size(width, height));
  var image = await picture.toImage(width.toInt(), height.toInt());
  var bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

  Future<BitmapDescriptor> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List img = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(img);
  }