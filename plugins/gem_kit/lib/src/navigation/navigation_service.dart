// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: avoid_print, inference_failure_on_collection_literal

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/navigation/navigation_instruction.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Navigation instruction event types
///
///
/// {@category Routes & Navigation}
enum NavigationEventType {
  /// Signal that the navigation request finished with error.
  error,

  /// Notification received when the destination has been reached.
  ///
  /// This is the moment when the navigation request finished with success.
  destinationReached,

  /// Notification called when the navigation instruction is updated.
  ///
  /// This method is called periodically, usually at 1 second intervals, to update the navigation information for the UI.
  navigationInstructionUpdate,

  /// Notification received when a waypoint on the route has been reached.
  ///
  /// This notification is not sent when the destination of the route has been reached. That is notified through [destinationReached] notification.
  waypointReached,
}

/// Navigation service class
///
/// {@category Routes & Navigation}
abstract class NavigationService {
  /// Cancel the active navigation.
  ///
  /// This method cancels the active navigation. If a route calculation is in progress then the registered progress listener will be signaled first with [ProgressListener.notifyComplete] ([GemError.cancel]).
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  static void cancelNavigation(TaskHandler taskHandler) {
    try {
      taskHandler as TaskHandlerImpl;

      GemKitPlatform.instance.unregisterEventHandler(taskHandler.id);
      GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "NavigationService", 'method': "stopNavigation", 'args': taskHandler.id}));
    } catch (e) {
      print(e);
    }
  }

  /// Get better route time-distance until it forks the navigation route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the time in seconds and distance in meters to the next fork
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static TimeDistance getBetterRouteTimeDistanceToFork({TaskHandler? taskHandler}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "getBetterRouteTimeDistanceToFork",
        'args': (taskHandler != null) ? taskHandler : {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the current navigation instruction.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// * [NavigationInstruction] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static NavigationInstruction getNavigationInstruction({TaskHandler? taskHandler}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "getNavigationInstruction",
        'args': (taskHandler != null) ? taskHandler : {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return NavigationInstruction.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the current route used for navigation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// *  Target route for the navigation session
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Route getNavigationRoute({TaskHandler? taskHandler}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "getNavigationRoute",
        'args': (taskHandler != null) ? taskHandler : {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return Route.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the maximum simulation speed multiplier.
  ///
  /// **Returns**
  ///
  /// *  The maximum simulation speed multiplier
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static double get simulationMaxSpeedMultiplier {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "NavigationService", 'method': "getSimulationMaxSpeedMultiplier", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the minimum simulation speed multiplier.
  ///
  /// **Returns**
  ///
  /// *  The minimum simulation speed multiplier
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static double get simulationMinSpeedMultiplier {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "NavigationService", 'method': "getSimulationMinSpeedMultiplier", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  // /// Get data transfer statistics for this service.
  // ///
  // /// **Returns**
  // ///
  // /// *  [TransferStatistics] object
  // ///
  // ///  **Throws**
  // ///
  // /// * An exception if it fails.
  // TransferStatistics get transferStatistics {
  //   try {
  //     final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
  //         jsonEncode({'id': _pointerId, 'class': "NavigationService", 'method': "getTransferStatistics", 'args': {}}));
  //     final decodedVal = jsonDecode(resultString!);
  //     return TransferStatistics.init(decodedVal['result'], 0);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// Check if there is an active navigation in progress.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// *  True if there is an active navigation in progress, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static bool isNavigationActive({TaskHandler? taskHandler}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "isNavigationActive",
        'args': (taskHandler != null) ? taskHandler : {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if there is an active simulation in progress.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the simulation instance.
  ///
  /// **Returns**
  ///
  /// *  True if there is an active simulation in progress, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static bool isSimulationActive({TaskHandler? taskHandler}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "isSimulationActive",
        'args': (taskHandler != null) ? taskHandler : {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if there is an active trip ( navigation or simulation ) in progress.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Returns**
  ///
  /// *  True if there is an active trip in progress, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static bool isTripActive({TaskHandler? taskHandler}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "isTripActive",
        'args': (taskHandler != null) ? taskHandler : {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel the active navigation.
  ///
  /// Set a roadblock on the current route having the length specified in meters starting from the current GPS position.
  ///
  /// **Parameters**
  ///
  /// * **IN** *length* The length specified in meters.
  /// * **IN** *startDistance* The distance from start where the roadblock begins, defaults to -1 meaning the current navigation position.
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static void setNavigationRoadBlock(
    int length, {
    int? startDistance,
    TaskHandler? taskHandler,
  }) {
    try {
      taskHandler as TaskHandlerImpl?;

      GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "NavigationService",
            'method': "setNavigationRoadBlock",
            'args': {
              'length': length,
              if (startDistance != null) 'startDistance': startDistance else 'startDistance': -1,
              if (taskHandler != null) 'navigationListener': taskHandler.id else 'navigationListener': 0
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Start a new navigation
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* [Route] to use for the navigation.
  /// * **IN** *onNavigationInstructionUpdate* Callback for navigation-specific events.
  ///   * **eventType** [NavigationEventType] The type of navigation event.
  ///   * **instruction** [NavigationInstruction?] The navigation instruction, if any.
  /// * **IN** *onTextToSpeechInstruction* Callback for text-to-speech events.
  ///   * **textInstruction** [String] The instruction text to be spoken.
  /// * **IN** *onRouteUpdated* Callback for signaling route calculation progress events.
  ///   * **route** [Route] The newly calculated or updated route. This will be used only when the route is calculated or recalculated.
  /// * **IN** *onBetterRouteDetected* Callback for signaling when a better route is detected.
  ///   * **route** [Route] The newly detected better route.
  ///   * **travelTime** [int] The travel time of the new route in seconds.
  ///   * **delay** [int] The delay in seconds of the current route.
  ///   * **timeGain** [int] Time gain from the existing route in seconds. `-1` means the original route has roadblocks and time gain cannot be calculated.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler startNavigation(Route route,
      void Function(NavigationEventType eventType, NavigationInstruction? instruction) onNavigationInstructionUpdate,
      {void Function(String textInstruction)? onTextToSpeechInstruction,
      void Function(Route route)? onRouteUpdated,
      void Function(Route route, int travelTime, int delay, int timeGain)? onBetterRouteDetected}) {
    try {
      final encodedString = jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "startNavigation",
        'args': {'route': route.pointerId, 'simulation': false}
      });

      final resultString = GemKitPlatform.instance.callObjectMethod(encodedString);
      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);

      progListener.registerOnNotifyCustom((json) {
        if (json['eventType'] == 'navInstructionUpdated') {
          final value = getNavigationInstruction();
          {
            onNavigationInstructionUpdate(NavigationEventType.navigationInstructionUpdate, value);
          }
        } else if (json['eventType'] == 'navigationDstEvent') {
          onNavigationInstructionUpdate(NavigationEventType.destinationReached, null);
        } else if (json['eventType'] == 'navigationWptEvent') {
          onNavigationInstructionUpdate(NavigationEventType.waypointReached, null);
        } else if (json['eventType'] == 'navigationErrorEvent') {
          onNavigationInstructionUpdate(NavigationEventType.error, null);
        } else if (json['eventType'] == 'navSound') {
          if (onTextToSpeechInstruction != null) {
            onTextToSpeechInstruction(json['ttsString']);
          }
        } else if (json['eventType'] == 'onRouteUpdated') {
          if (onRouteUpdated != null) {
            final route = Route.init(json['id'], 0);
            onRouteUpdated(route);
          }
        } else if (json['eventType'] == 'onBetterRouteDetected') {
          if (onBetterRouteDetected != null) {
            final route = Route.init(json['id'], 0);
            final travelTime = json['travelTime'];
            final delay = json['delay'];
            final timeGain = json['timeGain'];
            onBetterRouteDetected(route, travelTime, delay, timeGain);
          }
        }
      });

      progListener.registerOnCompleteWithDataCallback((err, hint, json) {});
      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Start a new simulation
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* [Route] to use for the navigation.
  /// * **IN** *onNavigationInstructionUpdate* Callback for navigation-specific events.
  ///   * **eventType** [NavigationEventType] The type of navigation event.
  ///   * **instruction** [NavigationInstruction?] The navigation instruction, if any.
  /// * **IN** *onTextToSpeechInstruction* Callback for text-to-speech events.
  ///   * **textInstruction** [String] The instruction text to be spoken.
  /// * **IN** *speedMultiplier* The route simulation speed multiplier. Accepted values are in the interval {[simulationMinSpeedMultiplier], [simulationMaxSpeedMultiplier]}. If set to **1.0** the simulation speed is the speed limit of the traveled links.
  /// * **IN** *onRouteUpdated* Callback for signaling route calculation progress events.
  ///   * **route** [Route] The newly calculated or updated route.
  /// * **IN** *onBetterRouteDetected* Callback for signaling when a better route is detected.
  ///   * **route** [Route] The newly detected better route.
  ///   * **travelTime** [int] The travel time of the new route in seconds.
  ///   * **delay** [int] The delay in seconds of the current route.
  ///   * **timeGain** [int] Time gain from the existing route in seconds. `-1` means the original route has roadblocks and time gain cannot be calculated.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler startSimulation(Route route,
      void Function(NavigationEventType eventType, NavigationInstruction? instruction) onNavigationInstructionUpdate,
      {void Function(String textInstruction)? onTextToSpeechInstruction,
      double? speedMultiplier,
      void Function(Route route)? onRouteUpdated,
      void Function(Route route, int travelTime, int delay, int timeGain)? onBetterRouteDetected}) {
    try {
      final encodedString = jsonEncode({
        'id': 0,
        'class': "NavigationService",
        'method': "startNavigation",
        'args': {
          'route': route.pointerId,
          'simulation': true,
          if (speedMultiplier != null) 'speedMultiplier': speedMultiplier
        }
      });
      final resultString = GemKitPlatform.instance.callObjectMethod(encodedString);
      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);
      progListener.registerOnNotifyCustom((json) {
        if (json['eventType'] == 'navInstructionUpdated') {
          final value = getNavigationInstruction();
          {
            onNavigationInstructionUpdate(NavigationEventType.navigationInstructionUpdate, value);
          }
        } else if (json['eventType'] == 'navigationDstEvent') {
          onNavigationInstructionUpdate(NavigationEventType.destinationReached, null);
        } else if (json['eventType'] == 'navigationWptEvent') {
          onNavigationInstructionUpdate(NavigationEventType.waypointReached, null);
        } else if (json['eventType'] == 'navigationErrorEvent') {
          onNavigationInstructionUpdate(NavigationEventType.error, null);
        } else if (json['eventType'] == 'navSound') {
          if (onTextToSpeechInstruction != null) {
            onTextToSpeechInstruction(json['ttsString']);
          }
        } else if (json['eventType'] == 'onRouteUpdated') {
          if (onRouteUpdated != null) {
            final route = Route.init(json['id'], 0);
            onRouteUpdated(route);
          }
        } else if (json['eventType'] == 'onBetterRouteDetected') {
          if (onBetterRouteDetected != null) {
            final route = Route.init(json['id'], 0);
            final travelTime = json['travelTime'];
            final delay = json['delay'];
            final timeGain = json['timeGain'];
            onBetterRouteDetected(route, travelTime, delay, timeGain);
          }
        }
      });
      progListener.registerOnCompleteWithDataCallback((err, hint, json) {});
      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);

      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Get navigation parameters.
  ///
  /// Possible parameters:
  ///
  /// * *tts_announce_min_traffic_delay* : large integer - the minimum traffic delay in seconds for which there should be a TTS announce
  ///
  /// **Returns**
  ///
  /// * Parameters list
  static ParameterList getNavigationParameters() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "NavigationService", 'method': "getNavigationParameters", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return ParameterList.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Skip next intermediate destination on the navigation route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  ///
  /// If there are no more intermediate waypoints on the route, [GemError.notFound] is returned
  ///
  /// The route will be recalculated and an `onRouteUpdated` notification will be emited
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success
  static GemError skipNextIntermediateDestination({TaskHandler? taskHandler}) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        Object(),
        jsonEncode({
          'id': 0,
          'class': "NavigationService",
          'method': "skipNextIntermediateDestination",
          'args': (taskHandler != null) ? taskHandler : {}
        }),
        dispatchOnMainThread: true,
      );
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  // /// Request to the navigation service to send the updated sound to the navigation listener.
  // ///
  // /// **Parameters**
  // ///
  // /// * **IN** *navigationListener* Navigation listener used to identify the navigation session.
  // ///
  // /// **Throws**
  // ///
  // /// * An exception if it fails.
  // void updateNavigationSound({TaskHandler? taskHandler}) {
  //   try {
  //     GemKitPlatform.instance.callObjectMethodffi(
  //         this,
  //         jsonEncode({
  //           'id': _pointerId,
  //           'class': "NavigationService",
  //           'method': "updateNavigationSound",
  //           'args': (taskHandler != null) ? taskHandler : {}
  //         }));
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
