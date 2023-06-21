import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/item/item_model.dart';
import 'package:greenio/src/screens/confirmation/confirmation_screen.dart';
import 'package:greenio/src/screens/item_upload/components/itemupload_screen_components.dart';
import 'package:greenio/src/screens/item_upload/components/upload_item.dart';
import 'package:greenio/src/services/firestorage_service.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ItemUploadScreen extends StatefulWidget {
  const ItemUploadScreen({Key? key, required this.itemCategory}) : super(key: key);
  final String itemCategory;

  @override
  State<ItemUploadScreen> createState() => _ItemUploadScreenState();
}

class _ItemUploadScreenState extends State<ItemUploadScreen> {
  final FirebaseStorageService _storageService = FirebaseStorageService();

  final TextEditingController _itemDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyForDate = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);
  ValueNotifier<DateTime?> selectedDatesNotifier = ValueNotifier<DateTime?>(null);

  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 5),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 5),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[400]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final pickedDateFormatted = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      selectedDatesNotifier.value = pickedDateFormatted;
    }
  }

  _showDatePicker() {
    return ValueListenableBuilder(
      valueListenable: selectedDatesNotifier,
      builder: (context, value, child) {
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green[300]!)),
          elevation: 2,
          color: Colors.green[100],
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: TextFormField(
              readOnly: true,
              controller: TextEditingController(
                  text: value != null ? DateFormat('MMMM d yyyy (dd / MM / y)').format(value) : ''),
              decoration:
                  const InputDecoration(border: InputBorder.none, hintText: 'Select a pickup date for the item'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
              onTap: () => _selectDate(context),
            ),
          ),
        );
      },
    );
  }

  _uploadItemPhoto() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        splashColor: Colors.green,
        onTap: _pickImage,
        child: Ink(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.green[300]!)),
          child: ValueListenableBuilder(
            valueListenable: _imageFile,
            builder: (context, value, child) {
              return value != null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green[400]!, width: 5.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(value),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 40),
                        Text(
                          'Upload\nImage',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        )
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  _pickImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Image'),
          content: SingleChildScrollView(
            child: ListBody(children: [
              TextButton(
                onPressed: () => _loadPicture(ImageSource.gallery),
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
                onPressed: () => _loadPicture(ImageSource.camera),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Take a Picture'),
              ),
            ]),
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
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          cropFrameColor: Theme.of(context).primaryColor,
          cropGridColor: Theme.of(context).primaryColor.withOpacity(0.5),
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        )
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
    _popOutDialog();
  }

  _popOutDialog() {
    Navigator.pop(context);
  }

  void _uploadItemToFireStorage() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_formKeyForDate.currentState!.validate()) return;
    if (_imageFile.value == null) {
      onUploadFailure('Please upload an image first!');
      return;
    }
    _showLoading();
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imageUrl = await _storageService.uploadFile(imageName, _imageFile.value!);
    _uploadItemToDatabase(imageUrl);
  }

  void _uploadItemToDatabase(String imageUrl) async {
    DonationItemModel donatedItem = DonationItemModel(
      category: widget.itemCategory,
      description: _itemDescriptionController.text.trim(),
      imageUrl: imageUrl,
      pickupDate: selectedDatesNotifier.value!,
      postedTime: DateTime.now(),
    );

    UploadDonationItem.uploadDonationItemToDatabase(
      donatedItem: donatedItem,
      onSuccess: onUploadSuccess,
      onFailure: onUploadFailure,
    );
  }

  void _showLoading() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void onUploadSuccess() {
    Navigator.of(context).pop();
    NavigationUtils.replaceWith(context, const ConfirmationScreen());
  }

  void onUploadFailure(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EmptySpace(heightFraction: 0.01),
              _uploadItemPhoto(),
              const EmptySpace(heightFraction: 0.01),
              const Divider(
                thickness: 2,
              ),
              ItemUploadScreenComponents.itemLabelText('Item Category'),
              ItemUploadScreenComponents.itemCategory(itemCategory: widget.itemCategory),
              const EmptySpace(heightFraction: 0.01),
              ItemUploadScreenComponents.itemLabelText('Item Description'),
              Form(
                key: _formKey,
                child:
                    ItemUploadScreenComponents.itemDescription(itemDescriptionController: _itemDescriptionController),
              ),
              const EmptySpace(heightFraction: 0.01),
              ItemUploadScreenComponents.itemLabelText('Select Pickup Date'),
              Form(key: _formKeyForDate, child: _showDatePicker()),
              const Divider(
                thickness: 2,
              ),
              const EmptySpace(heightFraction: 0.03),
              CustomElevatedButton(text: 'Submiit', onPressed: () => _uploadItemToFireStorage()),
            ],
          ),
        ),
      ),
    );
  }
}
