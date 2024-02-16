import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'color_palette.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<Service> services = []; // List to store services

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Services'),
        backgroundColor: ColorPalette.appBarBackground,
        foregroundColor: ColorPalette.appBarText,
        leading: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
      ),
      body: Column(
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
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (BuildContext buildContext,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Dialog(
                              insetPadding: EdgeInsets.zero,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0.0, 1.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: ServiceDialog(
                                  onServiceAdded: addService,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                      backgroundColor: ColorPalette.buttonBackground,
                      foregroundColor: ColorPalette.buttonText,
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
                const Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      DataCell(Text(service.serviceName)),
                      DataCell(Text(service.serviceDescription)),
                      DataCell(
                        TextButton(
                          onPressed: () {
                            toggleStatus(index);
                          },
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
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditServiceDialog(
                                      service: service,
                                      onDelete: () => deleteService(index),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: ColorPalette.buttonText,
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
                                  backgroundColor: Colors.red,
                                  foregroundColor: ColorPalette.buttonText,
                                ),
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
          ),
        ],
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
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  ElevatedButton buildElevatedButton({
    required String text,
    required Function onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorPalette.buttonBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
         elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: AlertDialog(
        title: const Text('Add Service'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _image == null
                    ? const Text('No image selected.')
                    : Image.file(_image!),
                ElevatedButton(
                  onPressed: getImage,
                  child: const Text('Select Image'),
                ),
                TextFormField(
                  controller: _serviceNameController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Service Name'),
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter service name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _serviceDescriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Service Description'),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildElevatedButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      backgroundColor: Colors.red, // Change cancel button color
                      textColor:
                          Colors.white, // Change cancel button text color
                    ),
                    buildElevatedButton(
                      text: 'Add Service',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String serviceName = _serviceNameController.text;
                          String serviceDescription =
                              _serviceDescriptionController.text;
                          Service service = Service(
                            serviceName: serviceName,
                            serviceDescription: serviceDescription,
                            imagePath: _image!.path,
                          );
                          widget.onServiceAdded(service);
                          Navigator.of(context).pop();
                        }
                      },
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditServiceDialog extends StatefulWidget {
  final Service service;
  final Function onDelete;

  const EditServiceDialog({
    Key? key,
    required this.service,
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
      } else {
        print('No image selected.');
      }
    });
  }

  ElevatedButton buildElevatedButton({
    required String text,
    required Function onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorPalette.buttonBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Service'),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: const Text('Change Image'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _serviceNameController,
              decoration: const InputDecoration(labelText: 'Service Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter service name';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _serviceDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'Service Description'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter service description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onDelete();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_serviceNameController.text.isNotEmpty &&
                _serviceDescriptionController.text.isNotEmpty) {
              widget.service.serviceName = _serviceNameController.text;
              widget.service.serviceDescription =
                  _serviceDescriptionController.text;
              widget.service.imagePath = _image!.path;
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class Service {
  String serviceName;
  String serviceDescription;
  String imagePath;
  bool isActive;

  Service({
    required this.serviceName,
    required this.serviceDescription,
    required this.imagePath,
    this.isActive = true,
  });
}
