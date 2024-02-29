import 'dart:io';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
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

  int _selectedCheckboxCount = 0;

  List<Testimonial> testimonials = [
    Testimonial(
      name: 'Najmuddin',
      review: '',
      status: 'ACTIVE',
    ),
    Testimonial(
      name: 'Taher',
      review: '',
      status: 'ACTIVE',
    ),
    Testimonial(
      name: 'Adnan',
      review: '',
      status: 'INACTIVE',
    ),
    
  ];

  final _formKey = GlobalKey<FormState>();

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
        leading: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'About Us Page Edits',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20.0),
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
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Select Image from Gallery',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      buildTextAreaFormField(
                        'Description',
                        (value) => _description = value ?? '',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Description.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      buildTextFormField(
                        'City',
                        (value) => _city = value ?? '',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter City.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      buildTextFormField(
                        'Title',
                        (value) => _title = value ?? '',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Title.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      buildTextFormField(
                        'Website',
                        (value) => _website = value ?? '',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Website.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_bannerImage.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select an image.'),
                                ),
                              );
                            } else {
                              if (_formKey.currentState!.validate()) {
                                // All fields are valid, proceed with save
                                // Handle saving form data
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightColorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Highlights Edits',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      children: [
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
                                            labelText: 'Count',
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
                                            if (value == null ||
                                                value.isEmpty) {
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
                              .expand((widget) =>
                                  [widget, const SizedBox(width: 8)])
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_highlightFields
                                  .any((field) => field['enabled'])) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please select at least one checkbox.'),
                                  ),
                                );
                              } else if (!_controllers.every((controller) =>
                                  controller.text.isNotEmpty &&
                                  int.tryParse(controller.text) != null &&
                                  int.parse(controller.text) >= 0 &&
                                  int.parse(controller.text) <= 5)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please provide a valid rating for all fields.'),
                                  ),
                                );
                              } else {
                                // Handle form submission
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Changes saved successfully.'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Testimonials',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: Column(
                        children: testimonials
                            .map(
                              (testimonial) => GestureDetector(
                                onTap: () {
                                  toggleTestimonialStatus(testimonial);
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(8),
                                  elevation: 4,
                                  child: ListTile(
                                    title: Text(testimonial.name),
                                    subtitle: Text(testimonial.review),
                                    trailing: Text(testimonial.status),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      String label,
      void Function(String?) onSaved,
      String? Function(String?)? validator,
      ) {
    return TextFormField(
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Enter $label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 20,
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  TextFormField buildTextAreaFormField(
      String label,
      void Function(String?) onSaved,
      String? Function(String?)? validator,
      ) {
    return TextFormField(
      style: const TextStyle(fontSize: 16),
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Enter $label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _bannerImage = image.path;
      });
    }
  }

  void toggleTestimonialStatus(Testimonial testimonial) {
    setState(() {
      testimonial.status =
      testimonial.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
    });
  }
}

class Testimonial {
  String name;
  String review;
  String status;

  Testimonial({
    required this.name,
    required this.review,
    required this.status,
  });
}
