import 'package:adactin_hotel_app/api/models/hotel_search.dart';
import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:adactin_hotel_app/api/repo/hotel_search_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// ------------ Event

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HotelSearchAction extends HomeEvent {
  final AppBloc appBloc;
  final HotelSearch hotelSearch;

  const HotelSearchAction({
    @required this.appBloc,
    @required this.hotelSearch,
  })  : assert(appBloc != null, 'Need appbloc for token'),
        assert(hotelSearch != null, 'Provide proper hotel search data');

  @override
  List<Object> get props => [appBloc, hotelSearch];

  @override
  String toString() {
    return 'HotelSearchAction { appBloc: $appBloc, search: $hotelSearch }';
  }
}

/// ------------ State

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class SearchInProcess extends HomeState {}

class HotelSearchSuccess extends HomeState {
  final List<HotelSearchResult> hotelSearchResultList;

  const HotelSearchSuccess({@required this.hotelSearchResultList});

  @override
  List<Object> get props => [hotelSearchResultList];

  @override
  String toString() {
    return 'HotelSearchSuccess { hotelSearchResultList: $hotelSearchResultList }';
  }
}

class HotelSearchFailure extends HomeState {
  final String error;

  const HotelSearchFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'HotelSearchFailure { error: $error }';
  }
}

/// ------------ Bloc

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HotelSearchRepository hotelSearchRepository;

  HomeBloc({
    @required this.hotelSearchRepository,
  }) : assert(hotelSearchRepository != null, 'Provide repository for search');

  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HotelSearchAction) {
      yield SearchInProcess();

      try {
        yield HotelSearchSuccess(
          hotelSearchResultList: await hotelSearchRepository.searchForHotels(
            token: event.appBloc.userDetails.token,
            hotelSearch: event.hotelSearch,
          ),
        );
      } catch (error) {
        yield HotelSearchFailure(error: error.toString());
      }
    }
  }
}
