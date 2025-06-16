// import 'dart:ffi';

import 'package:flutter/material.dart';

enum SquareSize { petit, grand }

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  SquareSize currentSquareShape = SquareSize.grand;
  late AnimationController _controller;
  late Animation<double>? _tweenSize;
  late Animation<double>? _curve;
  late Animation<Color?> _tweenColor;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    _tweenColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_curve!);

    _tweenSize = Tween(begin: 200.0, end: 50.0).animate(_curve!);

    _tweenSize!.addListener(() {
      setState(() {});
      print(_tweenSize!.value);
    });

    super.initState();
  }

  void switchSquare() {
    currentSquareShape == SquareSize.grand
        ? _controller.forward()
        : _controller.reverse();
    setState(() {
      currentSquareShape = currentSquareShape == SquareSize.grand
          ? SquareSize.petit
          : SquareSize.grand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60),
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                  height: _tweenSize?.value ?? 200,
                  width: _tweenSize?.value ?? 200,
                  color: _tweenColor.value ?? Colors.blue),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.green),
                  ),
                  onPressed: switchSquare,
                  child: const Text(
                    'Change size',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
