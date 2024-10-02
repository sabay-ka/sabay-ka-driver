// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:typed_data';

import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/geographic_area.dart';
import 'package:gem_kit/src/core/landmark.dart';
import 'package:gem_kit/src/core/route.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';
import 'dart:math';

///  Route display modes
///
/// {@category Maps & 3D Scene}
enum RouteDisplayMode {
  /// Full route display
  full,

  /// Zoom to the branched part of the route
  branches,
}

/// @nodoc
extension RouteDisplayModeExtension on RouteDisplayMode {
  int get id {
    switch (this) {
      case RouteDisplayMode.full:
        return 0;
      case RouteDisplayMode.branches:
        return 1;
    }
  }

  static RouteDisplayMode fromId(int id) {
    switch (id) {
      case 0:
        return RouteDisplayMode.full;
      case 1:
        return RouteDisplayMode.branches;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Follow position state
///
/// {@category Maps & 3D Scene}
enum FollowPositionState {
  /// Enter following position
  entered,

  /// Exit following position
  exited,
}

class CameraTrackMethod {}

/// Interface for listening to map view events
///
/// {@category Maps & 3D Scene}
class IMapViewListener {
  /// Notifies that canvas was resized because of the screen resize
  ///
  /// **Parameters**
  ///
  /// * **IN** *viewport* The new dimensions of the viewport
  void onViewportResized(Rectangle<int> viewport) {}

  /// Single pointer touch down event.
  ///
  /// A touch event is defined as a pointer down and up within a preset time in milliseconds, and pointer movement has to be less than a preset distance in millimeters.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* is the position where event occurred
  void onTouch(Point pos) {}

  /// Raw unprocessed pointer up
  ///
  /// **Parameters**
  ///
  /// * **IN** *ptrId* Identifier for the pointer
  /// * **IN** *pos* Position of the pointer when it was lifted
  void onPointerUp(int pointerId, Point pos) {}

  /// Raw unprocessed pointer down started - used to determine when one of the other processed actions start.
  ///
  /// Set pointer down flag indicating that action started! The flag is cleared by the actual action, such as OnPinch, when it starts.
  ///
  /// **Parameters**
  ///
  /// * **IN** *ptrId* Identifier for the pointer
  /// * **IN** *pos* Position of the pointer
  void onPointerDown(int pointerId, Point pos) {}

  /// Raw unprocessed pointer move
  ///
  /// **Parameters**
  ///
  /// * **IN** *ptrId* Identifier for the pointer
  /// * **IN** *pos* New position of the pointer
  void onPointerMove(int pointerId, Point pos) {}

  /// This is called by the map view when it enters/exits the following position
  ///
  /// **Parameters**
  ///
  /// * **IN** *followPositionState* The state of the following position
  void onFollowPostionState(FollowPositionState followPositionState) {}

  /// Single pointer move event.
  ///
  /// A single pointer move event is defined as a pointer down, followed by a move, followed by a pointer up.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* is the start position involved in move action
  /// * **IN** *end* is the end position involved in move action
  void onMove(Point startPos, Point endPos) {}

  /// Single pointer long touch event.
  ///
  /// A long touch event is defined as a pointer down longer than a preset time in milliseconds and then pointer up, and pointer movement has to be less than a preset distance in millimeters.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* is the position where event occurred
  void onLongPress(Point pos) {}

  /// This is called by the map view when the map angle is changed
  ///
  /// This happens when either the user rotates the map, or the GPS angle is changed while in tracking mode
  ///
  /// **Parameters**
  ///
  /// * **IN** *angle* New angle of the map view
  void onMapAngleUpdate(double angle) {}

  /// External rendering for custom markers notification
  void onMarkerRender(dynamic data) {}

  /// Called by the View after rendering is finished
  void onViewRendered(dynamic data) {}
}

/// The map view class
///
/// This abstract class is implemented by [GemMapController]
///
/// {@category Maps & 3D Scene}
abstract class GemView extends EventHandler {
  dynamic _pointerId;
  int _mapId;
  Rectangle<int> _viewport;
  IMapViewListener _listener;
  late MapViewPreferences _preferences;
  MapViewExtensions? _extensions;
  bool hasPrefsInit = false;
  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unnecessary_getters_setters
  RectType<int> get viewport =>
      RectType<int>(x: _viewport.left, y: _viewport.top, width: _viewport.width, height: _viewport.height);

  set viewport(RectType<int> value) {
    _viewport = Rectangle(value.x ?? _viewport.left, value.y ?? _viewport.top, value.width ?? _viewport.bottom,
        value.height ?? _viewport.height);
  }

  IMapViewListener get listener => _listener;
  set setListener(IMapViewListener l) => _listener = l;

  GemView()
      : _pointerId = -1,
        _mapId = -1,
        _viewport = const Rectangle(0, 0, 0, 0),
        _listener = IMapViewListener();

  GemView.init(int id, int mapId, Rectangle<int> viewport)
      : _pointerId = id,
        _mapId = mapId,
        _viewport = viewport,
        _listener = IMapViewListener();

  /// Create a map view and save the view id.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<String?> createView(IMapViewListener l) async {
    _listener = l;
    _mapId = 0;

    try {
      final result = await GemKitPlatform.instance.getChannel(mapId: _mapId).invokeMethod<String>('createView');
      _pointerId = jsonDecode(result as String)['viewId'];

      GemKitPlatform.instance.registerEventHandler(_pointerId, this);

      return result;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// Release the map view.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<void> releaseView() async {
    try {
      await GemKitPlatform.instance
          .getChannel(mapId: _mapId)
          .invokeMethod<String>('releaseView', jsonEncode({"viewId": _pointerId}));
    } catch (e) {
      //return Future.error(e.toString());
    }
  }

  /// Sets the cursor screen position to the default location (the center of viewport).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void resetMapSelection() {
    setCursorScreenPosition(Point<int>((_viewport.width / 2).round(), (_viewport.height / 2).round()));
  }

  /// React to view events and call the listener functions.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  @override
  void handleEvent(dynamic method) {
    Map<String, dynamic> arguments;

    if (method is String) {
      arguments = jsonDecode(method);
    } else {
      arguments = method;
    }
    if (arguments['eventType'] == 'mapViewResizedEvent') {
      final Rectangle<int> viewport = Rectangle(arguments['viewport']['rectLeft'], arguments['viewport']['rectTop'],
          arguments['viewport']['rectWidth'], arguments['viewport']['rectHeight']);
      _listener.onViewportResized(viewport);
    }
    if (arguments['eventType'] == 'mapViewOnTouch') {
      final ptx = arguments['point']['ptX'];
      final pty = arguments['point']['ptY'];
      _listener.onTouch(Point(ptx, pty));
    } else if (arguments['eventType'] == 'mapViewFollowPositionEntered') {
      _listener.onFollowPostionState(FollowPositionState.entered);
    } else if (arguments['eventType'] == 'mapViewFollowPositionExited') {
      _listener.onFollowPostionState(FollowPositionState.exited);
    } else if (arguments['eventType'] == 'mapViewOnCursorSelUpdated') {
      // final lmks = jsonDecode(method.arguments)['lmks'];
      // if (lmks != null && lmks['count'] != null) {
      //   _listener.onCursorSelectionUpdatedLmks(lmks['count']);
      // }
      // final routes = jsonDecode(method.arguments)['routes'];
      // if (routes != null && routes['count'] != null) {
      //   _listener.onCursorSelectionUpdatedRoutes(routes['count']);
      // }
    } else if (arguments['eventType'] == 'onPointerUp') {
      final ptx = arguments['point']['ptX'];
      final pty = arguments['point']['ptY'];
      _listener.onPointerUp(arguments['pointerId'], Point(ptx, pty));
    } else if (arguments['eventType'] == 'onPointerDown') {
      final ptx = arguments['point']['ptX'];
      final pty = arguments['point']['ptY'];
      _listener.onPointerDown(arguments['pointerId'], Point(ptx, pty));
    } else if (arguments['eventType'] == 'onPointerMove') {
      final ptx = arguments['point']['ptX'];
      final pty = arguments['point']['ptY'];
      _listener.onPointerMove(arguments['pointerId'], Point(ptx, pty));
    } else if (arguments['eventType'] == 'onMove') {
      final ptx = arguments['startPoint']['ptX'];
      final pty = arguments['startPoint']['ptY'];
      final ptendx = arguments['endPoint']['ptX'];
      final ptendy = arguments['endPoint']['ptY'];
      _listener.onMove(Point(ptx, pty), Point(ptendx, ptendy));
    } else if (arguments['eventType'] == 'mapViewOnLongDown') {
      final ptx = arguments['point']['ptX'];
      final pty = arguments['point']['ptY'];
      _listener.onLongPress(Point(ptx, pty));
    } else if (arguments['eventType'] == 'onMapAngleUpdate') {
      final angle = arguments['angle'];
      _listener.onMapAngleUpdate(angle);
    } else if (arguments['eventType'] == 'onMarkerRender') {
      _listener.onMarkerRender(arguments);
    } else if (arguments['eventType'] == 'onViewRendered') {
      _listener.onViewRendered(arguments);
    }
  }

  /// Get the camera
  ///
  /// **Returns**
  ///
  /// * [MapCamera] future object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapCamera get camera {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getCamera", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MapCamera.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Stop the current animation
  ///
  /// The current animation is completed instantaneously and error code [GemError.cancel] is returned.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void skipAnimation() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "skipAnimation", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  /// Center the WGS coordinates on the screen coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* Coordinates
  /// * **IN** *zoomLevel* Zoom level (Use -1 for automatic selection)
  /// * **IN** *screenPosition* Screen position where the coordinates should project (default uses the specified cursor coordinates). The coordinates are relative to the parent view screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  /// * **IN** *mapAngle* Map rotation angle in the range **0.0 - 360.0** degrees (Use [double.infinity] for automatic selection).
  /// * **IN** *viewAngle* MapView angle in the range **-90.0 - 90.0** degrees (Use [double.infinity] for automatic selection).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnCoordinates(Coordinates coords,
      {int zoomLevel = -1,
      XyType<int>? screenPosition,
      GemAnimation? animation,
      double? mapAngle,
      double? viewAngle,
      double slippyZoomLevel = -1.0}) {
    try {
      if (viewAngle != null && (viewAngle - viewAngle.toInt() == 0)) {
        viewAngle -= 0.0000000001;
      }
      if (mapAngle != null && (mapAngle - mapAngle.toInt() == 0)) {
        mapAngle -= 0.0000000001;
      }
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(<String, dynamic>{
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnCoordinates",
            'args': {
              'coords': coords,
              'zoomLevel': zoomLevel,
              'slippyZoomLevel': slippyZoomLevel,
              if (screenPosition != null) 'xy': screenPosition,
              if (animation != null) 'animation': animation,
              if (mapAngle != null) 'mapAngle': mapAngle,
              if (viewAngle != null) 'viewAngle': viewAngle
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Center the view on the given WGS area
  ///
  /// **Parameters**
  ///
  /// * **IN** *area* Geographic area
  /// * **IN** *zoomLevel* Zoom level. When -1 is used, the zoom level is automatically selected so that the entire area is visible on the map.
  /// * **IN** *screenPosition* Screen position where the coordinates should project (default uses the specified cursor coordinates). The coordinates are relative to the parent view screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnArea(
    RectangleGeographicArea area, {
    int? zoomLevel = -1,
    XyType<int>? screenPosition,
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnArea",
            'args': {
              'area': area,
              'zoomLevel': zoomLevel,
              if (screenPosition != null) 'xy': screenPosition,
              if (animation != null) 'animation': animation
            }
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Center the on the given WGS area.
  /// 
  /// **Parameters**
  /// 
  /// * **IN** *area* Geographic area
  /// * **IN** *zoomLevel* Zoom level. When -1 is used, the zoom level is automatically selected so that the entire area is visible on the map.
  /// * **IN** *viewRc* Screen rectangle where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  /// 
  /// **Throws**
  /// 
  /// * An exception if it fails.
  void centerOnAreaRect(
    RectangleGeographicArea area, {
    required RectType<int> viewRc,
    int? zoomLevel = -1,
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnAreaRect",
            'args': {
              'area': area,
              'zoomLevel': zoomLevel,
              'viewRc': viewRc,
              if (animation != null) 'animation': animation
            }
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the cursor screen position. The coordinates are relative to the parent view screen
  ///
  ///  **Returns**
  ///
  /// * The current screen coordinates (Xy) of the cursor, relative to the view's parent screen.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  XyType<int>? get cursorScreenPosition {
    try {
      final val = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getCursorScreenPosition", 'args': {}}));
      final decodedVal = jsonDecode(val!);
      final retVal = XyType<int>.fromJson(decodedVal['result']);
      return retVal;
    } catch (e) {
      rethrow;
    }
  }

  /// Scroll map.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void scroll({required double dx, required double dy}) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "GemMapView", 'method': "scroll", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  /// Stop the camera from following the current real/simulated position.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void stopFollowingPosition() {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "stopFollowingPosition", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  /// Returns true if the camera is following the current real/simulated position and false otherwise.
  ///
  /// **Returns**
  ///
  /// * True if the map is currently following the current position.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isFollowingPosition {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "isFollowingPosition", 'args': {}}),
      );
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Returns true if the camera is following the current real/simulated position from a fixed relative position adjusted by user input and false otherwise.
  ///
  /// **Returns**
  ///
  /// * True if the follow position mode has been manually adjusted by the user, false if it remains in its default state.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isFollowingPositionTouchHandlerModified() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapView", 'method': "isFollowingPositionTouchHandlerModified", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Returns true if the camera is following the current real/simulated position in default auto-zoom mode and false otherwise.
  ///
  /// **Returns**
  ///
  /// * True if the map is in the default auto-zoom follow position mode, false if it has been manually adjusted or is not in follow position mode.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isDefaultFollowingPosition() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "isDefaultFollowingPosition", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set the cursor screen position.
  ///
  /// Use this function to trigger a map view selection (POI, landmark, overlay, route, path, marker) at the given screen coordinates.
  /// If map view selection changes, a notification is sent via *IMapViewListener::onCursorSelectionUpdated*
  /// The current view selection can be queried via cursorSelection...() functions.
  ///
  /// **Parameters**
  ///
  /// * **IN** *screenPosition*	position relative to the parent screen. The coordinates are relative to the parent view screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setCursorScreenPosition(Point<int> screenPosition) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "setCursorScreenPosition",
            'args': XyType<int>(x: screenPosition.x, y: screenPosition.y)
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Convert a screen(x, y) coordinate to a WGS(lon, lat) coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *screenCoordinates* Screen coordinate. The coordinates are relative to the parent view screen
  ///
  /// **Returns**
  ///
  /// WGS 84 coordinates
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates? transformScreenToWgs(XyType<int>? screenCoordinates) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "MapView", 'method': "transformScreenToWgs", 'args': screenCoordinates}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      throw e.toString();
    }
  }

  /// Convert a WGS84 coordinate to a screen coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* WGS Coordinates
  ///
  /// **Returns**
  ///
  /// The screen coordinates relative to view parent screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  XyType<int> transformWgsToScreen(Coordinates coords) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "transformWgsToScreen", 'args': coords}));
      final decodedVal = jsonDecode(resultString!);
      return XyType<int>.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Convert a lsit of WGS84 coordinates to screen coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* WGS Coordinates
  ///
  /// **Returns**
  ///
  /// The screen coordinates relative to view parent screen
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<XyType<int>> transformWgsListToScreen(List<Coordinates> coords) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "transformWgsListToScreen", 'args': coords}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<XyType<int>> retList = listJson.map((categoryJson) => XyType<int>.fromJson(categoryJson)).toList();
      return retList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get access to this view's preferences.
  ///
  /// **Returns**
  ///
  /// [MapViewPreferences] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewPreferences get preferences {
    if (hasPrefsInit == false) {
      try {
        final resultString = GemKitPlatform.instance.callObjectMethodffi(
            this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "preferences", 'args': {}}));
        final decodedVal = jsonDecode(resultString!);
        _preferences = MapViewPreferences.init(decodedVal['result'], _mapId);
        hasPrefsInit = true;
        return _preferences;
      } catch (e) {
        rethrow;
      }
    }
    return _preferences;
  }

