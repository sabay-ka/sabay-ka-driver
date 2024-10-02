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
import 'package:gem_kit/src/contentstore/content_updater.dart';
import 'package:gem_kit/src/contentstore/content_updater_status.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/progress_listener.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Content store object
///
/// This behaves like a singleton, i.e. all instances are sharing behind the same API interface
///
/// {@category Content}
class ContentStore {
  /// Asynchronously gets an online store content list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  /// * **IN** *onCompleteCallback*	The listener object that implements the notification events associated with this operation.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  static ProgressListener? asyncGetStoreContentList(
    ContentType type,
    void Function(GemError err, List<ContentStoreItem>? items, bool? isCached) onCompleteCallback,
  ) {
    EventDrivenProgressListener progListener = EventDrivenProgressListener();
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        Object(),
        jsonEncode({
          'id': 0,
          'class': "ContentStore",
          'method': "asyncGetStoreContentList",
          'args': {'type': type.id, 'listener': progListener.id}
        }));
    final decodedVal = jsonDecode(resultString!);
    if (decodedVal is Map && decodedVal.containsKey('error')) {
      onCompleteCallback(GemErrorExtension.fromCode(-1), null, null);
      return null;
    }

    progListener.registerOnCompleteWithDataCallback((err, hint, json) {
      if (err == 0) {
        final contentStoreListString = GemKitPlatform.instance.callObjectMethodffi(
            Object(), jsonEncode({'id': 0, 'class': "ContentStore", 'method': "getStoreContentList", 'args': type.id}));
        final decodedRetVal = jsonDecode(contentStoreListString!);
        final listId = decodedRetVal['result']['contentStoreListId'];
        bool isCached = decodedRetVal['result']['isCached'];
        onCompleteCallback(GemErrorExtension.fromCode(0), ContentStoreItemList.init(listId, 0).toList(), isCached);
        //onCompleteCallback(err, result.getJson());
      } else {
        onCompleteCallback(GemErrorExtension.fromCode(err), null, null);
      }
    });
    GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
    return progListener;
  }

  /// Creates a content updater for the given content type.
  ///
  /// After creation, the content updater must be started by calling the [ContentUpdater.update]
  /// The content updater supports operation resume between SDK running sessions.
  ///
  /// To check if there is a pending update operation started in a previous SDK session, user must do the following steps:
  ///
  /// * create an updater with [createContentUpdater]
  /// * check if [ContentUpdater.status], if status != [ContentUpdaterStatus.idle] there is a pending update which can be resumed by calling [ContentUpdater.update]
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * ContentUpdater object. If a content update already exists, it is returned.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static ContentUpdater createContentUpdater(ContentType type) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "ContentStore", 'method': "createContentUpdater", 'args': type.id}));
      final decodedVal = jsonDecode(resultString!);
      return ContentUpdater.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets access to the store cached content list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * Pair of <Content list, locally cached flag>. If the list is not cached locally a call to [asyncGetStoreContentList] must be performed in order to request it from store.
  static Pair<List<ContentStoreItem>, bool> getStoreContentList(ContentType type) {
    final contentStoreListString = GemKitPlatform.instance.callObjectMethodffi(
        Object(), jsonEncode({'id': 0, 'class': "ContentStore", 'method': "getStoreContentList", 'args': type.id}));
    final decodedRetVal = jsonDecode(contentStoreListString!);
    final listId = decodedRetVal['result']['contentStoreListId'];
    bool isCached = decodedRetVal['result']['isCached'];
    return Pair<List<ContentStoreItem>, bool>(ContentStoreItemList.init(listId, 0).toList(), isCached);
  }

  /// Gets access to the installed content list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * List of content store items
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static List<ContentStoreItem> getLocalContentList(ContentType type) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "ContentStore", 'method': "getLocalContentList", 'args': type.id}));
      final decodedVal = jsonDecode(resultString!);
      return ContentStoreItemList.init(decodedVal['result'], 0).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Check for update on the given content type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type*	Content list type (see [ContentType])
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static GemError checkForUpdate(ContentType type) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "ContentStore", 'method': "checkForUpdate", 'args': type.id}));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh the content store by loading external changes from disk.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void refreshContentStore() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "ContentStore", 'method': "refreshContentStore", 'args': {}}));
      jsonDecode(resultString!);
    } catch (e) {
      rethrow;
    }
  }

  /// Set parallel downloads count.
  ///
  /// Default value is 3.
  ///
  /// **Parameters**
  /// 
  /// * **IN** *count*	The number of parallel downloads
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void setParallelDownloadsLimit(int count) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "ContentStore", 'method': "setParallelDownloadsLimit", 'args': count}));
      jsonDecode(resultString!);
    } catch (e) {
      rethrow;
    }
  }
}
