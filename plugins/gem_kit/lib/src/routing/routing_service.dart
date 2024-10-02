// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/landmark.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/route.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/routing/routing_preferences.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Routing service class
///
/// {@category Routes & Navigation}
abstract class RoutingService {
  /// Calculate a route between the specified waypoints.
  ///
  /// **Parameters**
  ///
  /// * **IN** *waypoints* The list of waypoints for the route
  /// * **IN** *routePreferences* The preferences for the route calculation
  /// * **IN** *onCompleteCallback* The listener for the route calculation completeness notification
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler calculateRoute(
      List<Landmark> waypoints,
      RoutePreferences routePreferences,
      void Function(GemError err, List<Route>? routes) onCompleteCallback) {
    try {
      final landmarkList = LandmarkList.fromList(waypoints);

      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "RoutingService",
            'method': "calculateRoute",
            'args': {
              'waypoints': landmarkList.pointerId,
              'routePreferences': routePreferences
            }
          }));

      final decodedVal = jsonDecode(resultString!);
      final retVal = decodedVal['result'];

      if (retVal >= GemError.missingCapability.code && retVal < 0) {
        throw ("Error code $retVal");
      }

      final progListener = EventDrivenProgressListener.init(retVal);
      progListener.registerOnCompleteWithDataCallback((err, hint, json) {
        if (err == 0) {
          final routeList = RouteList.init(json['searchId'], 0);
          onCompleteCallback(
              GemErrorExtension.fromCode(err), routeList.toList());
        } else {
          onCompleteCallback(GemErrorExtension.fromCode(err), null);
        }
      });

      GemKitPlatform.instance
          .registerEventHandler(progListener.id, progListener);

      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel the route calculation associated with the specified listener. **FFI METHOD**

  /// **Parameters**
  ///
  /// * **IN** *progressListener* The listener associated with the route calculation to be canceled.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void cancelRoute(TaskHandler taskHandler) {
    try {
      taskHandler as TaskHandlerImpl;

      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "RoutingService",
        'method': "cancelRoute",
        'routeId': taskHandler.id
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set a user road block from the provided route instruction.
  ///
  /// **Parameters**
  ///
  /// * **IN** *instruction* 	The route instruction containing the road block information.
  ///
  /// **Returns**
  ///
  /// * 0 on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static int setRouteRoadBlock(RouteInstructionBase instruction) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(Object(),jsonEncode({
        'id': 0,
        'class': "RoutingService",
        'method': "setRouteRoadBlock",
        'args': instruction
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Reset the user road blocks.
  ///
  /// This will remove all the user road blocks set by the user.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void resetRouteRoadBlocks() {
    try {
      GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "RoutingService",
        'method': "resetRouteRoadBlocks",
        'args': {}
      }));
    } catch (e) {
      rethrow;
    }
  }

  /// Check if there is route calculation in progress associated with the specified task handler.
  ///
  /// **Parameters**
  ///
  /// * **IN** *progressListener* The listener associated with the route calculation to be canceled.
  ///
  /// **Returns**
  ///
  /// * true if the route calculation is in progress, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static bool isCalculationRunning(TaskHandler progressListener) {
    try {
      progressListener as TaskHandlerImpl;

      final result = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "RoutingService",
        'method': "isCalculationRunning",
        'args': progressListener.id
      }));
      final decodedVal = jsonDecode(result!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the status for the route monitored by the given listener.
  ///
  /// **Parameters**
  ///
  /// * **IN** *progressListener* The listener associated with the route calculation to be canceled.
  ///
  /// **Returns**
  ///
  /// * The status of the route calculation.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static RouteStatus getRouteStatus(TaskHandler progressListener) {
    try {
      progressListener as TaskHandlerImpl;

      final result = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "RoutingService",
        'method': "getRouteStatus",
        'args': progressListener.id
      }));
      final decodedVal = jsonDecode(result!);
      return RouteStatusExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }
}
