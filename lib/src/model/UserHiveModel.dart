import 'package:hive/hive.dart';

part 'UserHiveModel.g.dart';

@HiveType(typeId: 1)
class UserHiveModel{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;

}