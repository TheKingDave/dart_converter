import 'package:intl/intl.dart';
import 'package:dart_json_converter/dart_converter.dart';

final moneyFormat = NumberFormat.currency(locale: 'de_AT', symbol: '€');

void main() {
  final converter = Converter();

  converter.addSerializer(
      'money',
      ConvertSerializer<String, double>(
        serializer: (value) => moneyFormat.format(value),
        deserializer: (value) => moneyFormat.parse(value),
      ));

  final test = TestJson(
      stringField: 'Testing',
      excludedField: 'should not be displayed',
      intField: 23,
      doubleField: 22.238,
      apiField: 'only in api');

  print(converter.toMap(test));
  print(converter.toMap(test, ['api']));
  print(converter.toMap(test, ['api', 'api_x']));
}

@convert
class TestJson {
  @ConvertField(name: 'someName')
  String stringField;

  @ConvertField(exclude: true)
  String excludedField;

  @ConvertField()
  int intField;

  @ConvertField(serializer: 'money')
  @ConvertField(group: 'api', serializer: null, name: 'double')
  @ConvertField(group: 'api_x', serializer: 'money')
  double doubleField;

  @ConvertField(exclude: true)
  @ConvertField(group: 'api', exclude: false)
  String apiField;

  TestJson(
      {this.stringField,
      this.excludedField,
      this.intField,
      this.doubleField,
      this.apiField});
}
