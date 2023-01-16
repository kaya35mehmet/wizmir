import 'dart:async';
import 'dart:io';
import 'package:animated_button/animated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:octo_image/octo_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'package:wizmir/notification.dart';
import 'package:wizmir/profilecomplete.dart';

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
  String? _darkMapStyle;
  FlickManager? flickManager;

  @override
  void initState() {
    setState(() {
      isadmin = widget.isadmin;
      infoviewheight = widget.isadmin ? 280 : 210;
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
    _loadMapStyles();
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
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

  Future<void> reloadmap() async {
    setState(() {
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
        baslatildi: false,
        lokasyon: ''));
    // ignore: use_build_context_synchronously
    wifiAlert(
        locations?.where((element) => element.mylocation == false).toList(),
        latLng,
        context);
    nlist = nearlist();
    await Future<dynamic>.delayed(const Duration(milliseconds: 4000));

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
    var ikon = await functions.bitmapDescriptorFromSvgAsset(
        context, "assets/icons/wifi6.svg", 36);
    var ikon2 = await functions.bitmapDescriptorFromSvgAsset(
        context, "assets/icons/wifi7inactive.svg", 36);
    var buradayim = await functions.bitmapDescriptorFromSvgAsset(
        context, "assets/icons/buradayim5.svg", 90);
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
                    controller: _customInfoWindowController,
                    closecallback: _closecallback,
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
                ? buradayim
                : !isadmin! && dist > 50
                    ? location.aktifmi
                        ? ikon
                        : ikon2
                    : isadmin! && location.baslatildi
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
      infoviewheight = isadmin! ? 280 : 210;
    });
  }

  void _callbacknear(val) {
    setState(() {
      floatingActionButtonvisible = val;
      nearlocationsvisible = val;
      infoviewheight = isadmin! ? 280 : 210;
    });
  }

  void _callbacknearopen(val) {
    setState(() {
      floatingActionButtonvisible = val;
      infoviewheight = isadmin! ? 280 : 210;
    });
  }

  void _callbackuserview(bool val) {
    Toast.show(val ? "switchingtouserview".tr() : "switchingtoadminview".tr(),
        duration: Toast.lengthLong, gravity: Toast.bottom);
    setState(() {
      userview = val;
      isadmin = !val;
      infoviewheight = isadmin! ? 280 : 210;
      generateMarkers(context, latLng).whenComplete(() => Toast.show(
          val ? "switchedtouserview".tr() : "switchedtoadminview".tr(),
          duration: Toast.lengthShort,
          gravity: Toast.bottom));
    });
  }

  void _callbackislogin(phonenumber, password) {
    login(phonenumber, password).then((value) {
      if (value.success == "0") {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  // title: Text('Dialog Title'),
                  content: Text('wrongusernameorpassword'.tr()),
                  actions: <Widget>[
                    Center(
                      child: AnimatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        duration: 70,
                        height: 50,
                        width: 200,
                        enabled: true,
                        shadowDegree: ShadowDegree.dark,
                        color: Colors.blue,
                        child: Text(
                          "ok".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
        // Toast.show("wrongusernameorpassword".tr(),
        //     duration: Toast.lengthShort, gravity: Toast.bottom);
      } else {
        Toast.show("loginsuccessful".tr(),
            duration: Toast.lengthShort, gravity: Toast.bottom);
        setState(() {
          islogin = true;
          isadmin = value.isadmin!;
          infoviewheight = isadmin! ? 280 : 210;
          generateMarkers(context, latLng);
        });

        if (!value.fullprofile!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileComplete(
                        username: phonenumber,
                      )));
        }
      }
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _callbackdrawer() {
    setState(() {
      islogin = false;
      isadmin = false;
      infoviewheight = isadmin! ? 280 : 210;
      generateMarkers(context, latLng);
    });
  }

  void _closecallback() {
    generateMarkers(context, latLng);
  }

  void _callbackinfoview(Locations newlocation) {
    _customInfoWindowController.hideInfoWindow!();
    var dd = locations!.firstWhere((element) => element.id == newlocation.id);
    dd.baslatildi = newlocation.baslatildi;
    infoviewheight = isadmin! ? 280 : 210;
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
        controller: _customInfoWindowController,
        closecallback: _closecallback,
      ),
      LatLng(location.lat!, location.lng!),
    );

    _markers?.remove((element) =>
        element.markerId == MarkerId('${location.lat}_${location.lng}'));
    setState(() {
      infoviewheight = isadmin! ? 280 : 210;
      selectedMarker = Marker(
          markerId: MarkerId('${location.lat}_${location.lng}'),
          position: LatLng(location.lat!, location.lng!),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
      _markers?.add(selectedMarker!);
    });
  }

  FlickManager setflickManager(url) {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(url),
    );
    return flickManager!;
  }

  Future<void> startTimer() async {
    getimportantdays().then(
      (value) async {
        var importantdays = await storage.read(key: "importantdays");
        String id = "";
        int kalangosterimSayisi = -1;
        if (importantdays == null) {
          showdialog(value);
          await storage.write(
              key: "importantdays",
              value:
                  "${value.id}:${value.gosterimSayisi}:${--value.gosterimSayisi}");
        }

        if (importantdays != null) {
          id = importantdays.split(":")[0];
          kalangosterimSayisi = int.parse(importantdays.split(":")[2]);

          if (id == value.id && kalangosterimSayisi > 0) {
            showdialog(value);
            await storage.write(
                key: "importantdays",
                value:
                    "${value.id}:${value.gosterimSayisi}:${--kalangosterimSayisi}");
          }

          if (id != value.id) {
            showdialog(value);
            await storage.write(
                key: "importantdays",
                value:
                    "${value.id}:${value.gosterimSayisi}:${--kalangosterimSayisi}");
          }
        }
      },
    );
  }

  showdialog(value) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Container(
              child: value.turu == "resim"
                  ? OctoImage(
                      image: CachedNetworkImageProvider(value.url),
                      placeholderBuilder: OctoPlaceholder.blurHash(
                        'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                      ),
                      errorBuilder: OctoError.icon(color: Colors.red),
                      fit: BoxFit.cover,
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FlickVideoPlayer(
                          flickVideoWithControls: FlickVideoWithControls(
                            videoFit: BoxFit.fitHeight,
                            controls: FlickPortraitControls(
                              progressBarSettings: FlickProgressBarSettings(
                                  playedColor: Colors.green),
                            ),
                          ),
                          flickManager: setflickManager(value.url)),
                    ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () async {
                  await ImageDownloader.downloadImage(value.url).whenComplete(
                    () => Toast.show("succesful".tr(),
                        duration: Toast.lengthLong, gravity: Toast.bottom),
                  );
                },
                icon: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        actions: [
          Center(
            child: AnimatedButton(
              onPressed: () {
                if (flickManager != null) {
                  flickManager!.dispose();
                }
                Navigator.pop(context);
              },
              duration: 70,
              height: 50,
              width: 200,
              enabled: true,
              shadowDegree: ShadowDegree.dark,
              color: Colors.blue,
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
        ],
      ),
    );
  }

  void openWhatsapp() async {
    var whatsapp = '+905309194035';
    var whatsappUrl = "whatsapp://send?phone=$whatsapp&text=";
    try {
      launch(whatsappUrl);
    } catch (e) {
      //To handle error and display error message
    }
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    Widget icon = Icon(Icons.location_on,
        color: brightness == Brightness.light ? Colors.blue : Colors.white);
    Widget iconrefresh = Icon(Icons.refresh,
        color: brightness == Brightness.light ? Colors.blue : Colors.white);
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    heroTag: "btnwhatsapp",
                    // onPressed: () async {
                    //   //  FlutterOpenWhatsapp.sendSingleMessage("905309194035", "");
                    //   FlutterLaunch.launchWhatsapp(
                    //       phone: "905309194035", message: "");

                    //   // await launchUrl(
                    //   //   Uri(
                    //   //       scheme: 'https',
                    //   //       host: 'https://wa.me/+905309194035',
                    //   //       ),
                    //   //   mode: LaunchMode.externalApplication,
                    //   // );
                    // },
                    onPressed: () => openWhatsapp(),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset("assets/images/whatsapp.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FloatingActionButton(
                    heroTag: "btnhim",
                    onPressed: () async {
                      const number = '153';
                      // await FlutterPhoneDirectCaller.callNumber(number);

                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: number,
                      );
                      await launchUrl(launchUri);
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/him.jpeg')),
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btn11",
                  backgroundColor: brightness == Brightness.light
                      ? Colors.white
                      : Colors.blue,
                  child: iconrefresh,
                  onPressed: () async {
                    setState(() {
                      iconrefresh = const CircularProgressIndicator();
                    });
                    reloadmap().whenComplete(() {
                      Toast.show("maprenewed".tr(),
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                      iconrefresh = Icon(Icons.refresh,
                          color: brightness == Brightness.light
                              ? Colors.blue
                              : Colors.white);
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                FloatingActionButton(
                  heroTag: "btn22",
                  backgroundColor: brightness == Brightness.light
                      ? Colors.white
                      : Colors.blue,
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
                        icon = Icon(
                          Icons.location_on,
                          color: brightness == Brightness.light
                              ? Colors.blue
                              : Colors.white,
                        );
                      });
                    });
                  },
                ),
              ],
            )
          : null,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          // title: Container(   // <--- Change here
          //      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1), // <-- play with the double number
          //      child: Image.asset("assets/images/ibblogo.png", fit: BoxFit.cover)
          //   ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40),
            child: SafeArea(
              child: Image.asset(
                "assets/images/ibblogo.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                icon: Icon(
                  Icons.notifications,
                  color: brightness == Brightness.light ? Colors.black : null,
                ))
          ],
          centerTitle: false,
          backgroundColor: brightness == Brightness.light ? Colors.white : null,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _customInfoWindowController.hideInfoWindow!();
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Padding(
              padding: const EdgeInsets.all(0),
              child: Icon(
                Icons.menu,
                color: brightness == Brightness.light ? Colors.black : null,
              ),
            ),
          ),
        ),
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
                        generateMarkers(context, latLng);
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        generateMarkers(context, latLng);
                        _customInfoWindowController.googleMapController =
                            controller;
                        if (brightness == Brightness.dark) {
                          controller.setMapStyle(_darkMapStyle);
                        }
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
                      offset: 60,
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
