import 'package:dart_json_converter/src/constants.dart';

import 'annotations.dart';

class ConvertGlobalConfig {
  static const Map<String, Convert> configs = {
    null: Convert(
        ignoreUnknowns: true, namingConvention: NamingConvention.noChange)
  };
  
  static ConvertField initConvertField = ConvertField(exclude: false);

  static void addConfig(Convert convert, [String group]) {
    configs[group] = convert;
  }

  static Convert getConfig([String group]) {
    return configs[group];
  }
}
