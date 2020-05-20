const notSet = '______this_is_not_set______';

String notSetNull(String val) {
  return val == notSet ? null : val;
}

String notSetOr(String val, String or) {
  return val == notSet ? or : val;
}

enum NamingConvention {
  noChange,
  camelCase,
  snake_case,
  kebabCase,
  PascalCase,
  UPPER_SNAKE_CASE,
}