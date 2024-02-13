import 'dart:io';
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
  TextEditingController companyCategoryController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();

  String _companyName = '';
  String _companyCategory = '';
  Color _selectedColor = ColorPalette.buttonBackground;
  XFile? _image;
  Color _selectColorButtonColor = ColorPalette.buttonBackground;

  String? _companyNameError;
  String? _companyCategoryError;
  String? _whatsappError;
  String? _youtubeError;
  String? _twitterError;
  String? _instagramError;
  String? _facebookError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: ColorPalette.appBarBackground,
        foregroundColor: ColorPalette.appBarText,
        automaticallyImplyLeading: false,
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.buttonText,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  'Enter Company Name',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                  (value) {
                    _companyName = value!;
                  },
                  companyNameController,
                  _companyNameError,
                ),
                _buildTextFormField(
                  'Select Company Category',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select company category';
                    }
                    return null;
                  },
                  (value) {
                    _companyCategory = value!;
                  },
                  companyCategoryController,
                  _companyCategoryError,
                ),
                _buildImagePicker(),
                _buildColorPicker(),
                const SizedBox(height: 24.0),
                _buildElevatedButton(
                  onPressed: () {
                    _saveChangesFormData(context);
                  },
                  text: 'Save Changes',
                  icon: Icons.save,
                  isSelectColorButton: false,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Social Media Section',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.buttonText,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildAdditionalFormFields(),
                const SizedBox(height: 16.0),
                _buildElevatedButton(
                  onPressed: () {
                    _validateAndSaveSocialMediaData(context);
                  },
                  text: 'Save Social Media',
                  icon: Icons.save,
                  isSelectColorButton: false,
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
            contentPadding: const EdgeInsets.all(10),
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

  Widget _buildElevatedButton(
      {required VoidCallback onPressed,
      required String text,
      required IconData icon,
      required bool isSelectColorButton}) {
    return ElevatedButton.icon(
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
        foregroundColor: ColorPalette.buttonText,
        backgroundColor: isSelectColorButton
            ? _selectColorButtonColor
            : ColorPalette.buttonBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
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
            'Choose Image',
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
              vertical: 16,
              horizontal: 24,
            ),
          ),
        ),
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
        ElevatedButton.icon(
          onPressed: () {
            _showColorPickerDialog(context);
          },
          icon: const Icon(Icons.color_lens),
          label: const Text(
            'Select Color',
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
              vertical: 16,
              horizontal: 24,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectColorButtonColor = _selectedColor;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdditionalFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFormField(
          'Whatsapp Number',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter WhatsApp number';
            }
            return null;
          },
          null,
          whatsappController,
          _whatsappError,
        ),
        _buildTextFormField(
          'Youtube Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter YouTube link';
            }
            return null;
          },
          null,
          youtubeController,
          _youtubeError,
        ),
        _buildTextFormField(
          'Twitter Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Twitter link';
            }
            return null;
          },
          null,
          twitterController,
          _twitterError,
        ),
        _buildTextFormField(
          'Instagram Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Instagram link';
            }
            return null;
          },
          null,
          instagramController,
          _instagramError,
        ),
        _buildTextFormField(
          'Facebook Link',
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Facebook link';
            }
            return null;
          },
          null,
          facebookController,
          _facebookError,
        ),
      ],
    );
  }

  void _saveChangesFormData(BuildContext context) {
    setState(() {
      _companyNameError = companyNameController.text.isEmpty
          ? 'Please enter company name'
          : null;
      _companyCategoryError = companyCategoryController.text.isEmpty
          ? 'Please select company category'
          : null;
    });

    if (_companyNameError == null && _companyCategoryError == null) {
      // Save the form data to the database
      print(
          'Save Changes: Company Name: $_companyName, Category: $_companyCategory');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data inserted successfully'),
        ),
      );
    }
  }

  void _validateAndSaveSocialMediaData(BuildContext context) {
    setState(() {
      _whatsappError = whatsappController.text.isEmpty
          ? 'Please enter WhatsApp number'
          : null;
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
      // Save additional form data (social media links) to the database
      print('Save Social Media Data:');
      print('Whatsapp: ${whatsappController.text}');
      print('Youtube: ${youtubeController.text}');
      print('Twitter: ${twitterController.text}');
      print('Instagram: ${instagramController.text}');
      print('Facebook: ${facebookController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Social Media Data inserted successfully'),
        ),
      );
    }
  }
}
