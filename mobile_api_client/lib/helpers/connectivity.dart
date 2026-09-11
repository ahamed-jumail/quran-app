// ignore_for_file: always_declare_return_types, inference_failure_on_function_return_type

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

final ValueNotifier<bool> checkingConnectivity = ValueNotifier<bool>(false);

onNoInternet() async {
  Config.isNoInternet.value = true;
}

final MyConnectivity connectivity = MyConnectivity.instance;
onConnectedtoNet() async {
  Config.isNoInternet.value = false;
}

Future<dynamic> onConnectionResult(bool result) async {
  if (result) {
    onConnectedtoNet();
  } else {
    onNoInternet();
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  // ignore: inference_failure_on_instance_creation
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  Stream<bool> get myStream => _controller.stream;

  initialise() async {
    final List<ConnectivityResult> result =
        await _connectivity.checkConnectivity();
    _checkStatus(result.last);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result.last);
    });
  }

  _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add(isOnline);
  }

  void disposeStream() => _controller.close();
}
