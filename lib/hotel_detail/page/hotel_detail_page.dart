import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:adactin_hotel_app/app/routes/app_routes.dart';
import 'package:adactin_hotel_app/hotel_detail/constants/hotel_detail_content.dart';
import 'package:adactin_hotel_app/hotel_detail/constants/hotel_detail_semantics.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';

class HotelDetailPage extends StatefulWidget {
  final HotelSearchResult hotel;

  HotelDetailPage({Key key, @required this.hotel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HotelDetailPage();
}

class _HotelDetailPage extends State<HotelDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          HotelDetailContent.pageTitle,
          semanticsLabel: HotelDetailSemantics.pageTitle,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            _getHotelDetail(context),
            _getBottomButton(context),
          ],
        ),
      ),
    );
  }

  /// --- --- --- Hotel Detail --- --- ---

  Widget _getHotelDetail(BuildContext context) {
    return Semantics(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.hotelName),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelName,
              widget.hotel.hotelName,
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.location),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelLocation,
              widget.hotel.location,
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.rooms),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelRooms,
              widget.hotel.getNoOfRooms(),
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.arrivalDate),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelArrivalDate,
              widget.hotel.getFormattedArrivalDate(),
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.departureDate),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelDepartureDate,
              widget.hotel.getFormattedDepartureDate(),
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.noOfDays),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelNoOfDays,
              widget.hotel.noOfDays.toString(),
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.roomsType),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelRoomType,
              widget.hotel.roomsType,
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.pricePerNight),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelPricePerNight,
              widget.hotel.pricePerNight,
            ),
            const SizedBox(height: 20),
            _getLabel(context, HotelDetailContent.totalPrice),
            const SizedBox(height: 4),
            _getTextField(
              context,
              HotelDetailSemantics.hotelTotalPrice,
              widget.hotel.totalPrice,
            ),
            const SizedBox(height: 128),
          ],
        ),
      ),
    );
  }

  /// --- --- --- Label --- --- ---

  Widget _getLabel(BuildContext context, String label) {
    return Semantics(
      enabled: true,
      label: label,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Palette.primaryColor,
          ),
        ),
      ),
    );
  }

  /// --- --- --- Text field --- --- ---

  Widget _getTextField(
    BuildContext context,
    String semanticLabel,
    String text,
  ) {
    return Semantics(
      label: semanticLabel,
      enabled: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
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
          child: _getContinueButton(context),
        ),
      ),
    );
  }

  Widget _getContinueButton(BuildContext context) {
    return Semantics(
      label: HotelDetailSemantics.continueButton,
      enabled: true,
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.BOOK_HOTEL,
            arguments: widget.hotel,
          );
        },
        child: Text(
          HotelDetailContent.selectTxt,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        color: Palette.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
