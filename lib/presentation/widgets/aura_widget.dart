import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AuraWidget extends StatelessWidget {
  const AuraWidget({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: const FlareActor(
        'assets/animations/ia.flr',
        animation: 'Aura',
      ),
    );
  }
}
