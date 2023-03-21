
/// A tradesperson (Tradie) who uses the Jemma application.
class Tradie{
  int id;
  String? firstName;
  String? lastName;
  String? profilePictureUrl;
  String? description;
  double? rating; // Average rating of all tradie's booking
  int? australianBusinessNumber;
  int? phoneNumber;
  String? companyName;
  int? preferredTravelDistance;
  String? bankAccountName;
  int? bankAccountNumber;
  int? bankStateBranch;
  String? suburb;
  String? jobType;
  List<String>? certificatesUrl;


  Tradie(this.id,[
    this.firstName,
    this.lastName,
    this.description,
    this.rating,
    this.companyName,
    this.profilePictureUrl,
    this.preferredTravelDistance,
    this.australianBusinessNumber,
    this.phoneNumber,
    this.bankAccountName,
    this.bankAccountNumber,
    this.bankStateBranch,
    this.suburb,
    this.jobType,
    this.certificatesUrl
  ]);

  factory Tradie.fromJson(json){
    if (json is int) {
      return Tradie(json);
    } else{
      return Tradie._fromJson(json);
    }
  }

  Tradie._fromJson(Map<String, dynamic> json) :
        id =json["id"],
        firstName= json["first_name"],
        lastName = json["last_name"],
        profilePictureUrl = json["user_profile_image"],
        description = json["description"],
        rating = json["rating"],
        australianBusinessNumber = json["australian_business_number"],
        phoneNumber = json["phone_number"],
        companyName = json["company_name"],
        preferredTravelDistance = json["preferred_travel_distance"],
        bankAccountName = json["bank_account_name"],
        bankAccountNumber = json["bank_account_number"],
        bankStateBranch = json["bank_state_branch"],
        suburb = json["suburb"],
        jobType = json["job_type"],
        certificatesUrl = json["certificates"];


  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "user_profile_image": profilePictureUrl,
    "description": description,
    "rating": rating,
    "australian_business_number": australianBusinessNumber,
    "company_name": companyName,
    'preferred_travel_distance': preferredTravelDistance,
    'bank_account_name': bankAccountName,
    'bank_account_number': bankAccountNumber,
    'bank_state_branch': bankStateBranch,
    'phone_number': phoneNumber,
    'suburb':suburb,
    'job_type': jobType,
    "certificates":certificatesUrl
  };

  @override
  String toString() {
    return 'Tradie{id: $id, firstName: $firstName, lastName: $lastName, profilePictureUrl: $profilePictureUrl, description: $description, rating: $rating, australianBusinessNumber: $australianBusinessNumber, phoneNumber: $phoneNumber, companyName: $companyName, preferredTravelDistance: $preferredTravelDistance, bankAccountName: $bankAccountName, bankAccountNumber: $bankAccountNumber, bankStateBranch: $bankStateBranch}\n';
  }
}