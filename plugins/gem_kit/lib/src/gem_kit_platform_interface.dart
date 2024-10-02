// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc

import 'dart:collection';

import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/contentstore/content_store.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';
import 'package:gem_kit/src/contentstore/content_updater.dart';
import 'package:gem_kit/src/contentstore/content_updater_status.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/offboard_listener.dart';
import 'package:gem_kit/src/core/sdk_settings.dart';

import 'package:gem_kit/src/gem_kit_native.dart' if (dart.library.html) 'package:gem_kit/src/gem_kit_native_web.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dart:async';
import 'dart:convert';

class _CacheEntry {
  final Uint8List image;
  DateTime timestamp;

  _CacheEntry(this.image, this.timestamp);
}

/// Platform initialization.
class GemKitPlatform extends PlatformInterface {
  final Map<String, _CacheEntry> _cache = HashMap();
  final Duration _cacheDuration = const Duration(minutes: 1);
  Timer? _cleanupTimer;

  /// Constructs a GemMapsPlatform.
  static final Object gemToken = Object();

  GemSdkNative gemKit = GemSdkNative();

  late OffBoardListener mOffboardListener;
  late ContentUpdater mContentUpdater;
  late ContentUpdater mStyleUpdater;

  GemKitPlatform() : super(token: gemToken) {
    _startPeriodicCleanup();
  }

  static GemKitPlatform? _gemInstance;

  /// The default instance of [GemKitPlatform] to use.
  static GemKitPlatform get instance {
    _gemInstance ??= GemKitPlatform();
    return _gemInstance!;
  }

  static void disposeGemSdk() {
    _gemInstance?.gemKit.release();
    _gemInstance = null;
  }

  /// Platform-specific implementations should set this with their own platform-specific class that extends [GemKitPlatform] when they register themselves.
  static set instance(GemKitPlatform instance) {
    PlatformInterface.verifyToken(instance, gemToken);
    _gemInstance = instance;
  }

  /// Initializes the platform interface with [mapId].
  ///
  /// This method is called when the plugin is first initialized.
  Future<dynamic> init(int mapId) async {
    final MethodChannel channel = ensureChannelInitialized(mapId);
    final result = await channel.invokeMethod<String>('waitForViewId');
    var viewId = jsonDecode(result!);
    return viewId;
  }

  // Keep a collection of id -> channel
  // Every method call passes the int mapId
  final Map<int, MethodChannel> _channels = <int, MethodChannel>{};

  /// Returns the channel for [mapId], creating it if it doesn't already exist.
  @visibleForTesting
  MethodChannel ensureChannelInitialized(int mapId) {
    MethodChannel? channel = _channels[mapId];
    if (channel == null) {
      channel = MethodChannel('plugins.flutter.dev/gem_maps_$mapId');
      channel.setMethodCallHandler((MethodCall call) => _handleMethodCall(call, mapId));
      _channels[mapId] = channel;
    }
    return channel;
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int mapId) async {
    gemEventsMethodHandler(call);
  }

  /// Map with viewId and EventHandler
  Map<dynamic, EventHandler> eventHandlerMap = {};

  void registerEventHandler(dynamic listenerId, EventHandler ptr) {
    eventHandlerMap[listenerId.toString()] = ptr;
  }

  void unregisterEventHandler(dynamic listenerId) {
    eventHandlerMap.remove(listenerId.toString());
  }

  void gemEventsMethodHandlerAndroid(MethodCall methodCall) {
    final decodedJson = jsonDecode(methodCall.arguments);
    for (final iter in decodedJson) {
      dynamic name;
      var parsedBigInt = BigInt.tryParse(iter['eventName']);
      if (parsedBigInt != null) {
        name = parsedBigInt.toSigned(64);
      } else {
        var parsedInt = int.tryParse(iter['eventName']);
        if (parsedInt != null) {
          name = parsedInt;
        } else {
          // Handle the case where the conversion failed
          // or assign a default value if desired.
        }
      }
      if (eventHandlerMap.containsKey(name)) {}
      eventHandlerMap[name.toString()]?.handleEvent(iter['arguments']);
    }
  }

  void nativeMethodHandler(dynamic iter) {
    dynamic name;
    var parsedBigInt = BigInt.tryParse(iter['eventName']);
    if (parsedBigInt != null) {
      name = parsedBigInt.toSigned(64);
    } else {
      var parsedInt = int.tryParse(iter['eventName']);
      if (parsedInt != null) {
        name = parsedInt;
      } else {
        // Handle the case where the conversion failed
        // or assign a default value if desired.
      }
    }
    if (eventHandlerMap.containsKey(name)) {}
    eventHandlerMap[name.toString()]?.handleEvent(iter['arguments']);
  }

  Future<dynamic> gemEventsMethodHandler(MethodCall methodCall) async {
    dynamic name;
    if (methodCall.method == "notifyEvents") {
      gemEventsMethodHandlerAndroid(methodCall);
    } else {
      var parsedBigInt = BigInt.tryParse(methodCall.method);
      if (parsedBigInt != null) {
        name = parsedBigInt.toSigned(64);
      } else {
        var parsedInt = int.tryParse(methodCall.method);
        if (parsedInt != null) {
          name = parsedInt;
        } else {
          // Handle the case where the conversion failed
          // or assign a default value if desired.
        }
      }
      if (eventHandlerMap.containsKey(name)) {}
      eventHandlerMap[name.toString()]?.handleEvent(methodCall.arguments);
    }
  }

