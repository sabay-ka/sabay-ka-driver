// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/contentstore/content_updater.dart';
import 'package:gem_kit/src/core/progress_listener.dart';

/// Content updater status
///
/// {@category Content}
enum ContentUpdaterStatus {
  /// Not started
  idle,

  /// Wait for internet connection.
  waitConnection,

  /// Wait for WIFI internet connection.
  waitWIFIConnection,

  /// Check for updated items.
  checkForUpdate,

  /// Download updated content.
  download,

  /// Update is fully downloaded & ready to apply.
  ///
  /// When entering this state [ContentUpdater.items] will return the list of target items to update.
  fullyReady,

  /// Update is partially downloaded & ready to apply.
  partiallyReady,

  /// Download remaining content after appliance.
  downloadRemainingContent,

  /// Download pending content.
  downloadPendingContent,

  /// Finished with success.
  ///
  /// This state will be returned by convention, user will also receive [ProgressListener.notifyComplete].
  complete,

  /// Finished with error.
  ///
  /// This state will be returned by convention, user will also receive [ProgressListener.notifyComplete] with more error details.
  error,
}

/// This class will not be documented
/// @nodoc
/// {@category Content}
extension ContentUpdaterStatusExtension on ContentUpdaterStatus {
  int get id {
    switch (this) {
      case ContentUpdaterStatus.idle:
        return 0;
      case ContentUpdaterStatus.waitConnection:
        return 1;
      case ContentUpdaterStatus.waitWIFIConnection:
        return 2;
      case ContentUpdaterStatus.checkForUpdate:
        return 3;
      case ContentUpdaterStatus.download:
        return 4;
      case ContentUpdaterStatus.fullyReady:
        return 5;
      case ContentUpdaterStatus.partiallyReady:
        return 6;
      case ContentUpdaterStatus.downloadRemainingContent:
        return 7;
      case ContentUpdaterStatus.downloadPendingContent:
        return 8;
      case ContentUpdaterStatus.complete:
        return 9;
      case ContentUpdaterStatus.error:
        return 10;
    }
  }

  static ContentUpdaterStatus fromId(int id) {
    switch (id) {
      case 0:
        return ContentUpdaterStatus.idle;
      case 1:
        return ContentUpdaterStatus.waitConnection;
      case 2:
        return ContentUpdaterStatus.waitWIFIConnection;
      case 3:
        return ContentUpdaterStatus.checkForUpdate;
      case 4:
        return ContentUpdaterStatus.download;
      case 5:
        return ContentUpdaterStatus.fullyReady;
      case 6:
        return ContentUpdaterStatus.partiallyReady;
      case 7:
        return ContentUpdaterStatus.downloadRemainingContent;
      case 8:
        return ContentUpdaterStatus.downloadPendingContent;
      case 9:
        return ContentUpdaterStatus.complete;
      case 10:
        return ContentUpdaterStatus.error;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
