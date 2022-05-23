import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whiteboard/datakit/models/category.dart';
import 'package:whiteboard/datakit/repository/category/category_client.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  CategoryClient service;

  CategoryBloc(this.service) : super(Loading());

  @override
   CategoryState get initialState => Loading();

   @override
  Stream<Transition<CategoryEvent, CategoryState>> transformEvents(
      Stream<CategoryEvent> events,
      TransitionFunction<CategoryEvent, CategoryState> transitionFn,
      ) {
    return super.transformEvents(
      events.throttleTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryFetched) {
      yield* _mapFetchHomeDataToStates(event);
    }
  }

  Stream<CategoryState> _mapFetchHomeDataToStates(CategoryEvent event) async* {
    try {
      final result = await service.getCategories();

      if (result.isEmpty) {
        yield LoadDataFail('Parse Error. Try Again.');
      } else {
        yield LoadDataSuccess(categories: result);
      }
    } catch (e) {
      print(e);
      yield LoadDataFail('Error occurred. Please try again.');
    }
  }
}
