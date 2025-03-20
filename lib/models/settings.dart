import 'package:freezed_annotation/freezed_annotation.dart';

part "settings.g.dart";

@JsonSerializable(explicitToJson: true)
class AppSettings {
  bool darkTheme;
  String themeName;
  bool monoColor;
  bool generateAiTip;

  AppSettings({
    this.darkTheme = true,
    this.themeName = "barossa",
    this.monoColor = false,
    this.generateAiTip = true,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
