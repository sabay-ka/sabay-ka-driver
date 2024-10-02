// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/contentstore/content_store_item_status.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/language.dart';
import 'package:gem_kit/src/core/offboard_listener.dart';
import 'package:gem_kit/src/core/parameters.dart';
import 'package:gem_kit/src/core/progress_listener.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/sdk_settings.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/map/map_details.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'package:flutter/services.dart';

import 'dart:convert';

/// Content download thread priority
///
/// {@category Content}
enum ContentDownloadThreadPriority {
  /// Default priority, following the OS default value
  defaultPriority,

  /// Low priority for download threads
  lowPriority,

  /// High priority for download threads
  highPriority
}

/// @nodoc
///
/// {@category Content}
extension ContentDownloadThreadPriorityExtension
    on ContentDownloadThreadPriority {
  int get id {
    switch (this) {
      case ContentDownloadThreadPriority.defaultPriority:
        return 0;
      case ContentDownloadThreadPriority.lowPriority:
        return 1;
      case ContentDownloadThreadPriority.highPriority:
        return 2;
    }
  }

  static ContentDownloadThreadPriority fromId(int id) {
    switch (id) {
      case 0:
        return ContentDownloadThreadPriority.defaultPriority;
      case 1:
        return ContentDownloadThreadPriority.lowPriority;
      case 2:
        return ContentDownloadThreadPriority.highPriority;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Data save policy
///
/// {@category Content}
enum DataSavePolicy {
  /// Save new data only on internal storage.
  useInternalOnly,

  /// Save new data only on external storage.
  useExternalOnly,

  /// Save new data on both storages but prefer on internal storage.
  useBothPreferInternal,

  /// Save new data on both storages but prefer on external storage.
  useBothPreferExternal,

  /// Use the default saving policy. Not allowed in [GemKit.initialize].
  useDefault,
}

/// @nodoc
///
/// {@category Content}
extension DataSavePolicyExtension on DataSavePolicy {
  int get id {
    switch (this) {
      case DataSavePolicy.useInternalOnly:
        return 0;
      case DataSavePolicy.useExternalOnly:
        return 1;
      case DataSavePolicy.useBothPreferInternal:
        return 2;
      case DataSavePolicy.useBothPreferExternal:
        return 3;
      case DataSavePolicy.useDefault:
        return 4;
    }
  }

  static DataSavePolicy fromId(int id) {
    switch (id) {
      case 0:
        return DataSavePolicy.useInternalOnly;
      case 1:
        return DataSavePolicy.useExternalOnly;
      case 2:
        return DataSavePolicy.useBothPreferInternal;
      case 3:
        return DataSavePolicy.useBothPreferExternal;
      case 4:
        return DataSavePolicy.useDefault;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Content store item class
///
/// This class should not be instantiated directly. Instead, use the methods provided by the [ContentStore] class
///
/// {@category Content}
class ContentStoreItem {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  ContentStoreItem._()
      : _pointerId = -1,
        _mapId = -1;

  ContentStoreItem.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get the name of the associated product.
  ///
  /// **Remarks**
  ///
  /// * The name is automatically translated based on the interface language.
  ///
  /// **Returns**
  ///
  /// * The name of the product
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getName",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the unique id of the item in the content store.
  ///
  /// **Returns**
  ///
  /// * The content store item id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getId",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the product chapter name translated to interface language.
  ///
  /// Items with same chapter name are considered to be part of the same group.
  ///
  /// **Returns**
  ///
  /// * The chapter name of the product
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get chapterName {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getChapterName",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the country code (ISO 3166-1 alpha-3) list of the product as text.
  ///
  /// **Remarks**
  ///
  /// * Country code can be empty. This information can be used to render a country flag using [MapDetails.getCountryFlag] method.
  ///
  /// **Returns**
  ///
  /// * Country code(ISO 3166-1 alpha-3) of the product as text (empty for none).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<String> get countryCodes {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getCountryCodes",
            'args': {}
          }));
      return (jsonDecode(resultString!)['result']).cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  /// Get the full language code for the product.
  ///
  /// **Remarks**
  ///
  /// * [Language] code can be empty.
  ///
  /// **Returns**
  ///
  /// * Full language code of the product (empty for none).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Language get language {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getLanguage",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Language.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the type of the product as a [ContentType] value.
  ///
  /// **Returns**
  ///
  /// * The type of the product
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentType get type {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getType",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ContentTypeExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the full path to the content data file when available.
  ///
  /// **Returns**
  ///
  /// * The full path to the content data file
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get fileName {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getFileName",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the client version of the content.
  ///
  /// Requires the content available size greater than zero.
  ///
  /// **Returns**
  ///
  /// * The client version of the content if available, 0 otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Version get clientVersion {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getClientVersion",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Version.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the size of the content in bytes.
  ///
  /// **Returns**
  ///
  /// * The real size of the content. If the content is not available then it returns 0.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get totalSize {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getTotalSize",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the available size of the content in bytes.
  ///
  /// **Returns**
  ///
  /// * The size of the downloaded content. This may or may not be equal with [totalSize].
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get availableSize {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getAvailableSize",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the item is completed downloaded.
  ///
  /// **Returns**
  ///
  /// * True if the download is completed, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isCompleted {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "isCompleted",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  ///Gets current item status.
  ///
  /// **Returns**
  ///
  /// * [ContentStoreItemStatus] value
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentStoreItemStatus get status {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getStatus",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ContentStoreItemStatusExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Pause a previous download operation.
  ///
  /// User will receive a onNotifyComplete
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError pauseDownload() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "pauseDownload",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel a previous download operation.
  ///
  /// The partially downloaded content is deleted.
  ///
  /// Operation is executed immediately, i.e. no notifications are thrown.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError cancelDownload() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "cancelDownload",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current download progress.
  ///
  /// **Returns**
  ///
  /// * Current download progress.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get downloadProgress {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getDownloadProgress",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if associated content can be deleted.
  ///
  /// **Note**
  ///
  /// * Content can be deleted if it has partially or complete local data and is not marked as SDK resource.
  ///
  /// **Returns**
  ///
  /// * True if the content can be deleted, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get canDeleteContent {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "canDeleteContent",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Delete the associated content.
  ///
  /// Operation is executed immediately, i.e. no notifications are thrown.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError deleteContent() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "deleteContent",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if there is an image preview available on the client.
  ///
  /// **Returns**
  ///
  /// * True if an image preview is available, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isImagePreviewAvailable {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "isImagePreviewAvailable",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the preview if available.
  ///
  /// Available only if [isImagePreviewAvailable] returns true.
  ///
  /// **Returns**
  ///
  /// * The resulting image.
  Uint8List getImagePreview({Size? size, ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(
        pointerId,
        "ContentStoreItemGetImagePreview",
        size?.width.toInt() ?? -1,
        size?.height.toInt() ?? -1,
        format?.id ?? -1);
  }

  /// Get additional parameters for the content.
  ///
  /// This is not available for all content types.
  ///
  /// **Returns**
  ///
  /// * The additional parameters for the content.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  SearchableParameterList get contentParameters {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "ContentStoreItem",
        'method': "getContentParameters",
        'args': {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return SearchableParameterList.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get corresponding update item.
  ///
  /// Function will return a valid item only if an update is in progress for that item.
  ///
  /// **Returns**
  ///
  /// * The update item.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  ContentStoreItem get updateItem {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getUpdateItem",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ContentStoreItem.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if item is updatable, i.e. it has a newer version available.
  ///
  /// **Returns**
  ///
  /// * True if the item is updatable, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get isUpdatable {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "isUpdatable",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get update size (if an update is available for this item).
  ///
  /// Function will return a valid size (!= 0) only if the item has a newer version in store.
  ///
  /// This function doesn't request an update to be started for the item.
  ///
  /// **Returns**
  ///
  /// * The update size
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get updateSize {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getUpdateSize",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get update version (if an update is available for this item).
  ///
  /// Function will return a valid version (!= 0) only if the item has a newer version in store.
  ///
  /// This function doesn't request an update to be started for the item.
  ///
  /// **Returns**
  ///
  /// * The update version
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Version get updateVersion {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContentStoreItem",
            'method': "getUpdateVersion",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Version.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
        jsonEncode({'class': "ContentStoreItem", 'id': _pointerId}));
  }

  /// Asynchronous start/resume the download of the content store product content.
  ///
  /// Requires automatic map rendering. Disables the cursor if enabled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *onCompleteCallback*	Object that implements notification event associated with operation completion. Cannot be empty.
  /// * **IN** *onProgressCallback*	Object that implements notification event associated with operation progress.
  /// * **IN** *allowChargedNetworks*	Flag whether to allow charged networks. If true, it will override [SdkSettings.setAllowOffboardServiceOnExtraChargedNetwork] ( [ServiceGroupType.contentService, false ).
  /// * **IN** *savePolicy*	Specify where the download will be made (optional).
  ///
  /// **Returns**
  ///
  /// * 0 on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  ProgressListener asyncDownload(void Function(GemError err) onCompleteCallback,
      {void Function(int progress)? onProgressCallback,
      bool allowChargedNetworks = false,
      DataSavePolicy savePolicy = DataSavePolicy.useDefault,
      ContentDownloadThreadPriority priority =
          ContentDownloadThreadPriority.defaultPriority}) {
    EventDrivenProgressListener progListener = EventDrivenProgressListener();
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "ContentStoreItem",
          'method': "asyncDownload",
          'args': {
            'listener': progListener.id,
            'allowChargedNetworks': allowChargedNetworks,
            'savePolicy': savePolicy.id,
            'priority': priority.id
          }
        }));
    final decodedVal = jsonDecode(resultString!);
    if (decodedVal is Map && decodedVal.containsKey('error')) {
      onCompleteCallback(GemErrorExtension.fromCode(decodedVal['error']));
      return EventDrivenProgressListener.init(0);
    }
    if (onProgressCallback != null) {
      progListener.registerOnProgressCallback((p0) {
        onProgressCallback(p0);
      });
    }
    progListener.registerOnCompleteWithDataCallback((err, hint, json) {
      if (err == 0) {
        onCompleteCallback(GemErrorExtension.fromCode(0));
        //onCompleteCallback(err, result.getJson());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err));
      }
    });
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    return progListener;
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Content}
class ContentStoreItemList extends GemList<ContentStoreItem> {
  factory ContentStoreItemList({dynamic id = 0, int mapId = 0}) {
    if (id == 0 && mapId == 0) {
      return ContentStoreItemList._create();
    } else {
      return ContentStoreItemList.init(id, mapId);
    }
  }

  ContentStoreItemList.init(dynamic id, int mapId)
      : super(id, mapId, "ContentStoreItemList",
            (data, mapId) => ContentStoreItem.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  static ContentStoreItemList _create() {
    final resultString = GemKitPlatform.instance
        .callCreateObject(jsonEncode({'class': "ContentStoreItemList"}));
    final decodedVal = jsonDecode(resultString!);
    return ContentStoreItemList.init(decodedVal['result'], 0);
  }
}
