import 'package:bloc/bloc.dart';

import 'nav_drawer_event.dart';
import 'nav_drawer_state.dart';

class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {
  NavDrawerBloc() : super(const NavDrawerState(NavItem.home_item));

  @override
  Stream<NavDrawerState> mapEventToState(NavDrawerEvent event) async* {
    // this is where the events are handled, if you want to call a method
    // you can yield* instead of the yield, but make sure your
    // method signature returns Stream<NavDrawerState> and is async*
    if (event is NavigateTo) {
      // only route to a new location if the new location is different
      //if (event.destination != state.selectedItem) {
      yield NavDrawerState(event.destination);
      //}
    }
  }
}
