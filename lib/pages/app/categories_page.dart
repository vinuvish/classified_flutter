import 'package:classified_flutter/models_providers/theme_provider.dart';
import 'package:classified_flutter/models_providers/user_provider.dart';
import 'package:classified_flutter/pages/app/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedCat = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: _bodyBuilder());
  }

  Widget _bodyBuilder() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 15),
                  child: ListView.builder(
                    itemCount: userProvider.streamCategories.length,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCat = i;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 25.0),
                          width: 50,
                          constraints: BoxConstraints(minHeight: 85),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: _selectedCat == i ? Border.all() : Border(),
                            color: themeProvider.isLightTheme
                                ? _selectedCat == i
                                    ? Colors.transparent
                                    : Colors.black45
                                : _selectedCat == i
                                    ? Colors.grey[500]
                                    : Theme.of(context).buttonColor,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              "${userProvider.streamCategories[i].name}",
                              style: TextStyle(
                                  color: themeProvider.isLightTheme
                                      ? _selectedCat == i
                                          ? Colors.black
                                          : Colors.white
                                      : _selectedCat == i
                                          ? Colors.white
                                          : Colors.white,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemCount: userProvider
                        .streamCategories[_selectedCat].subCategories.length,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(9.0),
                          decoration: BoxDecoration(
                            color: themeProvider.isLightTheme
                                ? Colors.grey[100]
                                : Colors.grey[500],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    "${userProvider.streamCategories[_selectedCat].subCategories[i].name}"),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) {
                                return FilterPage(
                                  category: userProvider
                                      .streamCategories[_selectedCat],
                                  subCategory: userProvider
                                      .streamCategories[_selectedCat]
                                      .subCategories[i],
                                );
                              },
                              fullscreenDialog: false));
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
