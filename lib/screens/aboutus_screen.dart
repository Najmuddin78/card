import 'dart:convert';
import 'dart:io';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String bannerImage = '';
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  List<Map<String, dynamic>> _highlightFields = [
    {'name': 'Products', 'count': '', 'enabled': false},
    {'name': 'Projects', 'count': '', 'enabled': false},
    {'name': 'Awards', 'count': '', 'enabled': false},
    {'name': 'Reviews', 'count': '', 'enabled': false},
    {'name': 'Team', 'count': '', 'enabled': false},
    {'name': 'Clients', 'count': '', 'enabled': false},
    {'name': 'Ratings', 'count': '', 'enabled': false},
  ];

  Future<String?> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyId');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> loadAboutusInfo() async {
    try {
      final String? companyId = await getCompanyId();
      final String? token = await getToken();

      if (companyId == null || token == null) {
        throw Exception(" comapny id or token is null");
      }
      final url = Uri.parse(
          'https://digitalbusinesscard.webwhizinfosys.com/api/about-us/$companyId');
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["companyAboutUs"];
        print('Response Status :${response.statusCode}');
        print('Response Data :${responseData}');
        //print(responseData["companyAboutUs"]["highlights"]);
        setState(() {
          bannerImage = responseData["banner"];
          descriptionController.text = responseData["description"];
          titleController.text = responseData["title"];
          cityController.text = responseData["city"];
          websiteController.text = responseData["website"];
          _highlightFields = responseData["highlights"];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> saveAboutUsInfo() async {
    try {
      final String? token = await getToken();
      final String? companyId = await getCompanyId();

      final url = Uri.parse(
          'https://digitalbusinesscard.webwhizinfosys.com/api/about-us/details/$companyId');
      final response = await http.patch(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({
          "banner": bannerImage,
          "description": descriptionController.text,
          "city": cityController.text,
          "title": titleController.text,
          "website": websiteController.text,
          "highlights": _highlightFields.map((field) {
            return {
              'name': field['name'],
              'count': _controllers[_highlightFields.indexOf(field)].text,
            };
          }).toList(),
        }),
      );

      // print('Response Status :${response.statusCode}');
      // print('Response body :${response.body}');

      if (response.statusCode == 200) {
        loadAboutusInfo();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aboutus information saved successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Failed to save Aboutus information');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

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

  @override
  void initState() {
    super.initState();
    loadAboutusInfo();
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
                        child: GestureDetector(
                          child: bannerImage.isEmpty
                              ? const Text('No image selected.')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    bannerImage,
                                    height: 150.0,
                                    width: 150.0,
                                    fit: BoxFit.cover,
                                  ),
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
                        'Enter Descrption',
                        descriptionController,
                      ),
                      const SizedBox(height: 20.0),
                      buildTextFormField(
                        'Enter City',
                        cityController,
                      ),
                      const SizedBox(height: 20.0),
                      buildTextFormField(
                        'Enter Title',
                        titleController,
                      ),
                      const SizedBox(height: 20.0),
                      buildTextFormField(
                        'Enter Website',
                        websiteController,
                      ),
                      const SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            saveAboutUsInfo();
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
                                      MainAxisAlignment.spaceEvenly,
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
                                              value = false;
                                            }
                                          } else {
                                            if (_selectedCheckboxCount > 3) {
                                              _selectedCheckboxCount--;
                                            }
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
                                            hintText: 'Count',
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
                                                rating > 0 ||
                                                rating > 10) {
                                              return 'Please enter a valid rating ';
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
                                        'Please select at least four checkboxes.'),
                                  ),
                                );
                              } else if (!_controllers.every((controller) {
                                final String text = controller.text.trim();
                                final int? rating =
                                    text.isNotEmpty ? int.tryParse(text) : null;

                                return text.isNotEmpty &&
                                    rating != null &&
                                    rating >= 0 &&
                                    rating <= 10;
                              })) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please provide a ratings.'),
                                  ),
                                );
                              } else {
                                saveAboutUsInfo();
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

  Widget buildTextFormField(String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildTextAreaFormField(
      String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          maxLines: 8,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        bannerImage = image.path;
      });

      await saveAboutUsInfo();
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
