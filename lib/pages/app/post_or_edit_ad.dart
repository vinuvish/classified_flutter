import 'package:classified_flutter/app_utils/validator.dart';
import 'package:classified_flutter/components/z_button_outlined.dart';
import 'package:classified_flutter/components/z_button_raised.dart';
import 'package:classified_flutter/components/z_expansion_tile.dart';
import 'package:classified_flutter/components/z_select_multi_images.dart';
import 'package:classified_flutter/components/z_text_form_field.dart';
import 'package:classified_flutter/components/z_text_form_field_bottom_sheet.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models_providers/auth_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:classified_flutter/pages/app/ad_promotion_page.dart';
import 'package:classified_flutter/pages/app/guest_sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:classified_flutter/components/z_bot_toast.dart';

class PostOrEditAd extends StatefulWidget {
  final Product product;
  PostOrEditAd({Key key, this.product}) : super(key: key);

  @override
  _PostOrEditAdState createState() => _PostOrEditAdState();
}

class _PostOrEditAdState extends State<PostOrEditAd> {
  Product product;
  final formKey = GlobalKey<FormState>();
  List<Asset> imageAssets = List<Asset>();
  Map<String, String> optionDetailsMap = new Map();
  String _categoryName;
  String _subCategoryName;
  bool _isProduct;
  bool _isDisplaySub;
  bool _isDisplayOpt;
  @override
  void initState() {
    if (widget.product == null) {
      product = Product();
      _isProduct = false;
      _isDisplaySub = false;
      _isDisplayOpt = false;
    } else {
      _isProduct = true;
      product = widget.product;
      _isDisplaySub = true;
      _isDisplayOpt = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAnonymous
        ? GuestSignInPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Ade Post'),
            ),
            body: _bodyBuilder(),
          );
  }

  Widget _bodyBuilder() {
    final userProvider = Provider.of<UserProvider>(context);
    return Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            new ZExpansionTile(
              key: GlobalKey(),
              title: new Text(
                  _isProduct ? product.category : _categoryName ?? 'Category'),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              children: [
                for (var i = 0; i < userProvider.categoryNames.length; i++)
                  new ListTile(
                    title: Text(userProvider.categoryNames[i]),
                    onTap: () {
                      _categoryName = userProvider.categoryNames[i];
                      userProvider
                          .getSubCategories(userProvider.categoryNames[i]);
                      _subCategoryName = null;
                      _isDisplaySub = true;
                      formKey.currentState.reset();
                      product.category = _categoryName;
                      setState(() {});
                    },
                  ),
              ],
            ),
            if (_isDisplaySub)
              new ZExpansionTile(
                key: GlobalKey(),
                title: new Text(_isProduct
                    ? product.subCategory
                    : _subCategoryName ?? 'Type'),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: [
                  for (var i = 0; i < userProvider.subCategoryNames.length; i++)
                    new ListTile(
                      title: Text(userProvider.subCategoryNames[i]),
                      onTap: () {
                        _subCategoryName = userProvider.subCategoryNames[i];
                        userProvider.getOptions(
                            _categoryName, userProvider.subCategoryNames[i]);
                        _isDisplayOpt = true;
                        formKey.currentState.reset();
                        product.subCategory = _subCategoryName;
                        setState(() {});
                      },
                    ),
                ],
              ),
            if (_isDisplayOpt)
              Column(
                children: [
                  ZTextFormField(
                    // validator: (value) => AdTitleValidator.validate(value),
                    hint: 'Title',
                    initialValue: product.title ?? '',
                    onSaved: (value) {
                      product.title = value;
                    },
                    onValueChanged: (value) {
                      product.title = value;
                    },
                  ),
                  ZTextFormFieldBottomSheet(
                    initialValue: product.district ?? '',
                    hint: 'District',
                    items: ['Colombo', 'Jaffna'],
                    onValueChanged: (value) {
                      product.district = value;
                    },
                  ),
                  ZTextFormFieldBottomSheet(
                    initialValue: product.city ?? '',
                    hint: 'City',
                    items: ['Colombo1', 'Colombo2'],
                    onValueChanged: (value) {
                      product.city = value;
                    },
                  ),
                  ZSelectMultiImages(
                    onValueChanged: (images) {
                      imageAssets = images;
                      setState(() {});
                    },
                  ),
                  Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Fill in the details ',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.lato(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      )),
                  if (userProvider.options.isNotEmpty)
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userProvider.options.length,
                      itemBuilder: (context, index) {
                        if (userProvider.options[index].isDropDown) {
                          return ZTextFormFieldBottomSheet(
                            initialValue:
                                _isProduct ? product.optionDetails : '',
                            hint: userProvider.options[index].name,
                            items: userProvider.options[index].values,
                            onValueChanged: (value) {
                              optionDetailsMap[
                                  userProvider.options[index].name] = value;
                            },
                          );
                        }
                        return ZTextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: userProvider.options[index].isNumaric
                              ? TextInputType.number
                              : TextInputType.text,
                          hint: userProvider.options[index].name,
                          initialValue:
                              _isProduct ? product.optionDetails.values : '',
                          onSaved: (value) {
                            optionDetailsMap[userProvider.options[index].name] =
                                value;
                          },
                          onValueChanged: (value) {
                            optionDetailsMap[userProvider.options[index].name] =
                                value;
                          },
                        );
                      },
                    ),
                  ZTextFormField(
                    hint: 'Description',
                    initialValue: product.description ?? '',
                    maxLines: 5,
                    onSaved: (value) {
                      product.description = value;
                    },
                    onValueChanged: (value) {
                      product.description = value;
                    },
                  ),
                  ZTextFormField(
                    keyboardType: TextInputType.number,
                    hint: 'Price',
                    initialValue: product.price ?? '',
                    onSaved: (value) {
                      product.price = value;
                    },
                    onValueChanged: (value) {
                      product.price = value;
                    },
                  ),
                  Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Contect Details',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.lato(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      )),
                  ZTextFormField(
                    isEnabled: false,
                    hint: 'Name',
                    initialValue: userProvider.authUser.fullName,
                    readyOnly: true,
                  ),
                  if (userProvider.authUser.phoneNumber != null)
                    ZTextFormField(
                      readyOnly: true,
                      hint: 'Phone Number',
                      initialValue: userProvider.authUser.phoneNumber,
                    ),
                  if (userProvider.authUser.phoneNumber == null)
                    ZButtonOutline(text: 'Add Phone Number', onTap: () {}),
                  ZTextFormField(
                    hint: 'Email',
                    initialValue: userProvider.authUser.email,
                    readyOnly: true,
                  ),
                  ZButtonRaised(
                      text: 'Submit',
                      onTap: () async {
                        product.optionDetails = optionDetailsMap;

                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();

                          if (imageAssets.isEmpty) {
                            ZBotToast.showToastError(
                                message: 'Please Select images');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AdPromotionpage(
                                  product: product,
                                  imageAssets: imageAssets,
                                );
                              },
                            ));
                          }
                        }
                      }),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
          ],
        ));
  }
}
