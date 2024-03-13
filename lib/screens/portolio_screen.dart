import 'dart:io';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PortfolioScreenState();
  }
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<Portfolio> portfolios = [];

  void addPortfolio(Portfolio portfolio) {
    setState(() {
      portfolios.add(portfolio);
    });
  }

  void deletePortfolio(int index) {
    setState(() {
      portfolios.removeAt(index);
    });
  }

  void toggleStatus(int index) {
    setState(() {
      portfolios[index].isActive = !portfolios[index].isActive;
    });
  }

  void editPortfolio(int index, Portfolio editedPortfolio) {
    setState(() {
      portfolios[index] = editedPortfolio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
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
                    'Portfolio List',
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
                              PortfolioDialog(onPortfolioAdded: addPortfolio),
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
                        'Add Portfolio',
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
                  DataColumn(label: Text('Image Name')),
                  DataColumn(label: Text('Image Category')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action')),
                ],
                rows: portfolios.asMap().entries.map((portfolioEntry) {
                  int index = portfolioEntry.key;
                  Portfolio portfolio = portfolioEntry.value;
                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(
                            File(portfolio.imagePath),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(portfolio.imageName),
                      ),
                      DataCell(
                        Text(portfolio.imageCategory),
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
                                  color: portfolio.isActive
                                      ? Colors.green
                                      : Colors.red,
                                  width: 2.0,
                                );
                              },
                            ),
                          ),
                          child: Text(
                            portfolio.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: portfolio.isActive
                                  ? Colors.green
                                  : Colors.red,
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
                                    builder: (_) => EditPortfolioDialog(
                                      portfolio: portfolio,
                                      onPortfolioEdited: (editedPortfolio) {
                                        editPortfolio(index, editedPortfolio);
                                      },
                                      onDelete: () => deletePortfolio(index),
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
                                  deletePortfolio(index);
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

class PortfolioDialog extends StatefulWidget {
  final Function(Portfolio) onPortfolioAdded;

  const PortfolioDialog({super.key, required this.onPortfolioAdded});

  @override
  State<PortfolioDialog> createState() {
    return _PortfolioDialogState();
  }
}

class _PortfolioDialogState extends State<PortfolioDialog> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _imageNameController;
  late TextEditingController _imageCategoryController;

  @override
  void initState() {
    super.initState();
    _imageNameController = TextEditingController();
    _imageCategoryController = TextEditingController();
  }

  @override
  void dispose() {
    _imageNameController.dispose();
    _imageCategoryController.dispose();
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
      String imageName = _imageNameController.text;
      String imageCategory = _imageCategoryController.text;
      Portfolio portfolio = Portfolio(
        imageName: imageName,
        imageCategory: imageCategory,
        imagePath: _image!.path,
      );
      widget.onPortfolioAdded(portfolio);
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
                controller: _imageNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Image Name',
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
                    return 'Please enter image name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageCategoryController,
                decoration: InputDecoration(
                  hintText: 'Enter Image Category',
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
                    return 'Please enter image category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    child: const Text('Add Portfolio'),
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

class EditPortfolioDialog extends StatefulWidget {
  final Portfolio portfolio;
  final Function(Portfolio) onPortfolioEdited;
  final Function onDelete;

  const EditPortfolioDialog({
    super.key,
    required this.portfolio,
    required this.onPortfolioEdited,
    required this.onDelete,
  });

  @override
  State<EditPortfolioDialog> createState() {
    return _EditPortfolioDialogState();
  }
}

class _EditPortfolioDialogState extends State<EditPortfolioDialog> {
  late File? _image;
  final picker = ImagePicker();
  late TextEditingController _imageNameController;
  late TextEditingController _imageCategoryController;

  TextFormField buildTextFormField(String label, void Function(String?) onSaved,
      String? Function(String?)? validator) {
    return TextFormField(
      style: const TextStyle(fontSize: 16),
      controller: _imageNameController,
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
    _imageNameController =
        TextEditingController(text: widget.portfolio.imageName);
    _imageCategoryController =
        TextEditingController(text: widget.portfolio.imageCategory);
    _image = File(widget.portfolio.imagePath);
  }

  @override
  void dispose() {
    _imageNameController.dispose();
    _imageCategoryController.dispose();
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
                'Image Name',
                (value) => _imageNameController.text = value!,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageCategoryController,
                decoration: InputDecoration(
                  hintText: 'Enter Image Category',
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
                    return 'Please enter image category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_imageNameController.text.isNotEmpty &&
                          _imageCategoryController.text.isNotEmpty) {
                        Portfolio editedPortfolio = Portfolio(
                          imageName: _imageNameController.text,
                          imageCategory: _imageCategoryController.text,
                          imagePath: _image!.path,
                        );
                        widget.onPortfolioEdited(editedPortfolio);
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

class Portfolio {
  final String imageName;
  final String imageCategory;
  final String imagePath;
  bool isActive;

  Portfolio({
    required this.imageName,
    required this.imageCategory,
    required this.imagePath,
    this.isActive = true,
  });
}
