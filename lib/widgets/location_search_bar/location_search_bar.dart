import 'package:flutter/material.dart';
import 'package:flutter_weather_app/widgets/location_search_bar/i_location_search_bar_delegate.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    super.key,
    required this.delegate,
    required this.searchBarFocusNode,
    required this.searchController,
  });

  final ILocationSearchBarDelegate delegate;
  final FocusNode searchBarFocusNode;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searching = delegate.isSearching();

    return SliverAppBar(
      pinned: true,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80),
              bottomRight: Radius.circular(80))),
      expandedHeight: 90,
      collapsedHeight: 90,
      backgroundColor: theme.primaryColor,
      titleSpacing: 25,
      /**
                 * 
                 * I'm choosing to use a TextField only here, and not a SearchAnchor
                 * owing to the fact that the suggestion builder of the anchor is only
                 * refreshed at the exact instant the text changes.  Our suggestions are
                 * coming from an asyc source, the WeatherAPI search/autocomplete endpoint,
                 * and will arrive after the suggestion builder is refreshed. 
                 * 
                 * The accepted work-around is to insert zero-width unicode spaces into the 
                 * search string to affect a refresh, but I do not like sullying the data
                 * that way, as downstreamm issues may arise, requiring us to prune the 
                 * zero-width spaces, and that is too much squeeze for not enough juice.
                 * 
                 * It is bewtter to keep the data clean, and not play such games.
                 * 
                 * Also, the SearchBar enforces spell checking, and we don't want that for
                 * this.  Full stop.  With TextField, we can turn it off.
                 *
                 * So instead, we use only a TextField, and a manually implemented
                 * suggestion list, so that it might refresh when the suggestions change.
                 *
                 */

      title: TextField(
        focusNode: searchBarFocusNode,
        enableSuggestions: false,
        spellCheckConfiguration: SpellCheckConfiguration.disabled(),
        controller: searchController,
        // Handler called whenever the text changes:
        onChanged: (value) {
          // If we have cleared, clear the focus:
          if (searchController.text == "") {
            searchBarFocusNode.unfocus();
          }
          // Notify the delegate:
          delegate.searchStringUpdated(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          hintText: 'Enter new location',
          contentPadding: EdgeInsets.all(20),
          /**
           * The suffix icon, when searching, is a "close" style
           * icon button that clears the search.  When not searching,
           * the trailing icon is a vanilla search icon with no action.
           */
          suffixIcon: searching
              ? IconButton(
                  onPressed: () {
                    // Unfocus
                    FocusScope.of(context).unfocus();
                    // clear search field
                    searchController.clear();
                    // update delegate
                    delegate.setSearching(false);
                  },
                  icon: const Icon(Icons.close))
              : const Icon(Icons.search),
        ),
      ),
    );
  }
}
