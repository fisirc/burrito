import 'package:burrito/data/markers/markers.dart';
import 'package:collection/collection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 9 Bus stops
const List<Map<String, dynamic>> kBusStopsGeoJSON = [
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.0795983171576, -12.059617630437259],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.08013743857973, -12.057450000854544],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.08196916014336, -12.055548819154808],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.08447129103324, -12.054151788768749],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.08577397007359, -12.053656239277572],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.08608175182626, -12.054903185311602],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.08517004234986, -12.056224577874275],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.084409331681, -12.06031186261498],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [-77.08295365353449, -12.060818347666796],
      "type": "Point"
    }
  }
];

BitmapDescriptor? bustStopIcon;

final kUNMSMBusStopsMarkers =
    Future.wait(kBusStopsGeoJSON.mapIndexed((i, busstop) async {
  final location = busstop['geometry']['coordinates'] as List<double>;

  if (bustStopIcon == null) {
    final icon = await kBusStopIcon;
    bustStopIcon = icon;
  }

  return Marker(
    visible: true,
    icon: bustStopIcon!,
    markerId: MarkerId('busstop_$i'),
    position: LatLng(location[1], location[0]),
    zIndex: 1000,
  );
}));
