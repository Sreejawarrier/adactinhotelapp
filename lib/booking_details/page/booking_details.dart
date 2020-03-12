import 'package:adactin_hotel_app/api/models/booking_details.dart';
import 'package:adactin_hotel_app/booking_details/constants/booking_details_content.dart';
import 'package:adactin_hotel_app/booking_details/constants/booking_details_semantic_keys.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';

class BookingDetailsPage extends StatefulWidget {
  final BookingDetails details;

  BookingDetailsPage({Key key, this.details}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            _getBookingDetail(context),
          ],
        ),
      ),
    );
  }

  /// --- --- --- App bar --- --- ---

  PreferredSizeWidget _getAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        BookingDetailsContent.pageTitle,
        semanticsLabel: BookingDetailsSemanticKeys.pageTitle,
      ),
      leading: const SizedBox.shrink(),
      actions: <Widget>[
        Semantics(
          enabled: true,
          explicitChildNodes: true,
          label: BookingDetailsSemanticKeys.appBarCloseButton,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _navigateToRoot(context);
            },
          ),
        ),
      ],
    );
  }

  /// --- --- --- Booking Detail --- --- ---

  Widget _getBookingDetail(BuildContext context) {
    final List<Widget> viewItemWidgets = [];
    viewItemWidgets.addAll(_getInitialDetails(context));
    if (widget.details.childrenPerRoom?.isNotEmpty == true) {
      viewItemWidgets.addAll(_getChildrenDetails(context));
    }
    viewItemWidgets.addAll(_getRestOfTheDetails(context));
    viewItemWidgets.add(_getBottomButton(context));

    return Semantics(
      enabled: true,
      explicitChildNodes: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: viewItemWidgets,
        ),
      ),
    );
  }

  List<Widget> _getInitialDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.hotelName),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.hotelName,
        widget.details.hotelName,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.location),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.location,
        widget.details.location,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.roomType),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.roomType,
        widget.details.roomType,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.arrivalDate),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.arrivalDate,
        widget.details.arrivalDate,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.departureDate),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.departureDate,
        widget.details.departureDate,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.totalRooms),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.totalRooms,
        widget.details.getTotalRooms(),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.adultsPerRoom),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.adultsPerRoom,
        widget.details.getPersonsPerRoom(widget.details.adultsPerRoom),
      ),
    ];
  }

  List<Widget> _getChildrenDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.childrenPerRoom),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.childrenPerRoom,
        widget.details.getPersonsPerRoom(widget.details.childrenPerRoom),
      ),
    ];
  }

  List<Widget> _getRestOfTheDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.pricePerNight),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.pricePerNight,
        widget.details.pricePerNight,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.totalPrice),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.totalPrice,
        widget.details.totalPrice,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.gst),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.gst,
        widget.details.gst,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.finalBilledPrice),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.finalBilledPrice,
        widget.details.finalBilledPrice,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.firstName),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.firstName,
        widget.details.firstName,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.lastName),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.lastName,
        widget.details.lastName,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.billingAddress),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.billingAddress,
        widget.details.billingAddress,
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookingDetailsContent.orderNo),
      const SizedBox(height: 4),
      _getTextField(
        context,
        BookingDetailsSemanticKeys.orderNo,
        widget.details.orderID,
      ),
      const SizedBox(height: 40),
    ];
  }

  /// --- --- --- Label --- --- ---

  Widget _getLabel(BuildContext context, String label) {
    return Semantics(
      enabled: true,
      explicitChildNodes: true,
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
      explicitChildNodes: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  /// --- --- --- Done button --- --- ---

  Widget _getBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: _getDoneButton(context),
      ),
    );
  }

  Widget _getDoneButton(BuildContext context) {
    return Semantics(
      label: BookingDetailsSemanticKeys.doneButton,
      enabled: true,
      explicitChildNodes: true,
      child: RaisedButton(
        onPressed: () {
          _navigateToRoot(context);
        },
        child: Text(
          BookingDetailsContent.doneButton,
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

  /// --- --- --- Navigate to Root --- --- ---

  void _navigateToRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      return (route.settings.name == Navigator.defaultRouteName);
    });
  }
}
