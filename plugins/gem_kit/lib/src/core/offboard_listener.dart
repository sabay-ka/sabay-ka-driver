// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Error reason type
///
/// {@category Core}
enum Reason {
  /// There is not enough space on disk.
  ///
  /// Resolution: run a cleanup procedure in order to free more disk space
  noDiskSpace,

  /// There is not enough space on disk.
  ///
  /// Resolution: run a cleanup procedure in order to free more disk space
  expiredSDK,
}

/// @nodoc
///
/// {@category Core}
extension ReasonExtension on Reason {
  int get id {
    switch (this) {
      case Reason.noDiskSpace:
        return 0;
      case Reason.expiredSDK:
        return 1;
    }
  }

  static Reason fromId(int id) {
    switch (id) {
      case 0:
        return Reason.noDiskSpace;
      case 1:
        return Reason.expiredSDK;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Worldwide road map support status
///
/// {@category Core}
enum Status {
  /// Notifies that the existing worldwide road map data is old, which implies that the SDK worldwide road map still has
  /// support but will not use the latest worldwide road map data.
  oldData,

  /// Notifies that the existing worldwide road map data is expired, which implies that the SDK worldwide road map does
  /// not have support anymore.
  expiredData,

  /// Notifies that the worldwide road map data is up to date This notification is sent only as a result of a
  /// [ContentStore.checkForUpdate] request.
  upToDate,
}

/// @nodoc
///
/// {@category Core}
extension StatusExtension on Status {
  int get id {
    switch (this) {
      case Status.oldData:
        return 0;
      case Status.expiredData:
        return 1;
      case Status.upToDate:
        return 2;
    }
  }

  static Status fromId(int id) {
    switch (id) {
      case 0:
        return Status.oldData;
      case 1:
        return Status.expiredData;
      case 2:
        return Status.upToDate;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Service group enum, including map tiles, traffic, terrain.
///
/// {@category Core}
enum ServiceGroupType {
  /// All map data related services: map tiles, overlays, searching, routing.
  mapDataService,

  /// Traffic related services: live traffic flow, congestion, detours, closed roads.
  trafficService,

  /// Terrain/satellite/external WMTS services.
  terrainService,

  /// Content download service
  contentService,
}

/// @nodoc
///
/// {@category Core}
extension ServiceGroupTypeExtension on ServiceGroupType {
  int get id {
    switch (this) {
      case ServiceGroupType.mapDataService:
        return 0;
      case ServiceGroupType.trafficService:
        return 1;
      case ServiceGroupType.terrainService:
        return 2;
      case ServiceGroupType.contentService:
        return 3;
    }
  }

  static ServiceGroupType fromId(int id) {
    switch (id) {
      case 0:
        return ServiceGroupType.mapDataService;
      case 1:
        return ServiceGroupType.trafficService;
      case 2:
        return ServiceGroupType.terrainService;
      case 3:
        return ServiceGroupType.contentService;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// OffBoard Listener
///
/// {@category Core}
class OffBoardListener extends EventDrivenProgressListener {
  /// Notifies that the connection status changed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isConnected* Tells if the connection to the online services is established.
  void Function(bool isConnected)? onConnectionStatusUpdatedCallback;

  /// Notifies that the connection status changed for the given service group
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceGroupType* The service group type
  /// * **IN** *isConnected* Tells if the connection is available.
  void Function(ServiceGroupType type, bool isConnected)? onConnectionStatusUpdated2Callback;

  /// Notifies that the topic notifications service status changed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *isTopicNotificationsEnabled* Tells that the topic notifications service is available
  void Function(bool isTopicNotificationsEnabled)? onTopicNotificationsStatusUpdatedCallback;

  /// Notifies that the worldwide road map support is disabled
  /// Worldwide road map data, routing and traffic support is disabled
  ///
  /// **Parameters**
  ///
  /// * **IN** *reason* The reason why the worldwide road map support was disabled
  void Function(Reason reason)? onWorldwideRoadMapSupportDisabledCallback;

  /// Notifies about worldwide road map data state
  ///
  /// **Parameters**
  ///
  /// * **IN** *state* The worldwide road map support status
  void Function(Status state)? onWorldwideRoadMapSupportStatusCallback;

  /// Notifies that the worldwide road map support is enabled
  ///
  /// Worldwide road map data, routing and traffic support is enabled
  void Function()? onWorldwideRoadMapSupportEnabledCallback;

  /// Notifies that the application resources are ready to be deployed
  void Function()? onResourcesReadyToDeployCallback;

  /// Notifies that offboard cache changed size.
  /// Cache size is given in KB
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The new cache size in KB
  void Function(int size)? onOnlineCacheSizeChangeCallback;

  /// Notifies that the worldwide road map version was updated
  void Function()? onWorldwideRoadMapVersionUpdatedCallback;

  /// Notifies about existing content update
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* Content type
  /// * **IN** *state* Content status code
  void Function(int contentType, Status statusCode)? onAvailableContentUpdateCallback;

  /// Notifies that current SDK doesn't support all worldwide road map capabilities.
  ///
  /// SDK can use the latest worldwide road map version but the new map capabilities are disabled
  void Function()? onWorldwideRoadMapUnsupportedCapabilitiesCallback;

  /// Notifies that current API token was rejected
  ///
  /// Please check the API token availability or contact MagicLane support
  void Function()? onApiTokenRejectedCallback;

  /// Notifies that current API token was updated
  ///
  /// This notification will be available only for tokens updated internally via MagicEarth services
  void Function()? onApiTokenUpdatedCallback;

  /// Notifies that social login state changed
  ///
  /// **Parameters**
  ///
  /// * **IN** *loggedIn* True if the user is logged in, false otherwise
  void Function(bool loggedIn)? onLoginStatusUpdatedCallback;

  OffBoardListener.init(dynamic id) {
    this.id = id;
  }

  factory OffBoardListener(bool canDoAutoUpdate) => OffBoardListener._create(canDoAutoUpdate);

  static OffBoardListener _create(bool canDoAutoUpdate) {
    final resultString =
        GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "OffBoardListener", 'args': canDoAutoUpdate}));
    final decodedVal = jsonDecode(resultString!);
    return OffBoardListener.init(decodedVal['result']);
  }

  void registerOnConnectionStatusUpdated(void Function(bool isConnected)? callback) {
    onConnectionStatusUpdatedCallback = callback;
  }

  void registerOnConnectionStatusUpdated2(void Function(ServiceGroupType serviceType, bool isConnected)? callback) {
    onConnectionStatusUpdated2Callback = callback;
  }

  void registerOnTopicNotificationsStatusUpdated(void Function(bool isNotifying)? callback) {
    onTopicNotificationsStatusUpdatedCallback = callback;
  }

  void registerOnWorldwideRoadMapSupportDisabled(void Function(Reason reason)? callback) {
    onWorldwideRoadMapSupportDisabledCallback = callback;
  }

  void registerOnWorldwideRoadMapSupportStatus(void Function(Status status)? callback) {
    onWorldwideRoadMapSupportStatusCallback = callback;
  }

  void registerOnWorldwideRoadMapSupportEnabled(void Function()? callback) {
    onWorldwideRoadMapSupportEnabledCallback = callback;
  }

  void registerOnResourcesReadyToDeploy(void Function()? callback) {
    onResourcesReadyToDeployCallback = callback;
  }

  void registerOnOnlineCacheSizeChange(void Function(int size)? callback) {
    onOnlineCacheSizeChangeCallback = callback;
  }

  void registerOnWorldwideRoadMapVersionUpdated(void Function()? callback) {
    onWorldwideRoadMapVersionUpdatedCallback = callback;
  }

  void registerOnAvailableContentUpdate(void Function(int type, Status status)? callback) {
    onAvailableContentUpdateCallback = callback;
  }

  void registerOnWorldwideRoadMapUnsupportedCapabilities(void Function()? callback) {
    onWorldwideRoadMapUnsupportedCapabilitiesCallback = callback;
  }

  void registerOnApiTokenRejected(void Function()? callback) {
    onApiTokenRejectedCallback = callback;
  }

  void registerOnApiTokenUpdated(void Function()? callback) {
    onApiTokenUpdatedCallback = callback;
  }

  void registerOnLoginStatusUpdated(void Function(bool isLoggedIn)? callback) {
    onLoginStatusUpdatedCallback = callback;
  }

  /// Verifies that application resources update is allowed. Returning true will allow the SDK to download and prepare the latest resources
  ///
  /// Returns true if the resources update is allowed, false otherwise
  bool isResourcesUpdateAllowed() {
    return true;
  }

  @override
  void notifyCustom(dynamic json) {
    String eventSubtype = json['event_subtype'];

    switch (eventSubtype) {
      case 'onConnectionStatusUpdated':
        if (onConnectionStatusUpdatedCallback != null) {
          onConnectionStatusUpdatedCallback!(json['connected']);
        }
        break;

      case 'onConnectionStatusUpdated2':
        if (onConnectionStatusUpdated2Callback != null) {
          onConnectionStatusUpdated2Callback!(ServiceGroupType.values[json['svc']], json['connected']);
        }
        break;

      case 'onTopicNotificationsStatusUpdated':
        if (onTopicNotificationsStatusUpdatedCallback != null) {
          onTopicNotificationsStatusUpdatedCallback!(json['available']);
        }
        break;

      case 'onWorldwideRoadMapSupportDisabled':
        if (onWorldwideRoadMapSupportDisabledCallback != null) {
          onWorldwideRoadMapSupportDisabledCallback!(Reason.values[json['reason']]);
        }
        break;

      case 'onWorldwideRoadMapSupportStatus':
        if (onWorldwideRoadMapSupportStatusCallback != null) {
          onWorldwideRoadMapSupportStatusCallback!(Status.values[json['state']]);
        }
        break;

      case 'onWorldwideRoadMapSupportEnabled':
        if (onWorldwideRoadMapSupportEnabledCallback != null) {
          onWorldwideRoadMapSupportEnabledCallback!();
        }
        break;

      case 'onResourcesReadyToDeploy':
        if (onResourcesReadyToDeployCallback != null) {
          onResourcesReadyToDeployCallback!();
        }
        break;

      case 'onOnlineCacheSizeChange':
        if (onOnlineCacheSizeChangeCallback != null) {
          onOnlineCacheSizeChangeCallback!(json['size']);
        }
        break;

      case 'onWorldwideRoadMapVersionUpdated':
        if (onWorldwideRoadMapVersionUpdatedCallback != null) {
          onWorldwideRoadMapVersionUpdatedCallback!();
        }
        break;

      case 'onAvailableContentUpdate':
        if (onAvailableContentUpdateCallback != null) {
          onAvailableContentUpdateCallback!(json['type'], Status.values[json['state']]);
        }
        break;

      case 'onWorldwideRoadMapUnsupportedCapabilities':
        if (onWorldwideRoadMapUnsupportedCapabilitiesCallback != null) {
          onWorldwideRoadMapUnsupportedCapabilitiesCallback!();
        }
        break;

      case 'onApiTokenRejected':
        if (onApiTokenRejectedCallback != null) {
          onApiTokenRejectedCallback!();
        }
        break;

      case 'onApiTokenUpdated':
        if (onApiTokenUpdatedCallback != null) {
          onApiTokenUpdatedCallback!();
        }
        break;

      case 'onLoginStatusUpdated':
        if (onLoginStatusUpdatedCallback != null) {
          onLoginStatusUpdatedCallback!(json['loggedIn']);
        }
        break;

      default:
        // Handle unknown event subtype or log a warning
        print('Unknown event subtype: $eventSubtype');
    }
  }
}
