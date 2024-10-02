// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/landmark_category.dart';
import 'package:gem_kit/src/core/landmark_store.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Landmark store collection class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.lmks] getter to obtain an instance.
///
/// {@category Places}
class LandmarkStoreCollection {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  LandmarkStoreCollection._()
      : _pointerId = -1,
        _mapId = -1;

  LandmarkStoreCollection.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Add all categories of the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *lms* The store
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError add(LandmarkStore lms) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkStoreCollection",
            'method': "addAllStoreCategories",
            'args': lms.id
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Add all categories of the specified store ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError addAllStoreCategories(int storeId) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkStoreCollection",
            'method': "addAllStoreCategories",
            'args': storeId
          }),
          dispatchOnMainThread: true);

      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Add a new category ID into the specified store list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError addStoreCategoryId(int storeId, int categoryId) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkStoreCollection",
            'method': "addStoreCategoryId",
            'args': {'storeId': storeId, 'categoryId': categoryId}
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Add a list of categories into the specified store list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *categories* The list of categories
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError addStoreCategoryList(int storeId, List<LandmarkCategory> categories) {
    final categoryList = LandmarkCategoryList();
    for (final cat in categories) {
      categoryList.add(cat);
    }

    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "LandmarkStoreCollection",
        'method': "addStoreCategoryList",
        'args': {'storeId': storeId, 'categories': categoryList.pointerId}
      }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all stores and categories.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode({'id': _pointerId, 'class': "LandmarkStoreCollection", 'method': "clear", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the specified category ID from the specified store ID was already added.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *indexCategory* The index of the category
  ///
  /// **Returns**
  ///
  /// * True if the category ID from the store ID was already added, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool contains(int storeId, int categoryId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "LandmarkStoreCollection",
        'method': "contains",
        'args': {'storeId': storeId, 'categoryId': categoryId}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the specified store has any category in the list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *lms* The store
  ///
  /// **Returns**
  ///
  /// * True if the store has any category in the list, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool containsLandmarkStore(LandmarkStore lms) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "LandmarkStoreCollection",
        'method': "containsLandmarkStore",
        'args': lms.pointerId
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the specified store ID has any category in the list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  ///
  /// **Returns**
  ///
  /// * True if the store has any category in the list, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool containsStoreId(int storeId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "LandmarkStoreCollection", 'method': "containsStoreId", 'args': storeId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the number of categories enabled for the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *indexCategory* The index of the category
  ///
  /// **Returns**
  ///
  /// * The number of categories
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int getCategoryCount(int storeId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "LandmarkStoreCollection", 'method': "getCategoryCount", 'args': storeId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the specified category ID for the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *indexCategory* The index of the category
  ///
  /// **Returns**
  ///
  /// * The category ID
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int getStoreCategoryId(int storeId, int indexCategory) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "LandmarkStoreCollection",
        'method': "getStoreCategoryId",
        'args': {'storeId': storeId, 'indexCategory': indexCategory}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the store ID for the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The index should be less than the value provided by [size].
  ///
  /// **Returns**
  ///
  /// * On success, returns the store ID > 0
  /// * On failure, returns < 0. See [GemError] for more information.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int getStoreIdAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "LandmarkStoreCollection", 'method': "getStoreIdAt", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all categories of the specified store.
  ///
  /// **Parameters**
  ///
  /// * **IN** *lms* The store
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError remove(LandmarkStore lms) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "LandmarkStoreCollection", 'method': "remove", 'args': lms.pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all categories of the specified store ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError removeAllStoreCategories(int storeId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "LandmarkStoreCollection",
        'method': "removeAllStoreCategories",
        'args': storeId
      }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove category ID from the specified store list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *storeId* The store ID
  /// * **IN** *categoryId* The category ID
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError removeStoreCategoryId(int storeId, int categoryId) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkStoreCollection",
            'method': "removeStoreCategoryId",
            'args': {'storeId': storeId, 'categoryId': categoryId}
          }),
          dispatchOnMainThread: true);
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the number of stores in the list.
  ///
  /// **Returns**
  ///
  /// * The number of stores
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "LandmarkStoreCollection", 'method': "size", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}
