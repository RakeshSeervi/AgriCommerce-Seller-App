import 'package:agri_com/constants.dart';
import 'package:agri_com/models/fruits.dart';
import 'package:agri_com/models/product.dart';
import 'package:agri_com/models/vegetables.dart';
import 'package:agri_com/services/firebase_services.dart';
import 'package:agri_com/widgets/custom_action_bar.dart';
import 'package:agri_com/widgets/image_swipe.dart';
import 'package:agri_com/widgets/product_weight.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage({this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  User _user = FirebaseAuth.instance.currentUser;

  FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedProductSize;
  bool isSwitched ;



  final SnackBar _snackBarDelete = SnackBar(
    content: Text("Product Deleted"),
  );
  final SnackBar _snackBarEdit = SnackBar(
    content: Text("Product Edited"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.product.id).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Product product = Product.fromSnapshot(snapshot.data);
                List productSizes;

                if (product.category == 'Fruits')
                  productSizes = Fruits[product.subCategory]['weighted']
                      ? Fruits[product.subCategory]['weights']
                      : [1];
                else
                  productSizes = Vegetables[product.subCategory]['weighted']
                      ? Vegetables[product.subCategory]['weights']
                      : [1];

                _selectedProductSize = productSizes[0].toString();

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: product.images,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        product.name,
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\Rs ${product.price}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "${product.description}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Category ",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor,

                            ),
                          ),

                          Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Subcategory ",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor,

                            ),
                          ),

                          Text(
                            product.subCategory,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "In stock",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor,

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: FlutterSwitch(
                                width: 110.0,
                                height: 45.0,
                                valueFontSize: 25.0,
                                toggleSize: 45.0,
                                value: product.available,
                                borderRadius: 30.0,
                                padding: 8.0,
                                showOnOff: true,
                                activeColor: Colors.green,
                                onToggle: (val) {
                                  setState(() {
                                    _firebaseServices.productsRef
                                        .doc(product.id)
                                        .update({"available":val});
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.symmetric(horizontal: 36.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
