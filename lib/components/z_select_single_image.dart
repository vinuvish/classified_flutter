import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

import 'z_bottom_sheet.dart';

typedef Null ValueChangeCallback(File value);
typedef Null ValueChangeCallbackDeleteImg(bool value);

class ZSelectSingleImage extends StatefulWidget {
  final ValueChangeCallback onImageChange;
  final ValueChangeCallbackDeleteImg onDeleteImage;
  final File imageFile;
  final String imageUrl;
  final bool isEnabled;
  final double height;
  final double width;
  final EdgeInsets margin;

  ZSelectSingleImage({
    Key key,
    this.onImageChange,
    this.onDeleteImage,
    this.imageFile,
    this.imageUrl = '',
    this.isEnabled = true,
    this.height = 155,
    this.width = 155,
    this.margin,
  }) : super(key: key);

  _ZSelectSingleImageState createState() => _ZSelectSingleImageState();
}

class _ZSelectSingleImageState extends State<ZSelectSingleImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZBottomSheet(
      zbottomSheetItems: [
        ZBottomSheetItem(text: Text('Camera'), icon: Icon(AntDesign.camera)),
        ZBottomSheetItem(text: Text('Galery'), icon: Icon(AntDesign.picture)),
        ZBottomSheetItem(
            text: Text('Delete', style: TextStyle(color: Colors.red)),
            icon: Icon(AntDesign.delete, color: Colors.red)),
      ],
      onValueChanged: (v) {
        if (v == 'Camera') getImage(true);
        if (v == 'Galery') getImage(false);
        if (v == 'Delete') {
          widget.onDeleteImage(true);
          widget.onImageChange(null);
          setState(() {});
        }
      },
      child: Container(
        margin: widget.margin ?? EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: <Widget>[
            if (widget.imageFile == null && widget.imageUrl != '')
              Container(
                  width: widget.width,
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      width: widget.width,
                      height: widget.height,
                      fit: BoxFit.cover,
                      imageUrl: widget.imageUrl ?? '',
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        height: widget.height,
                        width: widget.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200],
                        ),
                      ),
                      errorWidget: (context, url, error) => Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: widget.height,
                            width: widget.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[200],
                            ),
                            child: Text(
                              'No Image \nSelected',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            else
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                alignment: Alignment.center,
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: widget.imageFile == null
                      ? Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(AntDesign.camera),
                              SizedBox(height: 5),
                              Text(
                                'Selected Image',
                                style: GoogleFonts.lato(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: <Widget>[
                            AspectRatio(
                              child: Image(
                                image: FileImage(widget.imageFile),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              aspectRatio: 1,
                            ),
                            Positioned(
                              right: 6,
                              bottom: 6,
                              child: CircleAvatar(
                                radius: 14,
                                child: Icon(
                                  AntDesign.edit,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future getImage(bool isCamera) async {
    File _imageFile;
    if (isCamera) {
      _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    widget.onImageChange(_imageFile ?? widget.imageFile);
    setState(() {});
  }
}
