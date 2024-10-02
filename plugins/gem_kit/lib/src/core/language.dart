// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// Script variants
///
/// {@category Core}
enum ScriptVariant {
  /// Native
  native,

  /// Transcription
  transcription,

  /// Transliteration
  transliteration,
}

/// @nodoc
///
/// {@category Core}
extension ScriptVariantExtension on ScriptVariant {
  int get id {
    switch (this) {
      case ScriptVariant.native:
        return 0;
      case ScriptVariant.transcription:
        return 256;
      case ScriptVariant.transliteration:
        return 512;
    }
  }

  static ScriptVariant fromId(int id) {
    switch (id) {
      case 0:
        return ScriptVariant.native;
      case 256:
        return ScriptVariant.transcription;
      case 512:
        return ScriptVariant.transliteration;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Complete language specification.
///
/// {@category Core}
class Language {
  /// Language name.
  String? name;

  /// ISO 639-3 three letter language code.
  String? languagecode;

  /// ISO 3166-1 three letter region code.
  String? regioncode;

  /// ISO 15924 four letter script code.
  String? scriptcode;

  /// Script variant.
  ScriptVariant? scriptvariant;
  Language({
    this.name,
    this.languagecode,
    this.regioncode,
    this.scriptcode,
    this.scriptvariant,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (name != null) {
      json['name'] = name;
    }
    if (languagecode != null) {
      json['languagecode'] = languagecode;
    }
    if (regioncode != null) {
      json['regioncode'] = regioncode;
    }
    if (scriptcode != null) {
      json['scriptcode'] = scriptcode;
    }
    if (scriptvariant != null) {
      json['scriptvariant'] = scriptvariant!.id;
    }
    return json;
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'],
      languagecode: json['languagecode'],
      regioncode: json['regioncode'],
      scriptcode: json['scriptcode'],
      scriptvariant: ScriptVariantExtension.fromId(json['scriptvariant']),
    );
  }

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.languagecode == languagecode &&
        other.regioncode == regioncode &&
        other.scriptcode == scriptcode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        languagecode.hashCode ^
        regioncode.hashCode ^
        scriptcode.hashCode;
  }
}
