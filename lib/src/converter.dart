import 'dart:mirrors';

import 'globalConfig.dart';
import 'serializer.dart';
import 'annotations.dart';
import 'utils.dart';

class Converter {
  final Map<String, IConvertSerializer> serializers = {};

  bool hasSerializer(String name) {
    return serializers.containsKey(name);
  }

  void addSerializer(String name, IConvertSerializer serializer) {
    if (hasSerializer(name)) {
      throw ArgumentError('Serializer `$name` is already defined');
    }
    serializers[name] = serializer;
  }

  ConvertSerializer getSerializer(String name) {
    if (!hasSerializer(name)) {
      throw ArgumentError('Serializer `$name` is not defined');
    }
    return serializers[name];
  }

  Map<String, dynamic> toMap(dynamic object, [List<String> groups = const []]) {
    final convert = Utils.getConvert(object.runtimeType, groups);

    final ret = <String, dynamic>{};

    final decl = reflectClass(object.runtimeType).declarations;
    decl.forEach((k, v) {
      final convertField = Utils.getConvertField(v, groups);

      if (convertField == null || convertField.exclude) return;

      final name = convertField.name ?? MirrorSystem.getName(k);

      var value = reflect(object).getField(k).reflectee;

      if (convertField.serializer != null) {
        value = getSerializer(convertField.serializer).serialize(value);
      }

      ret[name] = value;
    });

    return ret;
  }

  T fromMap<T>(Map<String, dynamic> json, [List<String> groups = const []]) {
    final convert = Utils.getConvert(T, groups);

    final rc = reflectClass(T);
    
    final arguments = <Symbol, dynamic>{};
    
    final decl = rc.declarations;
    decl.forEach((k, v) {
      final convertFieldsMap = Utils.getMetadataMap<ConvertField>(v);
      if (convertFieldsMap.isEmpty) return;

      var convertField = ConvertGlobalConfig.defaultConvertField;

      for (var group in [null, ...groups]) {
        convertField = convertField?.copyWith(convertFieldsMap[group]) ??
            convertFieldsMap[group];
      }

      if (convertField == null) return;
      if (convertField.exclude) return;

      final name = convertField.name ?? MirrorSystem.getName(k);

      var value = json[name];
      
      if (convertField.serializer != null) {
        value = getSerializer(convertField.serializer).deserialize(value);
      }
      
      arguments[k] = value;
    });

    return rc.newInstance(Symbol(''), [], arguments).reflectee;
  }
}
