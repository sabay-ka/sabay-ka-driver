// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:typed_data';

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/sense/sense_data_types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Path import supported formats
///
/// {@category Sensor Data Source}
enum FileType {
  /// NMEA
  nmea,

  //GPX
  gpx,

  /// KML
  kml,

  /// GeoJson
  geoJson,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Sensor Data Source}
extension FileTypeExtension on FileType {
  int get id {
    switch (this) {
      case FileType.nmea:
        return 0;
      case FileType.gpx:
        return 1;
      case FileType.kml:
        return 2;
      case FileType.geoJson:
        return 3;
    }
  }

  static FileType fromId(int id) {
    switch (id) {
      case 0:
        return FileType.nmea;
      case 1:
        return FileType.gpx;
      case 2:
        return FileType.kml;
      case 3:
        return FileType.geoJson;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Structure describing recorder configuration properties.
///
/// {@category Sensor Data Source}
class RecorderConfiguration {
  /// The directory used to keep the logs. This is an absolute path. Restart will occur.
  String? logsDir;

  /// The device model
  String? deviceModel;

  /// The types that are recorded. If only one of them is not produced by the data source the recording will not start.
  List<DataType>? recordedTypes;

  /// The minimum recording duration for it to be saved.
  ///
  /// The default value is 30 seconds.
  int? minDurationSeconds;

  /// The chunk duration time in seconds
  ///
  /// The default value is infinite recording (0).
  int? chunkDurationSeconds;

  /// Whether the recording should continue automatically when chunk time achieved.
  ///
  /// The default value is true.
  bool? continuousRecording;

  /// If set to true, startRecording will be performed even if the temperature conditions are not respected
  ///
  /// This is added for development purposes.
  ///
  /// The default value is false.
  bool? overrideOverheatCheck;

  /// All recordings will not occupy space in bytes more than this limit.
  ///
  /// Ex: 100 * 1024*1024 = 100 MB. All logs will not occupy more than this.
  ///
  /// The default value is ignore disk limit (0).
  int? maxDiskSpaceUsed;

  /// Will not delete any record if this threshold is not reached.
  ///
  /// After the threshold is reached the oldest recording will be deleted if there is no space left on the device.
  ///
  /// The default value is keep all recordings (0).
  int? keepMinSeconds;

  /// Older logs that exceeds minimum kept seconds threshold should be deleted.
  ///
  /// The default value is false.
  bool? deleteOlderThanKeepMin;

  /// The transport mode
  ///
  /// The default value is unknown.
  RecordingTransportMode? transportMode;

  RecorderConfiguration({
    this.logsDir,
    this.deviceModel,
    this.recordedTypes,
    this.minDurationSeconds = 30,
    this.chunkDurationSeconds = 0,
    this.continuousRecording = true,
    this.overrideOverheatCheck = false,
    this.maxDiskSpaceUsed = 0,
    this.keepMinSeconds = 0,
    this.deleteOlderThanKeepMin = false,
    this.transportMode = RecordingTransportMode.unknown,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (logsDir != null) {
      json['logsDir'] = logsDir;
    }
    if (deviceModel != null) {
      json['deviceModel'] = deviceModel;
    }
    if (recordedTypes != null) {
      json['recordedTypes'] = recordedTypes!.map((type) => type.id).toList();
    }
    if (minDurationSeconds != null) {
      json['minDurationSeconds'] = minDurationSeconds;
    }
    if (chunkDurationSeconds != null) {
      json['chunkDurationSeconds'] = chunkDurationSeconds;
    }
    if (continuousRecording != null) {
      json['bContinuousRecording'] = continuousRecording;
    }
    if (overrideOverheatCheck != null) {
      json['bOverrideOverheatCheck'] = overrideOverheatCheck;
    }
    if (maxDiskSpaceUsed != null) {
      json['maxDiskSpaceUsed'] = maxDiskSpaceUsed;
    }
    if (keepMinSeconds != null) {
      json['keepMinSeconds'] = keepMinSeconds;
    }
    if (deleteOlderThanKeepMin != null) {
      json['deleteOlderThanKeepMin'] = deleteOlderThanKeepMin;
    }
    if (transportMode != null) {
      json['transportMode'] = transportMode!.id;
    }
    return json;
  }

  factory RecorderConfiguration.fromJson(Map<String, dynamic> json) {
    return RecorderConfiguration(
      logsDir: json['logsDir'],
      deviceModel: json['deviceModel'],
      recordedTypes: json['recordedTypes'] != null
          ? (json['recordedTypes'] as List<dynamic>)
              .map((item) => DataType.values.firstWhere((e) => e.id == item))
              .toList()
          : null,
      minDurationSeconds: json['minDurationSeconds'],
      chunkDurationSeconds: json['chunkDurationSeconds'],
      continuousRecording: json['bContinuousRecording'],
      overrideOverheatCheck: json['bOverrideOverheatCheck'],
      maxDiskSpaceUsed: json['maxDiskSpaceUsed'],
      keepMinSeconds: json['keepMinSeconds'],
      deleteOlderThanKeepMin: json['deleteOlderThanKeepMin'],
      transportMode: json['transportMode'] != null
          ? RecordingTransportMode.values.firstWhere((e) => e.id == json['transportMode'])
          : RecordingTransportMode.unknown,
    );
  }
}

/// Enumerates different states of a recorder.
/// 
/// {@category Sensor Data Source}
enum RecorderStatus{
  /// Recording is stopped.
  stopped,

  /// Recording is stopping.
  stopping,

  /// Recording is starting.
  starting,

  /// Recording is in progress.
  recording,

  /// Recording is restarting.
  restarting,
}

/// @nodoc
/// 
/// {@category Sensor Data Source}
extension RecorderStatusExtension on RecorderStatus {
  int get id {
    switch (this) {
      case RecorderStatus.stopped:
        return 0;
      case RecorderStatus.stopping:
        return 1;
      case RecorderStatus.starting:
        return 2;
      case RecorderStatus.recording:
        return 3;
      case RecorderStatus.restarting:
        return 4;
    }
  }

  static RecorderStatus fromId(int id) {
    switch (id) {
      case 0:
        return RecorderStatus.stopped;
      case 1:
        return RecorderStatus.stopping;
      case 2:
        return RecorderStatus.starting;
      case 3:
        return RecorderStatus.recording;
      case 4:
        return RecorderStatus.restarting;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Recorder class
///
/// This class should not be instantiated directly. Instead, use the [create] method to obtain an instance.
///
/// {@category Sensor Data Source}
class Recorder {
  final int _pointerId;

  int get pointerId => _pointerId;

  // ignore: unused_element
  Recorder._() : _pointerId = -1;

  Recorder.init(int id) : _pointerId = id {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }
  static Recorder create(RecorderConfiguration config) {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "Recorder", 'args': config}));
    final decodedVal = jsonDecode(resultString!);
    return Recorder.init(decodedVal['result']);
  }

  /// Starts the recording.
  ///
  /// When recording is started, the status changes to recording and a notification is issued.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If successfully moved to the initializing status.
  /// * [GemError.general] If could not go to the initializing status.
  GemError startRecording() {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "Recorder", 'method': "startRecording", 'args': {}}));
    return GemErrorExtension.fromCode(jsonDecode(resultString!)['result']);
  }

  /// Stops the recording.
  ///
  /// When recording is stopped, the status changes to stopped and a notification is issued.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If successfully moved to the initializing status.
  /// * [GemError.recordedLogTooShort] If the recorded log duration is shorter than the minLogDuration set in recorder configuration.
  /// * [GemError.general] If could not go to the initializing status
  GemError stopRecording() {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "Recorder", 'method': "stopRecording", 'args': {}}));
    return GemErrorExtension.fromCode(jsonDecode(resultString!)['result']);
  }


  /// Returns the current configuration.
  /// 
  /// **Returns**
  /// 
  /// * The current recorder configuration
  RecorderConfiguration get recorderConfiguration {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "Recorder", 'method': "getConfiguration", 'args': {}}));
    return RecorderConfiguration.fromJson(jsonDecode(resultString!)['result']);
  }

  /// Updates the recorder settings.
  /// 
  /// If it is started, first stops it, updates settings and restarts it.
  /// 
  /// **Parameters**
  /// 
  /// * **IN** *config* The recorder configuration
  set recorderConfiguration(RecorderConfiguration config) {
    GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "Recorder", 'method': "setConfiguration", 'args': config}));
  }

  /// Gets the recorder status.
  RecorderStatus get recorderStatus {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "Recorder", 'method': "getStatus", 'args': {}}));
    return RecorderStatusExtension.fromId(jsonDecode(resultString!)['result']);
  }

  /// Gets the recorder status.
  int get diskSpaceUsedPerSecond {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "Recorder", 'method': "diskSpaceUsedPerSecond", 'args': {}}));
    return jsonDecode(resultString!)['result'];
  }

  /// Save in log metadata a customer buffer.
  /// 
  /// Call this method before stopping the record.
  /// 
  /// **Parameters**
  /// 
  /// * **IN** *key* The key of the user metadata.
  /// * **IN** *userMetata* The buffer to be recorded.
  void addUserMetadata(String key, Uint8List userMetadata) {
    GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "Recorder", 'method': "addUserMetadata", 'args': {
          'key': key,
          'userMetadatadata': base64Encode(userMetadata),
        }}));
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "Recorder", 'id': _pointerId}));
  }
}

