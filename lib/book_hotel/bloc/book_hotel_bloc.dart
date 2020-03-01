import 'package:adactin_hotel_app/api/models/book_hotel.dart';
import 'package:adactin_hotel_app/api/models/booking_details.dart';
import 'package:adactin_hotel_app/api/repo/book_hotel_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// ------------ Event

abstract class BookHotelEvent extends Equatable {
  const BookHotelEvent();
}

class BookHotelAction extends BookHotelEvent {
  final AppBloc appBloc;
  final BookHotel bookHotel;

  const BookHotelAction({
    @required this.appBloc,
    @required this.bookHotel,
  })  : assert(appBloc != null, 'Need appbloc for token'),
        assert(bookHotel != null, 'Provide proper hotel data for bokking');

  @override
  List<Object> get props => [appBloc, bookHotel];

  @override
  String toString() {
    return 'BookHotelAction { appBloc: $appBloc, hotelDetails: $bookHotel }';
  }
}

/// ------------ State

abstract class BookHotelState extends Equatable {
  const BookHotelState();

  @override
  List<Object> get props => [];
}

class BookHotelInitial extends BookHotelState {}

class BookingInProcess extends BookHotelState {}

class BookingSuccessful extends BookHotelState {
  final BookingDetails bookingDetails;

  const BookingSuccessful(this.bookingDetails);

  @override
  List<Object> get props => [bookingDetails];

  @override
  String toString() {
    return 'BookingSuccessful { bookingDetails: $bookingDetails }';
  }
}

class BookingFailure extends BookHotelState {
  final String error;

  const BookingFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'BookingFailure { error: $error }';
  }
}

/// ------------ Bloc

class BookHotelBloc extends Bloc<BookHotelEvent, BookHotelState> {
  final BookHotelRepository bookHotelRepository;

  BookHotelBloc({
    @required this.bookHotelRepository,
  }) : assert(bookHotelRepository != null,
            'Provide repository for booking hotel');

  @override
  BookHotelState get initialState => BookHotelInitial();

  @override
  Stream<BookHotelState> mapEventToState(BookHotelEvent event) async* {
    if (event is BookHotelAction) {
      yield BookingInProcess();

      try {
        yield BookingSuccessful(
          await bookHotelRepository.book(
            token: event.appBloc.userDetails.token,
            bookHotel: event.bookHotel,
          ),
        );
      } catch (error) {
        yield BookingFailure(error: error.toString());
      }
    }
  }
}
