// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/contentstore/content_store_item.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';
import 'package:gem_kit/src/contentstore/content_updater_status.dart';
import 'package:gem_kit/src/core/progress_listener.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Content updater class
///
/// This class should not be instantiated directly. Instead, use the [ContentStore.createContentUpdater] getter to obtain an instance.
///
/// {@category Content}
class ContentUpdater {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  ContentUpdater._()
      : _pointerId = -1,
        _mapId = -1;

  ContentUpdater.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Start / resume the update process.
  ///
  /// **Parameters**
  ///
  /// * **IN** *allowChargeNetwork*	Allow charging network
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError update(
    bool allowChargeNetwork, {
    void Function(ContentUpdaterStatus status)? onStatusUpdated,
    void Function(int progress)? onProgressUpdated,
  }) {
    try {
      final progressListener = EventDrivenProgressListener();

      if (onStatusUpdated != null) {
        progressListener.registerOnNotifyStatusChanged((status) =>
            onStatusUpdated(ContentUpdaterStatusExtension.fromId(status)));
      }

      if (onProgressUpdated != null) {
        progressListener.registerOnProgressCallback(
            (progress) => onProgressUpdated(progress));
      }

      GemKitPlatform.instance
          .registerEventHandler(progressListener.id, progressListener);

      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "update",
            'args': {
              'allowChargeNetwork': allowChargeNetwork,
              'listener': progressListener.id
            }
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the content items list in update process.
  ///
  /// **Returns**
  ///
  /// * Content list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<ContentStoreItem> get items {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "getItems",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ContentStoreItemList.init(decodedVal['result'], 0).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get content type in update process.
  ///
  /// See [ContentType] enum for possible values.
  ///
  /// **Returns**
  ///
  /// * Content type
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get contentType {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "getContentType",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get update operation status.
  ///
  /// **Returns**
  ///
  /// * Content updater status
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  ContentUpdaterStatus get status {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "getStatus",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ContentUpdaterStatusExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get content type in update process.
  ///
  /// Progress values are calculated with respect to [ProgressListener.progressMultiplier]
  ///
  /// **Returns**
  ///
  /// * Progress value
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get progress {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "getProgress",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if content update can be applied.
  ///
  /// **Returns**
  ///
  /// * True if content update can be applied, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get canApply {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "canApply",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Apply content update
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.

  GemError apply() {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "apply",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel content update.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void cancel() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentUpdater",
            'method': "cancel",
            'args': {}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Check if content updater is started.
  ///
  /// **Returns**
  ///
  /// * True if content update can be applied, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isStarted {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "ContentUpdater",
        'method': "isStarted",
        'args': {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(
      jsonEncode({'class': "ContentUpdater", 'id': _pointerId}));
}
