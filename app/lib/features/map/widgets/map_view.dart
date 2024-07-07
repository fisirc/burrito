import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:burrito/features/map/widgets/app_bottom_bar.dart';
import 'package:burrito/data/entities/positions_response.dart';
import 'package:burrito/features/map/widgets/app_top_bar.dart';
import 'package:burrito/data/geojson/burrito_path.dart';
import 'package:burrito/data/geojson/bus_stops.dart';
import 'package:burrito/data/geojson/entrances.dart';
import 'package:burrito/data/geojson/faculties.dart';
import 'package:burrito/data/markers/markers.dart';
import 'package:burrito/features/map/config.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:burrito/data/geojson/unmsm.dart';

class BurritoMap extends StatefulWidget {
  const BurritoMap({super.key});

  @override
  State<BurritoMap> createState() => BurritoMapState();
}

class BurritoMapState extends State<BurritoMap> {
  late GoogleMapController _controller;
  Position? userPos;

  LatLng? screenCenterLatLng;
  double mapRotation = 0;

  List<Marker> busStopsMarkers = [];
  List<Marker> entrancesMarkers = [];

  BurritoInfoInTime? lastInfo;
  bool loadingLastInfo = true;
  Marker? burritoMarker;

  @override
  void initState() {
    super.initState();
    backgroundPosUpdate();
    kUNMSMBusStopsMarkers.then((value) {
      setState(() {
        busStopsMarkers = value;
      });
    });
    kUNMSMEntrances.then((value) {
      setState(() {
        entrancesMarkers = value;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onCameraMove(CameraPosition pos) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenSize = MediaQuery.of(context).size;

    final deviceWidth = screenSize.width * pixelRatio;
    final deviceHeight = screenSize.height * pixelRatio;

    final screenCoords = await _controller.getLatLng(
      ScreenCoordinate(
        x: (deviceWidth / 2).round(),
        y: (deviceHeight / 2).round(),
      ),
    );

    setState(() {
      screenCenterLatLng = screenCoords;
      mapRotation = -pos.bearing;
    });
  }

  void backgroundPosUpdate() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final burritoInfo = await getInfoAcrossTime();
        final burritoPosIcon = await kBurritoPosIcon;

        setState(() {
          lastInfo = burritoInfo.last;
          loadingLastInfo = false;
          burritoMarker = Marker(
            markerId: const MarkerId('burrito'),
            position: LatLng(
              lastInfo!.pos.latitude,
              lastInfo!.pos.longitude,
            ),
            icon: burritoPosIcon,
          );
        });
      } catch (e, st) {
        log('Error fetching burrito info', error: e, stackTrace: st);
      }

      // try {
      //   final tempUserPos = await determinePosition();
      //   if (unmsmSafeBounds.contains(tempUserPos.latLng)) {
      //     _controller.animateCamera(CameraUpdate.newLatLng(
      //       LatLng(tempUserPos.latitude, tempUserPos.longitude),
      //     ));
      //   }
      //   // setState(() {
      //   //   userPos = tempUserPos;
      //   // });
      // } catch (e) {
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userOnBounds = screenCenterLatLng == null
        ? true
        : unmsmSafeBounds.contains(screenCenterLatLng!);

    // final burritoExists = lastInfo != null && lastInfo!.status.locatable();
    // final userLocated = userPos != null;

    return Scaffold(
      body: Column(
        children: [
          BurritoTopAppBar(lastInfo: lastInfo),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: initialPos,
                  padding: const EdgeInsets.only(top: 60),
                  minMaxZoomPreference: const MinMaxZoomPreference(14, 20),
                  compassEnabled: false,
                  trafficEnabled: false,
                  buildingsEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: false,
                  style: mapStyleString,
                  polygons: {kUNMSMPolygon, ...kUNMSMPlacesPolygons},
                  polylines: {kBurritoPathPolyLine},
                  markers: {
                    ...busStopsMarkers,
                    ...entrancesMarkers.map((m) => m.copyWith(
                        rotationParam: mapRotation + initialBearing)),
                    if (burritoMarker != null) burritoMarker!,
                  },
                  // Events
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                ),
                if (!userOnBounds) ...[
                  // Go back button
                  Positioned(
                    right: 10,
                    bottom: kBottomBarHeight + 10,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black87, width: 2),
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              _controller.animateCamera(
                                CameraUpdate.newLatLng(initialPos.target),
                              );
                            },
                            child: const SizedBox(
                              width: 56,
                              height: 56,
                              child:
                                  Icon(Icons.keyboard_return_rounded, size: 32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const Positioned(
                  left: 10,
                  bottom: kBottomBarHeight + 5,
                  child: Text(
                    // TODO: fetch last velocity
                    '20 km/h',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: BurritoBottomAppBar(lastInfo: lastInfo),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
