// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:typed_data';

import 'package:gem_kit/src/contentstore/content_store_item.dart';
import 'package:gem_kit/src/core/data_buffer.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/landmark_store_collection.dart';
import 'package:gem_kit/src/core/path.dart';
import 'package:gem_kit/src/core/route.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/map/map_scene.dart';
import 'package:gem_kit/src/map/markers.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/gem_kit_view.dart';

import 'dart:convert';

/// OverlayCollection for a MapView object.
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.overlays] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapViewOverlayCollection {
  final int _pointerId;
  final int _mapId;
  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  MapViewOverlayCollection._()
      : _pointerId = -1,
        _mapId = -1;

  MapViewOverlayCollection.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId;
}

/// The type of animation.
///
/// {@category Maps & 3D Scene}
enum AnimationType {
  /// No animation
  none,

  /// Linear animation
  linear,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension AnimationTypeExtension on AnimationType {
  int get id {
    switch (this) {
      case AnimationType.none:
        return 0;
      case AnimationType.linear:
        return 1;
    }
  }

  static AnimationType fromId(int id) {
    switch (id) {
      case 0:
        return AnimationType.none;
      case 1:
        return AnimationType.linear;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Perspectives in which the map is viewed
///
/// {@category Maps & 3D Scene}
enum MapViewPerspective {
  /// Two dimensional
  twoDimensional,

  /// Three dimensional
  threeDimensional,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MapViewPerspectiveExtension on MapViewPerspective {
  int get id {
    switch (this) {
      case MapViewPerspective.twoDimensional:
        return 0;
      case MapViewPerspective.threeDimensional:
        return 1;
    }
  }

  static MapViewPerspective fromId(int id) {
    switch (id) {
      case 0:
        return MapViewPerspective.twoDimensional;
      case 1:
        return MapViewPerspective.threeDimensional;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Map details quality levels
///
/// {@category Maps & 3D Scene}
enum MapDetailsQualityLevel {
  /// Low quality details
  low,

  /// Medium quality details
  medium,

  /// High quality details (default)
  high,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MapDetailsQualityLevelExtension on MapDetailsQualityLevel {
  int get id {
    switch (this) {
      case MapDetailsQualityLevel.low:
        return 0;
      case MapDetailsQualityLevel.medium:
        return 1;
      case MapDetailsQualityLevel.high:
        return 2;
    }
  }

  static MapDetailsQualityLevel fromId(int id) {
    switch (id) {
      case 0:
        return MapDetailsQualityLevel.low;
      case 1:
        return MapDetailsQualityLevel.medium;
      case 2:
        return MapDetailsQualityLevel.high;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Follow position map rotation mode
///
/// {@category Maps & 3D Scene}
enum FollowPositionMapRotationMode {
  /// Use position sensor heading for map rotation
  positionHeading,

  /// Use compass sensor for map rotation
  compass,

  /// Use fixed map rotation angle
  fixed,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension FollowPositionMapRotationModeExtension on FollowPositionMapRotationMode {
  int get id {
    switch (this) {
      case FollowPositionMapRotationMode.positionHeading:
        return 0;
      case FollowPositionMapRotationMode.compass:
        return 1;
      case FollowPositionMapRotationMode.fixed:
        return 2;
    }
  }

  static FollowPositionMapRotationMode fromId(int id) {
    switch (id) {
      case 0:
        return FollowPositionMapRotationMode.positionHeading;
      case 1:
        return FollowPositionMapRotationMode.compass;
      case 2:
        return FollowPositionMapRotationMode.fixed;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Touch gestures list
///
/// {@category Maps & 3D Scene}
enum TouchGestures {
  /// Single pointer touch event (down and up with negligible move) - not used - could be used for selection.
  onTouch,

  /// Single pointer long touch event - put a marker on the map.
  onLongDown,

  /// Single pointer double touch event - zoom in.
  onDoubleTouch,

  /// Two pointers single touch event - zoom out.
  onTwoPointersTouch,

  /// Two pointers double touch event - autocenter the globe.
  onTwoPointersDoubleTouch,

  /// Single pointer move event - pan.
  onMove,

  /// Single pointer touch event followed immediately by a vertical move/pan event = single pointer zoom in/out.
  onTouchMove,

  /// Single pointer linear swipe event - move/pan with pointer moving when lifted, in the dXInPix, dYInPix direction.
  onSwipe,

  /// Two pointer zooming swipe event - one or both pointers moving when lifted during pinch zoom, causing motion to continue for a while.
  onPinchSwipe,

  /// Two pointers pinch (pointers moving toward or away from each other) event - can include zoom and shove (2-pointer pan) but no rotate.
  onPinch,

  /// Two pointers rotate event - can include zoom and shove (distance between 2 pointers remains constant while line connecting them moves or rotates).
  onRotate,

  /// Two pointers shove event(2-pointer pan - pointers moving in the same direction the same distance) - can include rotate and zoom.
  onShove,

  /// Two pointers touch event followed immediately by a pinch event - not used.
  onTouchPinch,

  /// Two pointers touch event followed immediately by a rotate event - not used.
  onTouchRotate,

  /// Two pointers touch event followed immediately by a shove event - not used.
  onTouchShove,

  /// Two pointer rotating swipe event - one or both pointers moving when lifted during pinch rotate, causing motion to continue for a while.
  onRotatingSwipe,

  /// Allow internal events processing - if disabled, only send notifications to external listeners (UI)
  internalProcessing
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension TouchGesturesExtension on TouchGestures {
  int get id {
    switch (this) {
      case TouchGestures.onTouch:
        return 256;
      case TouchGestures.onLongDown:
        return 512;
      case TouchGestures.onDoubleTouch:
        return 1024;
      case TouchGestures.onTwoPointersTouch:
        return 2048;
      case TouchGestures.onTwoPointersDoubleTouch:
        return 4096;
      case TouchGestures.onMove:
        return 8192;
      case TouchGestures.onTouchMove:
        return 16384;
      case TouchGestures.onSwipe:
        return 32768;
      case TouchGestures.onPinchSwipe:
        return 65536;
      case TouchGestures.onPinch:
        return 131072;
      case TouchGestures.onRotate:
        return 262144;
      case TouchGestures.onShove:
        return 524288;
      case TouchGestures.onTouchPinch:
        return 1048576;
      case TouchGestures.onTouchRotate:
        return 2097152;
      case TouchGestures.onTouchShove:
        return 4194304;
      case TouchGestures.onRotatingSwipe:
        return 8388608;
      case TouchGestures.internalProcessing:
        return 2147483648;
    }
  }

  static TouchGestures fromId(int id) {
    switch (id) {
      case 256:
        return TouchGestures.onTouch;
      case 512:
        return TouchGestures.onLongDown;
      case 1024:
        return TouchGestures.onDoubleTouch;
      case 2048:
        return TouchGestures.onTwoPointersTouch;
      case 4096:
        return TouchGestures.onTwoPointersDoubleTouch;
      case 8192:
        return TouchGestures.onMove;
      case 16384:
        return TouchGestures.onTouchMove;
      case 32768:
        return TouchGestures.onSwipe;
      case 65536:
        return TouchGestures.onPinchSwipe;
      case 131072:
        return TouchGestures.onPinch;
      case 262144:
        return TouchGestures.onRotate;
      case 524288:
        return TouchGestures.onShove;
      case 1048576:
        return TouchGestures.onTouchPinch;
      case 2097152:
        return TouchGestures.onTouchRotate;
      case 4194304:
        return TouchGestures.onTouchShove;
      case 8388608:
        return TouchGestures.onRotatingSwipe;
      case 2147483648:
        return TouchGestures.internalProcessing;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Buildings visibility modes
///
/// {@category Maps & 3D Scene}
enum BuildingsVisibility {
  /// Show style default
  defaultVisibility,

  /// Hide
  hide,

  /// Show 2D (flat)
  twoDimensional,

  /// Show 3D
  threeDimensional,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension BuildingsVisibilityExtension on BuildingsVisibility {
  int get id {
    switch (this) {
      case BuildingsVisibility.defaultVisibility:
        return 0;
      case BuildingsVisibility.hide:
        return 1;
      case BuildingsVisibility.twoDimensional:
        return 2;
      case BuildingsVisibility.threeDimensional:
        return 3;
    }
  }

  static BuildingsVisibility fromId(int id) {
    switch (id) {
      case 0:
        return BuildingsVisibility.defaultVisibility;
      case 1:
        return BuildingsVisibility.hide;
      case 2:
        return BuildingsVisibility.twoDimensional;
      case 3:
        return BuildingsVisibility.threeDimensional;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Follow position preferences class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.followPositionPreferences] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class FollowPositionPreferences {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  FollowPositionPreferences._()
      : _pointerId = -1,
        _mapId = -1;

  FollowPositionPreferences.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get the follow position camera focus in viewport coordinates ( between 0.f = left / top and 1.f = right / bottom )
  ///
  /// **Returns**
  ///
  /// * The camera focus position
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  XyType<double> get cameraFocus {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "FollowPositionPreferences", 'method': "getCameraFocus", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return XyType<double>.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the map view perspective in follow position mode.
  ///
  /// **Returns**
  ///
  /// * The map perspective
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapViewPerspective get perspective {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "FollowPositionPreferences", 'method': "getPerspective", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MapViewPerspectiveExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the time interval before starting a turn presentation.
  ///
  /// **Returns**
  ///
  /// * The time interval in seconds.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get timeBeforeTurnPresentation {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "getTimeBeforeTurnPresentation",
        'args': {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Test if manually exiting follow position via touch handler events is enabled.
  ///
  /// Default value is true.
  ///
  /// **Returns**
  ///
  /// * True if exiting follow position is allowed, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get touchHandlerExitAllow {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "FollowPositionPreferences", 'method': "getTouchHandlerExitAllow", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Test if manually adjusted follow position changes (via touch handler) are persistent.
  ///
  /// **Returns**
  ///
  /// * True if changes are persistent, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get touchHandlerModifyPersistent {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "getTouchHandlerModifyPersistent",
        'args': {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the vertical angle.
  ///
  /// **Returns**
  ///
  /// * The view angle
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get viewAngle {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "FollowPositionPreferences", 'method': "getViewAngle", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get a zoom level in follow position mode.
  ///
  /// **Returns**
  ///
  /// * The current zoom level.
  ///
  /// -1 means auto-zooming is enabled.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get zoomLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "FollowPositionPreferences", 'method': "getZoomLevel", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if accuracy circle is visible.
  ///
  /// **Returns**
  ///
  /// * True if the accuracy circle is visible, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get accuracyCircleVisibility {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "FollowPositionPreferences",
            'method': "isAccuracyCircleVisible",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if position tracking object rotation follows map rotation.
  ///
  /// **Returns**
  ///
  /// * True if the position tracking object rotation follows map rotation, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isTrackObjectFollowingMapRotation {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "isTrackObjectFollowingMapRotation",
        'args': {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set accuracy circle visibility.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isVisible* True to show the accuracy circle
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError setAccuracyCircleVisibility(bool isVisible) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "setAccuracyCircleVisibility",
        'args': isVisible
      }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Set the follow position camera focus in viewport coordinates ( between 0.f = left / top and 1.f = right / bottom )
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* The camera focus point
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError setCameraFocus(XyType<double> pos) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "FollowPositionPreferences", 'method': "setCameraFocus", 'args': pos}));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Set map rotation mode in follow position.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mode* Map rotation mode.
  /// * **IN** *angle* The fixed rotation angle for [FollowPositionMapRotationMode.fixed].
  /// * **IN** *objectFollowMap* The position tracker object orientation will follow map view rotation.
  ///
  /// If the position tracker object orientation will follow map view rotation, all views using the same tracking object will see the object update.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setMapRotationMode(
    FollowPositionMapRotationMode mode, {
    double? angle,
    bool? objectFollowMap,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "FollowPositionPreferences",
            'method': "setMapRotationMode",
            'args': {
              'mode': mode.id,
              if (angle != null) 'angle': angle,
              if (objectFollowMap != null) 'objectFollowMap': objectFollowMap
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the map view perspective in follow position mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *perspective* The map perspective.
  /// * **IN** *animation* The operation animation type. Default is [AnimationType.none].
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setPerspective(
    MapViewPerspective perspective, {
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "setPerspective",
        'args': {'perspective': perspective.id, if (animation != null) 'animation': animation}
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the time interval before starting a turn presentation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *val* The time interval in seconds. -1 means using SDK default value.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set timeBeforeTurnPresentation(int val) {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "setTimeBeforeTurnPresentation",
        'args': val
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set manually adjusted follow position changes (via touch handler) persistent from one follow position session to another.
  ///
  /// Default value is false
  ///
  /// **Parameters**
  ///
  /// * **IN** *isPersistent* True to make changes persistent
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set touchHandlerModifyPersistent(bool isPersistent) {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "setTouchHandlerModifyPersistent",
        'args': isPersistent
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set whether to allow manually exiting follow position via touch handler events.
  ///
  /// Default value is true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *allowExit* True to allow exiting follow position
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set touchHandlerExitAllow(bool allowExit) {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "setTouchHandlerExitAllow",
        'args': allowExit
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set vertical angle in follow position mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* The view angle.
  /// * **IN** *animation* Enable/ disable the animation. Default is false.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setViewAngle(
    double viewAngle, {
    bool? animated,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "setViewAngle",
        'args': {'value': viewAngle, if (animated != null) 'animated': animated}
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set a zoom level in follow position mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel* Zoom level, may be between 0 and max zoom level.
  /// * **IN** *duration* The animation duration in milliseconds (0 means no animation)
  ///
  /// **Returns**
  ///
  /// * The previous zoom level
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int setZoomLevel(
    int zoomLevel, {
    int? duration,
  }) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "FollowPositionPreferences",
        'method': "setZoomLevel",
        'args': {'zoomLevel': zoomLevel, if (duration != null) 'duration': duration}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  void dispose() =>
      GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "FollowPositionPreferences", 'id': _pointerId}));
}

/// Mapview preferences
///
/// This class should not be instantiated directly. Instead, use the [GemView.preferences] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapViewPreferences {
  final dynamic _pointerId;
  final int _mapId;

  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  bool hasRoutesCollectionInit = false;
  bool hasPathCollectionInit = false;
  bool hasFollowPositionPrefsInit = false;

  late MapViewRoutesCollection _routes;
  late MapViewPathCollection _paths;
  LandmarkStoreCollection? _lmks;
  MapViewMarkerCollections? _markers;
  late FollowPositionPreferences _followPositionPreferences;

  MapViewPreferences()
      : _pointerId = -1,
        _mapId = -1;

  MapViewPreferences.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId;

  /// Enable / disable touch gestures.
  ///
  /// **Parameters**
  ///
  /// * **IN** *gestures* Packed [TouchGestures].
  /// * **IN** *enable* True to enable, false to disable
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void enableTouchGestures(List<TouchGestures> gestures, bool enable) {
    try {
      int gesturesValue = gestures.fold(0, (int previousValue, gesture) => previousValue | gesture.id);
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "enableTouchGestures",
            'args': {'gestures': gesturesValue, 'enable': enable}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Get follow position preferences.
  ///
  /// **Returns**
  ///
  /// * The current follow position preferences
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  FollowPositionPreferences get followPositionPreferences {
    if (hasFollowPositionPrefsInit == false) {
      try {
        final resultString = GemKitPlatform.instance.callObjectMethodffi(
            this,
            jsonEncode(
                {'id': _pointerId, 'class': "MapViewPreferences", 'method': "followPositionPreferences", 'args': {}}));
        final decodedVal = jsonDecode(resultString!);
        _followPositionPreferences = FollowPositionPreferences.init(decodedVal['result'], _mapId);
        hasFollowPositionPrefsInit = true;
      } catch (e) {
        rethrow;
      }
    }
    return _followPositionPreferences;
  }

  /// Get buildings visibility option.
  ///
  /// **Returns**
  ///
  /// * The buildings visibility option
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  BuildingsVisibility get buildingsVisibility {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "getBuildingsVisibility", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return BuildingsVisibilityExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get frames per second draw state.
  ///
  /// **Returns**
  ///
  /// * True if frames per second draw is enabled, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get drawFPS {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getDrawFPS", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the map view focus viewport.
  ///
  /// The focus viewport is the view screen part containing the maximum map details. The coordinates are relative to view parent screen.
  ///
  /// The default value is the view whole viewport.
  ///
  /// **Returns**
  ///
  /// * The focus viewport
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RectType<int> get focusViewport {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getFocusViewport", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RectType<int>.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get map details quality level.
  ///
  /// **Returns**
  ///
  /// * The map details quality level
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapDetailsQualityLevel get mapDetailsQualityLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "getMapDetailsQualityLevel", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MapDetailsQualityLevelExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the current view style content id. See [ContentStoreItem.id].
  ///
  /// If no style is set the function returns 0.
  ///
  /// **Returns**
  ///
  /// * The current view style content id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get mapStyleId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getMapStyleId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the current map view style
  ///
  /// **Returns**
  ///
  /// * The current map view style path
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get mapStylePath {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getMapStylePath", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the map view perspective.
  ///
  /// **Returns**
  ///
  /// * The map perspective
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapViewPerspective get mapViewPerspective {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getMapViewPerspective", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MapViewPerspectiveExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the maximum viewing angle.
  ///
  /// Maximum view angle is when the camera is looking directly toward the horizon.
  ///
  /// **Returns**
  ///
  /// * The maximum view angle
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get maxViewAngle {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getMaxViewAngle", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the minimum viewing angle.
  ///
  /// Minimum view angle is when the camera is looking directly downward at the map.
  ///
  /// **Returns**
  ///
  /// * The minimum view angle
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get minViewAngle {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getMinViewAngle", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the value of the NorthFixed flag.
  ///
  /// **Returns**
  ///
  /// * The NorthFixed flag value
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get northFixedFlag {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getNorthFixedFlag", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get map rotation angle in degrees relative to north-south axis.
  ///
  ///  The value of 0 corresponds to north-up alignment.
  ///
  /// **Returns**
  ///
  /// * The rotation angle
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get rotationAngle {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getRotationAngle", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get tilt angle in degrees.
  ///
  /// The tilt angle is 90 - [viewAngle].
  ///
  /// **Returns**
  ///
  /// * The tilt angle
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get tiltAngle {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getTiltAngle", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get enabled touch gestures packed.
  ///
  /// **Returns**
  ///
  /// * Packed [TouchGestures]
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get touchGesturesStates {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "getTouchGesturesStates", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get traffic visibility.
  ///
  /// By default is true if current map style contains the traffic layer.
  ///
  /// **Returns**
  ///
  /// * True if traffic is visible, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get trafficVisibility {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getTrafficVisibility", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the viewing angle.
  ///
  /// **Returns**
  ///
  /// * The view angle
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get viewAngle {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "getViewAngle", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Test if cursor is enabled.
  ///
  /// Default is false.
  ///
  /// **Returns**
  ///
  /// * True if the cursor is enabled, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get cursorEnabled {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "isCursorEnabled", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Test if cursor render is enabled.
  ///
  /// Default is false.
  ///
  /// **Returns**
  ///
  /// * True if the cursor rendering is enabled, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isCursorRenderEnabled {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "isCursorRenderEnabled", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the given map scene object visibility in current view.
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The [MapSceneObject]
  ///
  /// **Returns**
  ///
  /// * True if the object is visible, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool isMapSceneObjectVisible(MapSceneObject obj) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "isMapSceneObjectVisible", 'args': obj}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if touch gesture is enabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The [MapSceneObject]
  ///
  /// **Returns**
  ///
  /// * True if the touch gesture is enabled
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool isTouchGestureEnabled(TouchGestures gesture) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "isTouchGestureEnabled", 'args': gesture}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get access to the visibility settings for the landmark stores.
  ///
  /// **Returns**
  ///
  /// * The landmark store collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  LandmarkStoreCollection get lmks {
    if (_lmks == null) {
      try {
        final resultString = GemKitPlatform.instance.callObjectMethod(
            jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "lmks", 'args': {}}));
        final decodedVal = jsonDecode(resultString!);
        _lmks = LandmarkStoreCollection.init(decodedVal['result'], _mapId);
      } catch (e) {
        rethrow;
      }
    }
    return _lmks!;
  }

  /// Get access to the collections of visible markers.
  ///
  /// **Returns**
  ///
  /// * The markers collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapViewMarkerCollections get markers {
    if (_markers == null) {
      try {
        final resultString = GemKitPlatform.instance.callObjectMethodffi(
            this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "markers", 'args': {}}));
        final decodedVal = jsonDecode(resultString!);
        _markers = MapViewMarkerCollections.init(decodedVal['result'], _mapId);
      } catch (e) {
        rethrow;
      }
    }
    return _markers!;
  }

  /// Get access to the collection of visible overlays.
  ///
  /// **Returns**
  ///
  /// * The overlays collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapViewOverlayCollection get overlays {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "overlays", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MapViewOverlayCollection.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get access to the collection of visible paths.
  ///
  /// **Returns**
  ///
  /// * The paths collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapViewPathCollection get paths {
    if (hasPathCollectionInit == false) {
      try {
        final resultString = GemKitPlatform.instance.callObjectMethod(
            jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "paths", 'args': {}}));
        final decodedVal = jsonDecode(resultString!);
        _paths = MapViewPathCollection.init(decodedVal['result'], _mapId);
        hasPathCollectionInit = true;
        return _paths;
      } catch (e) {
        rethrow;
      }
    }
    return _paths;
  }

  /// Get access to the collection of visible routes.
  ///
  /// **Returns**
  ///
  /// * The routes collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapViewRoutesCollection get routes {
    if (hasRoutesCollectionInit == false) {
      try {
        final resultString = GemKitPlatform.instance.callObjectMethod(
            jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "routes", 'args': {}}));
        final decodedVal = jsonDecode(resultString!);
        _routes = MapViewRoutesCollection.init(decodedVal['result'], _mapId);
        hasRoutesCollectionInit = true;
        return _routes;
      } catch (e) {
        rethrow;
      }
    }
    return _routes;
  }

  /// Set buildings visibility to specified option.
  ///
  /// **Parameters**
  ///
  /// * **IN** *option* The buildings visibility option
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set buildingsVisibility(BuildingsVisibility option) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "setBuildingsVisibility", 'args': option.id}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Set car model by path.
  ///
  /// **Parameters**
  ///
  /// * **IN** *filePath* The path to the car model
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set carModelByPath(String filePath) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "setCarModelByPath", 'args': filePath}));
    } catch (e) {
      rethrow;
    }
  }

  /// Enable/disable frames per second draw.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isEnabled* True to enable frames per second draw
  /// * **IN** *pos* 	The position of the frames per second draw
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setDrawFPS(bool isEnabled, XyType<int> pos) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setDrawFPS",
            'args': {'bEnable': isEnabled, 'pos': pos}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the map view focus viewport.
  ///
  /// If view is an empty viewport the focus will be reset to whole view.
  ///
  /// **Parameters**
  ///
  /// * **IN** *view* The focus viewport
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set focusViewport(RectType<int> view) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "setFocusViewport", 'args': view}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set map details quality level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *level* Map details quality level, see [MapDetailsQualityLevel]
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set mapDetailsQualityLevel(MapDetailsQualityLevel level) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setMapDetailsQualityLevel",
            'args': level.id
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the given map scene object visibility in current view.
  ///
  /// **Parameters**
  ///
  /// * **IN** *obj* The [MapSceneObject]
  /// * **IN** *visible* True to show the object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setMapSceneObjectVisibility(MapSceneObject obj, bool visible) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setMapSceneObjectVisibility",
            'args': {'obj': obj, 'visible': visible}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set map view details by content.
  ///
  /// **Parameters**
  ///
  /// * **IN** *style* Style content.
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  void setMapStyle(
    ContentStoreItem style, {
    bool? smoothTransition,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setMapStyle",
            'args': {'style': style, if (smoothTransition != null) 'smoothTransition': smoothTransition}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set map view details by content id.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* Content id. See [ContentStoreItem.id].
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  void setMapStyleById(
    int id, {
    bool? smoothTransition,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setMapStyleById",
            'args': {'id': id, if (smoothTransition != null) 'smoothTransition': smoothTransition}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set map view style by content path
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* Content path. See [ContentStoreItem.fileName].
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  void setMapStyleByPath(
    String path, {
    bool? smoothTransition,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "MapViewPreferences",
          'method': "setMapStyleByPath",
          'args': {'path': path, if (smoothTransition != null) 'smoothTransition': smoothTransition}
        }),
        dispatchOnMainThread: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Set map view style by content buffer
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer* Content buffer.
  /// * **IN** *smoothTransition* Enables a smooth transition between old and new style.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  void setMapStyleByBuffer(
    Uint8List buffer, {
    bool? smoothTransition,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setMapStyleByBuffer",
            'args': {'content': buffer, if (smoothTransition != null) 'smoothTransition': smoothTransition}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the map view perspective.
  ///
  /// **Parameters**
  ///
  /// * **IN** *perspective* The map perspective.
  /// * **IN** *aniamtion* The operation animation type. Default is [AnimationType.none].
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  void setMapViewPerspective(
    MapViewPerspective perspective, {
    GemAnimation? animation,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setMapViewPerspective",
            'args': {'perspective': perspective, if (animation != null) 'animation': animation}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the value of the NorthFixed flag.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isNorthFixed* The NorthFixed flag value
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  set setNorthFixedFlag(bool isNorthFixed) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "setNorthFixedFlag", 'args': isNorthFixed}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the map rotation angle in degrees relative to north-south axis.
  ///
  /// **Parameters**
  ///
  /// * **IN** *angle* The rotation angle in degrees.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  set rotationAngle(double rotationAngle) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "setRotationAngle", 'args': rotationAngle}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set tilt angle in degrees.
  ///
  /// The tilt angle is 90 - [viewAngle].
  ///
  /// **Parameters**
  ///
  /// * **IN** *angleDegrees* The tilt angle in degrees.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  set tiltAngle(double tiltAngle) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "setTiltAngle", 'args': tiltAngle}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set enabled touch gestures packed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *enabledTouchGesturesBitfield* Packed [TouchGestures]
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  set touchGesturesStates(int enabledTouchGesturesBitfield) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setTouchGesturesStates",
            'args': enabledTouchGesturesBitfield
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set traffic visibility.
  ///
  /// Will return [GemError.notFound] if current map style doesn't contain the traffic layer.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isVisible* True to show traffic
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  GemError setTrafficVisibility(bool isVisible) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "setTrafficVisibility", 'args': isVisible}),
          dispatchOnMainThread: true);
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Set the viewing angle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* The view angle.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  void setViewAngle(
    double viewAngle, {
    bool? animated,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPreferences",
            'method': "setViewAngle",
            'args': {'value': viewAngle, if (animated != null) 'animated': animated}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Update current style from json (studio style editor use case).
  ///
  /// **Parameters**
  ///
  /// * **IN** *data* The JSON data buffer
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  void updateCurrentStyleFromJson(DataBuffer data) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewPreferences", 'method': "updateCurrentStyleFromJson", 'args': data}));
    } catch (e) {
      rethrow;
    }
  }

  /// Enable/Disable the cursor mode When the cursor is enabled map selection can be activated by calling setCursorScreenPosition The cursor is automatically disabled by [GemView.startFollowingPosition].
  ///
  /// **Parameters**
  ///
  /// * **IN** *isEnabled* True to enable the cursor
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set enableCursor(bool isEnabled) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "enableCursor", 'args': isEnabled}));
    } catch (e) {
      rethrow;
    }
  }

  /// Enable/Disable the cursor rendering.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isEnabled* True to enable cursor rendering
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set enableCursorRender(bool value) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewPreferences", 'method': "enableCursorRender", 'args': value}));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async {
    await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "MapViewPreferences", 'id': _pointerId}));
  }
}

/// Animation helper class.
///
/// {@category Maps & 3D Scene}
class GemAnimation {
  /// The type of animation.
  AnimationType type;

  /// The duration of animation in milliseconds (0 means no animation)
  int duration;

  /// The callback when animation is completed.
  void Function()? onCompleted;

  late EventDrivenProgressListener _progressListener;

  GemAnimation({this.type = AnimationType.none, this.duration = -1, this.onCompleted}) {
    _progressListener = EventDrivenProgressListener();
    GemKitPlatform.instance.registerEventHandler(_progressListener.id, _progressListener);

    _progressListener.registerOnCompleteWithDataCallback((p0, p1, p2) {
      if (onCompleted != null) {
        onCompleted!();
      }
    });
  }

  GemAnimation._(this.type, this.duration, EventDrivenProgressListener progressListener)
      : _progressListener = progressListener;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['type'] = type.id;

    json['progress'] = _progressListener.id;

    json['duration'] = duration;

    return json;
  }

  factory GemAnimation.fromJson(Map<String, dynamic> json) {
    return GemAnimation._(
      json['type'],
      json['duration'],
      EventDrivenProgressListener.init(json['progress']),
    );
  }
}
