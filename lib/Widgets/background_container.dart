import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osbrosound/Controllers/playerController.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final PlayerController playerController = Get.find();

  BackgroundContainer({super.key, required this.child});

  // Pour améliorer de beaucoup les performances, on utilise Obx() uniquement sur ce Container personnalisé
  // et pas sur tout le reste de l'arbre de widgets
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: playerController.backgroundColor.value,
          ),
        ),
        child: child,
      ),
    );
  }
}
