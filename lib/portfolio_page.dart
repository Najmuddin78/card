import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'color_palette.dart';

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  List<Portfolio> portfolios = []; // List to store portfolios

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
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
                                child: AddPortfolioDialog(
                                  onPortfolioAdded: addPortfolio,
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
                      'Add Portfolio',
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
                  DataColumn(label: Text('Image Name')),
                  DataColumn(label: Text('Image Category')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action')),
                ],
                rows: portfolios.asMap().entries.map((portfolioEntry) {
                  int index = portfolioEntry.key;
                  Portfolio portfolio = portfolioEntry.value;
                  return DataRow(cells: [
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
                      GestureDetector(
                        onTap: () {
                          toggleStatus(index);
                        },
                        child: Text(
                          portfolio.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color:
                                portfolio.isActive ? Colors.green : Colors.red,
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
                                  onDelete: () => deletePortfolio(index),
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
                              deletePortfolio(index);
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
                  ]);
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
  final Function(Portfolio) onPortfolioAdded; // Callback function
  const AddPortfolioDialog({Key? key, required this.onPortfolioAdded})
      : super(key: key);

  @override
  _AddPortfolioDialogState createState() => _AddPortfolioDialogState();
}

class _AddPortfolioDialogState extends State<AddPortfolioDialog> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _imageNameController = TextEditingController();
  TextEditingController _imageCategoryController = TextEditingController();

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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: AlertDialog(
        title: const Text('Add Portfolio'),
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
                  controller: _imageNameController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Image Name'),
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter image name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageCategoryController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Image Category'),
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
                      text: 'Add Portfolio',
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

class EditPortfolioDialog extends StatelessWidget {
  final Portfolio portfolio;
  final Function onDelete;

  const EditPortfolioDialog({
    Key? key,
    required this.portfolio,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Portfolio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(
            File(portfolio.imagePath),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text('Image Name: ${portfolio.imageName}'),
          const SizedBox(height: 8),
          Text('Image Category: ${portfolio.imageCategory}'),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: ColorPalette.buttonText,
          ),
          child: const Text('Delete'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: ColorPalette.buttonText,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class Portfolio {
  final String imageName;
  final String imageCategory;
  final String imagePath;
  bool isActive; // Status of the portfolio

  Portfolio({
    required this.imageName,
    required this.imageCategory,
    required this.imagePath,
    this.isActive = true, // Initially active
  });
}
