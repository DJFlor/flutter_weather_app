abstract class ILocationSearchBarDelegate {
  bool isSearching();
  void setSearching(bool searching);
  void searchStringUpdated(String searchString);
}
