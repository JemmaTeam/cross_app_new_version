
/// Users who book orders, a.k.a bookings.
class Customer{

  int id;
  String? firstName;
  String? lastName;
  String? description;
  String? profilePictureUrl;
  double? rating; // Average rating of all customer's order given by the tradie.
  int? phoneNumber;
  String? bankCardHolder;
  int? bankCardNumber;
  String? bankCardExpiry;
  int? bankCardCvv;


  Customer(this.id,[
    this.firstName,
    this.lastName,
    this.description,
    this.profilePictureUrl,
    this.rating,
    this.phoneNumber,
    this.bankCardHolder,
    this.bankCardNumber,
    this.bankCardExpiry,
    this.bankCardCvv,
  ]);


  Customer._fromJson(Map<String, dynamic> json) :
        id =json["id"],
        firstName= json["first_name"],
        lastName = json["last_name"],
        description = json["description"],
        profilePictureUrl = json["user_profile_image"],
        rating = json["rating"],
        phoneNumber = json["phone_number"],
        bankCardHolder = json["bank_card_holder"],
        bankCardNumber= json["bank_card_number"],
        bankCardExpiry = json["bank_card_expiry"],
        bankCardCvv = json["bank_card_cvv"];

  factory Customer.fromJson(json){
    if (json is int) {
      return Customer(json);
    } else{
      return Customer._fromJson(json);
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "description": description,
    "user_profile_image": profilePictureUrl,
    "rating": rating,
    "phone_number": phoneNumber,
    'bank_card_holder': bankCardHolder,
    'bank_card_number': bankCardNumber,
    'bank_card_expiry': bankCardExpiry,
    'bank_card_cvv': bankCardCvv,
  };

  @override
  String toString() {
    return 'Customer{id: $id, firstName: $firstName, lastName: $lastName, description: $description, profilePictureUrl: $profilePictureUrl, rating: $rating, phoneNumber: $phoneNumber, bankCardHolder: $bankCardHolder, bankCardNumber: $bankCardNumber, bankCardExpiry: $bankCardExpiry, bankCardCvv: $bankCardCvv}\n';
  }
}