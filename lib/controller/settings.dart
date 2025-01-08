import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences.dart';

enum ListType { card, flat }

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    String themeKey = "themeMode";

    final prefs = ref.watch(sharedPreferencesProvider);
    final theme = ThemeMode.values.firstWhere(
        (element) => element.toString() == prefs.getString(themeKey),
        orElse: () => ThemeMode.system);
    listenSelf((prev, next) {
      prefs.setString(themeKey, next.toString());
    });
    return theme;
  }

  void updateTheme(ThemeMode themeMode) => state = themeMode;
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ListTypeNotifier extends Notifier<ListType> {
  @override
  ListType build() {
    String key = "listType";

    final prefs = ref.watch(sharedPreferencesProvider);
    final listapp = ListType.values.firstWhere(
        (element) => element.toString() == prefs.getString(key),
        orElse: () => ListType.flat);
    listenSelf((prev, next) {
      prefs.setString(key, next.toString());
    });
    return listapp;
  }

  void updateAppearance(ListType listapp) => state = listapp;
}

final listTypeProvider =
    NotifierProvider<ListTypeNotifier, ListType>(ListTypeNotifier.new);

class DenseListTileNotifier extends Notifier<bool> {
  @override
  bool build() {
    String key = "denseList";

    final prefs = ref.watch(sharedPreferencesProvider);
    final dense = prefs.getBool(key) ?? true;

    listenSelf((prev, next) {
      prefs.setBool(key, next);
    });
    return dense;
  }

  void updateBool(bool value) => state = value;
}

final denseListProvider =
    NotifierProvider<DenseListTileNotifier, bool>(DenseListTileNotifier.new);

class RoundedCheckboxNotifier extends Notifier<bool> {
  @override
  bool build() {
    String key = "roundedCheckbox";

    final prefs = ref.watch(sharedPreferencesProvider);
    final dense = prefs.getBool(key) ?? false;

    listenSelf((prev, next) {
      prefs.setBool(key, next);
    });
    return dense;
  }

  void updateBool(bool value) => state = value;
}

final roundedCheckboxProvider = NotifierProvider<RoundedCheckboxNotifier, bool>(
    RoundedCheckboxNotifier.new);
