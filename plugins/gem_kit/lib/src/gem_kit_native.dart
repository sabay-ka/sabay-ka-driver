// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc

// ignore_for_file: avoid_print

import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/_ffi/generated_binding.dart' as native_bindings;
import 'package:gem_kit/src/core/exceptions.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

Pointer<Uint8> passBinaryDataToC(Uint8List binaryData) {
  // Allocate memory for the binary data
  final Pointer<Uint8> dataPointer = malloc.allocate<Uint8>(binaryData.length);

  // Copy the Uint8List data to the allocated memory
  for (int i = 0; i < binaryData.length; i++) {
    dataPointer[i] = binaryData[i];
  }
  return dataPointer;
}

typedef DeletePointerC = Void Function(Pointer<Void> pointerVal);
typedef DeletePointerDart = void Function(Pointer<Void> pointerVal);

typedef GetBytesC = Pointer<Uint8> Function(Pointer<Void> pointerVal);
typedef GetBytesDart = Pointer<Uint8> Function(Pointer<Void> pointerVal);

typedef GetImageBufferC = Pointer<Void> Function(Int64 pointerId, Pointer<Utf8> className, Int32 width, Int32 height,
    Int32 imgType, Pointer<Utf8> arg, Int32 argLen);
typedef GetImageBufferDart = Pointer<Void> Function(
    int pointerId, Pointer<Utf8> className, int width, int height, int imgType, Pointer<Utf8> arg, int arglen);

final DynamicLibrary libToLoad = Platform.isWindows
    ? DynamicLibrary.open('GEMWebRTC.dll')
    : Platform.isLinux
        ? DynamicLibrary.open('libGEM.so')
        : Platform.isAndroid
            ? DynamicLibrary.open('libGEM.so')
            : DynamicLibrary.process();

class GemSdkNative {
  static int? cookie;
  bool initHasBeenDone = false;
  bool loadNativeCalled = false;
  dynamic handleDartObject;
  dynamic _callObjectMethod;
  dynamic _safecallObjectMethod;
  dynamic _callGetOsVersion;
  dynamic _callCreateBitmap;
  dynamic _callGetBitmapBuffer;
  dynamic _callWeakPtrCount;
  dynamic _callDeletePointer;
  dynamic _callGetBytes;
  dynamic _callGetSizeOfBytes;
  dynamic _callGetImageBuffer;
  dynamic _callCreateGemImage;
  dynamic _callReleaseNative;
  native_bindings.GEMKitFFigen? gemWebRTCNative;
  static int androidVersion = -1;
  int getAndroidVersion() {
    return androidVersion;
  }

  Completer<void> initializationCompleter = Completer<void>();
  Future<void> get initializationDone => initializationCompleter.future;
  Future<void> loadNative() async {
    if (loadNativeCalled) {
      return;
    }

    loadNativeCalled = true;
    if (gemWebRTCNative == null) {
      final lookUp = libToLoad.lookup;
      gemWebRTCNative = native_bindings.GEMKitFFigen.fromLookup(lookUp);
      handleDartObject =
          libToLoad.lookupFunction<Void Function(Handle, Int64), void Function(Object, int)>("HandleDartObject");

      _callObjectMethod = libToLoad.lookupFunction<Pointer<Utf8> Function(Handle, Pointer<Utf8>, Int64),
          Pointer<Utf8> Function(Object, Pointer<Utf8>, int)>("CallObjectMethodFFI");
      _safecallObjectMethod = libToLoad.lookupFunction<Pointer<Utf8> Function(Handle, Pointer<Utf8>, Int64, Bool),
          Pointer<Utf8> Function(Object, Pointer<Utf8>, int, bool)>("SafeCallObjectMethodFFI");

      _callGetOsVersion = libToLoad.lookupFunction<Int Function(), int Function()>("getOSVersionNumber");
      _callCreateBitmap =
          libToLoad.lookupFunction<Int64 Function(Int, Int), int Function(int, int)>("createBitmapObject");
      _callGetBitmapBuffer =
          libToLoad.lookupFunction<Pointer<Uint8> Function(Int64), Pointer<Uint8> Function(int)>("getBitmapBuffer");
      _callWeakPtrCount = libToLoad.lookupFunction<Int Function(Int64), int Function(int)>("GetObjectCountRefs");

      _callDeletePointer = libToLoad.lookupFunction<DeletePointerC, DeletePointerDart>('deletePointer');
      _callGetBytes = libToLoad.lookupFunction<GetBytesC, GetBytesDart>('getBytes');
      _callGetImageBuffer = libToLoad.lookupFunction<GetImageBufferC, GetImageBufferDart>('getImageBuffer');
      _callGetSizeOfBytes =
          libToLoad.lookupFunction<Int Function(Pointer<Void>), int Function(Pointer<Void>)>('getBytesSize');
      _callCreateGemImage = libToLoad.lookupFunction<Int64 Function(Pointer<Uint8>, Int64, Int32),
          int Function(Pointer<Uint8>, int, int)>("createGemImage");
      _callReleaseNative = libToLoad.lookupFunction<Void Function(), void Function()>("releaseNative");
      //if(Platform.isAndroid)
      {
        cookie = gemWebRTCNative!.Dart_InitializeApiDLFunc(NativeApi.initializeApiDLData);
        final pub = ReceivePort()
          ..listen((message) {
            if (message.toString() == "initCompleted") {
              if (!initHasBeenDone) {
                initHasBeenDone = true;
                initializationCompleter.complete();
                print("Native init is completed!!!");
              }
            } else {
              final decodedMessage = jsonDecode(message);
              GemKitPlatform.instance.nativeMethodHandler(decodedMessage);
            }
          });

        gemWebRTCNative!.set_dart_port(pub.sendPort.nativePort);
        androidVersion = _callGetOsVersion();
        print("Got the androidVersion $androidVersion");
        await initializationCompleter.future;

        //
      }
    }
  }

