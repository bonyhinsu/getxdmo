import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:game_on_flutter/infrastructure/network/dio_client.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../values/common_utils.dart';

class NetworkConnectivity {

  final logger = Logger();

  NetworkConnectivity._();

  static final _instance = NetworkConnectivity._();

  static NetworkConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();

  Stream get connectionStream => _controller.stream;

  Flushbar? _noInternetFlushbar;

  /// Initialised connectivity instance for listen when connection property change
  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  /// Check status when connectivity change.
  ///
  /// When network not available then shows No internet message.
  /// When network available then hide message.
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      isOnline = result != ConnectivityResult.none;

      if (!isOnline) {
        showNoInternetFlushbar();
      } else {
        hideNoInternetFlushbar();
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    if (!_controller.isClosed) _controller.sink.add({result: isOnline});
  }

  /// Dispose controller stream.
  void disposeStream() => _controller.close();

  /// Returns true when internet available.
  Future<bool> hasNetwork() async {

      if (GetPlatform.isWeb) {
        try {
          final dio = Dio();
          final result = await dio.get('example.com');
          if (result.statusCode==200) return true;
        } on SocketException catch (_) {}
        return false;
      } else {
        try {
        final result = await InternetAddress.lookup('example.com');
        bool res = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        if (!res) {
          showNoInternetFlushbar();
        } else {
          hideNoInternetFlushbar();
        }
        return res;
      }
      on SocketException catch (_) {
      showNoInternetFlushbar();
      return false;
    }
  }
  }

  /// Shows no internet message when [_noInternetFlushbar] is null otherwise hide message.
  void showNoInternetFlushbar() {
    if (_noInternetFlushbar != null) {
      hideNoInternetFlushbar();
    }
    if (_noInternetFlushbar == null) {
      _noInternetFlushbar = CommonUtils.getNoInternetFlushbar(
          title: "No Internet",
          message: "Please check your network connection");
      Future.delayed(Duration.zero, () {
      _noInternetFlushbar!.show(Get.context!);
      });
    }
  }

  /// Hide no internet message when internet back.
  void hideNoInternetFlushbar() {
    if (_noInternetFlushbar != null) {
      _noInternetFlushbar!.dismiss();
      _noInternetFlushbar = null;
    }
  }
}
