// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:js';
import 'dart:core';

class GemSdkNative {
  Completer<void> initializationCompleter = Completer<void>();
  static int androidVersion = -1;

  int getAndroidVersion() {
    return androidVersion;
  }

  Future<void> loadNative() async {
    await initializationCompleter.future;
  }

  void registerCallbackPointer() {}

  static void onNotifyEvent() {}

  dynamic callObjectMethod(String json, int markerId) {
    var pWebRTCModule = context["Module"];
    final argumentsNative = pWebRTCModule.callMethod("allocateUTF8", [json]);
    final argumentsLength = pWebRTCModule.callMethod("lengthBytesUTF8", [json]);
    try {
      final result = pWebRTCModule.callMethod("_native_call_marker_add",
          [argumentsNative, argumentsLength, markerId]);
      String resultConverted =
          pWebRTCModule.callMethod("UTF8ToString", [result]);
      pWebRTCModule.callMethod("_gemFree", [argumentsNative]);
      pWebRTCModule.callMethod("_gemFree", [result]);
      return resultConverted;
    } catch (e) {
      print(e);
    }
    return null;
  }

  dynamic callCreateObject(String json) {
    var pWebRTCModule = context["Module"];
    final argumentsNative = pWebRTCModule.callMethod("allocateUTF8", [json]);
    final argumentsLength = pWebRTCModule.callMethod("lengthBytesUTF8", [json]);

    try {
      final result = pWebRTCModule.callMethod("_native_call_createObject", [
        argumentsNative,
        argumentsLength,
      ]);
      String resultConverted =
          pWebRTCModule.callMethod("UTF8ToString", [result]);
      pWebRTCModule.callMethod("_gemFree", [argumentsNative]);
      pWebRTCModule.callMethod("_gemFree", [result]);
      return resultConverted;
    } catch (e) {
      print(e);
    }
    return null;
  }

  void callDeleteObject(String json) {
    var pWebRTCModule = context["Module"];
    final argumentsNative = pWebRTCModule.callMethod("allocateUTF8", [json]);
    final argumentsLength = pWebRTCModule.callMethod("lengthBytesUTF8", [json]);
    try {
      pWebRTCModule.callMethod("_native_deleteObject", [
        argumentsNative,
        argumentsLength,
      ]);
      pWebRTCModule.callMethod("_gemFree", [argumentsNative]);
    } catch (e) {
      print(e);
    }
  }

  void registerWeakRelease(Object obj, dynamic nativePointerId) {}

  dynamic callObjectMethodWithWeak(Object object, String json, int markerId) {
    return callObjectMethod(json, markerId);
  }

  dynamic callCreateBitmap(int width, int height) {
    var pWebRTCModule = context["Module"];
    return pWebRTCModule.callMethod("_createBitmapObject", [
      width,
      height,
    ]);
  }

  dynamic callGetBitmap(int bitmapId, int width, int height) {
    var pWebRTCModule = context["Module"];
    final result = pWebRTCModule.callMethod("_getBitmapBuffer", [
      bitmapId,
      width,
      height,
    ]);
    return result;
  }

  void setLibLoaded() {
    final finalizationRegistryConstructor =
        context['FinalizationRegistry'] as JsFunction;

    // Create an instance of FinalizationRegistry using JsObject
    final registry = JsObject(finalizationRegistryConstructor, [
      allowInterop((Object heldValue) {
        print("Object is about to be garbage-collected: $heldValue");
        // Perform cleanup or any necessary actions
      }),
    ]);

    // Create an object
    final myObject = {"key": "value"};

    // Register the object with the FinalizationRegistry
    registry.callMethod('register', [myObject, "CustomHandle"]);

    // Register the object with the FinalizationRegistry
    // registry.callMethod('register', [myObject, "CustomHandle"]);
    // final finalizationRegistry = FinalizationRegistry((handle) {
    //   print("Object is about to be garbage-collected: $handle");
    //   // Perform cleanup or any necessary actions
    // });

    // // Create an object
    // final myObject = {"key": "value"};

    // // Register the object with the FinalizationRegistry
    // finalizationRegistry.register(myObject, "CustomHandle");
    initializationCompleter.complete();
  }
}
