import 'package:flutter/material.dart';
import 'package:greenio/Screens/Components/full_width_bottom_button.dart';

import '../../../Navigation/navigation_bar.dart';
import '../../Components/empty_space.dart';

class BodyUserInfo extends StatefulWidget {
  const BodyUserInfo({super.key});

  @override
  State<BodyUserInfo> createState() => _BodyUserInfoState();
}

class _BodyUserInfoState extends State<BodyUserInfo> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _country = '';
  String _city = '';
  String _phoneNumber = '';
  String _address = '';
  String _landmark = '';
  bool _saveAsPrimaryAddress = false;

  void onButtonPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Navigation(
            index: 0,
          );
        },
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        emptySpace(context, heightMultiplier: 0.02),
                        const Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                        emptySpace(context, heightMultiplier: 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Country',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your country',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your country';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _country = value!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            emptySpace(context, widthMultiplier: 0.02),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'City',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your city',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your city';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _city = value!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        emptySpace(context, heightMultiplier: 0.02),
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _phoneNumber = value!;
                          },
                        ),
                        emptySpace(context, heightMultiplier: 0.02),
                        const Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your Address',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _address = value!;
                          },
                        ),
                        emptySpace(context, heightMultiplier: 0.02),
                        const Text(
                          'Lankmark',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter a Landmark',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Landmark';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _landmark = value!;
                          },
                        ),
                        emptySpace(context, heightMultiplier: 0.02),
                        Row(
                          children: [
                            const Text(
                              'Save as primary address',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            const Spacer(),
                            Switch(
                              value: _saveAsPrimaryAddress,
                              onChanged: (value) {
                                setState(() {
                                  _saveAsPrimaryAddress = value;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        fullWidthBottomButton(
          buttonText: 'register',
          onPressed: onButtonPressed,
        )
      ],
    );
  }
}
