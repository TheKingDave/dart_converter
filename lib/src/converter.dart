import 'dart:mirrors';

import 'package:dart_json_converter/src/errors.dart';
import 'package:dart_json_converter/src/globalConfig.dart';
import 'package:dart_json_converter/src/serializer.dart';

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
    final objectMirror = reflectClass(object.runtimeType);

    final convertMap = Utils.getFromMetadata<Convert>(objectMirror);

    if (convertMap.isEmpty) {
      throw NotConvertObject(object);
    }

    final convert = convertMap[null];
    final ret = <String, dynamic>{};

    final decl = objectMirror.declarations;
    decl.forEach((k, v) {
      final convertFieldsMap = Utils.getFromMetadata<ConvertField>(v);
      if (convertFieldsMap.isEmpty) return;

      var convertField = ConvertGlobalConfig.initConvertField;

      for (var group in [null, ...groups]) {
        convertField = convertField?.copyWith(convertFieldsMap[group]) ??
            convertFieldsMap[group];
      }

      if (convertField == null) return;
      if (convertField.exclude) return;

      final name = convertField.name ?? MirrorSystem.getName(k);

      var value = reflect(object).getField(k).reflectee;

      if (convertField.serializer != null) {
        value = getSerializer(convertField.serializer).serialize(value);
      }

      ret[name] = value;
    });

    return ret;
  }

  Map<String, dynamic> fromMap(dynamic object, [List<String> groups = const []]) {
    final objectMirror = reflectClass(object.runtimeType);

    final convertMap = Utils.getFromMetadata<Convert>(objectMirror);

    if (convertMap.isEmpty) {
      throw NotConvertObject(object);
    }

    final convert = convertMap[null];
    final ret = <String, dynamic>{};

    final decl = objectMirror.declarations;
    decl.forEach((k, v) {
      final convertFieldsMap = Utils.getFromMetadata<ConvertField>(v);
      if (convertFieldsMap.isEmpty) return;

      var convertField = ConvertGlobalConfig.initConvertField;

      for (var group in [null, ...groups]) {
        convertField = convertField?.copyWith(convertFieldsMap[group]) ??
            convertFieldsMap[group];
      }

      if (convertField == null) return;
      if (convertField.exclude) return;

      final name = convertField.name ?? MirrorSystem.getName(k);

      var value = reflect(object).getField(k).reflectee;

      if (convertField.serializer != null) {
        value = getSerializer(convertField.serializer).serialize(value);
      }

      ret[name] = value;
    });

    return ret;
  }
}
