import 'dart:io';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() {
    return _PaymentDetailsScreenState();
  }
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
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
        leading: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 20),
          _buildBankPaymentDetailsContainer(),
          const SizedBox(height: 20),
          _buildUpiPaymentDetailsContainer(),
          const SizedBox(height: 20),
          _buildQrPaymentDetailsContainer(),
        ],
      ),
    );
  }

  Widget _buildBankPaymentDetailsContainer() {
    return Column(
      children: [
        Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16), // Same padding for all fields in this container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSectionTitle('Bank Payment Details'),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                _buildTextField(_receiverNameController, 'Receiver Name',
                    _bankDetailsError),
                const SizedBox(height: 20),
                _buildTextField(
                    _bankNameController, 'Bank Name', _bankDetailsError),
                const SizedBox(height: 20),
                _buildTextField(
                    _ifscCodeController, 'IFSC Code', _bankDetailsError),
                const SizedBox(height: 20),
                _buildTextField(
                    _accountTypeController, 'Account Type', _bankDetailsError),
                const SizedBox(height: 20),
                _customButton('Save Bank Payment Details', _saveBankDetails),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUpiPaymentDetailsContainer() {
    return Column(
      children: [
        Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16), // Same padding for all fields in this container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSectionTitle(
                  'UPI Payment Details',
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                _buildTextField(
                    _upiNameController, 'Receiver Name', _upiDetailsError),
                const SizedBox(height: 20),
                _buildTextField(
                    _upiNumberController, 'UPI Number or ID', _upiDetailsError),
                const SizedBox(height: 20),
                _customButton('Save UPI Payment Details', _saveUpiDetails),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQrPaymentDetailsContainer() {
    return Column(
      children: [
        Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSectionTitle('QR Payment Details'),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                _customButton('Upload QR Code', _showImagePicker),
                const SizedBox(height: 20),
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorText: errorText,
        contentPadding: const EdgeInsets.all(20.0), 
      ),
    );
  }

  Widget _customButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: lightColorScheme.primary,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
