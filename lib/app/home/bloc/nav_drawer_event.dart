// this import is needed to import NavItem,
// which we'll use to represent the item the user has selected
import 'nav_drawer_state.dart';

// event, so that you can use it later in your BLoC and or tests
abstract class NavDrawerEvent {
  const NavDrawerEvent();
} // this is the event that's triggered when the user

// wants to change pages
class NavigateTo extends NavDrawerEvent {
  final NavItem destination;

  const NavigateTo(this.destination);
}
