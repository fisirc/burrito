import 'dart:async';
import 'package:burrito/data/entities/positions_response.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:flutter/material.dart';

const kBottomBarHeight = 50.0;

class BurritoBottomAppBar extends StatefulWidget {
  final BurritoState? burritoState;

  const BurritoBottomAppBar({super.key, this.burritoState});

  @override
  State<BurritoBottomAppBar> createState() => BurritoBottomAppBarState();
}

class BurritoBottomAppBarState extends State<BurritoBottomAppBar> {
  Timer? _timer;
  String timeAgoString = '?';

  @override
  void initState() {
    backgroundTimerUpdate();
    super.initState();
  }

  void backgroundTimerUpdate() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.burritoState != null) {
          timeAgoString = widget.burritoState!.lastInfo.timestamp.timeAgoString;
        } else {
          timeAgoString = '?';
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final burritoState = widget.burritoState;

    return SizedBox(
      height: kBottomBarHeight,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 8),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (burritoState != null) ...[
              Row(
                children: [
                  Text(
                    burritoState.lastInfo.velocity.kmphString,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.thermostat_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        burritoState.lastInfo.temperature.tempString,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.opacity_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        burritoState.lastInfo.humidity.humidityString,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Actualizado hace',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    timeAgoString,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
