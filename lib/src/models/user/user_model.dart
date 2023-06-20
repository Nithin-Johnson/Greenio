enum AdminType { ngo, govt }

class UserModel {
  String? picture;
  String? fullName;
  String? emailAddress;
  String? phoneNumber;
  String? homeAddress;
  String? pinCode;
  String? wardNumber;
  String? houseNumber;
  bool isProfileComplete;
  AdminType? adminType;

  UserModel({
    this.picture,
    this.fullName,
    this.emailAddress,
    this.phoneNumber,
    this.homeAddress,
    this.pinCode,
    this.wardNumber,
    this.houseNumber,
    this.isProfileComplete = false,
    this.adminType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'picture': picture,
      'fullName': fullName,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'homeAddress': homeAddress,
      'pinCode': pinCode,
      'wardNumber': wardNumber,
      'houseNumber': houseNumber,
      'isProfileComplete': isProfileComplete,
      'adminType': adminType?.toString(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      picture: map['picture'] != null ? map['picture'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      emailAddress: map['emailAddress'] != null ? map['emailAddress'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      homeAddress: map['homeAddress'] != null ? map['homeAddress'] as String : null,
      pinCode: map['pinCode'] != null ? map['pinCode'] as String : null,
      wardNumber: map['wardNumber'] != null ? map['wardNumber'] as String : null,
      houseNumber: map['houseNumber'] != null ? map['houseNumber'] as String : null,
      isProfileComplete: map['isProfileComplete'] as bool,
      adminType: map['adminType'] != null ? _parseAdminType(map['adminType'] as String) : null,
    );
  }

  static AdminType? _parseAdminType(String? value) {
    if (value == 'AdminType.ngo') {
      return AdminType.ngo;
    } else if (value == 'AdminType.govt') {
      return AdminType.govt;
    }
    return null;
  }

  UserModel copyWith({
    String? picture,
    String? fullName,
    String? emailAddress,
    String? phoneNumber,
    String? homeAddress,
    String? pinCode,
    String? wardNumber,
    String? houseNumber,
    bool? isProfileComplete,
    AdminType? adminType,
  }) {
    return UserModel(
      picture: picture ?? this.picture,
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      pinCode: pinCode ?? this.pinCode,
      wardNumber: wardNumber ?? this.wardNumber,
      houseNumber: houseNumber ?? this.houseNumber,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      adminType: adminType ?? this.adminType,
    );
  }
}
