

/// Reusable Address which can be linked to [User]s of Jemma.
class Address{
  int id;
  String? postalCode;
  String? state;
  String? suburb;
  String? addressLineOne;
  String? addressLineTwo;


  Address(this.id,[
    this.addressLineOne,
    this.addressLineTwo,
    this.suburb,
    this.state,
    this.postalCode]);


  Address._fromJson(Map<String, dynamic> json) :
        id =json["id"],
        addressLineOne=json["address_line_one"],
        addressLineTwo=json["address_line_two"],
        suburb=json["suburb"],
        state=json["state"],
        postalCode=json["postal_code"];

  Map<String, dynamic> toJson() => {
    "id": id,
    "address_line_one": addressLineOne,
    "address_line_two": addressLineTwo,
    "suburb": suburb,
    "state": state,
    "postal_code":postalCode
  };

  factory Address.fromJson(json){
    if (json is int) {
      return Address(json);
    } else{
      return Address._fromJson(json);
    }
  }
  @override
  String toString() {
    return 'Address{id: $id, postalCode: $postalCode, state: $state, suburb: $suburb, addressLineOne: $addressLineOne, addressLineTwo: $addressLineTwo}';
  }

  String toSimpleString(){
    return "$addressLineOne  $addressLineTwo  $suburb  $state  $postalCode";
  }

  String toStyledString(){
    return "$addressLineOne\n$addressLineTwo\n$suburb\n$state\n$postalCode";
  }
}