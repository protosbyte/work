part of 'category_bloc.dart';

class CategoryState extends Equatable {
  CategoryState();

  @override
  List<Object> get props => [];
}

class Loading extends CategoryState {
  Loading() : super();
}

class LoadDataSuccess extends CategoryState {
  final List<Category> categories;

  LoadDataSuccess({required this.categories});

  @override
  List<Object> get props => [categories];
}

class LoadDataFail extends CategoryState {
  final dynamic error;

  LoadDataFail(this.error) : super();

  @override
  List<Object> get props =>[];
}