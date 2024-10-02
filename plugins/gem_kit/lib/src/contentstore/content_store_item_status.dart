// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// Enumerates possible item states.
///
/// {@category Content}
enum ContentStoreItemStatus {
  /// The item has no content.
  unavailable,

  /// The item has complete content.
  completed,

  /// The item download is paused.
  paused,

  ///Download is waiting in the downloads queue.
  ///
  ///A download might be enqueued due to "max parallel downloads" constraint or because of an API token rate limit
  downloadQueued,

  /// Download is waiting for a network connection.
  downloadWaitingNetwork,

  /// deprecated
  downloadWaiting,

  /// Download is waiting for a free network to begin/resume the download.
  downloadWaitingFreeNetwork,

  /// Download is running.
  downloadRunning,

  /// Item download is waiting for the update operation to finish.
  ///
  /// Items selected for download during an update operation will enter this state.
  updateWaiting,
}

/// This class will not be documented.
/// @nodoc
/// {@category Content}
extension ContentStoreItemStatusExtension on ContentStoreItemStatus {
  int get id {
    switch (this) {
      case ContentStoreItemStatus.unavailable:
        return 0;
      case ContentStoreItemStatus.completed:
        return 1;
      case ContentStoreItemStatus.paused:
        return 2;
      case ContentStoreItemStatus.downloadQueued:
        return 3;
      case ContentStoreItemStatus.downloadWaitingNetwork:
        return 4;
      case ContentStoreItemStatus.downloadWaiting:
        return 5;
      case ContentStoreItemStatus.downloadWaitingFreeNetwork:
        return 6;
      case ContentStoreItemStatus.downloadRunning:
        return 7;
      case ContentStoreItemStatus.updateWaiting:
        return 8;
    }
  }

  static ContentStoreItemStatus fromId(int id) {
    switch (id) {
      case 0:
        return ContentStoreItemStatus.unavailable;
      case 1:
        return ContentStoreItemStatus.completed;
      case 2:
        return ContentStoreItemStatus.paused;
      case 3:
        return ContentStoreItemStatus.downloadQueued;
      case 4:
        return ContentStoreItemStatus.downloadWaitingNetwork;
      case 5:
        return ContentStoreItemStatus.downloadWaiting;
      case 6:
        return ContentStoreItemStatus.downloadWaitingFreeNetwork;
      case 7:
        return ContentStoreItemStatus.downloadRunning;
      case 8:
        return ContentStoreItemStatus.updateWaiting;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
