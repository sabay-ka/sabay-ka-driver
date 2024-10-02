// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: avoid_print

import 'dart:math';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:flutter/foundation.dart' show Factory, kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dart:async';
import 'dart:io';

import '../gem_kit_platform_interface.dart';

/// Mode of hosting native Android view in Flutter
///
/// {@category Maps & 3D Scene}
enum AndroidViewMode {
  /// auto - checking against the version of Android and selecting the best mode
  auto,

  /// hybridComposition - Is slower on Android versions prior to Android 10.s
  hybridComposition,

  /// virtualDisplay - can cause problems on Android 12
  virtualDisplay,
}

/// Callback method for when the map is ready to be used.
///
/// Pass to [GemMap.onMapCreated] to receive a [GemMapController] when the map is created.
typedef MapCreatedCallback = void Function(GemMapController controller);

/// GemMap Widget
///
/// Displays the map on the screen. The map can be controlled using the [GemMapController] provided by the [onMapCreated] callback.
///
/// {@category Maps & 3D Scene}
class GemMap extends StatefulWidget {
  const GemMap(
      {Key? key,
      this.onMapCreated,
      this.androidViewMode = AndroidViewMode.auto,
      this.coordinates,
      this.area,
      this.zoomLevel,
      this.appAuthorization})
      : super(key: key);

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GemMapController] for this [GemMap].
  final MapCreatedCallback? onMapCreated;
  final AndroidViewMode androidViewMode;
  final Coordinates? coordinates;
  final RectangleGeographicArea? area;
  final int? zoomLevel;
  final String? appAuthorization;
  @override
  State createState() => GemMapState();
}

/// GemMap State
///
/// {@category Maps & 3D Scene}
class GemMapState extends State<GemMap> {
  final Completer<GemMapController> _controller = Completer<GemMapController>();
  double? pixelSize;
  @override
  void initState() {
    GemKitPlatform.instance.loadNative().then((value) {
      if (widget.appAuthorization != null && widget.appAuthorization!.isNotEmpty) {
        SdkSettings.appAuthorization = widget.appAuthorization!;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    pixelSize = mediaQuery.devicePixelRatio;
    if (kIsWeb) {
      return HtmlElementView(viewType: 'canvasView', onPlatformViewCreated: onPlatformViewCreated);
    }
    if (!kIsWeb && Platform.isIOS) {
      return buildNativeView(onPlatformViewCreated);
    } else if (Platform.isAndroid) {
      return buildNativeAndroidView(onPlatformViewCreated);
    } else if (Platform.isLinux) {
      //return GemTextureView(onPlatformViewCreated: onPlatformViewCreatedLinux);
    }
    return Container();
  }

  Widget buildNativeAndroidView(PlatformViewCreatedCallback onPlatformViewCreated) {
    // This is used in the platform side to register the view.
    const String viewType = 'plugins.flutter.dev/gem_maps';
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = {};
    var viewMode = widget.androidViewMode;
    if (widget.androidViewMode == AndroidViewMode.auto) {
      if (GemKitPlatform.instance.androidVersion != -1 && GemKitPlatform.instance.androidVersion >= 29) {
        viewMode = AndroidViewMode.hybridComposition;
        print("Auto selected ViewMode. AndroidViewMode.hybridComposition");
      } else {
        viewMode = AndroidViewMode.virtualDisplay;
        print("Auto selectd ViewMode. AndroidViewMode.virtualDisplay");
      }
    }

    if (viewMode == AndroidViewMode.hybridComposition) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          final AndroidViewController controller = PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged(true),
          );
          controller.addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.addOnPlatformViewCreatedListener(onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    }

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        final AndroidViewController controller = PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () => params.onFocusChanged(true),
        );
        controller.addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
        controller.addOnPlatformViewCreatedListener(onPlatformViewCreated);
        controller.create();
        return controller;
      },
    );
  }

  Widget buildNativeView(PlatformViewCreatedCallback onPlatformViewCreated) {
    // This is used in the platform side to register the view.
    const String viewType = 'plugins.flutter.dev/gem_maps';

    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'initialPosition': '45.456#25.568', // demo params.
    };

    return UiKitView(
      viewType: viewType,
      onPlatformViewCreated: onPlatformViewCreated,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Future<void> onPlatformViewCreatedLinux(int id, Rectangle<int> viewport) async {
    await GemKitPlatform.instance.initializationDone;

    final GemMapController controller = await GemMapController.init(id, this, pixelSize: pixelSize);
    controller.registerForEventsHandler();
    _controller.complete(controller);
    final MapCreatedCallback? onMapCreated = widget.onMapCreated;
    final Coordinates? coordinates = widget.coordinates;
    final RectangleGeographicArea? area = widget.area;
    final int zoomLevel = widget.zoomLevel ?? 16;
    if (coordinates != null) {
      GemAnimation animation = GemAnimation(duration: 0);
      controller.centerOnCoordinates(coordinates, animation: animation, zoomLevel: zoomLevel);
    }
    if (area != null) {
      GemAnimation animation = GemAnimation(duration: 0);
      controller.centerOnArea(area, animation: animation);
    }
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  Future<void> onPlatformViewCreated(int id) async {
    await GemKitPlatform.instance.initializationDone;
    final GemMapController controller = await GemMapController.init(id, this, pixelSize: pixelSize);
    controller.registerForEventsHandler();
    _controller.complete(controller);
    final MapCreatedCallback? onMapCreated = widget.onMapCreated;
    final Coordinates? coordinates = widget.coordinates;
    final RectangleGeographicArea? area = widget.area;
    final int zoomLevel = widget.zoomLevel ?? 16;
    if (coordinates != null) {
      GemAnimation animation = GemAnimation(duration: 0);
      controller.centerOnCoordinates(coordinates, animation: animation, zoomLevel: zoomLevel);
    }
    if (area != null) {
      GemAnimation animation = GemAnimation(duration: 0);
      controller.centerOnArea(area, animation: animation);
    }
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  @override
  void didUpdateWidget(GemMap oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GemMapController controller = await _controller.future;
    controller.dispose();
  }
}
