class NotConvertObject implements Exception {
  final dynamic object;
  
  NotConvertObject(this.object);
  
  @override
  String toString() {
    return '${object.runtimeType} is not a `Convert` object';
  }
  
}