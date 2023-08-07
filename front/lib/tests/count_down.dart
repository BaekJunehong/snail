import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final int seconds;

  CountdownTimer({required this.seconds});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    Future.delayed(Duration(seconds: 3), () {
      super.dispose();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: Center(
        child: Text(
          '$_remainingSeconds',
          style: TextStyle(fontSize: 500, color: Colors.blueGrey),
        ),
      ),
    );
  }
}