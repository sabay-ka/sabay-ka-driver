// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/landmark.dart';
import 'package:gem_kit/src/core/landmark_category.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Landmark store class
///
/// This class should not be instantiated directly. Instead, use the related methods from [LandmarkStoreService] to obtain an instance.
///
/// {@category Places}
class LandmarkStore {
  final int _pointerId;
  final int _mapId;
  static const int uncategorizedLandmarkCategId = -1;
  static const int invalidLandmarkCategId = -2;
  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  LandmarkStore._()
      : _pointerId = -1,
        _mapId = -1;

  LandmarkStore.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId;

  /// Add a new category to the store.
  ///
  /// After this method call, the category object that is passed as a parameter belongs to this landmark store. The category must have a name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *category* The category to be added
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void addCategory(LandmarkCategory category) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "LandmarkStore", 'method': "addCategory", 'args': category.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Add a landmark to the specified category in the landmark store.
  ///
  /// If the landmark already exists in the landmark store, only the category info is updated.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark*	The landmark to be added to the landmark store in the specified category.
  /// * **IN** *categoryId*	The ID of the category where the landmark will be added.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void addLandmark(Landmark landmark, {int categoryId = LandmarkStore.uncategorizedLandmarkCategId}) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkStore",
            'method': "addLandmark",
            'args': {'landmark': landmark.pointerId, 'categoryId': categoryId}
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Update the information about a landmark.
  ///
  /// This updates only the information about a landmark and does not modify the categories the landmark belongs to.
  /// The landmark instance passed in as the parameter must be an instance that belongs to this landmark store.
  /// Calling this method updates the timestamp of the landmark.
  void updateLandmark(Landmark landmark) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkStore",
            'method': "updateLandmark",
            'args': landmark.pointerId,
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if the landmark store contains the landmark ID
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkId* The id of the landmark looked for
  ///
  /// **Returns**
  ///
  /// * True if the landmark is in the landmark store, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool containsLandmark(int landmarkId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "containsLandmark", 'args': landmarkId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the list of all categories.
  ///
  /// **Returns**
  ///
  /// * The list of categories
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<LandmarkCategory> get categories {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "getCategories", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkCategoryList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get the category by ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * The category
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  LandmarkCategory? getCategoryById(int categoryId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "getCategoryById", 'args': categoryId}));
      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) {
        return null;
      }
      return LandmarkCategory.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the ID of the landmark store.
  ///
  /// **Returns**
  ///
  /// * The landmark store ID
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "getId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the landmarks within the specified category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId*	The category id for which landmarks are retrieved (default LandmarkCategory.invalidLandmarkCategId, meaning all categories).
  ///
  /// If the category ID is LandmarkCategory.uncategorizedLandmarkCategId, all uncategorized landmarks are retrieved.
  ///
  /// If the category ID is LandmarkCategory.invalidLandmarkCategId, all landmarks are retrieved.
  ///
  /// **Returns**
  ///
  /// * The landmark list.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getLandmarks({int categoryId = LandmarkStore.invalidLandmarkCategId}) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "getLandmarks", 'args': categoryId}),
        dispatchOnMainThread: true,
      );
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get the landmark store name.
  ///
  /// **Returns**
  ///
  /// * The landmark store name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "getName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the type of the landmark store.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get type {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "getType", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the specified category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categoryId*	The category ID.
  /// * **IN** *removeLmkContent*	Request to remove all landmarks belonging to the category.
  ///
  /// If removeLmkContent is false, the landmarks belonging to the category are marked uncategorized.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void removeCategory(
    int categoryId, {
    bool? removeLmkContent,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkStore",
            'method': "removeCategory",
            'args': {'categoryId': categoryId, if (removeLmkContent != null) 'removeLmkContent': removeLmkContent}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the specified landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* The landmark to be removed
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void removeLandmark(Landmark landmark) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "LandmarkStore", 'method': "removeLandmark", 'args': landmark.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Update the specified category.
  ///
  /// The category object must belong to this landmark store. No fields of the parameter will be updated by this call.
  ///
  /// **Parameters**
  ///
  /// * **IN** *category* The category to be updated
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void updateCategory(LandmarkCategory category) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "LandmarkStore", 'method': "updateCategory", 'args': category.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all landmarks from store.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeAllLandmarks() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode({'id': _pointerId, 'class': "LandmarkStore", 'method': "removeAllLandmarks", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  void dispose() async =>
      GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "LandmarkStore", 'id': _pointerId}));
}
