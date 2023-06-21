import 'package:flutter/material.dart';
import 'package:greenio/src/utils/widgets/custom_dropdown_menu.dart';
import 'package:greenio/src/utils/widgets/custom_textform_field.dart';

class ProfileScreenFields {
  static label(String text) {
    return Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left);
  }

  static profilePicture(onTap, localPictureUrl, networkPictureUrl) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.green,
        backgroundImage: localPictureUrl != null
            ? FileImage(localPictureUrl)
            : (networkPictureUrl != null ? NetworkImage(networkPictureUrl) as ImageProvider : null),
        child: ((localPictureUrl == null) && (networkPictureUrl == null)) ? const Icon(Icons.person, size: 50) : null,
      ),
    );
  }

  static fullName(fullnameController, isEditingProfile) {
    return CustomTextFormFieldTile(
      controller: fullnameController,
      prefixIcon: Icons.person,
      isEnabled: isEditingProfile,
    );
  }

  static email(emailController) {
    return CustomTextFormFieldTile(
      controller: emailController,
      isEnabled: false,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
    );
  }

  static phoneNumber(phoneNumberController, isEditingProfile) {
    return CustomTextFormFieldTile(
      controller: phoneNumberController,
      isEnabled: isEditingProfile,
      prefixIcon: Icons.phone_android_outlined,
      keyboardType: TextInputType.phone,
    );
  }

  static address(homeAddressController, isEditingProfile) {
    return CustomTextFormFieldTile(
      controller: homeAddressController,
      isEnabled: isEditingProfile,
      prefixIcon: Icons.pin_drop_outlined,
    );
  }

  static pinCode(pinCodeController, isEditingProfile) {
    return CustomTextFormFieldTile(
      controller: pinCodeController,
      isEnabled: isEditingProfile,
      keyboardType: TextInputType.number,
      prefixIcon: Icons.pin_drop_outlined,
    );
  }

  static wardNumber(isEditingProfile, wardNumbers, selectedWardNumber) {
    return isEditingProfile
        ? CustomDropDownMenu(valueNotifier: selectedWardNumber, items: wardNumbers)
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.green[200]!),
            ),
            elevation: 2,
            color: Colors.green[100],
            child: ListTile(
              leading: const Icon(Icons.location_city_outlined),
              title: Text(
                selectedWardNumber.value != null
                    ? '${selectedWardNumber.value} - ${wardNumbers[selectedWardNumber.value]}'
                    : '',
                style: const TextStyle(fontSize: 17),
              ),
            ),
          );
  }

  static houseNumber(houseNumberController, isEditingProfile) {
    return CustomTextFormFieldTile(
      controller: houseNumberController,
      isEnabled: isEditingProfile,
      keyboardType: TextInputType.number,
      enableDoneAction: true,
      prefixIcon: Icons.house_outlined,
    );
  }
}
