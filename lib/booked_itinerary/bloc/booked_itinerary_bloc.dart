import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/api/repo/booked_itinerary_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// ------------ Event

abstract class BookedItineraryEvent extends Equatable {
  const BookedItineraryEvent();
}

class FetchBookingsAction extends BookedItineraryEvent {
  final AppBloc appBloc;

  const FetchBookingsAction({
    @required this.appBloc,
  }) : assert(appBloc != null, 'Need appbloc for token');

  @override
  List<Object> get props => [appBloc];

  @override
  String toString() {
    return 'FetchBookingsAction { appBloc: $appBloc }';
  }
}

/// ------------ State

abstract class BookedItineraryState extends Equatable {
  const BookedItineraryState();

  @override
  List<Object> get props => [];
}

class BookedItineraryInitial extends BookedItineraryState {}

class SearchInProcess extends BookedItineraryState {}

class BookedItinerarySuccess extends BookedItineraryState {
  final List<BookedItinerary> bookedItineraryList;

  const BookedItinerarySuccess({this.bookedItineraryList});

  @override
  List<Object> get props => [bookedItineraryList];

  @override
  String toString() {
    return 'BookedItinerarySuccess { bookedItineraries: $bookedItineraryList }';
  }
}

class BookedItineraryFailure extends BookedItineraryState {
  final String error;

  const BookedItineraryFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'BookedItineraryFailure { error: $error }';
  }
}

/// ------------ Bloc

class BookedItineraryBloc
    extends Bloc<BookedItineraryEvent, BookedItineraryState> {
  final BookedItineraryRepository bookedItineraryRepository;

  BookedItineraryBloc({
    @required this.bookedItineraryRepository,
  }) : assert(bookedItineraryRepository != null,
            'Provide repository for bookings');

  @override
  BookedItineraryState get initialState => BookedItineraryInitial();

  @override
  Stream<BookedItineraryState> mapEventToState(
    BookedItineraryEvent event,
  ) async* {
    if (event is FetchBookingsAction) {
      yield SearchInProcess();

      try {
        final List<BookedItinerary> bookedHotelsList =
            await bookedItineraryRepository.bookedHotels(
          token: event.appBloc.userDetails.token,
        );
        yield BookedItinerarySuccess(
          bookedItineraryList: bookedHotelsList,
        );
      } catch (error) {
        yield BookedItineraryFailure(error: error.toString());
      }
    }
  }
}
