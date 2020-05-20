import 'dart:mirrors';

abstract class IWithGroup {
  String get group;
}

class Utils {
  static Map<String, T> getFromMetadata<T extends IWithGroup>(
      DeclarationMirror mirror) {
    return Map.fromIterable(
        mirror.metadata.map((e) => e.reflectee).whereType<T>(),
        key: (e) => e.group);
  }
}
