// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// Interface for implementing progress of async operations (routing, search)
///
/// {@category Core}
abstract class ProgressListener {
  int _pointerId = 0;

  void registerOnCompleteWithDataCallback(void Function(int err, String hint, Map<dynamic, dynamic> json) callback) {}

  void registerOnProgressCallback(void Function(int progress) callback) {}

  void registerOnNotifyCustom(void Function(dynamic json) callback) {}

  void registerOnNotifyStatusChanged(void Function(int status) callback) {}

  /// Notify that the requested operation was started.
  ///
  /// Mandatory call
  ///
  /// **Parameters**
  ///
  /// * **IN** *hasProgress* If the operation supports progress then _hasProgress_ is true.
  void notifyStart(bool hasProgress) {
    throw UnimplementedError('notifyStart has not been implemented.');
  }

  void notifyCustom(dynamic json) {}

  /// Get the progress multiplier.
  ///
  /// SDK uses floating point values in the 0, 1 closed interval for the progress on operations. The values received in the [notifyProgress] notification are integers obtained by multiplying the internal floating point value with the value returned by [progressMultiplier].
  /// By default, this function returns 100 so that the progress values that may be received will be between 0 and 100.
  ///
  /// **Returns**
  ///
  /// * The progress multiplier
  int get progressMultiplier {
    return 100;
  }

  /// The interval in ms to receive progress updates
  ///
  /// SDK uses this interval to notify the progress Default is 200ms (5 times per second).
  ///
  /// **Returns**
  ///
  /// * The progress interval in milliseconds
  int get progressNotifyInterval {
    return 200;
  }

  /// Notify the progress on requested operation. Called when the progress is updated.
  ///
  /// Parameter value will be between 0 and the value returned by [progressMultiplier].
  ///
  /// **Parameters**
  ///
  /// * **IN** *progress* The progress value
  void notifyProgress(int progress) {}

  /// Notify operation status change on the requested operation. Called if the status of the operation is changed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *status* The new status
  void notifyStatusChanged(int status) {}

  /// Called when the operation is completed
  ///
  /// **Parameters**
  ///
  /// * **IN** *err*
  /// * **IN** *hint* Additional information about the completion
  void notifyComplete(int err, String hint) {
    throw UnimplementedError('notifyComplete has not been implemented.');
  }

  /// Called when the operation is completed
  ///
  /// **Parameters**
  ///
  /// * **IN** *err* The error code
  /// * **IN** *hint* Additional information about the completion
  /// * **IN** *json* Additional data for the completion
  void notifyCompleteWithData(int err, String hint, Map<dynamic, dynamic> json) {
    notifyComplete(err, hint);
  }

  dynamic get id => _pointerId;
  set id(dynamic id) => _pointerId = id;
}
