import 'dart:async';
import 'dart:io';

import 'package:card/screens/welcome_screen.dart';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _socialMediaFormKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();

  String _companyCategory = '';
  Color _selectedColor = lightColorScheme.primary;
  XFile? _image;

  List<String> companyCategories = [
    'Agriculture & Forestry',
    'Arts & Entertainment',
    'Automotive',
    'Beauty & Personal Care',
    'Construction & Real Estate',
    'Education',
    'Finance & Insurance',
    'Food & Beverage',
    'Health & Wellness',
    'Hospitality & Tourism',
    'Information Technology',
    'Manufacturing',
    'Marketing & Advertising',
    'Media & Communications',
    'Professional Services',
    'Retail & E-commerce',
    'Sports & Recreation',
    'Transportation & Logistics',
    'Utilities',
    'Other',
  ];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _buildForm(),
            ),
            const SizedBox(height: 20),
            _buildSocialMediaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 10.0),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Home Page Edits',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              'Enter Company Name',
              companyNameController,
            ),
            const SizedBox(height: 10),
            _buildCategoryDropdown(),
            const SizedBox(height: 20),
            _buildImagePicker(),
            const SizedBox(height: 20),
            _buildColorPicker(),
            const SizedBox(height: 20),
            _buildButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please choose a company logo.'),
                      ),
                    );
                    return;
                  }
                  if (_selectedColor == Colors.blue) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a color for your theme.'),
                      ),
                    );
                    return;
                  }
                  _saveChangesFormData(context);
                }
              },
              text: 'Save Changes',
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Form(
        key: _socialMediaFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Social Media Section',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),
            _buildTextFormField(
              'Enter WhatsApp Link',
              whatsappController,
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              'Enter YouTube Link',
              youtubeController,
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              'Enter Twitter Link',
              twitterController,
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              'Enter Instagram Link',
              instagramController,
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              'Enter Facebook Link',
              facebookController,
            ),
            const SizedBox(height: 16.0),
            _buildButton(
              onPressed: () {
                if (_socialMediaFormKey.currentState!.validate()) {
                  _validateAndSaveSocialMediaData(context);
                }
              },
              text: 'Save Social Media',
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      String hintText, TextEditingController controller) {
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

  Widget _buildButton({required VoidCallback onPressed, required String text}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            final pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                _image = XFile(pickedFile.path);
              });
            }
          },
          icon: const Icon(Icons.image),
          label: const Text('Choose Company Logo'),
        ),
        if (_image != null) _buildSelectedImage(),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          onTap: _showCompanyLogoImage,
          child: Image.file(
            File(_image!.path),
            height: 250.0,
            width: 250.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showCompanyLogoImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Image.file(
              File(_image!.path),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            _showColorPickerDialog();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.color_lens),
          label: const Text('Select any color of your theme'),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> _showColorPickerDialog() async {
    Color? selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color currentColor = _selectedColor;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                currentColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop(currentColor);
              },
            ),
          ],
        );
      },
    );

    if (selectedColor != null) {
      setState(() {
        _selectedColor = selectedColor;
      });
    }
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _companyCategory.isNotEmpty ? _companyCategory : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a company category.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Select Company Category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          items: companyCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _companyCategory = value ?? '';
            });
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  void _saveChangesFormData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    companyNameController.clear();
    // Clear other text fields if needed
  }

  void _validateAndSaveSocialMediaData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Social media links saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    whatsappController.clear();
    youtubeController.clear();
    twitterController.clear();
    instagramController.clear();
    facebookController.clear();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    whatsappController.dispose();
    youtubeController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    super.dispose();
  }
}
