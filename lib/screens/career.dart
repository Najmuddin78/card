import 'package:flutter/material.dart';

class CareerPage extends StatefulWidget {
  const CareerPage({Key? key}) : super(key: key);

  @override
  State<CareerPage> createState() => _CareerPageState();
}

class _CareerPageState extends State<CareerPage> {
  // Define variables to store the user input

  TextEditingController _name = TextEditingController();
  TextEditingController _companyName = TextEditingController();
  TextEditingController _contactInfo = TextEditingController();
  String? _jobTitle;

  // List of job titles for the dropdown
  final List<String> _jobTitles = [
    'Software Engineer',
    'Data Analyst',
    'Product Manager',
    'UI/UX Designer',
    // Add more job titles as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career'),
        leading: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        'Enter Name',
                        _name,
                      ),
                      const SizedBox(height: 20),
                      _buildDropdown(
                        labelText: 'Job Title',
                        value: _jobTitle,
                        items: _jobTitles,
                        onChanged: (value) {
                          setState(() {
                            _jobTitle = value;
                          });
                        },
                      ),
                      _buildTextFormField(
                        'Enter Comapny aname',
                        _companyName,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        'Enter Conatct info',
                        _contactInfo,
                      ),
                      const SizedBox(height: 20),
                      _buildButton(
                        onPressed: () {},
                        text: 'Submit',
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildDropdown({
    required String labelText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 16.0),
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
}