  MethodChannel getChannel({int mapId = 0}) {
    return ensureChannelInitialized(mapId);
  }

  dynamic callObjectMethod(String json) {
    return gemKit.callObjectMethod(json, 0);
  }

  dynamic callObjectMethodffi(Object obj, String json) {
    return gemKit.callObjectMethodWithWeak(obj, json, 0);
  }

  dynamic safecallObjectMethodffi(Object obj, String json, {bool? dispatchOnMainThread}) {
    return gemKit.safecallObjectMethodWithWeak(
        obj, json, 0, (dispatchOnMainThread != null) ? dispatchOnMainThread : false);
  }

  int callBitmapConstructor(int width, int height) {
    return gemKit.callCreateBitmap(width, height);
  }

  Uint8List callGetBitmapBuffer(int id, int width, int height) {
    return gemKit.callGetBitmap(id, width, height);
  }

  dynamic callCreateObject(String json) {
    return gemKit.callCreateObject(json);
  }

  void callDeleteObject(String json) {
    gemKit.callDeleteObject(json);
  }

  void registerWeakRelease(Object obj, dynamic nativeObjectId) {
    gemKit.registerWeakRelease(obj, nativeObjectId);
  }

  void registerCallbackPointer() {
    //gemKit.registerCallbackPointer();
  }

  Future<void> loadNative({String? appAuthorization}) async {
    if (!gemKit.initHasBeenDone && !gemKit.loadNativeCalled) {
      await gemKit.loadNative();
      if (appAuthorization != null) {
        SdkSettings.appAuthorization = appAuthorization;
      }

      SdkSettings.setAllowConnection(
        true,
        onAvailableContentUpdateCallback: (type, status) {
          if (ContentType.viewStyleHighRes == type || ContentType.viewStyleLowRes == type) {
            mStyleUpdater = ContentStore.createContentUpdater(type);

            mStyleUpdater.update(true, onStatusUpdated: (status) {
              if (status == ContentUpdaterStatus.fullyReady || status == ContentUpdaterStatus.partiallyReady) {
                mStyleUpdater.apply();
              }
            });
          }
        },
        onWorldwideRoadMapSupportStatusCallback: (status) {
          mContentUpdater = ContentStore.createContentUpdater(ContentType.roadMap);

          mContentUpdater.update(true, onStatusUpdated: (status) {
            if (status == ContentUpdaterStatus.fullyReady || status == ContentUpdaterStatus.partiallyReady) {
              mContentUpdater.apply();
            }
          });
        },
      );
    }
  }

  int get androidVersion {
    return gemKit.getAndroidVersion();
  }

  int getObjectWeakPtrCount(dynamic objectId) {
    return gemKit.getObjectWeakPtrCount(objectId);
  }

  void setLibLoaded() {
    gemKit.setLibLoaded();
  }

  Uint8List callGetImage(int pointerId, String className, int width, int height, int imageType,
      {String? arg, int? imageId}) {
    final now = DateTime.now(); // Store current time in a variable

    if (imageId != null) {
      final cacheKey = _generateCacheKey(imageId, width, height);
      final cacheEntry = _cache[cacheKey];
      if (cacheEntry != null && now.difference(cacheEntry.timestamp) < _cacheDuration) {
        // Return cached image if it is still valid
        cacheEntry.timestamp = now; // Update timestamp
        return cacheEntry.image;
      }
    }
    // Get new image and update cache
    final image = gemKit.callGetImage(className, pointerId, width, height, imageType, arg: arg);
    if (imageId != null) {
      final cacheKey = _generateCacheKey(imageId, width, height);
      _cache[cacheKey] = _CacheEntry(image, now); // Use the stored current time
    }

    return image;
  }

  void _clearStaleCacheEntries([int? imageId, int? width, int? height]) {
    final now = DateTime.now();
    final keysToRemove = <String>[];
    _cache.forEach((key, entry) {
      if (now.difference(entry.timestamp) >= _cacheDuration ||
          (imageId != null && key.startsWith('$imageId-') && !key.endsWith('-$width-$height'))) {
        keysToRemove.add(key);
      }
    });
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(_cacheDuration, (timer) {
      _clearStaleCacheEntries();
    });
  }

  Future<void> get initializationDone async {
    return gemKit.initializationDone;
  }

  dynamic createGemImage(Uint8List data, int imageType) {
    return gemKit.createGemImage(data, imageType);
  }

  void deleteCPointer(dynamic pointer) {
    gemKit.deleteCPointer(pointer);
  }

  String _generateCacheKey(int imageId, int width, int height) {
    return '$imageId-$width-$height';
  }

  dynamic addList(
      {required MapViewMarkerCollections object,
      required List<MarkerWithRenderSettings> list,
      required MarkerCollectionRenderSettings settings,
      required String name,
      MarkerType markerType = MarkerType.point}) {
    return gemKit.addList(object: object, list: list, settings: settings, name: name);
  }
}
