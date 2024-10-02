// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/geographic_area.dart';
import 'package:gem_kit/src/core/landmark.dart';
import 'package:gem_kit/src/core/landmark_category.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/route.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/search/search_preferences.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Search service class
///
/// {@category Places}
abstract class SearchService {
  /// Search using text and geographic area as discriminants.
  ///
  /// **Parameters**
  ///
  /// * **IN** *textFilter* The text filter.
  /// * **IN** *referenceCoordinates* The reference position. Results will be relevant to this position.
  /// * **IN** *onCompleteCallback* Will be invoked when the search operation is completed, providing the search results and an error code.
  /// * **IN** *preferences* The search preferences. Optional.
  /// * **IN** *locationHint* The location hint. The search will be restricted to the provided geographic area. Optional.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler search(
    String textFilter,
    Coordinates referenceCoordinates,
    void Function(GemError err, List<Landmark>? results) onCompleteCallback, {
    SearchPreferences? preferences,
    RectangleGeographicArea? locationHint,
  }) {
    try {
      final landmarkCategoryList = LandmarkCategoryList();

      for (final cat in preferences?.landmarkCategories ?? []) {
        landmarkCategoryList.add(cat);
      }

      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "SearchService",
            'method': "freeTextSearch",
            'args': {
              'textFilter': textFilter,
              'referenceCoordinates': referenceCoordinates,
              if (preferences != null) 'preferences': preferences,
              if (preferences != null && preferences.hasLandmarkCategoryList)
                'poiCategories': landmarkCategoryList.pointerId,
              if (locationHint != null) 'locationHint': locationHint
            }
          }));

      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);

      progListener.registerOnCompleteWithDataCallback((err, hint, json) {
        if (json.containsKey('searchId')) {
          final searchLandmark = LandmarkList.init(json['searchId'], 0);
          onCompleteCallback(GemErrorExtension.fromCode(err), searchLandmark.toList());
        } else {
          onCompleteCallback(GemErrorExtension.fromCode(err), null);
        }
        GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      });

      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Get details for the given landmark list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *results* The landmark list where to store the result.
  /// * **IN** *listener* The listener of the operation.
  ///
  /// If the landmarks in list already have the details populated, the function will return [GemError.upToDate]
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler searchLandmarkDetails(List<Landmark> results, void Function(GemError err) onCompleteCallback) {
    try {
      final landmarkList = LandmarkList.fromList(results);

      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode(
              {'id': 0, 'class': "SearchService", 'method': "searchLandmarkDetails", 'args': landmarkList.pointerId}));

      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);

      progListener.registerOnCompleteWithDataCallback((err, hint, json) {
        onCompleteCallback(GemErrorExtension.fromCode(err));
        GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      });

      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel specific request identified by the progress listener.
  ///
  /// **Parameters**
  ///
  /// * **IN** *progressListener* The progress listener associated with the request to be canceled.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void cancelSearch(TaskHandler taskHandler) {
    try {
      taskHandler as TaskHandlerImpl;

      GemKitPlatform.instance.safecallObjectMethodffi(Object(),
          jsonEncode({'id': 0, 'class': "SearchService", 'method': "cancelSearch", 'searchId': taskHandler.id}));
      //GemKitPlatform.instance.unregisterEventHandler(taskHandler.id);
      //final decodedVal = jsonDecode(resultString!);
    } catch (e) {
      rethrow;
    }
  }

  // /// Get data transfer statistics for this service.
  // ///
  // /// **Returns**
  // ///
  // /// *  The transfer statistics object
  // ///
  // ///  **Throws**
  // ///
  // /// * An exception if it fails.
  // static TransferStatistics getTransferStatistics() {
  //   try {
  //     final resultString = GemKitPlatform.instance.safecallObjectMethodffi(Object(),
  //         jsonEncode({'id': 0, 'class': "SearchService", 'method': "getTransferStatistics", 'args': {}}));

  //     final decodedVal = jsonDecode(resultString!);
  //     return TransferStatistics.init(decodedVal['result'], 0);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// Search for landmarks along the specified route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The target route.
  /// * **IN** *textFilter* The text filter. Optional.
  /// * **IN** *preferences* The search preferences. Optional.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler searchAlongRoute(
    Route route,
    void Function(GemError err, List<Landmark>? results) onCompleteCallback, {
    String? textFilter,
    SearchPreferences? preferences,
  }) {
    try {
      final landmarkCategoryList = LandmarkCategoryList();

      for (final cat in preferences?.landmarkCategories ?? []) {
        landmarkCategoryList.add(cat);
      }

      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "SearchService",
        'method': 'searchAlongRoute',
        'args': {
          'route': route.pointerId,
          if (textFilter != null) 'textFilter': textFilter,
          if (preferences != null && preferences.hasLandmarkCategoryList)
            'poiCategories': landmarkCategoryList.pointerId,
          if (preferences != null) 'preferences': preferences
        }
      }));

      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);

      progListener.registerOnCompleteWithDataCallback((err, hint, json) {
        if (err == 0) {
          final searchLandmark = LandmarkList.init(json['searchId'], 0);
          onCompleteCallback(GemErrorExtension.fromCode(err), searchLandmark.toList());
        } else {
          onCompleteCallback(GemErrorExtension.fromCode(err), null);
        }
        GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      });
      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Get list of landmarks in the given geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *results* The landmark list where to store the result.
  /// * **IN** *listener* The listener of the operation.
  /// * **IN** *area* The search target area.
  /// * **IN** *referenceCoordinates* The reference position. Results will be relevant to this position.
  /// * **IN** *textFilter* The optional text filter. Optional.
  /// * **IN** *preferences* The search preferences. Optional.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler searchInArea(
    RectangleGeographicArea area,
    Coordinates referenceCoordinates,
    void Function(GemError err, List<Landmark>? results) onCompleteCallback, {
    String? textFilter,
    SearchPreferences? preferences,
  }) {
    try {
      final landmarkCategoryList = LandmarkCategoryList();

      for (final cat in preferences?.landmarkCategories ?? []) {
        landmarkCategoryList.add(cat);
      }

      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "SearchService",
        'method': 'searchInArea',
        'args': {
          'area': area,
          'referenceCoordinates': referenceCoordinates,
          if (textFilter != null) 'textFilter': textFilter,
          if (preferences != null && preferences.hasLandmarkCategoryList)
            'poiCategories': landmarkCategoryList.pointerId,
          if (preferences != null) 'preferences': preferences
        }
      }));

      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);

      progListener.registerOnCompleteWithDataCallback((err, hint, json) {
        if (err == 0) {
          final searchLandmark = LandmarkList.init(json['searchId'], 0);
          onCompleteCallback(GemErrorExtension.fromCode(err), searchLandmark.toList());
        } else {
          onCompleteCallback(GemErrorExtension.fromCode(err), null);
        }
        GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      });

      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  ///Get list of landmarks for specific coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *position* The position.
  /// * **IN** *textFilter* The text filter. Optional.
  /// * **IN** *preferences* The search preferences. Optional.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler searchAroundPosition(
    Coordinates position,
    void Function(GemError err, List<Landmark>? results) onCompleteCallback, {
    String? textFilter,
    SearchPreferences? preferences,
  }) {
    try {
      final landmarkCategoryList = LandmarkCategoryList();

      for (final cat in preferences?.landmarkCategories ?? []) {
        landmarkCategoryList.add(cat);
      }

      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "SearchService",
        'method': 'searchAroundPosition',
        'args': {
          'position': position,
          if (textFilter != null) 'textFilter': textFilter,
          if (preferences != null && preferences.hasLandmarkCategoryList)
            'poiCategories': landmarkCategoryList.pointerId,
          if (preferences != null && preferences.allStoreCategoriesList.isNotEmpty)
            'allStoreCategories': preferences.allStoreCategoriesList,
          if (preferences != null) 'preferences': preferences
        }
      }));

      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);

      progListener.registerOnCompleteWithDataCallback((err, hint, json) {
        if (err == 0) {
          final searchLandmark = LandmarkList.init(json['searchId'], 0);
          onCompleteCallback(GemErrorExtension.fromCode(err), searchLandmark.toList());
        } else {
          onCompleteCallback(GemErrorExtension.fromCode(err), null);
        }
        GemKitPlatform.instance.unregisterEventHandler(progListener.id);
      });

      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }
}