  void loadNativeD() {}
  void isolateEntryPoint(SendPort sendPort) {
    // This function runs in a separate isolate
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    // Wait for messages from the main isolate
    receivePort.listen((message) {
      if (message is Function) {
        // Register the isolate callback with the main isolate
        //final OnNotifyEventDart callback = onNotifyEventIsolate;
        //message(callback);
      }
    });
  }

  void registerCallbackPointer() {
    // final receivePort = ReceivePort();
    //Isolate.spawn(_sentryIsolate, _SentryIsolateMessage(receivePort.sendPort, isolateId, nativeLibraryPath));
    //_callbackStream = receivePort.listen((dynamic _) { _libraryExecuteCallbacks(isolateId); });
    native_bindings.Dart_onNotifyEvent pointer = Pointer.fromFunction(onNotifyEvent);
    gemWebRTCNative!.native_register_callback(pointer);
  }

  static void onNotifyEvent(Pointer<Char> pChar) {
    if (pChar != nullptr) {
      // final response = pChar.cast<Utf8>().toDartString();
      // final decodeId = jsonDecode(response);
    }
  }

  dynamic callObjectMethodWithWeak(Object object, String json, int markerId) {
    if (!initHasBeenDone) {
      throw ("Native not loaded! Called too early, please add the call on GemKitPlatform.instance.loadNative().then((value){} if you want to run it at startup");
    }
    //print("call object $json");
    final dataNative = json.toNativeUtf8();

    Pointer<Utf8> result = _callObjectMethod(object, dataNative, dataNative.length);
    if (result != nullptr) {
      final response = result.cast<Utf8>().toDartString();
      malloc.free(dataNative);
      malloc.free(result);
      return response;
    }
  }

  dynamic safecallObjectMethodWithWeak(Object object, String json, int markerId, bool forceSafeThreadSync) {
    if (!initHasBeenDone) {
      throw (GemKitUninitializedException());
    }
    //print("Safe call object $json with dispatchToMain $forceSafeThreadSync");
    final dataNative = json.toNativeUtf8();
    //print("sending data to be processed of size ${dataNative.length}");
    Pointer<Utf8> result = _safecallObjectMethod(object, dataNative, dataNative.length, false);
    if (result != nullptr) {
      final response = result.cast<Utf8>().toDartString();
      malloc.free(dataNative);
      malloc.free(result);
      return response;
    }
  }

