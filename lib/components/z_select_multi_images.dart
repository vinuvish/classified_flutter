import 'package:cached_network_image/cached_network_image.dart';
import 'package:classified_flutter/components/z_button_outlined.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

typedef Null ValueChangeCallback(List<Asset> images);
typedef Null OnValueChangeCallBack(List<Asset> images);

class ZSelectMultiImages extends StatefulWidget {
  final OnValueChangeCallBack onValueChanged;
  final ValueChangeCallback onImageChange;
  final List<Asset> imageAsserts = List<Asset>();
  final List imageUrls;
  final double height;
  final double width;
  ZSelectMultiImages({
    Key key,
    this.onImageChange,
    this.onValueChanged,
    this.imageUrls,
    this.height = 155,
    this.width = 155,
  }) : super(key: key);

  @override
  _ZSelectMultiImagesState createState() => _ZSelectMultiImagesState();
}

class _ZSelectMultiImagesState extends State<ZSelectMultiImages> {
  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ZButtonOutline(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              text: 'Add Images',
              onTap: () async {
                await loadAssets();
                widget.onValueChanged(images);
              }),
          if (widget.imageAsserts == null && widget.imageUrls.isNotEmpty)
            GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(widget.imageUrls.length, (index) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    height: 155,
                    width: 155,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            width: widget.width,
                            height: widget.height,
                            fit: BoxFit.cover,
                            imageUrl: widget.imageUrls[index] ?? '',
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
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: CircleAvatar(
                              radius: 14,
                              child: GestureDetector(
                                child: Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onTap: () {
                                  images.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })),
          if (images.isNotEmpty)
            GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(images.length, (index) {
                  Asset asset = images[index];
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    height: 155,
                    width: 155,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: <Widget>[
                          AspectRatio(
                            child: AssetThumb(
                              asset: asset,
                              width: 100,
                              height: 100,
                            ),
                            aspectRatio: 1,
                          ),
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: CircleAvatar(
                              radius: 14,
                              child: GestureDetector(
                                child: Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onTap: () {
                                  images.removeAt(index);
                                  widget.onValueChanged(
                                      images ?? widget.imageAsserts);
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }))
        ],
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "PostX",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    images = resultList;
    widget.onValueChanged(images ?? widget.imageAsserts);
    setState(() {});
  }
}
