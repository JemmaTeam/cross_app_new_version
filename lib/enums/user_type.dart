import 'package:hive/hive.dart';
import 'package:recase/recase.dart';
part 'user_type.g.dart';

/// Logged-in user types of Jemma app.
@HiveType(typeId : 2)
enum UserType{
@HiveField(0)
  customer,
@HiveField(1)
  tradie,
@HiveField(2)
  admin
}

UserType parseUserTypeString(String status){
  for (var userType in UserType.values){
    if(userType.toSimpleString().constantCase == status.constantCase){
      return userType;
    }
  }
  return UserType.customer;
}


extension UserTypeUtil on UserType{
 String toSimpleString() => toString().split('.').last.constantCase;
}