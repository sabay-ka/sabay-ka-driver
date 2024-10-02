// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'dart:async';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/map/gem_map.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/gem_kit_view.dart';

import 'dart:math';

typedef TouchCallback = void Function(Point<int> pos);
typedef TouchPointerCallback = void Function(int pointerId, Point pos);
typedef TouchCallbackMove = void Function(Point p1, Point p2);

/// Controller for a single GemMap instance running on the host platform.
///
/// This class should not be instantiated directly. Instead, use the [GemMap.onMapCreated] callback to obtain an instance of this class.
/// 
/// {@category Maps & 3D Scene}
class GemMapController extends GemView implements IMapViewListener {
  TouchCallback? _touchCallback;
  TouchCallback? _touchLongPressCallback;
  TouchPointerCallback? _pPointerUpCallback;
  TouchPointerCallback? _pPointerMoveCallback;
  TouchPointerCallback? _pPointerDownCallback;
  TouchCallbackMove? _pMoveCallback;
  Timer? _delayedEvent;
  double? _pixelSize;
  bool _isCameraMoving = false;
  void Function(FollowPositionState state)? _followPositionState;
  void Function(double value)? _mapAngleUpdate;
  void Function(dynamic data)? _onMapViewRendered;
  void Function(bool state,RectangleGeographicArea area)? _onMapViewMoveStateChanged;
  GemMapController._(int vid, int mId, Rectangle<int> viewport) : super.init(vid, mId, viewport) {
    setListener = this;
  }
  
  /// Initialize control of a [GemMap] with *_id*.
  static Future<GemMapController> init(int mapId, GemMapState gemMapState,{double? pixelSize = 1.0}) async {
    var result = await GemKitPlatform.instance.init(mapId);
    final vid = result['viewId'];
    Rectangle<int> pInt = Rectangle<int>(0, 0, result['width'], result['height']);
    final retVal = GemMapController._(vid, mapId, pInt);
    retVal._pixelSize  = pixelSize;
    return retVal;
  }

  /// Register to receive events from Native side.
  void registerForEventsHandler() {
    GemKitPlatform.instance.registerEventHandler(pointerId, this);
  }

  /// Register to receive touch events from Native side.
  void registerTouchCallback(TouchCallback pTouchCallback) {
    _touchCallback = pTouchCallback;
  }

  /// Register to receive pointer up events from Native side.
  void registerPointerUpCallback(TouchPointerCallback pPointerUpCallback) {
    _pPointerUpCallback = pPointerUpCallback;
  }

  /// Register to receive pointer down events from Native side.
  void registerPointerDownCallback(TouchPointerCallback pPointerDownCallback) {
    _pPointerDownCallback = pPointerDownCallback;
  }

  /// Register to receive pointer move events from Native side.
  void registerPointerMoveCallback(TouchPointerCallback pPointerMoveCallback) {
    _pPointerMoveCallback = pPointerMoveCallback;
  }

  /// Register to receive move events from Native side.
  void registerMoveCallback(TouchCallbackMove pCallbackMove) {
    _pMoveCallback = pCallbackMove;
  }

  /// Register to receive long press events from Native side.
  void registerOnLongPressCallback(TouchCallback pCallback) {
    _touchLongPressCallback = pCallback;
  }

  /// Register to receive position events from Native side.
  void registerFollowPositionState(void Function(FollowPositionState state) followPositionStateUpdatedCallback) {
    _followPositionState = followPositionStateUpdatedCallback;
  }

  /// Register to receive map angle events from Native side.
  void registerOnMapAngleUpdate(void Function(double mapAngle) mapAngleUpdatedCallback) {
    _mapAngleUpdate = mapAngleUpdatedCallback;
  }

  /// Register to receive move state events from Native side.
  ///
  /// This event is sent when the map starts or stops moving.
  void registerOnMapViewMoveStateChanged(void Function(bool state,RectangleGeographicArea area) onMapViewMoveStateChanged) {
    _onMapViewMoveStateChanged = onMapViewMoveStateChanged;
  }

  void dispose() {
    releaseView();
  }

  @override

  /// IMapViewListener: onViewportResized
  void onViewportResized(Rectangle<int> viewportIn) {
    viewport = RectType(x: viewportIn.left, y: viewportIn.top, width: viewportIn.width, height: viewportIn.height);
  }

  @override

  /// IMapViewListener: onTouch
  void onTouch(Point pos) {
    if (_touchCallback != null) {
      _touchCallback!(Point<int>(pos.x.toInt(), pos.y.toInt()));
    }
  }

  @override

  /// IMapViewListener: onLongPress
  void onLongPress(Point<num> pos) {
    if (_touchLongPressCallback != null) {
      _touchLongPressCallback!(Point<int>(pos.x.toInt(), pos.y.toInt()));
    }
  }

  @override

  /// IMapViewListener: onPointerUp
  void onPointerUp(int pointerId, Point pos) {
    if (_pPointerUpCallback != null) {
      _pPointerUpCallback!(pointerId, pos);
    }
  }

  @override

  /// IMapViewListener: onPointerMove
  void onPointerMove(int pointerId, Point pos) {
    if (_pPointerMoveCallback != null) {
      _pPointerMoveCallback!(pointerId, pos);
    }
  }

  @override

  /// IMapViewListener: onPointerDown
  void onPointerDown(int pointerId, Point pos) {
    if (_pPointerDownCallback != null) {
      _pPointerDownCallback!(pointerId, pos);
    }
  }

  @override

  /// IMapViewListener: onMove
  void onMove(Point startPoint, Point endPoint) {
    if (_pMoveCallback != null) {
      _pMoveCallback!(startPoint, endPoint);
    }
  }

  @override

  /// IMapViewListener: onFollowPostionState
  void onFollowPostionState(FollowPositionState followPositionState) {
    if (_followPositionState != null) {
      _followPositionState!(followPositionState);
    }
  }

  @override

  /// IMapViewListener: onMapAngleUpdate
  void onMapAngleUpdate(double angle) {
    if (_mapAngleUpdate != null) {
      _mapAngleUpdate!(angle);
    }
  }

  @override

  /// IMapViewListener: onMarkerRender
  void onMarkerRender(data) {
    preferences.markers.onMarkerRender(this,data);
  }

  @override

  /// IMapViewListener: onViewRendered
  void onViewRendered(data) {
   // if (data['markersIds']!.length > 0) {

   if(_onMapViewMoveStateChanged!=null)
   {
    bool cameraIsMoving = data['cameraStatus'];
    bool viewDataTransitionStatus = data['viewDataTransitionStatus'];
    RectangleGeographicArea pArea = RectangleGeographicArea(topLeft : Coordinates.fromJson(data['leftTop']),bottomRight : Coordinates.fromJson(data['rightBottom']));
    if(_isCameraMoving != cameraIsMoving) {
      //if(viewDataTransitionStatus == false) {
         _isCameraMoving = cameraIsMoving;
      if(_onMapViewMoveStateChanged != null) {
        if(_delayedEvent != null) {
          _delayedEvent!.cancel();
        }
        _delayedEvent = Timer(const Duration(milliseconds: 100), () {
          _onMapViewMoveStateChanged!(cameraIsMoving,pArea);
        });
      }
      //}
    }
   }
      preferences.markers.onViewRendered(data);
      if(_onMapViewRendered != null) {
        _onMapViewRendered!(data);
      }
   // }
  }
  
  void registerViewRenderedCallback(void Function(dynamic data) onMapViewRendered) {
    _onMapViewRendered = onMapViewRendered;
  }

  /// The number of device pixels for each logical pixel.
  double get devicePixelSize => _pixelSize!;
}
