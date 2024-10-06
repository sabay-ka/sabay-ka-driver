// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:equatable/equatable.dart' as _i1;

abstract base class BaseRecord extends _i1.Equatable {
  BaseRecord({
    required this.id,
    required this.created,
    required this.updated,
    required this.collectionId,
    required this.collectionName,
  });

  final String id;

  final DateTime created;

  final DateTime updated;

  final String collectionId;

  final String collectionName;

  @override
  List<Object?> get props => [
        id,
        created,
        updated,
        collectionId,
        collectionName,
      ];
}
