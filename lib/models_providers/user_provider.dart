import 'dart:async';

import 'package:classified_flutter/models/categories.dart';
import 'package:classified_flutter/models/chats.dart';
import 'package:classified_flutter/models/product.dart';
import 'package:classified_flutter/models/subCategories.dart';
import 'package:classified_flutter/models/user.dart';
import 'package:classified_flutter/models_services/ad_service.dart';
import 'package:classified_flutter/models_services/auth_service.dart';
import 'package:classified_flutter/models_services/category_service.dart';
import 'package:classified_flutter/models_services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UserProvider with ChangeNotifier {
  User _authUser = User();
  User get authUser => _authUser;
/* -------------------------------- NOTE Init ------------------------------- */
  Future initState() async {
    var res = await AuthService.streamAuthUser();
    res.listen((r) {
      _authUser = r;
      fetchStreamCategories();
      fetchStreamAllAds();
      fetchStreamMyAds();
      fetchStreamFeaturedAds();
      fetchStreamLocation();
      fetchStreamMostVieweddAds();
      fetchStreamMostRecentdAds();
      fetchStreamChats();
      notifyListeners();
    });
  }

  /* ------------------------------ NOTE Ads ----------------------------- */

  StreamSubscription<List<Product>> _streamSubscriptionMyAds;
  List<Product> _streamMyAds = [];
  List<Product> get streamMyAds => _streamMyAds;
  Future fetchStreamMyAds() async {
    var res = await AdService.streamUserProducts(user: authUser);
    _streamSubscriptionMyAds = res.listen((r) {
      _streamMyAds = r;
      notifyListeners();
    });
  }

  StreamSubscription<List<Product>> _streamSubscriptionAllAds;
  List<Product> _streamAllAds = [];
  List<Product> get streamAllAds => _streamAllAds;
  Future fetchStreamAllAds() async {
    var res = await AdService.streamAllProducts();
    _streamSubscriptionAllAds = res.listen((r) {
      _streamAllAds = r;

      notifyListeners();
    });
  }

  Future fetchStreamAllAdsPagination(
      {String category, String subCategory, Product product}) async {
    var res = await AdService.streamAllProductsPagination(product: product);
    _streamSubscriptionAllAds = res.listen((r) {
      _streamAllAds.addAll(r);
      // if (!(r.length < 50)) {
      //   _streamAllAds.addAll(r);
      //   // print(_streamAllAds.length);
      // }

      notifyListeners();
    });
  }

  StreamSubscription<List<Product>> _streamSubscriptionFilterdAds;
  List<Product> _streamFilterdAds = [];
  List<Product> get streamFilterdAds => _streamFilterdAds;

  Future fetchFilterdAds(
      {Categories category, SubCategories subCategory}) async {
    _streamFilterdAds = [];
    var res = await AdService.streamAllProducts(
        category: category, subCategory: subCategory);
    _streamSubscriptionFilterdAds = res.listen((r) {
      _streamFilterdAds = r;
      notifyListeners();
    });
  }

  Future fetchFilterdPaginationdAds(
      {Categories category, Product product, SubCategories subCategory}) async {
    var res = await AdService.streamAllProductsPagination(
        product: product, category: category, subCategory: subCategory);
    _streamSubscriptionFilterdAds = res.listen((r) {
      _streamFilterdAds.addAll(r);

      notifyListeners();
    });
  }

  StreamSubscription<List<Product>> _streamSubscriptionFeaturedAds;
  List<Product> _streamFeaturedAds = [];
  List<Product> get streamFeaturedAds => _streamFeaturedAds;
  Future fetchStreamFeaturedAds() async {
    var res = await AdService.streamFeaturedProducts();
    _streamSubscriptionFeaturedAds = res.listen((r) {
      _streamFeaturedAds = r;
      notifyListeners();
    });
  }

  StreamSubscription<List<Product>> _streamSubscriptionMostViewedAds;
  List<Product> _streamMostViewedAds = [];
  List<Product> get streamMostViewedAds => _streamMostViewedAds;
  Future fetchStreamMostVieweddAds() async {
    var res = await AdService.streamMostViewedProducts();
    _streamSubscriptionMostViewedAds = res.listen((r) {
      _streamMostViewedAds = r;
      notifyListeners();
    });
  }

  StreamSubscription<List<Product>> _streamSubscriptionMostRecentAds;
  List<Product> _streamMostRecentAds = [];
  List<Product> get streamMostRecentAds => _streamMostRecentAds;
  Future fetchStreamMostRecentdAds() async {
    var res = await AdService.streamMostRecentProducts();
    _streamSubscriptionMostRecentAds = res.listen((r) {
      _streamMostRecentAds = r;
      notifyListeners();
    });
  }

  StreamSubscription<List<Product>> _streamSubscriptionSimilarAds;
  List<Product> _streamSimilarAds = [];
  List<Product> get streamSimilarAds => _streamSimilarAds;
  Future fetchStreamSimilarAds(Product product) async {
    var res =
        await AdService.streamSimilerProducts(user: authUser, product: product);
    _streamSubscriptionSimilarAds = res.listen((r) {
      _streamSimilarAds = r;
      notifyListeners();
    });
  }

  void increaseViewCount(Product product) async {
    AdService.increaseViewCount(product: product);
  }

  Future<bool> submitAd({Product product, List<Asset> imageAssets}) async {
    Categories categories = streamCategories
        .firstWhere((element) => element.name == product.category);
    product.categoryId = categories.id;
    SubCategories subCategory = categories.subCategories
        .firstWhere((element) => element.name == product.subCategory);
    product.subCategoryId = subCategory.id;
    bool res = await AdService.submitAdService(
        product: product, user: _authUser, imageAsset: imageAssets);

    return res;
  }

  /* ------------------------------ NOTE Categories ----------------------------- */
  StreamSubscription<List<Categories>> _streamSubscriptionCategories;
  List<Categories> _streamCategories = [];
  List<Categories> get streamCategories => _streamCategories;

  List<String> _categoryNames = [];
  List<String> get categoryNames => _categoryNames;
  set setCategoryNames(value) => _categoryNames;

  List<String> _subCategoryNames = [];
  List<String> get subCategoryNames => _subCategoryNames;
  set setsubCategoryNames(value) => _subCategoryNames;

  List<Options> _options = [];
  List<Options> get options => _options;
  set setoptions(value) => _options;

  Future fetchStreamCategories() async {
    var res = await CategoryService.streamCategories();
    _streamSubscriptionCategories = res.listen((r) {
      _streamCategories = r;
      _categoryNames = [];
      _subCategoryNames = [];
      _options = [];
      notifyListeners();
      _streamCategories.forEach((element) {
        _categoryNames.add(element.name);
      });
      notifyListeners();
    });
  }

  List _location = [];
  List get location => _location;
  Future fetchStreamLocation() async {}

  void getSubCategories(String categoryName) {
    _subCategoryNames = [];
    Categories category =
        _streamCategories.firstWhere((element) => element.name == categoryName);
    category.subCategories.forEach((element) {
      _subCategoryNames.add(element.name);
    });
    notifyListeners();
  }

  void getOptions(String categoryName, String subCategoryName) {
    _options = [];
    Categories category =
        _streamCategories.firstWhere((element) => element.name == categoryName);
    SubCategories subCategory = category.subCategories
        .firstWhere((element) => element.name == subCategoryName);

    _options = subCategory.options;
    notifyListeners();
  }

  /* ------------------------------ NOTE Chats ----------------------------- */
  StreamSubscription<List<Chats>> _streamSubscriptionChats;
  List<Chats> _streamChats = [];
  List<Chats> get streamChats => _streamChats;
  Future fetchStreamChats() async {
    var res = await ChatService.streamChats(user: authUser);
    _streamSubscriptionChats = res.listen((r) {
      _streamChats = [];
      _streamChats = r;
      _streamChats.forEach((chat) {
        chat.messages
            .sort((a, b) => b.timestampAdded.compareTo(a.timestampAdded));
      });
      print(_streamChats.length);
      if (_selectedChat != null) {
        _selectedChat = _streamChats.firstWhere(
            (element) => element.documentId == _selectedChat.documentId);
      }
      notifyListeners();
    });
  }

  Chats _selectedChat;
  Chats get selectedChat => _selectedChat;
  set setSelectedChat(String id) {
    _selectedChat =
        _streamChats.firstWhere((element) => element.documentId == id);
  }

  Future sendChatMessage({String msg, Product product}) async {
    Messages message = new Messages();
    message.message = msg;
    message.uuid = authUser.id;
    Chats chats = new Chats();
    chats.uuids = [authUser.id, product.user.id];
    chats.message = message;
    chats.senderName = authUser.fullName;
    chats.reciverName = product.user.fullName;
    chats.senderUuid = authUser.id;
    chats.reciverUuid = product.user.id;
    chats.productId = product.id;
    chats.productTitle = product.title;
    chats.productLocation = '${product.district},${product.city}';
    chats.productImgUrl = product.imgUrls[0];
    chats.productIsSold = product.isSold;

    await ChatService.sendChatMessage(
        chats: chats, product: product, user: authUser);
  }

  Future sendRealTimeMessage({Chats chats, String newMessage}) async {
    Messages message = new Messages();
    message.message = newMessage;
    message.uuid = authUser.id;
    await ChatService.sendRealTimeChat(chats: chats, message: message);
  }

  Future changeChatReaded({Chats chats}) async {
    await ChatService.changeChatIsReded(chats: chats);
  }
  /* ------------------------------ NOTE State ----------------------------- */

  void clearStreams() {
    _streamSubscriptionCategories?.cancel();
    _streamSubscriptionAllAds?.cancel();
    _streamSubscriptionMyAds?.cancel();
    _streamSubscriptionFeaturedAds?.cancel();
    _streamSubscriptionMostViewedAds?.cancel();
    _streamSubscriptionMostRecentAds?.cancel();
    _streamSubscriptionFilterdAds?.cancel();
    _streamSubscriptionSimilarAds?.cancel();
    _streamSubscriptionChats?.cancel();
  }

  void clearAllStates() {
    _authUser = null;
    _streamMyAds = [];
    _streamMyAds = [];
    _streamFilterdAds = [];
    _streamMostRecentAds = [];
    _streamCategories = [];
    _streamSimilarAds = [];
    _streamChats = [];
    _options = [];
  }
}