/// Recorder bookmarks class
///
/// This class should not be instantiated directly. Instead, use the [create] method to obtain an instance.
///
/// {@category Sensor Data Source}
class RecorderBookmarks {
  final int _pointerId;
  int get pointerId => _pointerId;

  // ignore: unused_element
  RecorderBookmarks._() : _pointerId = -1;

  RecorderBookmarks.init(int id) : _pointerId = id {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  static RecorderBookmarks create(String path) {
    final resultString =
        GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "RecorderBookmarks", 'args': path}));
    final decodedVal = jsonDecode(resultString!);
    return RecorderBookmarks.init(decodedVal['result']);
  }

  /// Export log file in a different format.
  ///
  /// If the name of the exported file is not specified, then the log name will be used.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* The path for the file to be exported.
  /// * **IN** *type* The type of the exported file.
  /// * **IN** *exportedFileName* The exported file name.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If operation succeeds.
  /// * [GemError.general] If operation fails.
  GemError exportLog(String logPath, FileType type, {String? exportedFileName}) {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "RecorderBookmarks",
          'method': "exportLog",
          'args': {'logPath': logPath, 'type': type.id, 'exportedFileName': exportedFileName}
        }));
    return GemErrorExtension.fromCode(jsonDecode(resultString!)['result']);
  }

  /// Import a log file in GM format.
  ///
  ///Supported file formats include: GPX, NMEA, KML. If the name of the exported file is not specified, the log name will be used.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path for the file to be imported.
  /// * **IN** *importedFileName* The imported file name.
  ///
  /// **Returns**
  ///
  /// * [GemError.success] If operation succeeds.
  /// * [GemError.exist] If the importedFileName file already exists in the folder.
  /// * [GemError.notSupported] If the file format is not supported.
  /// * [GemError.general] If the operation fails.
  GemError importLog(String logPath, {String? importedFileName}) {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "RecorderBookmarks",
          'method': "importLog",
          'args': {'logPath': logPath, 'importedFileName': importedFileName}
        }));
    return GemErrorExtension.fromCode(jsonDecode(resultString!)['result']);
  }

  /// Gets a list of all logs (protected and not protected).
  ///
  /// **Returns**
  ///
  /// * The list of logs.
  List<String> get logsList {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "RecorderBookmarks", 'method': "getLogsList", 'args': {}}));
    return (jsonDecode(resultString!)['result']).cast<String>();
  }

  /// Gets the metadata for a file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *logPath* 	The path to the file for which we get the metadata.
  ///
  /// **Returns**
  ///
  /// * The file metadata.
  LogMetadata getLogMetadata(String logPath) {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "RecorderBookmarks", 'method': "getMetadata", 'args': logPath}));
    final decodedVal = jsonDecode(resultString!);
    return LogMetadata(decodedVal['result']);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "RecorderBookmarks", 'id': _pointerId}));
  }
}

