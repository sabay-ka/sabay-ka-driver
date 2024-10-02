// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Map view extensions class
///
/// {@category Maps & 3D Scene}
class MapViewExtensions {
  final dynamic _pointerId;
  final dynamic _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  MapViewExtensions()
      : _pointerId = -1,
        _mapId = -1;

  MapViewExtensions.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId;

  /// Get group highlighted item index for the given highlighted item index (in original list)
  ///
  /// **Parameters**
  ///
  /// * **IN** *idx*	The highlighted item index in original list for which the group head is searched.
  /// * **IN** *highlightId*	The highlight collection id (optional).
  ///
  /// **Returns**
  /// * On success, returns the group index in highlighted items original list.
  /// * On error, returns the error code.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int getHighlightGroupItemIndex(
    int idx, {
    int? highlightId,
  }) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewExtensions",
            'method': "getHighlightGroupItemIndex",
            'args': {
              'idx': idx,
              if (highlightId != null) 'highlightId': highlightId
            }
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the maximum allowed zoom level.
  ///
  /// **Returns**
  ///
  /// * The maximum allowed zoom level
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get maximumAllowedZoomLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewExtensions",
            'method': "getMaximumAllowedZoomLevel",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the minimum allowed zoom level.
  ///
  /// **Returns**
  ///
  /// * The minimum allowed zoom level
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get minimumAllowedZoomLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewExtensions",
            'method': "getMinimumAllowedZoomLevel",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set the maximum allowed zoom level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel*	The maximum allowed zoom level
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set maximumAllowedZoomLevel(int zoomLevel) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewExtensions",
            'method': "setMaximumAllowedZoomLevel",
            'args': zoomLevel
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the minimum allowed zoom level.
  ///
  /// **Parameters**
  ///
  /// * **IN** *zoomLevel*	The minimum allowed zoom level
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setMinimumAllowedZoomLevel(int zoomLevel) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewExtensions",
            'method': "setMinimumAllowedZoomLevel",
            'args': zoomLevel
          }));
    } catch (e) {
      rethrow;
    }
  }

  void setLowEndCPUOptimizations(bool bEnable) {
    GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "MapViewExtensions",
          'method': "setLowEndCPUOptimizations",
          'args': bEnable
        }));
  }
}
