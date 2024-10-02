// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'dart:convert';
import 'dart:typed_data';

import 'package:gem_kit/src/core/types.dart';

import '../gem_kit_platform_interface.dart';

// ignore_for_file: inference_failure_on_collection_literal

/// {@category Maps & 3D Scene}
///
/// This class should not be instantiated directly. Instead, use the [GemView.camera] getter to obtain an instance.
///
/// Map Camera class
class MapCamera {
  final int _pointerId;
  final int _mapId;
  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  MapCamera._()
      : _pointerId = -1,
        _mapId = -1;

  MapCamera.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId;

  /// Saves the current state of the camera into a binary format.
  ///
  /// **Returns**
  ///
  /// * The binary representation of the camera's current state.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List get cameraState {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapCamera",
            'method': "saveCameraState",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return base64Decode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves the current orientation of the camera.
  ///
  /// **Returns**
  ///
  /// * A [Point4d] representing the current (x,y,z,w) orientation of the camera.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Point4d get orientation {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapCamera",
            'method': "getOrientation",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Point4d.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves the current position of the camera.
  ///
  /// **Returns**
  ///
  /// * A [Point3d] representing the current (x,y,z) position of the camera.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Point3d get position {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapCamera",
            'method': "getPosition",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Point3d.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Restores the camera's state from a previously saved binary format.
  ///
  /// **Parameters**
  ///
  /// * **IN** *state* The binary representation of the camera's current state.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set cameraState(Uint8List state) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapCamera",
            'method': "restoreCameraState",
            'args': String.fromCharCodes(state)
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Sets the camera's orientation using quaternion values.
  ///
  /// **Parameters**
  ///
  /// * **IN** *orient* A [Point4d] representing the new (x,y,z,w) orientation of the camera.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set orientation(Point4d orient) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapCamera",
            'method': "setOrientation",
            'args': orient
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Sets the camera's position in a 3D space.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* A [Point3d] representing the new (x,y,z) position of the camera.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set position(Point3d pos) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapCamera",
            'method': "setPosition",
            'args': pos
          }));
    } catch (e) {
      rethrow;
    }
  }
}
