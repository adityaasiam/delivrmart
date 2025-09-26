import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/menu_item.dart';
import '../features/search/search_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUseCase useCase;

  SearchBloc({required this.useCase}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<CategorySelected>(_onCategorySelected);
    on<FetchResults>(_onFetch);
  }

  String _query = '';
  String _category = '';

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    _query = event.query;
    add(const FetchResults());
  }

  Future<void> _onCategorySelected(CategorySelected event, Emitter<SearchState> emit) async {
    _category = event.category ?? '';
    add(const FetchResults());
  }

  Future<void> _onFetch(FetchResults event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final results = await useCase.search(query: _query, category: _category.isEmpty ? null : _category);
      if (results.isEmpty) {
        emit(SearchLoaded(items: []));
      } else {
        emit(SearchLoaded(items: results));
      }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
