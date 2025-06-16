import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ExampleAnimationWidget extends StatefulWidget {
  const ExampleAnimationWidget({super.key});

  @override
  State<ExampleAnimationWidget> createState() => _ExampleAnimationWidgetState();
}

class _ExampleAnimationWidgetState extends State<ExampleAnimationWidget>
    with TickerProviderStateMixin {
  Size containerSize = const Size(200, 200);
  Random random = Random();
  AnimationController? controller;
  Animation<Offset>? slideTween;
  Animation<double>? rotateTween;

  @override
  void initState() {
    // TODO: implement initState

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    slideTween = Tween<Offset>(begin: Offset.zero, end: const Offset(1, 0))
        .animate(controller!);

    rotateTween = Tween<double>(begin: 0.0, end: 2 * pi).animate(controller!)
      ..addListener(
        () {
          setState(() {});
        },
      )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller!.reset();
          controller!.forward();
        }
      });

    Timer.periodic(const Duration(seconds: 1), (_) {
      containerSize = Size(
        random.nextInt(200).toDouble(),
        random.nextInt(200).toDouble(),
      );
      setState(() {});
    });
    controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: Center(
  //       child: AnimatedContainer(
  //         width: containerSize.width,
  //         height: containerSize.height,
  //         duration: const Duration(
  //           seconds: 1,
  //         ),
  //         color: Colors.blue,
  //       ),
  //     ),
  //   );
  // }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FadeInImage.assetNetwork(
//         placeholder: 'assets/images/abidjan.jpeg',
//         image:
//             'https://img.freepik.com/photos-gratuite/prise-vue-au-grand-angle-seul-arbre-poussant-sous-ciel-assombri-pendant-coucher-soleil-entoure-herbe_181624-22807.jpg?t=st=1727561389~exp=1727564989~hmac=992303ae70d1b5c2db3c9547d1f0eace0b283fe7228163aca3b570d25a8bd122&w=1380',
//       ),
//     );
//   }
// }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: Center(
  //       child: FadeTransition(
  //         opacity: controller!,
  //         child: Container(
  //           height: 200,
  //           width: 200,
  //           color: Colors.indigo,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: Center(
  //       child: SlideTransition(
  //         position: slideTween!,
  //         child: Container(
  //           height: 200,
  //           width: 200,
  //           color: Colors.indigo,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Transform.rotate(
          angle: rotateTween!.value,
          child: AnimatedContainer(
            width: containerSize.width,
            height: containerSize.height,
            duration: const Duration(
              seconds: 1,
            ),
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
