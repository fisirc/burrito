import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit show LatLng;

enum BurritoStatus {
  working,
  outOfService,
  atRest,
  accident,
  error,
  loading,
  unknown;

  static BurritoStatus fromInt(int value) {
    switch (value) {
      case 0:
        return working;
      case 1:
        return outOfService;
      case 2:
        return atRest;
      case 3:
        return accident;
      case 4:
        return error;
      default:
        return unknown;
    }
  }

  String get displayName {
    switch (this) {
      case working:
        return 'En ruta';
      case outOfService:
        return 'Fuera de servicio';
      case atRest:
        return 'En descanso';
      case accident:
        return 'Accidente';
      case error:
        return 'Error';
      default:
        return 'unknown';
    }
  }

  bool locatable() {
    return this == working;
  }
}

class BurritoInfoInTime {
  final double humidity;
  final LatLng pos;
  final BurritoStatus status;
  final DateTime timestamp;
  final double temperature;

  BurritoInfoInTime({
    required this.humidity,
    required this.pos,
    required this.status,
    required this.timestamp,
    required this.temperature,
  });

  factory BurritoInfoInTime.fromJson(Map<String, dynamic> json) {
    return BurritoInfoInTime(
      humidity: json['hum'],
      pos: LatLng(json['lt'], json['lg']),
      status: BurritoStatus.fromInt(json['sts']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp']['secs_since_epoch'] * 1000 +
            json['timestamp']['nanos_since_epoch'] ~/ 1000000,
      ),
      temperature: json['tmp'],
    );
  }
}

extension XBurritoInfo on double {
  // 2 digits precision
  String get tempString => '${toStringAsFixed(2)}°';
  String get humidityString => '${toStringAsFixed(2)}%';
}

extension XBurritoTimeInfo on DateTime {
  // In seconds, minutes, hours
  String get timeAgoString {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} m';
    } else {
      return '${diff.inHours} h';
    }
  }
}

extension XLatLng on LatLng {
  maps_toolkit.LatLng get asTKLatLng =>
      maps_toolkit.LatLng(latitude, longitude);
}
