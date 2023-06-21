import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/screens/profile/components/profile_screen_components.dart';
import 'package:greenio/src/screens/profile/components/profile_screen_fields.dart';
import 'package:greenio/src/services/firestorage_service.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/constants/cheriyanad_ward_list.dart';
import 'package:greenio/src/utils/image_cropper/image_cropper_helper.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
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
  final ValueNotifier<File?> _imageFileNotifier = ValueNotifier<File?>(null);
  final Map<String, String> wardNumbersMap = cheriyanadWardList;
  ValueNotifier<String?> selectedWardNumberNotifier = ValueNotifier<String?>(null);

  void _editProfile() {
    setState(() {
      isEditingProfile = true;
    });
  }

  void _initializeFields(UserModel user) {
    _fullnameController.text = user.fullName ?? '';
    _emailController.text = user.emailAddress ?? '';
    _phoneNumberController.text = user.phoneNumber ?? '';
    _homeAddressController.text = user.homeAddress ?? '';
    _pinCodeController.text = user.pinCode ?? '';
    _houseNumberController.text = user.houseNumber ?? '';
    _profilePictureUrl = user.picture;
    selectedWardNumberNotifier.value = user.wardNumber;
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
                ProfileScreenComponents.textButton(() => _loadPicture(ImageSource.gallery), 'Choose from Gallery'),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 2)),
                    Text('OR'),
                    Expanded(child: Divider(thickness: 2)),
                  ],
                ),
                ProfileScreenComponents.textButton(() => _loadPicture(ImageSource.camera), 'Take a Picture'),
              ],
            ),
          ),
        );
      },
    );
  }

  _loadPicture(ImageSource imageSource) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage == null) {
      _popOutDialog();
      return;
    }
    File? image = File(pickedImage.path);
    image = await ImageCropperHelper.cropImage(image);
    _imageFileNotifier.value = image;
    _popOutDialog();
  }

  _popOutDialog() {
    Navigator.pop(context);
  }

  Column _profileFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileScreenFields.label('Full name'),
        ProfileScreenFields.fullName(_fullnameController, isEditingProfile),
        const EmptySpace(heightFraction: 0.01),
        ProfileScreenFields.label('Email address'),
        ProfileScreenFields.email(_emailController),
        const EmptySpace(heightFraction: 0.01),
        ProfileScreenFields.label('Phone number'),
        ProfileScreenFields.phoneNumber(_phoneNumberController, isEditingProfile),
        const EmptySpace(heightFraction: 0.01),
        ProfileScreenFields.label('Address'),
        ProfileScreenFields.address(_homeAddressController, isEditingProfile),
        const EmptySpace(heightFraction: 0.01),
        ProfileScreenFields.label('Pincode'),
        ProfileScreenFields.pinCode(_pinCodeController, isEditingProfile),
        const EmptySpace(heightFraction: 0.01),
        ProfileScreenFields.label('Ward number'),
        ProfileScreenFields.wardNumber(isEditingProfile, wardNumbersMap, selectedWardNumberNotifier),
        const EmptySpace(heightFraction: 0.01),
        ProfileScreenFields.label('House number'),
        ProfileScreenFields.houseNumber(_houseNumberController, isEditingProfile),
        const EmptySpace(heightFraction: 0.01),
        if (isEditingProfile == true) CustomElevatedButton(text: 'Submit', onPressed: _updateProfile)
      ],
    );
  }

  void _updateProfile() async {
    await _putImageToFirebaseStorage();
    final UserModel userProfile = user.copyWith(
      fullName: _fullnameController.text.trim(),
      emailAddress: _emailController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      homeAddress: _homeAddressController.text.trim(),
      pinCode: _pinCodeController.text.trim(),
      wardNumber: selectedWardNumberNotifier.value,
      houseNumber: _houseNumberController.text.trim(),
      picture: _profilePictureUrl,
      isProfileComplete: _checkProfileComplete(),
    );
    await _firestoreService.updateUserProfile(userProfile);
    setState(() {
      isEditingProfile = false;
    });
  }

  _putImageToFirebaseStorage() async {
    if (_imageFileNotifier.value == null) return;
    final imageName = 'Profile picture ${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageUrl = await _storageService.uploadFile(imageName, _imageFileNotifier.value!);
    _profilePictureUrl = imageUrl;
  }

  bool _checkProfileComplete() {
    return _fullnameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneNumberController.text.trim().isNotEmpty &&
        _homeAddressController.text.trim().isNotEmpty &&
        _pinCodeController.text.trim().isNotEmpty &&
        selectedWardNumberNotifier.value != null &&
        _houseNumberController.text.trim().isNotEmpty;
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
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: _firestoreService.getUserStreamDocSnapshot(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final userDoc = snapshot.data!.data();
              user = UserModel.fromMap(userDoc!);
              _initializeFields(user);
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _imageFileNotifier,
                      builder: (context, imageFile, child) {
                        return ProfileScreenFields.profilePicture(
                            isEditingProfile ? _pickImage : () {}, imageFile, user.picture);
                      },
                    ),
                    const Divider(),
                    _profileFields(),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
