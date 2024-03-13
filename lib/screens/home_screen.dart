import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:card/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
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

  final bool _uploadingImage = false;

  @override
  void initState() {
    super.initState();
    loadDataFromApi();
  }

  void loadDataFromApi() async {
    try {
      final String? companyId = await getCompanyId();
      final String? token = await getToken();

      final url = Uri.parse(
          'https://digitalbusinesscard.webwhizinfosys.com/api/company/$companyId');
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      print('Response Status :${response.statusCode}');
      print('Response body :${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["company"];

        setState(() {
          companyNameController.text = responseData["name"];
          _companyCategory = responseData['categoryName'];
          _image = XFile(responseData['logo']);
          _selectedColor = hexToColor(responseData["color"]);
          whatsappController.text = responseData['whatsappNumber'];
          facebookController.text = responseData['facebook'];
          instagramController.text = responseData['instagram'];
          twitterController.text = responseData['twitter'];
          youtubeController.text = responseData['youtube'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<String?> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyId');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveCompanyInfo() async {
    try {
      final String? token = await getToken();
      final String? companyId = await getCompanyId();

      final url = Uri.parse(
          'https://digitalbusinesscard.webwhizinfosys.com/api/company//update-home-section-one/$companyId');
      final response = await http.patch(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({
          "name": companyNameController.text,
          "categoryName": _companyCategory,
          "logo": _image?.path ?? "",
          "color": _selectedColor.toString(),
        }),
      );

      // print('Response Status :${response.statusCode}');
      // print('Response body :${response.body}');

      if (response.statusCode == 200) {
        loadDataFromApi();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Company information saved successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Failed to save company information');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> saveSocialMedia() async {
    try {
      final String? token = await getToken();
      final String? companyId = await getCompanyId();

      final url = Uri.parse(
          'https://digitalbusinesscard.webwhizinfosys.com/api/company/update-home-section-two/$companyId');
      final response = await http.patch(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({
          "whatsappNumber": whatsappController.text,
          "facebook": facebookController.text,
          "instagram": instagramController.text,
          "twitter": twitterController.text,
          "youtube": youtubeController.text,
        }),
      );

      // print('Response Status :${response.statusCode}');
      // print('Response body :${response.body}');

      if (response.statusCode == 200) {
        loadDataFromApi();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Social media links saved successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Failed to save social media links');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _uploadingImage,
      child: Scaffold(
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
              onPressed: () {
                _logout(context);
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
                saveCompanyInfo();
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
                saveSocialMedia();
              },
              text: 'Save Social Media',
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 40),
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
              saveCompanyInfo();
            }
          },
          icon: const Icon(Icons.image),
          label: const Text('Choose Company Logo'),
        ),
        if (_image != null) _buildSelectedImage(),
        if (_uploadingImage) const CircularProgressIndicator(),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return _image != null && File(_image!.path).existsSync()
        ? GestureDetector(
            onTap: () {
              _showCompanyLogoImage();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  File(_image!.path),
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void _showCompanyLogoImage() {
    if (_image != null && File(_image!.path).existsSync()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.file(
                File(_image!.path),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }
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
              pickerAreaHeightPercent: 0.8,
              labelTypes: const [],
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

  void _saveChangesFormData() {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        _image = null;
        _selectedColor = lightColorScheme.primary;
        companyNameController.clear();
        _companyCategory = '';
      });
    }
  }

  void _validateAndSaveSocialMediaData() {
    if (_socialMediaFormKey.currentState!.validate()) {
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

  void _logout(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('token');
    await prefs.remove('companyId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
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

  Color hexToColor(String code) {
    String hexCode = code.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');

    if (hexCode.length == 6) {
      hexCode = 'ff$hexCode';
    }

    return Color(int.parse(hexCode, radix: 16));
  }
}
