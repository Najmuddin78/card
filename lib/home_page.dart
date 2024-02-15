import 'dart:io';
import 'package:business_card/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:business_card/color_palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();

  String _companyCategory = '';
  Color _selectedColor = ColorPalette.buttonBackground;
  XFile? _image;

  String? _companyNameError;
  String? _companyCategoryError;
  String? _whatsappError;
  String? _youtubeError;
  String? _twitterError;
  String? _instagramError;
  String? _facebookError;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: ColorPalette.appBarBackground,
        foregroundColor: ColorPalette.appBarText,
        leading: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Home Page Edits',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), // Adjusted height
                _buildTextFormField(
                  'Enter Company Name',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                  (value) {
                    // Update companyNameController value
                  },
                  companyNameController,
                  _companyNameError,
                ),
                _buildCategoryDropdown(),
                const SizedBox(height: 20),
                _buildImagePicker(),
                _buildColorPicker(),
                const SizedBox(height: 24.0),
                _buildElevatedButton(
                  onPressed: () {
                    _saveChangesFormData(context);
                  },
                  text: 'Save Changes',
                  icon: Icons.save,
                ),
                const SizedBox(height: 20),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Social Media Section',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildAdditionalFormFields(),
                const SizedBox(height: 16.0),
                _buildElevatedButton(
                  onPressed: () {
                    _validateAndSaveSocialMediaData(context);
                  },
                  text: 'Save Social Media',
                  icon: Icons.save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String hintText,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextEditingController controller,
    String? errorText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorText: errorText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          style: const TextStyle(
            fontSize: 16,
            color: ColorPalette.buttonText,
          ),
          validator: validator,
          onSaved: onSaved,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
  }) {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorPalette.buttonText,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.buttonBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56.0,
          child: ElevatedButton.icon(
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
            label: const Text(
              'Choose Company Logo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorPalette.buttonText,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.buttonBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        if (_image != null) _buildSelectedImage(),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.file(
          File(_image!.path),
          height: 100.0,
          width: 100.0,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56.0,
          child: ElevatedButton.icon(
            onPressed: () {
              _showColorPickerDialog(context);
            },
            icon: const Icon(Icons.color_lens),
            label: const Text(
              'Please select any color of Your Theme',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorPalette.buttonText,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> _showColorPickerDialog(BuildContext context) async {
    Color? newColor = _selectedColor;
    newColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                newColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(newColor);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      setState(() {
        _selectedColor = newColor!;
      });
    }
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _companyCategory.isNotEmpty ? _companyCategory : null,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            hintText: 'Select Company Category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          items: companyCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  color: ColorPalette.buttonText,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _companyCategory = value ?? '';
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select company category';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildAdditionalFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFormField(
          'Enter WhatsApp Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter WhatsApp link';
            }
            return null;
          },
          (value) {
            // Update whatsappController value
          },
          whatsappController,
          _whatsappError,
        ),
        _buildTextFormField(
          'Enter YouTube Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter YouTube link';
            }
            return null;
          },
          (value) {
            // Update youtubeController value
          },
          youtubeController,
          _youtubeError,
        ),
        _buildTextFormField(
          'Enter Twitter Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Twitter link';
            }
            return null;
          },
          (value) {
            // Update twitterController value
          },
          twitterController,
          _twitterError,
        ),
        _buildTextFormField(
          'Enter Instagram Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Instagram link';
            }
            return null;
          },
          (value) {
            // Update instagramController value
          },
          instagramController,
          _instagramError,
        ),
        _buildTextFormField(
          'Enter Facebook Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Facebook link';
            }
            return null;
          },
          (value) {
            // Update facebookController value
          },
          facebookController,
          _facebookError,
        ),
      ],
    );
  }

  void _saveChangesFormData(BuildContext context) {
    final isValidCompanyName = _validateCompanyName();
    final isValidCompanyCategory = _validateCompanyCategory();

    if (!isValidCompanyName || !isValidCompanyCategory) {
      return;
    }

    // Proceed with saving changes or any other action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Clear text fields after saving
    companyNameController.clear();
    // Clear other text fields if needed
  }

  bool _validateCompanyName() {
    final isValid = companyNameController.text.isNotEmpty;
    setState(() {
      _companyNameError = isValid ? null : 'Please enter company name';
    });
    return isValid;
  }

  bool _validateCompanyCategory() {
    final isValid = _companyCategory.isNotEmpty;
    setState(() {
      _companyCategoryError = isValid ? null : 'Please select company category';
    });
    return isValid;
  }

  void _validateAndSaveSocialMediaData(BuildContext context) {
    setState(() {
      _whatsappError =
          whatsappController.text.isEmpty ? 'Please enter WhatsApp link' : null;
      _youtubeError =
          youtubeController.text.isEmpty ? 'Please enter YouTube link' : null;
      _twitterError =
          twitterController.text.isEmpty ? 'Please enter Twitter link' : null;
      _instagramError = instagramController.text.isEmpty
          ? 'Please enter Instagram link'
          : null;
      _facebookError =
          facebookController.text.isEmpty ? 'Please enter Facebook link' : null;
    });

    if (_whatsappError == null &&
        _youtubeError == null &&
        _twitterError == null &&
        _instagramError == null &&
        _facebookError == null) {
      // All fields are valid, proceed with saving data or other operations
      // Save changes to database or perform any other action
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