/// Enumeration representing different modes of transportation.
///
/// {@category Sensor Data Source}
enum RecordingTransportMode {
  /// Unknown transport mode, used when the mode is not specified or recognized.
  unknown,

  /// Transport mode for cars.
  car,

  /// Transport mode for trucks.
  truck,

  /// Transport mode for bicycles in general.
  bike,

  /// Transport mode for pedestrians, representing walking.
  pedestrian,

  /// Transport mode for road bikes, typically used on paved roads.
  roadBike,

  ///Transport mode for cross bikes, used on mixed terrain.
  crossBike,

  /// Transport mode for city bikes, designed for urban commuting.
  cityBike,

  /// Transport mode for mountain bikes, used on rough, off-road terrain.
  mountainBike,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Sensor Data Source}
extension RecordingTransportModeExtension on RecordingTransportMode {
  int get id {
    switch (this) {
      case RecordingTransportMode.unknown:
        return 0;
      case RecordingTransportMode.car:
        return 1;
      case RecordingTransportMode.truck:
        return 2;
      case RecordingTransportMode.bike:
        return 3;
      case RecordingTransportMode.pedestrian:
        return 4;
      case RecordingTransportMode.roadBike:
        return 5;
      case RecordingTransportMode.crossBike:
        return 6;
      case RecordingTransportMode.cityBike:
        return 7;
      case RecordingTransportMode.mountainBike:
        return 8;
    }
  }

