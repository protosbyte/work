// this is the state the user is expected to see
class NavDrawerState {
  final NavItem selectedItem;

  const NavDrawerState(this.selectedItem);
} // helpful navigation pages, you can change

// them to support your pages
enum NavItem {
  /// Keep current order for first 5
  home_item,
  search_item,
  add_item,
  notification_item,
  account_item,
  about_item,
  logout_item
}

NavItem getNavItem(int idx) {
  switch (idx) {
    case 1:
      return NavItem.search_item;
    case 4:
      return NavItem.add_item;
    case 2:
      return NavItem.notification_item;
    case 3:
      return NavItem.account_item;
    default:
      return NavItem.home_item;
  }
}
