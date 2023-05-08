import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();
  //final _priceFocus = FocusNode();

  var _product = Product(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  var _hasImage = true;
  var _init = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      final productID = ModalRoute.of(context)!.settings.arguments;
      if (productID != null) {
        //...mahsulotni eski ma'lumotini olishimiz kerak
        final _editingProduct =
            Provider.of<Products>(context).findById(productID as String);
        _product = _editingProduct;
      }
    }
    _init = false;
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   //_priceFocus.dispose();
  // }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text("Rasm URL-ni kiriting!"),
          content: Form(
            key: _imageForm,
            child: TextFormField(
              initialValue: _product.imageUrl,
              decoration: const InputDecoration(
                labelText: 'Rasm URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Iltimos, URL manzilini kiriting.';
                } else if (!value.startsWith('http')) {
                  return 'URL ni to\'g\'ri kiriting';
                }
                return null;
              },
              onSaved: (newValue) {
                _product = Product(
                  id: _product.id,
                  title: _product.title,
                  description: _product.description,
                  price: _product.price,
                  imageUrl: newValue!,
                  isFavorite: _product.isFavorite,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "BEKOR QILISH",
              ),
            ),
            ElevatedButton(
              onPressed: _saveImageForm,
              child: const Text(
                "SAQLASH",
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveImageForm() {
    final isValid = _imageForm.currentState!.validate();
    if (isValid && _hasImage) {
      _imageForm.currentState!.save();
      //_isLoading = true;
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState!.validate();
    setState(() {
      _hasImage = _product.imageUrl.isNotEmpty;
    });
    if (isValid) {
      _form.currentState!.save();
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          print(error);
          await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Xatolik!"),
                content: const Text("Maxsulot qo'shishda xatolik yuz berdi!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      "Okay",
                    ),
                  ),
                ],
              );
            },
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
      } else {
        Provider.of<Products>(context, listen: false).updateProduct(_product);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Maxsulotlarni qo'shish"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            tooltip: 'SAQLASH',
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
              //child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _product.title,
                        decoration: const InputDecoration(
                          labelText: 'Nomi',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction
                            .next, // keyingi inputga o'tish uchun klaviaturada next button qoshish
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos, maxsulot nomini kiriting.';
                          }
                          return null;
                        },
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_priceFocus);
                        // },
                        onSaved: (newValue) => _product = Product(
                          id: _product.id,
                          title: newValue!,
                          description: _product.description,
                          price: _product.price,
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _product.price == 0
                            ? ''
                            : _product.price.toStringAsFixed(2),
                        decoration: const InputDecoration(
                          labelText: 'Narxi',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos, maxsulot narxini kiriting';
                          } else if (double.tryParse(value) == null) {
                            return 'Iltimos, maxsulot narxini to\'gri kiriting';
                          } else if (double.parse(value) < 1) {
                            return 'Maxsulot narxi 0 dan katta bo\'lishi kerak.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        //focusNode: _priceFocus,
                        onSaved: (newValue) => _product = Product(
                          id: _product.id,
                          title: _product.title,
                          description: _product.description,
                          price: double.parse(newValue!),
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _product.description,
                        decoration: const InputDecoration(
                          labelText: 'Qo\'shimcha ma\'lumotlar',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos, maxsulot ma\'lumotlarini kiriting.';
                          } else if (value.length < 10) {
                            return 'Iltimos, batafsil ma\'lumot kiriting';
                          }
                          return null;
                        },
                        //focusNode: _priceFocus,
                        onSaved: (newValue) => _product = Product(
                          id: _product.id,
                          title: _product.title,
                          description: newValue!,
                          price: _product.price,
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _hasImage
                                ? Colors.grey
                                : Theme.of(context).colorScheme.error,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: InkWell(
                          splashColor:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5),
                          highlightColor: Colors.transparent,
                          onTap: () => _showInputDialog(context),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            alignment: Alignment.center,
                            child: _product.imageUrl.isEmpty
                                ? Text(
                                    "Asosiy rasm URL-ini kiriting!",
                                    style: TextStyle(
                                        color: _hasImage
                                            ? Colors.black
                                            : Theme.of(context)
                                                .colorScheme
                                                .error),
                                  )
                                : Image.network(
                                    _product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
