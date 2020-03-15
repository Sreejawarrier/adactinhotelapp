import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:adactin_hotel_app/api/repo/cancel_booking_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/routes/app_routes.dart';
import 'package:adactin_hotel_app/base/adactin_label/widget/adactin_label.dart';
import 'package:adactin_hotel_app/base/adactin_text/widget/adactin_text.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/global/global_constants.dart';
import 'package:adactin_hotel_app/hotel_detail/bloc/hotel_detail_bloc.dart';
import 'package:adactin_hotel_app/hotel_detail/constants/hotel_detail_content.dart';
import 'package:adactin_hotel_app/hotel_detail/constants/hotel_detail_semantics.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class HotelDetailPage<T> extends StatefulWidget {
  final AppBloc appBloc;
  final T hotel;

  HotelDetailPage({Key key, @required this.appBloc, @required this.hotel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HotelDetailPage();
}

class _HotelDetailPage extends State<HotelDetailPage> {
  @override
  Widget build(BuildContext context) {
    setStatusBarColor();

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            HotelDetailContent.pageTitle,
            semanticsLabel: HotelDetailSemantics.pageTitle,
          ),
        ),
        body: BlocProvider(
          create: (context) {
            return HotelDetailBloc(
              cancelBookingRepository: CancelBookingRepository(),
            );
          },
          child: BlocListener<HotelDetailBloc, HotelDetailState>(
            listener: (context, state) {
              if (state is HotelCancellationSuccessful && state.success) {
                _hotelBookingCancellationSuccessAlert(context);
              } else if (state is HotelDetailFailure) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      semanticLabel: HotelDetailSemantics.failureAlert,
                      title: Text(HotelDetailContent.alertFailureTitle),
                      content: Text(state.error),
                      actions: <Widget>[
                        FlatButton(
                          child: Semantics(
                            enabled: true,
                            explicitChildNodes: true,
                            label: HotelDetailSemantics.failureAlertButton,
                            child: Text(HotelDetailContent.alertButtonOk),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                  barrierDismissible: false,
                );
              }
            },
            child: BlocBuilder<HotelDetailBloc, HotelDetailState>(
              builder: (context, state) {
                return Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          _getHotelDetail(context),
                          _getBottomButton(context),
                        ],
                      ),
                    ),
                    state is CallInProgress
                        ? Spinner()
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void setStatusBarColor() {
    FlutterStatusbarcolor.setStatusBarColor(Palette.primaryColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  }

  Future<bool> _onBackPressed() {
    _checkStatusColor();
    return Future.value(true);
  }

  void _checkStatusColor() {
    if (widget.hotel is HotelSearchResult) {
      setStatusBarColor();
    } else {
      FlutterStatusbarcolor.setStatusBarColor(Colors.grey.withOpacity(0.2));
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }
  }

  /// --- --- --- Hotel Detail --- --- ---

  Widget _getHotelDetail(BuildContext context) {
    final List<Widget> hotelDetailsColumnList = [];
    if (widget.hotel is BookedItinerary) {
      hotelDetailsColumnList.addAll(_getOrderIdDetails(context));
    }
    hotelDetailsColumnList.addAll(_getHotelNameDetails(context));
    hotelDetailsColumnList.addAll(_getLocationDetails(context));
    hotelDetailsColumnList.addAll(_getRoomsDetails(context));
    if (widget.hotel is BookedItinerary) {
      hotelDetailsColumnList.addAll(_getFirstNameDetails(context));
      hotelDetailsColumnList.addAll(_getLastNameDetails(context));
    }
    hotelDetailsColumnList.addAll(_getArrivalDateDetails(context));
    hotelDetailsColumnList.addAll(_getDepartureDateDetails(context));
    hotelDetailsColumnList.addAll(_getNoOfDaysDetails(context));
    hotelDetailsColumnList.addAll(_getRoomsTypeDetails(context));
    hotelDetailsColumnList.addAll(_getPricePerNightDetails(context));
    hotelDetailsColumnList.addAll(_getTotalPriceDetails(context));
    hotelDetailsColumnList.add(const SizedBox(height: 128));

    return Semantics(
      enabled: true,
      explicitChildNodes: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: hotelDetailsColumnList,
        ),
      ),
    );
  }

  List<Widget> _getOrderIdDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.orderId),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.orderId,
        (widget.hotel as BookedItinerary)?.orderId ?? '',
      ),
    ];
  }

  List<Widget> _getHotelNameDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.hotelName),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelName,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.hotelName
            : (widget.hotel is BookedItinerary ? widget.hotel.hotelName : ''),
      ),
    ];
  }

  List<Widget> _getLocationDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.location),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelLocation,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.location
            : (widget.hotel is BookedItinerary ? widget.hotel.location : ''),
      ),
    ];
  }

  List<Widget> _getRoomsDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.rooms),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelRooms,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.getNoOfRooms()
            : (widget.hotel is BookedItinerary ? widget.hotel.rooms : ''),
      ),
    ];
  }

  List<Widget> _getFirstNameDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.firstName),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.fistName,
        (widget.hotel as BookedItinerary)?.firstName ?? '',
      ),
    ];
  }

  List<Widget> _getLastNameDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.lastName),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.lastName,
        (widget.hotel as BookedItinerary)?.lastName ?? '',
      ),
    ];
  }

  List<Widget> _getArrivalDateDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.arrivalDate),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelArrivalDate,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.getFormattedArrivalDate()
            : (widget.hotel is BookedItinerary ? widget.hotel.arrivalDate : ''),
      ),
    ];
  }

  List<Widget> _getDepartureDateDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.departureDate),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelDepartureDate,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.getFormattedDepartureDate()
            : (widget.hotel is BookedItinerary
                ? widget.hotel.departureDate
                : ''),
      ),
    ];
  }

  List<Widget> _getNoOfDaysDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.noOfDays),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelNoOfDays,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.noOfDays.toString()
            : (widget.hotel is BookedItinerary ? widget.hotel.noOfDays : ''),
      ),
    ];
  }

  List<Widget> _getRoomsTypeDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.roomsType),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelRoomType,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.roomsType
            : (widget.hotel is BookedItinerary ? widget.hotel.roomType : ''),
      ),
    ];
  }

  List<Widget> _getPricePerNightDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(HotelDetailContent.pricePerNight),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelPricePerNight,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.pricePerNight
            : (widget.hotel is BookedItinerary
                ? '${GlobalConstants.audPriceFormat}'
                    '${(widget.hotel as BookedItinerary).pricePerNight}'
                : ''),
      ),
    ];
  }

  List<Widget> _getTotalPriceDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel((widget.hotel is HotelSearchResult)
          ? HotelDetailContent.totalPriceExclGST
          : HotelDetailContent.totalPriceInclGST),
      const SizedBox(height: 4),
      _getTextField(
        HotelDetailSemantics.hotelTotalPrice,
        (widget.hotel is HotelSearchResult)
            ? widget.hotel.totalPrice
            : (widget.hotel is BookedItinerary
                ? '${GlobalConstants.audPriceFormat}'
                    '${(widget.hotel as BookedItinerary).finalPrice}'
                : ''),
      ),
    ];
  }

  /// --- --- --- Label --- --- ---

  Widget _getLabel(String label) {
    return AdactinLabel(
      labelData: label,
      isRequiredField: false,
      leftPadding: 0,
    );
  }

  /// --- --- --- Text field --- --- ---

  Widget _getTextField(
    String semanticLabel,
    String text,
  ) {
    return AdactinText(semanticLabel: semanticLabel, text: text);
  }

  /// --- --- --- Continue button --- --- ---

  Widget _getBottomButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: _getContinueOrCancelButton(context),
        ),
      ),
    );
  }

  Widget _getContinueOrCancelButton(BuildContext context) {
    return Semantics(
      label: (widget.hotel is HotelSearchResult)
          ? HotelDetailSemantics.continueButton
          : HotelDetailSemantics.cancelButton,
      enabled: true,
      explicitChildNodes: true,
      child: RaisedButton(
        onPressed: () {
          if (widget.hotel is HotelSearchResult) {
            Navigator.of(context).pushNamed(
              AppRoutes.BOOK_HOTEL,
              arguments: widget.hotel,
            );
          } else {
            _hotelBookingCancellationConfirmationAlert(
              context,
              BlocProvider.of<HotelDetailBloc>(context),
            );
          }
        },
        child: Text(
          (widget.hotel is HotelSearchResult)
              ? HotelDetailContent.selectTxt
              : HotelDetailContent.cancelTxt,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        color: Palette.primaryColor,
        highlightColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _hotelBookingCancellationConfirmationAlert(
    BuildContext context,
    HotelDetailBloc hotelDetailBloc,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          semanticLabel: HotelDetailSemantics.confirmationAlert,
          title: Text(HotelDetailContent.alertConfirmTitle),
          content: Text(HotelDetailContent.alertCancellationConfirmMessage
              .replaceAll(HotelDetailContent.orderIdKey,
                  (widget.hotel as BookedItinerary).orderId)),
          actions: <Widget>[
            FlatButton(
              child: Semantics(
                enabled: true,
                explicitChildNodes: true,
                label: HotelDetailSemantics.confirmCancelButton,
                child: Text(HotelDetailContent.alertButtonCancel),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Semantics(
                enabled: true,
                explicitChildNodes: true,
                label: HotelDetailSemantics.cancelBookingOkButton,
                child: Text(HotelDetailContent.alertButtonOk),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                hotelDetailBloc.add(
                  CancelHotelAction(
                    appBloc: widget.appBloc,
                    bookedItinerary: (widget.hotel as BookedItinerary),
                  ),
                );
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  void _hotelBookingCancellationSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          semanticLabel: HotelDetailSemantics.successAlert,
          title: Text(HotelDetailContent.alertSuccessTitle),
          content: Text(HotelDetailContent.bookingCancellationSuccess),
          actions: <Widget>[
            FlatButton(
              child: Semantics(
                enabled: true,
                explicitChildNodes: true,
                label: HotelDetailSemantics.successAlertButton,
                child: Text(HotelDetailContent.alertButtonOk),
              ),
              onPressed: () {
                _checkStatusColor();
                widget.appBloc.add(
                  BookingCancelled(
                    cancellationTime: DateTime.now(),
                  ),
                );
                Navigator.of(context).popUntil((route) {
                  return (route.settings.name == Navigator.defaultRouteName);
                });
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }
}
