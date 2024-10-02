// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/position/gem_position.dart';
import 'package:gem_kit/src/position/gem_position_listener.dart';
import 'package:gem_kit/src/position/gem_position_listener_impl.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:async';
import 'dart:convert';

import 'package:gem_kit/src/sense/sense_data_source.dart';

/// Position service class
///
/// {@category Sensor Data Source}
class PositionService {
  static final PositionService _instance = PositionService._();
  static PositionService get instance => _instance;
  static Future<PositionService> create(int mapId) async {
    return PositionService.instance;
  }

  PositionService._();

  /// Register a new listener for updates. **FFI method**
  ///
  /// The listener also gets updates when the availability state of the data type provider changes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *positionUpdatedCallback* The callback the listener registers for.
  ///
  /// **Returns**
  ///
  /// * [GemPositionListener]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemPositionListener addPositionListener(void Function(GemPosition position) positionUpdatedCallback) {
    try {
      GemPositionListener posListener = GemPositionListener(positionUpdatedCallback);
      final result = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': 0, 'class': "PositionService", 'method': "registerSenseDataListener", 'senseDataType': 'position'}));

      posListener.id = jsonDecode(result as String)['result'];
      GemKitPlatform.instance.registerEventHandler(posListener.id, posListener);
      return posListener;
    } catch (e) {
      rethrow;
    }
  }

  /// Register a new improved listener for updates.
  ///
  /// The listener also gets updates when the availability state of the data type provider changes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *positionUpdatedCallback* The callback the listener registers for. It must not be empty.
  ///
  /// **Returns**
  ///
  /// * [GemPositionListener]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemPositionListener addImprovedPositionListener(void Function(GemPosition position) positionUpdatedCallback) {
    try {
      GemPositionListener posListener = GemPositionListener(positionUpdatedCallback);
      final result = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "PositionService",
        'method': "registerSenseDataListener",
        'senseDataType': 'improvedPosition'
      }));

      posListener.id = jsonDecode(result as String)['result'];
      GemKitPlatform.instance.registerEventHandler(posListener.id, posListener);
      return posListener;
    } catch (e) {
      rethrow;
    }
  }

  /// Unregister a position listener.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* The listener to be unregistered
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeListener(IGemPositionListener listener) {
    GemKitPlatform.instance.unregisterEventHandler(listener.id);
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': 0, 'class': "PositionService", 'method': "registerSenseDataListener", 'senseDataType': 'none'}));
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the latest position data available.
  ///
  /// **Returns**
  ///
  /// * [GemPosition] object
  GemPosition? getPosition() {
    final retVal = GemKitPlatform.instance
        .safecallObjectMethodffi(this, jsonEncode({'class': "PositionService", 'id': 0, 'method': 'getPosition'}));
    if (retVal == null || retVal.length == 0) {
      return null;
    }

    final decodedVal = jsonDecode(retVal);
    return GemPosition.fromJson(decodedVal);
  }

  /// Set the position service current datasource to **live**.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setLiveDataSource() {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        Object(),
        jsonEncode(
            {'id': 0, 'class': "PositionService", 'method': "selectPositionDataSource", 'senseDataSourceType': 'live'}),
        dispatchOnMainThread: true,
      );
      final result = jsonDecode(resultString);
      int errCode = result['errorCode'];
      return GemErrorExtension.fromCode(errCode);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the position service current datasource (set it to **none**) **FFI method**
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeDataSource() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "PositionService",
            'method': "selectPositionDataSource",
            'senseDataSourceType': 'none'
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Sets the current data source for obtaining position data.
  ///
  /// **Parameters**
  ///
  /// * **IN** *dataSource* The data source to be used for fetching position data.
  ///
  /// If dataSource is empty, the current data source will be removed.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setExternalDataSource(DataSource dataSource) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        Object(),
        jsonEncode(
            {'id': 0, 'class': "PositionService", 'method': "setExternalDataSource", 'args': dataSource.pointerId}),
        dispatchOnMainThread: true,
      );
      final result = jsonDecode(resultString);
      return GemErrorExtension.fromCode(result['errorCode']);
    } catch (e) {
      rethrow;
    }
  }

  /// Set the position service current datasource to **playback**.
  ///
  /// **Parameters**
  ///
  /// * **IN** *filePath* The path to the data source.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<void> setPlaybackDataSource(String filePath) async {
    try {
      await GemKitPlatform.instance.getChannel().invokeMethod<String>(
          'selectPositionDataSource', jsonEncode({'senseDataSourceType': 'playback', 'filePath': filePath}));
    } catch (e) {
      return Future.error(e);
    }
  }
}
