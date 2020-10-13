import 'package:hive/hive.dart';

part 'Some.g.dart';

@HiveType(typeId: 12)
class Some extends HiveObject {
  @HiveField(0)
  final String = 'asdasd';
}
