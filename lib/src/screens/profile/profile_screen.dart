import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/screens/profile/components/profile_picture.dart';
import 'package:greenio/src/services/firestorage_service.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/constants/cheriyanad_ward_list.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/custom_textform_field.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  late UserModel user;
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  String? _profilePictureUrl;
  bool isEditingProfile = false;
  final ImagePicker _imagePicker = ImagePicker();
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  final Map<String, String> wardNumbers = cheriyanadWardList;
  ValueNotifier<String?> selectedWardNumber = ValueNotifier<String?>(null);

  _labelText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    );
  }

  _editProfile() {
    setState(() {
      isEditingProfile = true;
    });
  }

  _updateProfile() async {
    await _putImageToFirebaseStorage();
    final UserModel userProfile = user.copyWith(
      fullName: _fullnameController.text.trim(),
      emailAddress: _emailController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      homeAddress: _homeAddressController.text.trim(),
      pinCode: _pinCodeController.text.trim(),
      wardNumber: selectedWardNumber.value,
      houseNumber: _houseNumberController.text.trim(),
      picture: _profilePictureUrl,
      isProfileComplete: _checkProfileComplete(),
    );
    await _firestoreService.updateUserProfile(userProfile);
    setState(() {
      isEditingProfile = false;
    });
  }

  bool _checkProfileComplete() {
    return _fullnameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneNumberController.text.trim().isNotEmpty &&
        _homeAddressController.text.trim().isNotEmpty &&
        _pinCodeController.text.trim().isNotEmpty &&
        selectedWardNumber.value != null &&
        _houseNumberController.text.trim().isNotEmpty;
  }

  _putImageToFirebaseStorage() async {
    if (_imageFile.value == null) return;
    final imageName = 'Profile picture ${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageUrl = await _storageService.uploadFile(imageName, _imageFile.value!);
    _profilePictureUrl = imageUrl;
  }

  _pickImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton(
                  onPressed: () {
                    _loadPicture(ImageSource.gallery);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Choose from Gallery'),
                ),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 2)),
                    Text('OR'),
                    Expanded(child: Divider(thickness: 2)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    _loadPicture(ImageSource.camera);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Take a Picture'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _cropImage(File pickedImage) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      compressQuality: 100,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );
    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  _loadPicture(ImageSource imageSource) async {
    XFile? pickedImage = await _imagePicker.pickImage(source: imageSource);
    if (pickedImage == null) return;
    File? image = File(pickedImage.path);
    image = await _cropImage(image);
    _imageFile.value = image;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: isEditingProfile ? null : [IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit))],
        ),
        body: StreamBuilder(
          stream: _firestoreService.getUserStreamDocSnapshot(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final userDoc = snapshot.data!.data() as Map<String, dynamic>;
            user = UserModel.fromMap(userDoc);
            _fullnameController.text = user.fullName ?? '';
            _emailController.text = user.emailAddress ?? '';
            _phoneNumberController.text = user.phoneNumber ?? '';
            _homeAddressController.text = user.homeAddress ?? '';
            _pinCodeController.text = user.pinCode ?? '';
            _houseNumberController.text = user.houseNumber ?? '';
            _profilePictureUrl = user.picture;
            selectedWardNumber.value = user.wardNumber;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _imageFile,
                      builder: (context, value, child) {
                        return showProfilePicture(
                          onTap: isEditingProfile ? _pickImage : () {},
                          localPictureUrl: value,
                          networkPictureUrl: user.picture,
                        );
                      },
                    ),
                    const Divider(),
                    _profileFields(),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }

  Column _profileFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelText('Full name'),
        CustomTextFormFieldTile(
          controller: _fullnameController,
          prefixIcon: Icons.person,
          isEnabled: isEditingProfile,
        ),
        const EmptySpace(heightFraction: 0.01),
        _labelText('Email address'),
        CustomTextFormFieldTile(
          controller: _emailController,
          isEnabled: isEditingProfile,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const EmptySpace(heightFraction: 0.01),
        _labelText('Phone number'),
        CustomTextFormFieldTile(
          controller: _phoneNumberController,
          isEnabled: isEditingProfile,
          prefixIcon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
        ),
        const EmptySpace(heightFraction: 0.01),
        _labelText('Address'),
        CustomTextFormFieldTile(
          controller: _homeAddressController,
          isEnabled: isEditingProfile,
          prefixIcon: Icons.pin_drop_outlined,
        ),
        const EmptySpace(heightFraction: 0.01),
        _labelText('Pincode'),
        CustomTextFormFieldTile(
          controller: _pinCodeController,
          isEnabled: isEditingProfile,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.pin_drop_outlined,
        ),
        const EmptySpace(heightFraction: 0.01),
        _labelText('Ward number'),
        isEditingProfile
            ? _valueListenableBuilder()
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
                    selectedWardNumber.value !=null ? '${selectedWardNumber.value} - ${wardNumbers[selectedWardNumber.value]}' : '',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
        const EmptySpace(heightFraction: 0.01),
        _labelText('House number'),
        CustomTextFormFieldTile(
          hintText: isEditingProfile ? 'Enter your house number' : '',
          controller: _houseNumberController,
          isEnabled: isEditingProfile,
          keyboardType: TextInputType.number,
          enableDoneAction: true,
          prefixIcon: Icons.house_outlined,
        ),
        const EmptySpace(heightFraction: 0.01),
        if (isEditingProfile == true) CustomElevatedButton(text: 'Submit', onPressed: _updateProfile)
      ],
    );
  }

  _valueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: selectedWardNumber,
      builder: (context, value, child) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.green[200]!),
          ),
          elevation: 2,
          color: Colors.green[100],
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: selectedWardNumber.value,
              items: wardNumbers.entries.map((wardNumber) {
                return DropdownMenuItem<String>(
                  value: wardNumber.key,
                  child: Text(
                    '${wardNumber.key} - ${wardNumber.value}',
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                selectedWardNumber.value = newValue!;
              },
              hint: const Text('Select a Ward Number'),
              isDense: false,
              isExpanded: true,
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.green),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
