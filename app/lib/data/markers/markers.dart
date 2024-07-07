import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final kBurritoPosIcon = BitmapDescriptor.asset(
  const ImageConfiguration(size: Size(26, 26 * (846 / 750))),
  'assets/icons/burrito_marker.png',
);

final kBusStopIcon = BitmapDescriptor.asset(
  const ImageConfiguration(size: Size(13, 13 * (12 / 7))),
  'assets/icons/busstop_marker.png',
);

Future<BitmapDescriptor> entranceIcon(int number) {
  return BitmapDescriptor.asset(
    const ImageConfiguration(size: Size(26 * 2, 26)),
    'assets/icons/entrance_p$number.png',
  );
}
