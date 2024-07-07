import 'package:burrito/data/entities/positions_response.dart';
import 'package:flutter/material.dart';

const kBottomBarHeight = 50.0;

class BurritoBottomAppBar extends StatelessWidget {
  final BurritoInfoInTime? lastInfo;

  const BurritoBottomAppBar({super.key, this.lastInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomBarHeight,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).colorScheme.primary,
        // color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (lastInfo != null) ...[
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.thermostat_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lastInfo!.temperature.tempString,
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
                      const SizedBox(width: 5),
                      Text(
                        lastInfo!.humidity.humidityString,
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
                    lastInfo!.timestamp.timeAgoString,
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
