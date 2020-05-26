import 'utils.dart';
import 'constants.dart';

const convert = Convert();

class Convert implements IWithGroup {
  final bool ignoreUnknowns;
  final NamingConvention namingConvention;
  final String _group;

  @override
  String get group {
    return notSetNull(_group);
  }

  const Convert({this.ignoreUnknowns, this.namingConvention, group = notSet})
      : _group = group;
  
  Convert copyWith(Convert other) {
    if(other == null) return this;
    return Convert(
      ignoreUnknowns: other.ignoreUnknowns ?? ignoreUnknowns,
      namingConvention: other.namingConvention ?? namingConvention,
    );
  }
}

const convertField = ConvertField();

class ConvertField implements IWithGroup {
  final String _name;
  final bool exclude;
  final String _serializer;
  @override
  final String group;

  const ConvertField(
      {String name = notSet,
      this.exclude,
      String serializer = notSet,
      this.group})
      : _name = name,
        _serializer = serializer;

  ConvertField copyWith(ConvertField other) {
    if (other == null) return this;
    return ConvertField(
      name: notSetOr(other._name, name),
      serializer: notSetOr(other._serializer, serializer),
      exclude: other.exclude ?? exclude,
    );
  }

  String get name {
    return notSetNull(_name);
  }

  String get serializer {
    return notSetNull(_serializer);
  }
}
