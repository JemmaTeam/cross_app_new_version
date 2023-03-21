

/// Job type which can be done by Tradies.
/// Example: Plumber.
/// Also knows whether or not certifications is need or not.
class JobType{
  int id;
  String? name;
  bool? needCertification;
  JobType(this.id,[this.name,this.needCertification]);

  JobType._fromJson(Map<String, dynamic> json) :
        id = json["id"],
        name = json["name"],
        needCertification = json["need_certification"] ;

  @override
  String toString() {
    return 'JobType{id: $id, name: $name, needCertification: $needCertification}';
  }



 factory JobType.fromJson(json) {
    if (json is int) {
      return JobType(json);
    } else{
      return JobType._fromJson(json);
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "need_certification": needCertification.toString(),
  };

}