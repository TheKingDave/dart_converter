import 'dart:mirrors';

import 'annotations.dart';
import 'errors.dart';
import 'globalConfig.dart';

abstract class IWithGroup {
  String get group;
}

class Utils {
  static Map<String, T> getMetadataMap<T extends IWithGroup>(
      DeclarationMirror mirror) {
    return Map.fromIterable(
        mirror.metadata.map((e) => e.reflectee).whereType<T>(),
        key: (e) => e.group);
  }
  
  static Convert getConvert(Type type, List<String> groups) {
    final classMirror = reflectClass(type);
    final convertMap = Utils.getMetadataMap<Convert>(classMirror);

    if (convertMap.isEmpty) {
      throw NotConvertObject(type);
    }

    var convert = ConvertGlobalConfig.defaultConvert;
    for (var group in [null, ...groups]) {
      convert = convert?.copyWith(convertMap[group]) ?? convertMap[group];
    }
    return convert;
  }
  
  static ConvertField getConvertField(DeclarationMirror dm, List<String> groups) {
    final convertFieldsMap = Utils.getMetadataMap<ConvertField>(dm);
    
    if (convertFieldsMap.isEmpty) return null;

    var convertField = ConvertGlobalConfig.defaultConvertField;

    for (var group in [null, ...groups]) {
      convertField = convertField?.copyWith(convertFieldsMap[group]) ??
          convertFieldsMap[group];
    }
    return convertField;
  }
  
}
