import 'package:hive/hive.dart';

part 'UserHiveModel.g.dart';

@HiveType(typeId: 1)
class UserHiveModel{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime birthDate;
  UserHiveModel(this.id, this.name, this.birthDate);
}