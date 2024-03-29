import 'package:addies_shamiyana/src/constants/colors.dart';
import 'package:addies_shamiyana/src/features/menu/screens/search/item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './menu_data_temp.dart';
import './category_tile.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<String> categories = [];
  List<Widget> categoryTiles = [];
  List<dynamic> menu_ = [];
  List<Widget> searchResults = [];
  Map<String, List<dynamic>> categoryItems = {};
  bool searchFocused = false;
  final searchTextController = TextEditingController();

  Map<String, Map<String, List<dynamic>>> subCategories = {};

  List<Widget> makeCategories(List<dynamic> menu) {

    menu_ = menu;
    categories = [];
    categoryTiles = [];
    categoryItems = {};
    for (int i = 0; i < menu.length; i++) {
      if (categories.contains(menu[i]["category"])) {
        categoryItems[menu[i]["category"]]?.add(menu[i]);
      }
      else {
        categories.add(menu[i]["category"]);
        categoryItems[menu[i]["category"]] = [];
        categoryItems[menu[i]["category"]]?.add(menu[i]);
      }
    }

    for (int i = 0; i < categories.length; i += 3) {
      Widget w1 = i < categories.length
          ? CategoryTile(categoryTitle: categories[i], categoryItems: categoryItems[categories[i]],)
          : const SizedBox(height: 100, width: 100);
      Widget w2 = i + 1 < categories.length
          ? CategoryTile(categoryTitle: categories[i+1], categoryItems: categoryItems[categories[i+1]],)
          : const SizedBox(height: 100, width: 100);
      Widget w3 = i + 2 < categories.length
          ? CategoryTile(categoryTitle: categories[i+2], categoryItems: categoryItems[categories[i+2]],)
          : const SizedBox(height: 100, width: 100);
      categoryTiles.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [w1, w2, w3],
      ));
    }
    return categoryTiles;

  }



  List<dynamic> fetchMenu() {
    var _instance = FirebaseFirestore.instance;
    // print("In fetch");
    final docRef = _instance.collection("Menu").doc("FullMenu");
    // print(docRef);
    docRef.get().then(
            (DocumentSnapshot doc) {
          // print("then");
          // final data = doc.data() as Map<String, List<Map<String, dynamic>>>;
          final data = doc.data() as Map<String, dynamic>;
          print('menu fetched');
          setState(() {
            // menu = data['menu'];
            categoryTiles = makeCategories(data['menu']);
          });
          return data['menu'];
        },
        onError: (e) {
          // print("Error getting document: $e");
          return [{"Error": "Something1"}];
        }
    );
    return [{"Error": "Something2"}];
  }

  void getSearchResults(String query) {
    List<Widget> results = [];
    print(query);
    for (var element in menu_) {
      // ''.toLowerCase()
      // print(1);
      if(element['name'].toLowerCase().contains(query.toLowerCase())) {
        results.add(ItemCard(itemInfo: element)) ;
      }
    }
    print(results.length);
    setState(() {
      searchResults = results;
    });
    // return results;
  }

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }





  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text("Browse",
                  style: Theme.of(context).textTheme.displayLarge
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 40, 5),
              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 2, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Builder(
                          builder: (context) {
                            return TextFormField(
                              controller: searchTextController,
                              onTap:(){
                                setState(() {
                                  searchFocused = true;
                                });
                              },
                              onTapOutside: (event){
                                // FocusManager.instance.primaryFocus?.unfocus();
                                // searchFocused = false;
                              },
                              onChanged: (query){
                                getSearchResults(query);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                  fontSize: 20
                              ),
                            );
                          }
                      ),
                    ),
                    IconButton(
                      icon: searchFocused ? Icon(Icons.close) : Icon(Icons.search),
                      onPressed: () {
                        // close button pressed
                        if (searchFocused) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          searchFocused = false;
                          searchTextController.clear();
                        }
                        // search button pressed
                        else {
                          searchFocused = true;
                        }
                      },
                      splashRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Visibility(
              visible: !searchFocused,
              child: Container(
                  height: 500,
                  child: ListView(
                    children: [
                      Center(
                        child: Wrap(
                          spacing: 20.0,
                          runSpacing: 10.0,
                          children: categoryTiles,
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Visibility(
                visible: searchFocused,
                child: Center(
                  child: Column(
                    children: searchResults,
                  ),
                ))

          ]
      ),
    );
  }
}
