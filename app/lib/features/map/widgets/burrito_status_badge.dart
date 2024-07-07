import 'package:burrito/data/entities/positions_response.dart';
import 'package:flutter/material.dart';

class BurritoStatusBadge extends StatelessWidget {
  final BurritoStatus status;
  final badgeWidth = 40.0;
  final badgeHeight = 16.0;

  const BurritoStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case BurritoStatus.working:
        return Container(
          color: Colors.red,
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: Text(
              'LIVE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        );
      case BurritoStatus.loading:
        return Container(
          // border rounded 8px
          color: Colors.grey,
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
