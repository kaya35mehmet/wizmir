import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:octo_image/octo_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:wizmir/drawer.dart';
import 'package:wizmir/functions.dart' as functions;
import 'package:wizmir/mappage/infowindow.dart';
import 'package:wizmir/mappage/wifialert.dart';
import 'package:wizmir/models/importantdays.dart';
import 'package:wizmir/models/locations.dart';
import 'package:wizmir/models/login.dart';
import 'package:wizmir/loginpanel.dart';
import 'package:wizmir/models/nearcluster.dart';
import 'package:wizmir/nearpoints.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MapPage extends StatefulWidget {
  const MapPage(
      {Key? key, required this.title, this.guid, required this.isadmin})
      : super(key: key);

  final String title;
  final String? guid;
  final bool isadmin;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  var storage = const FlutterSecureStorage();
  LatLng? latLng;
  Future<LatLng>? latLngfuture;
  Locations? selectedLocation;
  List<Locations>? locations;
  Set<Marker>? _markers = <Marker>{};
  // BitmapDescriptor? myMarker;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Widget icon = const Icon(Icons.location_on, color: Colors.blue);
  bool? islogin;
  bool? isadmin;
  bool floatingActionButtonvisible = true;
  bool nearlocationsvisible = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final PanelController _pc = PanelController();
  List<NearLocations> nlist = [];
  Marker? selectedMarker;
  bool userview = false;
  late double infoviewheight;

  @override
  void initState() {
    setState(() {
      isadmin = widget.isadmin;
      infoviewheight = widget.isadmin ? 180 : 140;
    });
    if (widget.guid != "0") {
      setState(() {
        islogin = true;
      });
    } else {
      setState(() {
        islogin = false;
      });
    }
    checklocation();
    startTimer();
    super.initState();
  }

  Future<dynamic> getlocation() async {
    try {
      return await functions.determinePosition();
    } catch (e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          // title: const Text(
          //   "Lütfen konum izni veriniz!",
          //   textAlign: TextAlign.center,
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: Image.asset(
                  "assets/icons/warning.png",
                  width: 150,
                ),
              ),
              Text(
                "pleaseenablelocationpermission".tr(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    openAppSettings().then((value) {
                      exit(0);
                      // Restart.restartApp();
                      // SystemNavigator.pop();
                    });

                    //  Map<Permission,PermissionStatus> status = await[Permission.location].request();
                  },
                  child: Text("ok".tr())),
            )
          ],
        ),
      );
    }
  }

  checklocation() async {
    latLngfuture = getData();
  }

  reloadmap() {
    setState(() {
      // latLngfuture = null;
      latLngfuture = getData();
    });
  }

  Future<LatLng> getData() async {
    var dd = await getlocation();
    latLng = LatLng(dd.latitude, dd.longitude);
    locations = await getalllocations();
    locations?.add(Locations(
        lat: dd.latitude,
        lng: dd.longitude,
        antenAdi: "mylocation".tr(),
        aktifmi: true,
        mylocation: true,
        kullanicisayisi: '',
        id: '',
        baslatildi: false));
    // ignore: use_build_context_synchronously
    wifiAlert(
        locations?.where((element) => element.mylocation == false).toList(),
        latLng,
        context);
    nlist = nearlist();
    await Future<dynamic>.delayed(const Duration(milliseconds: 2000));
    return LatLng(dd.latitude, dd.longitude);
  }

  List<NearLocations> nearlist() {
    List<NearLocations> list = [];
    for (Locations element
        in locations!.where((element) => element.mylocation == false)) {
      list.add(NearLocations(
          proximity: Geolocator.distanceBetween(
              latLng!.latitude, latLng!.longitude, element.lat!, element.lng!),
          locations: element));
    }
    list.sort((a, b) => a.proximity.compareTo(b.proximity));
    return list.take(5).toList();
  }

  Future<void> generateMarkers(context, current) async {
    var localMarkers = <Marker>{};
    for (var location in locations!) {
      var dist = Geolocator.distanceBetween(
          location.lat!, location.lng!, latLng!.latitude, latLng!.longitude);
      localMarkers.add(
        Marker(
            onTap: () {
              if (!location.mylocation) {
                _customInfoWindowController.addInfoWindow!(
                  InfoWindowScreen(
                    location: location,
                    islogin: islogin!,
                    isadmin: isadmin!,
                    callback: _callbackinfoview,
                  ),
                  LatLng(location.lat!, location.lng!),
                );
                var mk = Marker(
                    markerId: MarkerId('${location.lat}_${location.lng}'),
                    position: LatLng(location.lat!, location.lng!),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue));
                setState(() {
                  localMarkers.remove(selectedMarker);
                  localMarkers.add(mk);
                  selectedMarker = mk;
                });
              }
            },
            markerId: MarkerId('${location.lat}_${location.lng}'),
            position: LatLng(location.lat!, location.lng!),
            icon: location.mylocation
                ? await functions.bitmapDescriptorFromSvgAsset(
                    context, "assets/icons/buradayim5.svg", 90)
                : !isadmin! && dist > 50
                    ? await functions.bitmapDescriptorFromSvgAsset(
                        context, "assets/icons/wifi6.svg", 40)
                    : location.baslatildi
                        ? BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange)
                        : location.aktifmi
                            ? BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen)
                            : BitmapDescriptor.defaultMarker),
      );
    }
    setState(() {
      _markers = localMarkers;
    });
  }

  void _callback(val) {
    setState(() {
      floatingActionButtonvisible = val;
      nearlocationsvisible = val;
    });
  }

  void _callbacknear(val) {
    setState(() {
      floatingActionButtonvisible = val;
      nearlocationsvisible = val;
    });
  }

  void _callbacknearopen(val) {
    setState(() {
      floatingActionButtonvisible = val;
    });
  }

  void _callbackuserview(bool val) {
    Toast.show(val ? "switchingtouserview".tr() : "switchingtoadminview".tr(),
        duration: Toast.lengthLong, gravity: Toast.bottom);
    setState(() {
      userview = val;
      isadmin = !val;
      infoviewheight = isadmin! ? 180 : 140;
      generateMarkers(context, latLng).whenComplete(() => Toast.show(
          val ? "switchedtouserview".tr() : "switchedtoadminview".tr(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom));
    });
  }

  void _callbackislogin(phonenumber, password) {
    login(phonenumber, password).then((value) {
      if (value.success == "0") {
        Toast.show("wrongusernameorpassword".tr(),
            duration: Toast.lengthShort, gravity: Toast.bottom);
      } else {
        Toast.show("loginsuccessful".tr(),
            duration: Toast.lengthShort, gravity: Toast.bottom);
        setState(() {
          islogin = true;
          isadmin = value.isadmin!;
          infoviewheight = isadmin! ? 180 : 140;
          generateMarkers(context, latLng);
        });
      }
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _callbackdrawer() {
    setState(() {
      islogin = false;
      isadmin = false;
      generateMarkers(context, latLng);
    });
  }

  void _callbackinfoview(Locations newlocation) {
    _customInfoWindowController.hideInfoWindow!();
    var dd = locations!.firstWhere((element) => element.id == newlocation.id);
    dd.baslatildi = newlocation.baslatildi;
    generateMarkers(context, latLng);
  }

  Future<void> _callbackgotolocation(Locations location) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition nepPos = CameraPosition(
      target: LatLng(location.lat!, location.lng!),
      zoom: 17,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(nepPos));
    _pc.close();
    _customInfoWindowController.addInfoWindow!(
      InfoWindowScreen(
        location: location,
        islogin: islogin!,
        isadmin: isadmin!,
        callback: _callbackinfoview,
      ),
      LatLng(location.lat!, location.lng!),
    );

    _markers?.remove((element) =>
        element.markerId == MarkerId('${location.lat}_${location.lng}'));
    setState(() {
      selectedMarker = Marker(
          markerId: MarkerId('${location.lat}_${location.lng}'),
          position: LatLng(location.lat!, location.lng!),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
      _markers?.add(selectedMarker!);
    });
  }

  FlickManager flickManager(url) {
    return FlickManager(
      videoPlayerController: VideoPlayerController.network(url),
    );
  }

  Future<void> startTimer() async {
    var id = await storage.read(key: "importantdays");
    getimportantdays().then(
      (value) async {
        if (id != value.id) {}
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            content: Stack(
              children: [
                Container(
                  child:
                      // value.turu == "resim"
                      //     ? OctoImage(
                      //         image: CachedNetworkImageProvider(value.url),
                      //         placeholderBuilder: OctoPlaceholder.blurHash(
                      //           'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                      //         ),
                      //         errorBuilder: OctoError.icon(color: Colors.red),
                      //         fit: BoxFit.cover,
                      //       )
                      //     :
                      
                      FlickVideoPlayer(
                        preferredDeviceOrientation : const [DeviceOrientation.portraitDown],
                          flickVideoWithControls: FlickVideoWithControls(
                            videoFit: BoxFit.fitHeight,
                            controls: FlickPortraitControls(
                              progressBarSettings: FlickProgressBarSettings(
                                  playedColor: Colors.green),
                            ),
                          ),
                          flickManager: flickManager(
                              "https://yonetim.wizmir.net/OnemliGunResimler/pexels-dario-fernandez-ruz-9130068.mp4")),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await ImageDownloader.downloadImage(value.url)
                          .whenComplete(
                        () => Toast.show("succesful".tr(),
                            duration: Toast.lengthLong, gravity: Toast.bottom),
                      );
                    },
                    icon: const Icon(Icons.download),
                  ),
                )
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 35, 19, 145),
                        Color.fromARGB(255, 56, 108, 228),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "close".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        await storage.write(key: "importantdays", value: value.id);
      },
    );
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      drawer: NavigationDrawer(
        isadmin: isadmin!,
        islogin: islogin!,
        userview: userview,
        callbackuserview: _callbackuserview,
        pc: _pc,
        callback: _callbackdrawer,
      ),
      floatingActionButton: floatingActionButtonvisible
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    reloadmap();
                    // setState(() {
                    //   _callbackdrawer;
                    // });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: icon,
                  onPressed: () async {
                    setState(() {
                      icon = const CircularProgressIndicator();
                    });

                    final GoogleMapController controller =
                        await _controller.future;
                    getData().then((value) {
                      CameraPosition nepPos = CameraPosition(
                        target: LatLng(latLng!.latitude, latLng!.longitude),
                        zoom: 17,
                      );
                      controller.animateCamera(
                          CameraUpdate.newCameraPosition(nepPos));
                      setState(() {
                        icon = const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        );
                      });
                    });
                  },
                ),
              ],
            )
          : null,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Text(
              "menu".tr(),
              style: const TextStyle(color: Colors.black),
            )),
      ),
      body: Center(
        child: FutureBuilder<LatLng>(
            future: latLngfuture,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                latLng = snapshot.data!;
                return Stack(
                  children: <Widget>[
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: latLng!,
                        zoom: 14,
                      ),
                      markers: _markers!,
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                        _markers!.remove(selectedMarker!);
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        generateMarkers(context, latLng);
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      zoomControlsEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      tiltGesturesEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: infoviewheight,
                      width: MediaQuery.of(context).size.width * 0.7,
                      offset: 50,
                    ),
                    LoginPanelPage(
                      islogin: islogin!,
                      callback: _callback,
                      callbackislogin: _callbackislogin,
                      pc: _pc,
                    ),
                    nearlocationsvisible
                        ? NearPointsPage(
                            list: nlist,
                            callback: _callbacknear,
                            callbackopen: _callbacknearopen,
                            callbackgotolocation: _callbackgotolocation,
                          )
                        : const Center()
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
