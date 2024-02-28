import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() {
    return _ContactUsScreenState();
  }
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController mapLinkController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();

  String? mapLinkError;
  String? emailError;
  String? contactNumberError;
  String? officeAddressError;

  Map<String, String> contactStatus = {
    'John Doe': 'Pending',
    'Jane Smith': 'Resolved',
  };

  void toggleStatus(String name) {
    setState(() {
      if (contactStatus[name] == 'Pending') {
        contactStatus[name] = 'Resolved';
      } else {
        contactStatus[name] = 'Pending';
      }
    });
  }

  void handleButtonPress() {
    setState(() {
      mapLinkError =
          mapLinkController.text.isEmpty ? 'Please enter a valid link' : null;
      emailError =
          emailController.text.isEmpty ? 'Please enter a valid email' : null;
      contactNumberError = contactNumberController.text.isEmpty
          ? 'Please enter a valid number'
          : null;
      officeAddressError = officeAddressController.text.isEmpty
          ? 'Please enter a valid address'
          : null;
    });

    if (mapLinkError == null &&
        emailError == null &&
        contactNumberError == null &&
        officeAddressError == null) {
      print('Button pressed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
        ),
        backgroundColor: Colors.black,
        foregroundColor: lightColorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20.0),
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
                        'Contact Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: mapLinkController,
                      decoration: InputDecoration(
                        hintText: 'https://www.google.com/maps/embed?...',
                        errorText: mapLinkError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'example@company.com',
                        errorText: emailError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: contactNumberController,
                      decoration: InputDecoration(
                        hintText: '+911234567890',
                        errorText: contactNumberError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: officeAddressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter company office address',
                        errorText: officeAddressError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleButtonPress,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        backgroundColor: lightColorScheme.primary,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20.0),
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
                        'All Contact Table:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    Container(
                      constraints:
                          const BoxConstraints(maxWidth: double.infinity),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Contact Number')),
                            DataColumn(label: Text('Message')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                const DataCell(Text('John Doe')),
                                const DataCell(Text('john@example.com')),
                                const DataCell(Text('+918575947542')),
                                const DataCell(
                                    Text('Hello, I have a question.')),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      toggleStatus('John Doe');
                                    },
                                    child: Text(
                                      contactStatus['John Doe']!,
                                      style: TextStyle(
                                        color: contactStatus['John Doe'] ==
                                                'Pending'
                                            ? Colors.red
                                            : Colors.green,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: [
                                const DataCell(Text('Jane Smith')),
                                const DataCell(Text('jane@example.com')),
                                const DataCell(Text('+913257957542')),
                                const DataCell(Text('This is urgent.')),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      toggleStatus('Jane Smith');
                                    },
                                    child: Text(
                                      contactStatus['Jane Smith']!,
                                      style: TextStyle(
                                        color: contactStatus['Jane Smith'] ==
                                                'Pending'
                                            ? Colors.red
                                            : Colors.green,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