  dynamic addList(
      {required MapViewMarkerCollections object,
      required List<MarkerWithRenderSettings> list,
      required MarkerCollectionRenderSettings settings,
      required String name,
      MarkerType markerType = MarkerType.point}) {
    Map<int, Pointer<Utf8>> markersImagePointers = {};
    for (var marker in list) {
      if (marker.settings.image != null) {
        Pointer<Utf8> imagePointer;
        if (markersImagePointers.containsKey(marker.settings.image!.hashCode)) {
          imagePointer = markersImagePointers[marker.settings.image!.hashCode]!;
        } else {
          imagePointer = jsonEncode(marker.settings.image).toNativeUtf8();
          markersImagePointers[marker.settings.image!.hashCode] = imagePointer;
        }
        MarkerInfoSpecialAccess.updateImagePointerSizeRenderSettings(marker.settings, imagePointer.length);
        MarkerInfoSpecialAccess.updateImagePointerValueRenderSettings(marker.settings, imagePointer.address);
      
      }
    }
    final pList = serializeListOfMarkers(list);
    final toSend = passBinaryDataToC(pList);
    //print("Binary value for list is ${pList.length}");
    final retVal = safecallObjectMethodWithWeak(
        object,
        jsonEncode({
          'id': object.pointerId,
          'class': "MapViewMarkerCollections",
          'method': "addList",
          'args': {
            'settings': settings,
            'collectionType': markerType.id,
            'name': name,
            'binarylist': toSend.address,
            'binarylistSize': pList.length
          }
        }),
        0,
        true);
    for (var imagePointer in markersImagePointers.entries) {
      malloc.free(imagePointer.value);
    }
    malloc.free(toSend);
    return retVal;
  }

  dynamic callCreateBitmap(int width, int height) {
    int result = _callCreateBitmap(width, height);
    return result;
  }

  dynamic callGetBitmap(int bitmapId, int width, int height) {
    Pointer<Uint8> result = _callGetBitmapBuffer(bitmapId);
    return result.asTypedList(width * height * 4);
  }

  Uint8List callGetImage(String className, int objectId, int width, int height, int imageType, {String? arg}) {
    arg ??= "";
    Pointer<Utf8> clsName = className.toNativeUtf8();
    Pointer<Utf8> pArg = arg.toNativeUtf8();
    Pointer<Utf8> buffer = _callGetImageBuffer(objectId, clsName, width, height, imageType, pArg, pArg.length);
    if (buffer == nullptr) {
      malloc.free(clsName);
      malloc.free(pArg);
      return Uint8List(0);
    }
    Pointer<Uint8> imgBuffer = _callGetBytes(buffer);
    final imgBufferSize = _callGetSizeOfBytes(buffer);
    final retVal = imgBuffer.asTypedList(imgBufferSize);
    malloc.free(clsName);
    malloc.free(pArg);
    _callDeletePointer(buffer);
    return retVal;
  }

  dynamic callObjectMethod(String json, int markerId) {
    if (cookie == null) {
      throw (GemKitUninitializedException());
    }
    //print("call object method $json");
    final dataNative = json.toNativeUtf8();
    final result = gemWebRTCNative!.native_call(dataNative.cast<Char>(), dataNative.length, markerId);
    if (result != nullptr) {
      final response = result.cast<Utf8>().toDartString();
      malloc.free(dataNative);
      malloc.free(result);
      return response;
    }
  }

  dynamic callCreateObject(String json) {
    if (cookie == null) {
      throw (GemKitUninitializedException());
    }
    final dataNative = json.toNativeUtf8();
    final result = gemWebRTCNative!.native_call_createObject(dataNative.cast<Char>(), dataNative.length);
    malloc.free(dataNative);
    if (result != nullptr) {
      String? response;
      try {
        response = result.cast<Utf8>().toDartString();
      } catch (e) {
        print(e);
      }
      malloc.free(result);
      return response;
    }

    return nullptr;
  }

  void callDeleteObject(String json) {
    final dataNative = json.toNativeUtf8().cast<Char>();
    gemWebRTCNative!.native_deleteObject(dataNative, json.length);
    malloc.free(dataNative);
  }

  int getObjectWeakPtrCount(dynamic objectId) {
    return _callWeakPtrCount(objectId);
  }

  void registerWeakRelease(Object obj, dynamic nativePointerId) {
    if (cookie == null) {
      throw (GemKitUninitializedException());
    }
    handleDartObject(obj, nativePointerId);
  }

  dynamic createGemImage(Uint8List buffer, int imgType) {
    final Pointer<Uint8> bufferPtr = malloc.allocate<Uint8>(buffer.length);
    bufferPtr.asTypedList(buffer.length).setAll(0, buffer);
    final result = _callCreateGemImage(bufferPtr, buffer.length, imgType);
    malloc.free(bufferPtr);
    return result;
  }

  void deleteCPointer(dynamic address) {
    Pointer<Utf8> pointer = Pointer<Utf8>.fromAddress(address);
    _callDeletePointer(pointer);
  }

  void release() {
    _callReleaseNative();
  }

  void setLibLoaded() {}
}
