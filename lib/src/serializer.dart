abstract class IConvertSerializer<JSON, T> {
  JSON serialize(T value);

  T deserialize(JSON value);
}

class ConvertSerializer<JSON, T> implements IConvertSerializer<JSON, T> {
  final JSON Function(T) serializer;
  final T Function(JSON) deserializer;

  ConvertSerializer({this.serializer, this.deserializer});

  @override
  JSON serialize(T value) {
    return serializer(value);
  }

  @override
  T deserialize(JSON value) {
    return deserializer(value);
  }
}
