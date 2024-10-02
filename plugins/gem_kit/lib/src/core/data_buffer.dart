// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// @nodoc
///
/// {@category Core}
class DataBuffer {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  DataBuffer()
      : _pointerId = -1,
        _mapId = -1;

  DataBuffer.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Check if data buffer is empty.
  ///
  /// **Returns**
  ///
  /// * True if the buffer is empty, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Future<bool> get isEmpty async {
    try {
      final resultString = await GemKitPlatform.instance
          .getChannel(mapId: _mapId)
          .invokeMethod<String>(
              'callObjectMethod',
              jsonEncode({
                'id': _pointerId,
                'class': "DataBuffer",
                'method': "empty",
                'args': {}
              }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// Gets the size of the data buffer in bytes.
  ///
  /// **Returns**
  ///
  /// * The size of the data buffer
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Future<int> get size async {
    try {
      final resultString = await GemKitPlatform.instance
          .getChannel(mapId: _mapId)
          .invokeMethod<String>(
              'callObjectMethod',
              jsonEncode({
                'id': _pointerId,
                'class': "DataBuffer",
                'method': "size",
                'args': {}
              }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// Reserve data size.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* Size in bytes to reserve
  ///
  /// **Returns**
  ///
  /// * 0 on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Future<int> reserve(int size) async {
    try {
      final resultString = await GemKitPlatform.instance
          .getChannel(mapId: _mapId)
          .invokeMethod<String>(
              'callObjectMethod',
              jsonEncode({
                'id': _pointerId,
                'class': "DataBuffer",
                'method': "reserve",
                'args': size
              }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// Sets the new content for the data buffer.
  ///
  /// **Parameters**
  ///
  /// * **IN** *str* Size in bytes to reserve
  ///
  /// **Returns**
  ///
  /// * 0 on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.

  Future<void> setData(String str) async {
    try {
      await GemKitPlatform.instance
          .getChannel(mapId: _mapId)
          .invokeMethod<String>(
              'callObjectMethod',
              jsonEncode({
                'id': _pointerId,
                'class': "DataBuffer",
                'method': "fromString",
                'args': str
              }));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// Convert binary data to base64 string.
  ///
  /// **Returns**
  ///
  /// * A string representation of the data buffer.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Future<String> toStringV() async {
    try {
      final resultString = await GemKitPlatform.instance
          .getChannel(mapId: _mapId)
          .invokeMethod<String>(
              'callObjectMethod',
              jsonEncode({
                'id': _pointerId,
                'class': "DataBuffer",
                'method': "toString",
                'args': {}
              }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
