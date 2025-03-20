// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      darkTheme: json['darkTheme'] as bool? ?? true,
      themeName: json['themeName'] as String? ?? "barossa",
      monoColor: json['monoColor'] as bool? ?? false,
      generateAiTip: json['generateAiTip'] as bool? ?? true,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'darkTheme': instance.darkTheme,
      'themeName': instance.themeName,
      'monoColor': instance.monoColor,
      'generateAiTip': instance.generateAiTip,
    };
