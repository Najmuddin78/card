import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'color_palette.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsPage> createState() {
    return _PaymentDetailsPageState();
  }
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _upiNameController = TextEditingController();
  final TextEditingController _upiNumberController = TextEditingController();

  File? _qrImage;

  String? _bankDetailsError;
  String? _upiDetailsError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: ColorPalette.appBarBackground,
        foregroundColor: ColorPalette.appBarText,
        leading: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Bank Payment Details'),
            _buildTextField(
                _receiverNameController, 'Receiver Name', _bankDetailsError),
            _buildTextField(
                _bankNameController, 'Bank Name', _bankDetailsError),
            _buildTextField(
                _ifscCodeController, 'IFSC Code', _bankDetailsError),
            _buildTextField(
                _accountTypeController, 'Account Type', _bankDetailsError),
            const SizedBox(height: 16),
            _customButton('Save Bank Payment Details', _saveBankDetails,
                ColorPalette.buttonText, ColorPalette.buttonBackground),
            const SizedBox(
                height:
                    16.0), // SizedBox after the Save Bank Payment Details button
            const Divider(
              color: Colors.black,
            ), // Divider after the Save Bank Payment Details button
            _buildSectionTitle('UPI Payment Details'),
            _buildTextField(
                _upiNameController, 'Receiver Name', _upiDetailsError),
            _buildTextField(
                _upiNumberController, 'UPI Number or ID', _upiDetailsError),
            const SizedBox(height: 16.0),
            _customButton('Save UPI Payment Details', _saveUpiDetails,
                ColorPalette.buttonText, ColorPalette.buttonBackground),
            const SizedBox(height: 16.0),
            const Divider(
              color: Colors.black,
            ), // Divider after the Save UPI Payment Details button
            _buildSectionTitle('QR Payment Details'),
            const SizedBox(height: 16.0),
            _customButton('Upload QR Code', _showImagePicker,
                ColorPalette.buttonText, ColorPalette.buttonBackground),
            const SizedBox(height: 16),
            Container(
              color: Colors.grey[200],
              height: 200.0,
              child: _qrImage != null
                  ? Image.file(
                      _qrImage!,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Text(
                        'No QR code selected',
                      ),
                    ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, String? errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorText: errorText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _customButton(String label, VoidCallback onPressed, Color textColor,
      Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildButton(label, onPressed, textColor, backgroundColor),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, Color textColor,
      Color backgroundColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  void _saveBankDetails() {
    setState(() {
      _bankDetailsError = null;

      if (_receiverNameController.text.isEmpty ||
          _bankNameController.text.isEmpty ||
          _ifscCodeController.text.isEmpty ||
          _accountTypeController.text.isEmpty) {
        _bankDetailsError = 'Please fill all bank payment details';
        return;
      }
    });

    // Implement action for saving bank payment details
  }

  void _saveUpiDetails() {
    setState(() {
      _upiDetailsError = null;

      if (_upiNameController.text.isEmpty ||
          _upiNumberController.text.isEmpty) {
        _upiDetailsError = 'Please fill all UPI payment details';
        return;
      }
    });

    // Implement action for saving UPI payment details
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickQRImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickQRImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickQRImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _qrImage = File(pickedFile.path);
      }
    });
  }
}
