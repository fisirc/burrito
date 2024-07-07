import 'dart:async';

import 'package:burrito/data/geojson/burrito_path.dart';
import 'package:burrito/data/geojson/bus_stops.dart';
import 'package:burrito/data/geojson/entrances.dart';
import 'package:burrito/data/geojson/faculties.dart';
import 'package:burrito/data/geojson/unmsm.dart';
import 'package:burrito/features/map/config.dart';
import 'package:burrito/services/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BurritoMap extends StatefulWidget {
  const BurritoMap({super.key});

  @override
  State<BurritoMap> createState() => BurritoMapState();
}

class Vec2 {
  double x;
  double y;

  Vec2(this.x, this.y);
}

class BurritoMapState extends State<BurritoMap> {
  late GoogleMapController _controller;
  Position? userPos;

  static const initialPos = CameraPosition(
    target: LatLng(-12.05711777028543, -77.08399756046832),
    zoom: 16,
    bearing: initialBearing,
  );

  Vec2? dummyScreenButtonPos;

  LatLng? screenCenterLatLng;
  double mapRotation = 0;
  List<Marker> busStopsMarkers = [];
  List<Marker> entrancesMarkers = [];

  @override
  void initState() {
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
    super.initState();
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
      // print("🐢 Updating");

      try {
        final tempUserPos = await determinePosition();
        if (unmsmSafeBounds.contains(tempUserPos.latLng)) {
          _controller.animateCamera(CameraUpdate.newLatLng(
            LatLng(tempUserPos.latitude, tempUserPos.longitude),
          ));
        }
        // setState(() {
        //   userPos = tempUserPos;
        // });
      } catch (e) {
        // TODO: Handle no permissions
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialPos,
            padding: const EdgeInsets.symmetric(vertical: 60),
            minMaxZoomPreference: const MinMaxZoomPreference(14, 20),
            compassEnabled: false,
            trafficEnabled: false,
            buildingsEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            style: mapStyleString,
            polygons: {
              kUNMSMPolygon,
              ...kUNMSMPlacesPolygons.map(
                (poly) => poly.copyWith(
                  consumeTapEventsParam: true,
                  onTapParam: () {
                    print('Tapped on ${poly.polygonId}');
                  },
                ),
              )
            },
            polylines: {kBurritoPathPolyLine},
            markers: {
              ...busStopsMarkers,
              ...entrancesMarkers.map((m) =>
                  m.copyWith(rotationParam: mapRotation + initialBearing)),
              Marker(
                visible: false,
                markerId: const MarkerId('dummy_pos'),
                position: initialPos.target,
              ),
            },
            // Events
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
          ),
          if (screenCenterLatLng != null &&
              !unmsmSafeBounds.contains(screenCenterLatLng!))
            Positioned(
                right: 10,
                bottom: 10,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: change this to the burrito when found
                    _controller.animateCamera(
                      CameraUpdate.newLatLng(initialPos.target),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back_rounded),
                      Icon(Icons.directions_bus_rounded),
                      SizedBox(width: 5),
                      Text('Volver al burrito'),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