  static RecordingTransportMode fromId(int id) {
    switch (id) {
      case 0:
        return RecordingTransportMode.unknown;
      case 1:
        return RecordingTransportMode.car;
      case 2:
        return RecordingTransportMode.truck;
      case 3:
        return RecordingTransportMode.bike;
      case 4:
        return RecordingTransportMode.pedestrian;
      case 5:
        return RecordingTransportMode.roadBike;
      case 6:
        return RecordingTransportMode.crossBike;
      case 7:
        return RecordingTransportMode.cityBike;
      case 8:
        return RecordingTransportMode.mountainBike;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// LogMetadata class
///
/// This class should not be instantiated directly. Instead, use the [RecorderBookmarks.getLogMetadata] method to obtain an instance.
///
/// {@category Sensor Data Source}
class LogMetadata {
  final int _pointerId;

  // ignore: unused_element
  LogMetadata._() : _pointerId = -1;

  LogMetadata(this._pointerId) {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get the log duration.
  ///
  /// **Returns**
  ///
  /// * Log duration.
  int get durationMillis {
    return _callMethod('getDurationMillis');
  }

  /// Get the last position.
  ///
  /// **Returns**
  ///
  /// * The last sensor recorded position.
  Coordinates get endPosition {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "LogMetadata", 'method': "getEndPosition", 'args': {}}));
    final decodedVal = jsonDecode(resultString!);
    return Coordinates.fromJson(decodedVal['result']);
  }

  /// Get timestamp of the last sensor data.
  ///
  /// **Returns**
  ///
  /// * Timestamp of the last sensor data
  int get endTimestampInMillis {
    return _callMethod('getEndTimestampInMillis');
  }

  /// Get the log size.
  ///
  /// **Returns**
  ///
  /// * The log size
  int get logSize {
    return _callMethod('getLogSize');
  }

  /// Get a detailed route description.
  ///
  /// **Returns**
  ///
  /// * A list of all coordinates of the log.
  List<Coordinates> get preciseRoute {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "LogMetadata", 'method': "getPreciseRoute", 'args': {}}));
    final decodedVal = jsonDecode(resultString!);
    return (decodedVal['result'] as List).map((e) => Coordinates.fromJson(e)).toList();
  }

  /// Get a short route description.
  ///
  /// **Returns**
  ///
  /// * A short list of intermediary coordinates of the log.
  List<Coordinates> get route {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "LogMetadata", 'method': "getRoute", 'args': {}}));
    final decodedVal = jsonDecode(resultString!);
    return (decodedVal['result'] as List).map((e) => Coordinates.fromJson(e)).toList();
  }

  /// The first position.
  ///
  /// **Returns**
  ///
  /// * The first sensor recorded position.
  Coordinates get startPosition {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "LogMetadata", 'method': "getStartPosition", 'args': {}}));
    final decodedVal = jsonDecode(resultString!);
    return Coordinates.fromJson(decodedVal['result']);
  }

  /// The timestamp of the first sensor data.
  ///
  /// **Returns**
  ///
  /// * Timestamp of the first sensor data.
  int get startTimestampInMillis {
    return _callMethod('getStartTimestampInMillis');
  }

  /// The transport mode used when the log was recorded.
  RecordingTransportMode get transportMode {
    int id = _callMethod('getTransportMode');
    return RecordingTransportModeExtension.fromId(id);
  }

  /// Verify if a data type is produced by the log file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* The type to verify if available.
  ///
  /// **Returns**
  ///
  /// * True if data type is available.
  bool isDataTypeAvailable(DataType type) {
    return _callMethod('isDataTypeAvailable', args: {'type': type.id});
  }

  /// Get a list of the available data types.
  List<DataType> get availableDataTypes {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _pointerId, 'class': "LogMetadata", 'method': "getAvailableDataTypes", 'args': {}}));
    final decodedVal = jsonDecode(resultString!)['result'] as List;
    return decodedVal.map((e) => DataTypeExtension.fromId(e)).toList();
  } 

  /// Check if a log file is protected.
  ///
  /// **Returns**
  ///
  /// * True if the file is protected.
  bool get isProtected {
    return _callMethod('isProtected');
  }

  /// Check if a log file was updated.
  ///
  /// **Returns**
  ///
  /// * True if the file is available.
  bool get isUploaded {
    return _callMethod('isUploaded');
  }

  T _callMethod<T>(String method, {Map<String, dynamic>? args}) {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "LogMetadata",
          'method': method,
          'args': args ?? {},
        }));
    return jsonDecode(resultString!)['result'];
  }
}
