// ignore_for_file: unused_field

import 'dart:io';
import 'package:business_card/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String _bannerImage = '';
  String _description = '';
  String _city = '';
  String _title = '';
  String _website = '';

  final List<Map<String, dynamic>> _highlightFields = [
    {'name': 'Products', 'count': 0, 'enabled': false},
    {'name': 'Projects', 'count': 0, 'enabled': false},
    {'name': 'Awards', 'count': 0, 'enabled': false},
    {'name': 'Reviews', 'count': 0, 'enabled': false},
    {'name': 'Team', 'count': 0, 'enabled': false},
    {'name': 'Clients', 'count': 0, 'enabled': false},
    {'name': 'Ratings', 'count': 0, 'enabled': false},
  ];

  List<TextEditingController> _controllers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Testimonial> testimonials = [
    Testimonial(
      name: 'Najmuddin',
      review: '',
      profilePic: 'assets/logo.jpg',
      status: 'ACTIVE',
    ),
    Testimonial(
      name: 'Taher',
      review: '',
      profilePic: 'assets/logo.jpg',
      status: 'ACTIVE',
    ),
    Testimonial(
      name: 'Adnan',
      review: '',
      profilePic: 'assets/logo.jpg',
      status: 'INACTIVE',
    ),
  ];

  int _selectedCheckboxCount = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _highlightFields.length,
      (index) => TextEditingController(
        text: _highlightFields[index]['count'].toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: ColorPalette.appBarBackground,
        foregroundColor: ColorPalette.appBarText,
        leading: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: _bannerImage.isEmpty
                      ? const Text('No image selected.')
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(_bannerImage),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    backgroundColor: ColorPalette.buttonBackground,
                    foregroundColor: ColorPalette.buttonText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Select Image from Gallery',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                buildTextFormField(
                    'Description', (value) => _description = value ?? ''),
                const SizedBox(height: 16.0),
                buildTextFormField('City', (value) => _city = value ?? ''),
                const SizedBox(height: 16.0),
                buildTextFormField('Title', (value) => _title = value ?? ''),
                const SizedBox(height: 16.0),
                buildTextFormField(
                    'Website', (value) => _website = value ?? ''),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data Inserted Suceesfully'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      backgroundColor: ColorPalette.buttonBackground,
                      foregroundColor: ColorPalette.buttonText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Highlight Edit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _highlightFields
                            .map((field) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Checkbox(
                                    value: field['enabled'],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          if (_selectedCheckboxCount < 4) {
                                            _selectedCheckboxCount++;
                                            field['enabled'] = true;
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'You can only select up to 4 checkboxes'),
                                              ),
                                            );
                                          }
                                        } else {
                                          _selectedCheckboxCount--;
                                          field['enabled'] = false;
                                        }
                                      });
                                    },
                                  ),
                                  Text(field['name']),
                                  if (field['enabled'] == true)
                                    const SizedBox(width: 20),
                                  if (field['enabled'] == true)
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: _controllers[
                                            _highlightFields.indexOf(field)],
                                        decoration: InputDecoration(
                                          //hintText:
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a rating';
                                          }
                                          final int? rating =
                                              int.tryParse(value);
                                          if (rating == null ||
                                              rating < 0 ||
                                              rating > 5) {
                                            return 'Please enter a valid rating between 0 and 5';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                ],
                              );
                            })
                            .expand(
                                (widget) => [widget, const SizedBox(width: 8)])
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(
                  color: Colors.black,
                ),
                const Text(
                  'Testimonials',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: testimonials.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        toggleTestimonialStatus(index);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage(testimonials[index].profilePic),
                          ),
                          title: Text(testimonials[index].name),
                          subtitle: Text(testimonials[index].review),
                          trailing: Text(testimonials[index].status),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      String label, void Function(String?) onSaved) {
    return TextFormField(
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter $label.';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _bannerImage = image.path;
      });
    }
  }

  void toggleTestimonialStatus(int index) {
    setState(() {
      testimonials[index].status =
          testimonials[index].status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
    });
  }
}

class Testimonial {
  String name;
  String review;
  String profilePic;
  String status;

  Testimonial({
    required this.name,
    required this.review,
    required this.profilePic,
    required this.status,
  });
}
