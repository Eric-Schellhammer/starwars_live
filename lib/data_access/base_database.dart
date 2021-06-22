import 'package:moor/moor.dart';

abstract class IntKey {
  final int intKey;

  IntKey(this.intKey);

  @override
  bool operator ==(Object other) => identical(this, other) || other is IntKey && runtimeType == other.runtimeType && intKey == other.intKey;

  @override
  int get hashCode => intKey.hashCode;
}

abstract class IntKeyConverter<T extends IntKey> extends TypeConverter<T, int> {
  @override
  T? mapToDart(int? fromDb) {
    return fromDb != null ? createKey(fromDb) : null;
  }

  @override
  int? mapToSql(T? key) {
    return key?.intKey;
  }

  T createKey(int fromDb);
}