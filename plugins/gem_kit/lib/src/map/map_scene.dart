// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// File format of the scene object
///
/// {@category Maps & 3D Scene}
enum SceneObjectFileFormat {
  /// WAVEFRONT obj
  obj,

  /// WAVEFRONT material
  mat,

  /// WAVEFRONT texture
  tex,

  /// GLTF format
  gltf,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension SceneObjectFileFormatExtension on SceneObjectFileFormat {
  int get id {
    switch (this) {
      case SceneObjectFileFormat.obj:
        return 0;
      case SceneObjectFileFormat.mat:
        return 1;
      case SceneObjectFileFormat.tex:
        return 2;
      case SceneObjectFileFormat.gltf:
        return 3;
    }
  }

  static SceneObjectFileFormat fromId(int id) {
    switch (id) {
      case 0:
        return SceneObjectFileFormat.obj;
      case 1:
        return SceneObjectFileFormat.mat;
      case 2:
        return SceneObjectFileFormat.tex;
      case 3:
        return SceneObjectFileFormat.gltf;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Maps scene object
///
/// This class should not be instantiated directly. Instead, use the [getDefPositionTracker] method to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapSceneObject {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  MapSceneObject._()
      : _pointerId = -1,
        _mapId = -1;

  MapSceneObject.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId;

  // static Future<void> customizeDefPositionTracker(List<int> buffer, SceneObjectFileFormat format) async {
  //   await GemKitPlatform.instance
  //       .getChannel(mapId: 0)
  //       .invokeMethod<String>('customizeDefPositionTracker', jsonEncode({'buffer': buffer, 'format': format.id}));
  // }

  /// Customize default SDK position tracking object.
  ///
  /// To set a flat texture for the position tracking object, send only a [SceneObjectFileFormat.tex] data as input
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer* The object data. Provide empty list to load default SDK resource
  /// * **IN** *format* The format of the object data
  static int customizeDefPositionTracker(
      List<int> buffer, SceneObjectFileFormat format) {
    final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        Object(),
        jsonEncode({
          'id': 0,
          'class': "MapSceneObject",
          'method': "customizeDefPositionTracker",
          'args': {'buffer': buffer, 'format': format.id}
        }));
    final decodedVal = jsonDecode(resultString);
    return decodedVal['result'];
  }

  /// Get default SDK position tracked object
  ///
  /// SDK automatically creates a sense position tracker object after at least one location update happened. See [PositionService]
  ///
  /// The default position tracker automatically updates from current sense data source from PositionService
  ///
  /// By default it is visible, can be hidden by a call to setVisibility( false )
  static MapSceneObject getDefPositionTracker() {
    final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        Object(),
        jsonEncode({
          'id': 0,
          'class': "MapSceneObject",
          'method': "getDefPositionTracker",
          'args': {}
        }));
    final decodedVal = jsonDecode(resultString!);
    return MapSceneObject.init(decodedVal['result'], 0);
  }

  /// Object coordinates in main object coordinate system
  Coordinates get coordinates {
    final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "MapSceneObject",
          'method': "getCoordinates",
          'args': {}
        }));
    final decodedVal = jsonDecode(resultString!);
    return Coordinates.fromJson(decodedVal['result']);
  }

  /// Object coordinates in main object coordinate system
  set coordinates(Coordinates coordinates) {
    GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "MapSceneObject",
          'method': "setCoordinates",
          'args': {'coordinates': coordinates}
        }));
  }

  /// Object scale factor
  set scale(double scale) {
    GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "MapSceneObject",
          'method': "setScaleFactor",
          'args': scale
        }));
  }

  /// Object scale factor
  double get scale {
    final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "MapSceneObject",
          'method': "getScaleFactor",
          'args': {}
        }));
    final decodedVal = jsonDecode(resultString!);
    return decodedVal['result'];
  }
}
