import 'package:intl/intl.dart';
import 'package:dart_converter/dart_converter.dart';

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

  final groupList = <List<String>>[
    [],
    ['api'],
    ['api', 'api_c']
  ];

  for (var list in groupList) {
    final map = converter.toMap(test, list);
    print(map);
    print(converter.fromMap<TestJson>(map, list));
  }
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

  @override
  String toString() {
    return 'TestJson{stringField: $stringField, excludedField: $excludedField, '
        'intField: $intField, doubleField: $doubleField, apiField: $apiField}';
  }

  TestJson(
      {this.stringField,
      this.excludedField,
      this.intField,
      this.doubleField,
      this.apiField});
}
