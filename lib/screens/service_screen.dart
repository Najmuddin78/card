import 'dart:io';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ServiceScreenState();
  }
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<Service> services = [];

  void addService(Service service) {
    setState(() {
      services.add(service);
    });
  }

  void deleteService(int index) {
    setState(() {
      services.removeAt(index);
    });
  }

  void toggleStatus(int index) {
    setState(() {
      services[index].isActive = !services[index].isActive;
    });
  }

  void editService(int index, Service editedService) {
    setState(() {
      services[index] = editedService;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Services'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service List',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) =>
                              ServiceDialog(onServiceAdded: addService),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                        backgroundColor: lightColorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Add Service',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Service Name')),
                  DataColumn(label: Text('Service Description')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action')),
                ],
                rows: services.asMap().entries.map((serviceEntry) {
                  int index = serviceEntry.key;
                  Service service = serviceEntry.value;
                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(
                            File(service.imagePath),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(service.serviceName),
                      ),
                      DataCell(
                        Text(service.serviceDescription),
                      ),
                      DataCell(
                        OutlinedButton(
                          onPressed: () {
                            toggleStatus(index);
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (states) {
                                return BorderSide(
                                  color: service.isActive
                                      ? Colors.green
                                      : Colors.red,
                                  width: 2.0,
                                );
                              },
                            ),
                          ),
                          child: Text(
                            service.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color:
                                  service.isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) => EditServiceDialog(
                                      service: service,
                                      onServiceEdited: (editedService) {
                                        editService(index, editedService);
                                      },
                                      onDelete: () => deleteService(index),
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 5.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 0,
                                  backgroundColor: lightColorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  deleteService(index);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 5.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.red),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceDialog extends StatefulWidget {
  final Function(Service) onServiceAdded;

  const ServiceDialog({Key? key, required this.onServiceAdded})
      : super(key: key);

  @override
  _ServiceDialogState createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceNameController;
  late TextEditingController _serviceDescriptionController;

  @override
  void initState() {
    super.initState();
    _serviceNameController = TextEditingController();
    _serviceDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceDescriptionController.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String serviceName = _serviceNameController.text;
      String serviceDescription = _serviceDescriptionController.text;
      Service service = Service(
        serviceName: serviceName,
        serviceDescription: serviceDescription,
        imagePath: _image!.path,
      );
      widget.onServiceAdded(service);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _image == null
                  ? const Column(
                      children: [
                        SizedBox(height: 20),
                        Text('No image selected.'),
                        SizedBox(height: 8),
                      ],
                    )
                  : Flexible(
                      child: Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: getImage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: lightColorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Service Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _serviceDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter Service Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: lightColorScheme.primary,
                    ),
                    child: const Text('Add Service'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditServiceDialog extends StatefulWidget {
  final Service service;
  final Function(Service) onServiceEdited;
  final Function onDelete;

  const EditServiceDialog({
    Key? key,
    required this.service,
    required this.onServiceEdited,
    required this.onDelete,
  }) : super(key: key);

  @override
  _EditServiceDialogState createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends State<EditServiceDialog> {
  late File? _image;
  final picker = ImagePicker();
  late TextEditingController _serviceNameController;
  late TextEditingController _serviceDescriptionController;

  TextFormField buildTextFormField(String label, void Function(String?) onSaved,
      String? Function(String?)? validator) {
    return TextFormField(
      style: const TextStyle(fontSize: 16),
      controller: _serviceNameController,
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

  @override
  void initState() {
    super.initState();
    _serviceNameController =
        TextEditingController(text: widget.service.serviceName);
    _serviceDescriptionController =
        TextEditingController(text: widget.service.serviceDescription);
    _image = File(widget.service.imagePath);
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceDescriptionController.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: getImage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: lightColorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Change Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildTextFormField(
                'Service Name',
                (value) => _serviceNameController.text = value!,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _serviceDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter Service Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_serviceNameController.text.isNotEmpty &&
                          _serviceDescriptionController.text.isNotEmpty) {
                        Service editedService = Service(
                          serviceName: _serviceNameController.text,
                          serviceDescription:
                              _serviceDescriptionController.text,
                          imagePath: _image!.path,
                        );
                        widget.onServiceEdited(editedService);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: lightColorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Service {
  final String serviceName;
  final String serviceDescription;
  final String imagePath;
  bool isActive;

  Service({
    required this.serviceName,
    required this.serviceDescription,
    required this.imagePath,
    this.isActive = true,
  });
}
