import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/searchbar-controller.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final SearchBarController searchController;

  CustomSearchDelegate(this.searchController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    searchController.getSearchData(query);

    return Obx(
          () {
        if (searchController.searchResults.isEmpty) {
          return Center(
            child: Text('No results found'),
          );
        }

        return ListView.builder(
          itemCount: searchController.searchResults.length,
          itemBuilder: (context, index) {
            final product = searchController.searchResults[index];
            return ListTile(
              title: Text(product.productName),
            );
          },
        );
      },
    );
  }
}