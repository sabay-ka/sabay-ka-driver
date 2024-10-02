// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/landmark_store.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Landmark store service class
///
/// {@category Places}
abstract class LandmarkStoreService {
  /// Create a new landmark store. The landmark store type for all stores created with this function is ELandmarkStoreType::Default.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name*	The name of the landmark store. The name must be unique otherwise will return [GemError.exist].
  /// * **IN** *zoom*	The max zoom step at which the landmark store will be visible. If -1, a default optimal zoom level is selected.
  /// * **IN** *folder*	Folder path where the landmark store will be created. If empty, the landmark store will be created in the SDK default location.
  ///
  /// If a landmark with the given name already exists, it is returned.
  ///
  /// **Returns**
  ///
  /// * LandmarkStore object. If a landmark store already exists, it is returned.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static LandmarkStore createLandmarkStore(
    String name, {
    int? zoom,
    String? folder,
  }) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "LandmarkStoreService",
        'method': "createLandmarkStore",
        'args': {'name': name, if (zoom != null) 'zoom': zoom, if (folder != null) 'folder': folder}
      }));
      final decodedVal = jsonDecode(resultString!);
      final retVal = LandmarkStore.init(decodedVal['result'], 0);
      GemKitPlatform.instance.registerWeakRelease(retVal, retVal.pointerId);
      return retVal;
    } catch (e) {
      rethrow;
    }
  }

  /// Get landmark store by ID.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId*	The ID of the landmark store
  ///
  /// **Returns**
  /// * [LandmarkStore] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static LandmarkStore? getLandmarkStoreById(int landmarkStoreId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': 0, 'class': "LandmarkStoreService", 'method': "getLandmarkStoreById", 'args': landmarkStoreId}));
      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) return null;
      final retVal = LandmarkStore.init(decodedVal['result'], 0);
      GemKitPlatform.instance.registerWeakRelease(retVal, retVal.pointerId);
      return retVal;
    } catch (e) {
      rethrow;
    }
  }

  /// Get landmark store by name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name*	The name of the landmark store
  ///
  /// **Returns**
  /// * [LandmarkStore] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static LandmarkStore? getLandmarkStoreByName(String name) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "LandmarkStoreService", 'method': "getLandmarkStoreByName", 'args': name}));
      final decodedVal = jsonDecode(resultString!);
      final res = decodedVal['result'];
      if (res == 0) {
        return null;
      }
      final retVal = LandmarkStore.init(decodedVal['result'], 0);
      GemKitPlatform.instance.registerWeakRelease(retVal, retVal.pointerId);
      return retVal;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Map POIs landmarkstore id.
  ///
  /// **Returns**
  /// * [LandmarkStore] id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get mapPoisLandmarkStoreId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "LandmarkStoreService", 'method': "getMapPoisLandmarkStoreId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final res = decodedVal['result'];
      return res;
    } catch (e) {
      rethrow;
    }
  }

  /// Get [LandmarkStore] id attached to map address database information.
  ///
  /// **Returns**
  /// * [LandmarkStore] id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get mapAddressLandmarkStoreId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "LandmarkStoreService", 'method': "getMapAddressLandmarkStoreId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final res = decodedVal['result'];
      return res;
    } catch (e) {
      rethrow;
    }
  }

  /// Get [LandmarkStore] id attached to map cities database information.
  ///
  /// **Returns**
  /// * [LandmarkStore] id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int get mapCitiesLandmarkStoreId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "LandmarkStoreService", 'method': "getMapCitiesLandmarkStoreId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final res = decodedVal['result'];
      return res;
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the landmark store specified by ID.
  ///
  /// The landmark store should be disposed before calling this method. Dispose the landmark store using [LandmarkStore.dispose].
  /// The landmarks store will not be removed unless object is disposed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmarkStoreId* The landmark store ID
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static void removeLandmarkStore(int landmarkStoreId) {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': 0, 'class': "LandmarkStoreService", 'method': "removeLandmarkStore", 'args': landmarkStoreId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Register an already existing landmark store.
  ///
  /// The name parameter will override the landmark store internal creation name. This allows to register landmark stores in order to import data from them
  ///
  /// **Parameters**
  ///
  /// * **IN** *name*	The landmark store name. Must be unique, otherwise [GemError.exist] is returned
  /// * **IN** *path*	The landmark store path
  ///
  /// **Returns**
  ///
  /// * On success the landmark store ID
  /// * [GemError.exist] if the name already exist
  /// * [GemError.notFound] if the landmark store cannot be found
  /// * [GemError.invalidInput] if the path is not a valid landmark store
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails to initialize.
  static int registerLandmarkStore({required String name, required String path}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "LandmarkStoreService",
        'method': "registerLandmarkStore",
        'args': {'name': name, 'path': path},
      }));
      final decodedVal = jsonDecode(resultString!);
      final res = decodedVal['result'];
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
