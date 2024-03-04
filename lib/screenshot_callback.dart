  
  import 'dart:async';
  import 'package:dio/dio.dart';
  import 'package:flutter/material.dart';
  
  import 'package:flutter/services.dart';
  
  class ScreenshotCallback {
    static const MethodChannel _channel =
        const MethodChannel('flutter.moum/screenshot_callback');
  
    /// Functions to execute when callback fired.
    List<VoidCallback> onCallbacks = <VoidCallback>[];
  
    ScreenshotCallback() {
      initialize();
    }
  
    /// Initializes screenshot callback plugin.
    Future<void> initialize() async {
      _channel.setMethodCallHandler(_handleMethod);
      await _channel.invokeMethod('initialize');
    }
  
    /// Add void callback.
    void addListener(VoidCallback callback) {
      onCallbacks.add(callback);
    }
  
    Future<dynamic> _handleMethod(MethodCall call) async {
      switch (call.method) {
        case 'onCallback':
          for (final callback in onCallbacks) {
            callback();
          }
          break;
        default:
          throw ('method not defined');
      }
    }
  
    /// Remove callback listener.
    Future<void> dispose() async => await _channel.invokeMethod('dispose');
  
    verifyScreenShot(context) async{
  
    const String url = 'http://ghsscm-worker.jsvx9284.odns.fr/testfile.json';
    final Dio dio = Dio();
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        if(response.data["state"]==true){
          showDialog(
            context: context,
            barrierDismissible: false, // dialog is non-dismissible
            builder: (BuildContext context) {
              return  AlertDialog(
                title: Text(response.data["title"]??""),
                content: Text(response.data["description"]??""),
              );
            },
          );
        }
  
      }
    } catch (e) {
      print('Error: $e');
    }
  
  }
  }
