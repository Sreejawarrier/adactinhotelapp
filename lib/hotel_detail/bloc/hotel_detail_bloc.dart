import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/api/repo/cancel_booking_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// ------------ Event

abstract class HotelDetailEvent extends Equatable {
  const HotelDetailEvent();
}

class CancelHotelAction extends HotelDetailEvent {
  final AppBloc appBloc;
  final BookedItinerary bookedItinerary;

  const CancelHotelAction({
    @required this.appBloc,
    @required this.bookedItinerary,
  })  : assert(appBloc != null, 'Need appbloc for token'),
        assert(bookedItinerary != null, 'Provide booked hotel data');

  @override
  List<Object> get props => [appBloc, bookedItinerary];

  @override
  String toString() {
    return 'CancelHotelAction { appBloc: $appBloc, bookedHotel: '
        '$bookedItinerary }';
  }
}

/// ------------ State

abstract class HotelDetailState extends Equatable {
  const HotelDetailState();

  @override
  List<Object> get props => [];
}

class HotelDetailInitial extends HotelDetailState {}

class CallInProgress extends HotelDetailState {}

class HotelCancellationSuccessful extends HotelDetailState {
  final bool success;

  const HotelCancellationSuccessful({this.success});

  @override
  List<Object> get props => [success];

  @override
  String toString() {
    return 'HotelCancellationSuccessful { success: $success }';
  }
}

class HotelDetailFailure extends HotelDetailState {
  final String error;

  const HotelDetailFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'HotelDetailFailure { error: $error }';
  }
}

/// ------------ Bloc

class HotelDetailBloc extends Bloc<HotelDetailEvent, HotelDetailState> {
  final CancelBookingRepository cancelBookingRepository;

  HotelDetailBloc({
    @required this.cancelBookingRepository,
  }) : assert(cancelBookingRepository != null,
            'Provide repository for cancelling hotel');

  @override
  HotelDetailState get initialState => HotelDetailInitial();

  @override
  Stream<HotelDetailState> mapEventToState(HotelDetailEvent event) async* {
    if (event is CancelHotelAction) {
      yield CallInProgress();

      try {
        yield HotelCancellationSuccessful(
          success: await cancelBookingRepository.cancelHotel(
            token: event.appBloc.userDetails.token,
            bookedItinerary: event.bookedItinerary,
          ),
        );
      } catch (error) {
        yield HotelDetailFailure(error: error.toString());
      }
    }
  }
}
