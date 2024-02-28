import 'dart:io';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
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
      body: Column(
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return AddPortfolioDialog(
                            onPortfolioAdded: addPortfolio,
                          );
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(0.0, 1.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
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
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      DataCell(Text(portfolio.imageName)),
                      DataCell(Text(portfolio.imageCategory)),
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
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditPortfolioDialog(
                                    portfolio: portfolio,
                                    onPortfolioEdited: (editedPortfolio) {
                                      editPortfolio(index, editedPortfolio);
                                    },
                                    onDelete: () => deletePortfolio(index),
                                  ),
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
                              child: const Text('Edit'),
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
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
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

class AddPortfolioDialog extends StatefulWidget {
  final Function(Portfolio) onPortfolioAdded;
  const AddPortfolioDialog({Key? key, required this.onPortfolioAdded})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddPortfolioDialogState();
  }
}

class _AddPortfolioDialogState extends State<AddPortfolioDialog> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _imageNameController = TextEditingController();
  final TextEditingController _imageCategoryController =
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: _image == null
                    ? const Column(
                        children: [
                          SizedBox(height: 20),
                          Text('No image selected.'),
                        ],
                      )
                    : Image.file(
                        width: 200,
                        height: 200,
                        _image!,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: ElevatedButton(
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
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _imageNameController,
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
                      return 'Please enter image name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _imageCategoryController,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Image Cateogory';
                    }
                    return null;
                  },
                ),
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
                        backgroundColor: Colors.red),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
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
                    },
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
    Key? key,
    required this.portfolio,
    required this.onPortfolioEdited,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditPortfolioDialogState();
  }
}

class _EditPortfolioDialogState extends State<EditPortfolioDialog> {
  File? _image;
  final TextEditingController _imageNameController = TextEditingController();
  final TextEditingController _imageCategoryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageNameController.text = widget.portfolio.imageName;
    _imageCategoryController.text = widget.portfolio.imageCategory;
    _image = File(widget.portfolio.imagePath);
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _image == null
                  ? const Column(
                      children: [
                        SizedBox(height: 20),
                        Text('No image selected.'),
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
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: lightColorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Change Image'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _imageNameController,
                decoration: InputDecoration(
                  hintText: ' please Enter image Name',
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
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _imageCategoryController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Image Cateogory';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_imageNameController.text.isNotEmpty &&
                        _imageCategoryController.text.isNotEmpty) {
                      Portfolio editedPortfolio = Portfolio(
                        imageName: _imageNameController.text,
                        imageCategory: _imageCategoryController.text,
                        imagePath: _image != null
                            ? _image!.path
                            : widget.portfolio.imagePath,
                        isActive: widget.portfolio.isActive,
                      );
                      widget.onPortfolioEdited(editedPortfolio);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: lightColorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
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
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
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
