import 'constants.dart';
import 'annotations.dart';

class ConvertGlobalConfig {
  static Convert defaultConvert = Convert(
      ignoreUnknowns: true, namingConvention: NamingConvention.noChange);
  static ConvertField defaultConvertField = ConvertField(exclude: false);
}