  ///	Set the map north-up oriented.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void alignNorthUp({int duration = 0}) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "alignNorthUp", 'args': duration}));
    } catch (e) {
      rethrow;
    }
  }

  /// Get the maximum zoom level. Bigger zoom factor means closer to the map.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get maxZoomLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getMaxZoomLevel", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the maximum slippy zoom level. Bigger zoom factor means closer to the map.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get maxSlippyZoomLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getMaxSlippyZoomLevel", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set a new zoom level centered on the specified screen position.
  ///
  /// This may be between 0 and [maxZoomLevel]
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* Zoom level
  /// * **IN** *duration* The animation duration in milliseconds (0 means no animation).
  /// * **IN** *screenPosition* Screen coordinates on which the map should stay centered. The coordinates are relative to the parent view screen.
  ///
  /// **Returns**
  ///
  /// On success, the previous zoom level. On error, the error code.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int setZoomLevel(
    int zoomLevel, {
    int? duration,
    XyType<int>? screenPosition,
  }) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "setZoomLevel",
            'args': {
              'zoomLevel': zoomLevel,
              if (duration != null) 'duration': duration,
              if (screenPosition != null) 'xy': screenPosition
            }
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set a new zoom level based on slippy tile level.
  /// When "follow position" is active, the current position will be used as the reference point for the operation. Otherwise, the screen center will be used. The zoom level may be between 0 and *MaxSlippyZoomLevel*.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* Zoom level
  /// * **IN** *duration* The animation duration in milliseconds (0 means no animation).
  /// * **IN** *screenPosition* Screen coordinates on which the map should stay centered. The coordinates are relative to the parent view screen.
  ///
  /// **Returns**
  ///
  /// The previous zoom level.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double setSlippyZoomLevel(
    double zoomLevel, {
    int? duration,
    XyType<int>? screenPosition,
  }) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "setSlippyZoomLevel",
            'args': {
              'zoomLevel': zoomLevel,
              if (duration != null) 'duration': duration,
              if (screenPosition != null) 'xy': screenPosition
            }
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the zoom level.
  ///
  /// **Returns**
  ///
  /// The current zoom level.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get zoomLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getZoomLevel", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the slippy zoom level.
  ///
  /// **Returns**
  ///
  /// The current slippy zoom level.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double get slippyZoomLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getSlippyZoomLevel", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Restore following position from a manually adjusted mode (camera position fixed relative to the current/simulated position) to default auto-zoom mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void restoreFollowingPosition({GemAnimation? animation}) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "restoreFollowingPosition",
            'args': (animation != null) ? animation : {}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Disable highlighting.
  ///
  /// **Parameters**
  ///
  /// * **IN** *highlightId*	The highlighted collection id (optional).
  ///
  /// If the function fails, GEM_ERROR will contain the error (e.g. [GemError.invalidInput] if given *highlightId* doesn't exist).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void deactivateHighlight({int? highlightId}) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "deactivateHighlight",
            'args': (highlightId != null) ? highlightId : {}
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Disable highlighting.
  ///
  /// If the function fails, GEM_ERROR will contain the error.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void deactivateAllHighlights() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "deactivateAllHighlights", 'args': {}}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get highlighted geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *highlightId*	An identifier for the highlight whose area is to be retrieved, with a default value of 0.
  ///
  /// **Returns**
  ///
  /// A RectangleGeographicArea object representing the geographic bounds of the highlighted area
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea? getHighlightArea({int highlightId = 0}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getHighlightArea", 'args': highlightId}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      return null;
    }
  }

  /// Activate highlight
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarks*	[Landmark]
  /// * **IN** *renderSettings*	Specifies the way the provided landmarks are displayed on the map
  /// * **IN** *highlightId* The highlighted collection id (optional). If a highlighted collection with this id already exists, it will be replaced
  ///
  /// Highlighted collections will be displayed in ascending order sorted by highlightId
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void activateHighlight(
    List<Landmark> landmarks, {
    HighlightRenderSettings? renderSettings,
    int? highlightId,
  }) {
    final landmarkList = LandmarkList.fromList(landmarks);

    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "activateHighlight",
            'args': {
              'landmarks': landmarkList.pointerId,
              if (renderSettings != null) 'renderSettings': renderSettings,
              if (highlightId != null) 'highlightId': highlightId
            }
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Center on the given route.
  ///
  /// The zoom level is automatically selected so that the entire route is visible on the map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route*	[Route] to be shown.
  /// * **IN** *screenRect*	Screen rectangle where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRoute(
    Route route, {
    RectType<int>? screenRect,
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnRoute",
            'args': {
              'route': route.pointerId,
              if (screenRect != null) 'rc': screenRect,
              if (animation != null) 'animation': animation
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Center on the given route part.
  ///
  /// The zoom level is automatically selected so that the entire route is visible on the map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route*	[Route] to be shown.
  /// * **IN** *startDist*	Specifies the start distance from route begin.
  /// * **IN** *endDist*	Specifies the end distance from route begin.
  /// * **IN** *screenRect*	Screen rectangle where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRoutePart(
    Route route,
    int startDist,
    int endDist, {
    RectType<int>? screenRect,
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnRoutePart",
            'args': {
              'route': route.pointerId,
              'startDist': startDist,
              'endDist': endDist,
              if (screenRect != null) 'viewRc': screenRect,
              if (animation != null) 'animation': animation
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Center on the given route instruction.
  ///
  /// The route instruction turn arrow is visible on map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *routeInstruction*	Routing instruction
  /// * **IN** *zoomLevel*	Zoom level (Use -1 for automatic selection)
  /// * **IN** *screenPosition* Screen coordinate where area should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *viewAngle*	Specifies the map pitch angle.
  /// * **IN** *animation*	Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRouteInstruction(RouteInstruction routeInstruction,
      {double? zoomLevel, XyType<int>? screenPosition, double? viewAngle, GemAnimation? animation}) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnRouteInstruction",
            'args': {
              'instruction': routeInstruction.pointerId,
              'zoomLevel': zoomLevel ?? -1.0,
              if (screenPosition != null) 'xy': screenPosition,
              if (viewAngle != null) 'viewAngle': viewAngle,
              if (animation != null) 'animation': animation
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Center on the given routes collection.
  ///
  /// All routes from the list will be visible on the map. The zoom level is automatically selected.
  ///
  /// **Parameters**
  ///
  /// * **IN** *routesList* [Route] list to be shown. If no routes are provided then centering is done on the visible routes from [MapViewRoutesCollection].
  /// * **IN** *displayMode* [Route] display mode.
  /// * **IN** *screenRect* Screen viewport rectangle where routes should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnRoutes({
    List<Route>? routes,
    RouteDisplayMode? displayMode,
    RectType<int>? screenRect,
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnRoutes",
            'args': {
              'routesList': (routes != null) ? RouteList.fromList(routes).pointerId : -1,
              if (displayMode != null) 'displayMode': displayMode.id,
              if (screenRect != null) 'viewRc': screenRect,
              if (animation != null) 'animation': animation
            }
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Center on the routes visible on the map.
  ///
  /// **Parameters**
  ///
  /// * **IN** *displayMode* [Route] display mode.
  /// * **IN** *screenRect* Screen viewport rectangle where routes should be centered. The coordinates are relative to view parent screen.
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void centerOnMapRoutes({
    RouteDisplayMode? displayMode,
    RectType<int>? screenRect,
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "centerOnRoutes",
            'args': {
              'routesList': -1,
              if (displayMode != null) 'displayMode': displayMode.id,
              if (screenRect != null) 'viewRc': screenRect,
              if (animation != null) 'animation': animation
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieve the list of routes under the cursor location.
  ///
  /// **Returns**
  ///
  /// A list of Route objects under the cursor. If no routes are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Route> cursorSelectionRoutes() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "cursorSelectionRoutes", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RouteList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieve the list of landmarks under the cursor location.
  ///
  ///  **Returns**
  ///
  /// A list of Landmark objects under the cursor. If no landmarks are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> cursorSelectionLandmarks() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "cursorSelectionLandmarks", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieve the list of streets under the cursor location.
  ///
  /// **Returns**
  ///
  /// A list of Street objects under the cursor. If no streets are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> cursorSelectionStreets() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "cursorSelectionStreets", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieve the list of overlay items under the cursor location.
  ///
  /// **Returns**
  ///
  /// A list of OverlayItem objects under the cursor. If no overlay items are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<OverlayItem> cursorSelectionOverlayItems() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "cursorSelectionOverlayItems", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return OverlayItemList.init(decodedVal['result']).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves a reference to a list of markers under the current cursor location.
  ///
  /// **Returns**
  ///
  /// A list of MarkerMatch objects under the cursor. If no markers are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.

  List<MarkerMatch> cursorSelectionMarkers() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "cursorSelectionMarkers", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MarkerMatchList.init(decodedVal['result'], 0).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Start following the current position.
  ///
  /// Requires automatic map rendering. Disables the cursor if enabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *animation* Specifies the animation to be used by the operation.
  /// * **IN** *zoomLevel* Zoom level where the animation stops. (Use -1 for automatic selection)
  /// * **IN** *viewAngle* Map view angle. Default is **std::numeric_limits<double>::max()** meaning use default specified.
  /// * **IN** *positionObj* Navigation arrow scene object. If empty, a default SDK navigation arrow is used.
  /// * **IN** *trackMethod* The method is called by the camera every time a tracked object position changes (optional).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void startFollowingPosition({
    GemAnimation? animation,
    int? zoomLevel,
    double? viewAngle,
    MapSceneObject? positionObj,
    CameraTrackMethod? trackMethod,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "MapView",
        'method': "startFollowingPosition",
        'args': {
          if (animation != null) 'animation': animation,
          if (zoomLevel != null) 'zoomLevel': zoomLevel else 'zoomLevel': -1,
          if (viewAngle != null) 'viewAngle': viewAngle,
          if (positionObj != null) 'positionObj': positionObj,
          if (trackMethod != null) 'trackMethod': trackMethod
        }
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Allows the user to draw markers on the map using touch gestures.
  ///
  /// Panning/zooming the map is deactivated.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void enableDrawMarkersMode() {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "enabledrawmarkersmode", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  /// Disables the draw markers mode.
  ///
  /// **Returns**
  ///
  /// Landmarks generated during the draw markers mode.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> disableDrawMarkersMode() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "disabledrawmarkersmode", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieve the set of landmarks on the specified coordinates.
  ///
  /// This is a quick synchronous reverse geocoding method.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords*	Reference [Coordinates] for this operation.
  ///
  /// **Returns**
  ///
  /// A Landmark list containing the nearest locations to the specified coordinates. If no landmarks are found, the list will be empty.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getNearestLocations(Coordinates coords) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "getNearestLocations", 'args': coords}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Adds a GeoJSON data buffer as a marker collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer* The GeoJSON data buffer to be added as a marker collection.
  /// * **IN** *name* The name of the marker collection.
  ///
  /// **Returns**
  ///
  /// * The created marker collections
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<MarkerCollection> addGeoJsonAsMarkerCollection(String buffer, String name) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapView",
            'method': "addGeoJsonAsMarkerCollection",
            'args': {
              'name': name,
              'databuffer': buffer,
            }
          }),
          dispatchOnMainThread: true);
      List<MarkerCollection> pRet = List.empty(growable: true);
      final decodedVal = jsonDecode(resultString!);
      for (final markerCollectionId in decodedVal['result']) {
        pRet.add(MarkerCollection.init(markerCollectionId, 0));
      }
      return pRet;
    } catch (e) {
      rethrow;
    }
  }

  /// Make a screen region capture of the current map in binary format.
  ///
  /// No cursor/on-screen info is included.
  ///
  /// **Parameters**
  ///
  /// * **IN** *rect*	The screen rectangle to capture. If (0, 0, 0, 0) is provided then the entire map screen is captured.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Uint8List _captureAsImage({RectType<int>? rect}) {
    try {
      rect ??= RectType<int>(x: -1, y: -1, width: -1, height: -1);
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "captureAsImage", 'args': rect}),
          dispatchOnMainThread: true);
      final decodedVal = jsonDecode(resultString!);
      return base64Decode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Make a screen region capture of the current map in binary format.
  ///
  /// No cursor/on-screen info is included.
  ///
  /// **Parameters**
  ///
  /// * **IN** *rect*	The screen rectangle to capture. If (0, 0, 0, 0) is provided then the entire map screen is captured.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<Uint8List?> _captureAsImageAsync() async {
    final resultVal = await GemKitPlatform.instance.getChannel(mapId: mapId).invokeMethod("captureScreenshot");
    return resultVal;
  }

  /// Make a screen region capture of the current map in JPEG format.
  ///
  /// No cursor/on-screen info is included.
  ///
  /// **Returns**
  ///
  /// The image of the map shown on screen.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<Uint8List?> captureImage() async {
    if (GemKitPlatform.instance.androidVersion > -1) {
      return _captureAsImageAsync();
    } else {
      return _captureAsImage();
    }
  }

  /// Get access to MapViewExtensions
  ///
  /// **Returns**
  ///
  /// A MapViewExtensions object, providing additional functionalities and extensions specific to the MapView.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MapViewExtensions get extensions {
    if (_extensions == null) {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapView", 'method': "extensions", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      _extensions = MapViewExtensions.init(decodedVal['result'], _mapId);
    }
    return _extensions!;
  }
}
