import 'package:adactin_hotel_app/api/models/booking_details.dart';
import 'package:adactin_hotel_app/base/adactin_label/widget/adactin_label.dart';
import 'package:adactin_hotel_app/base/adactin_text/widget/adactin_text.dart';
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
      _getLabel(BookingDetailsContent.hotelName),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.hotelName,
        widget.details.hotelName,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.location),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.location,
        widget.details.location,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.roomType),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.roomType,
        widget.details.roomType,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.arrivalDate),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.arrivalDate,
        widget.details.arrivalDate,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.departureDate),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.departureDate,
        widget.details.departureDate,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.totalRooms),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.totalRooms,
        widget.details.getTotalRooms(),
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.adultsPerRoom),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.adultsPerRoom,
        widget.details.getPersonsPerRoom(widget.details.adultsPerRoom),
      ),
    ];
  }

  List<Widget> _getChildrenDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.childrenPerRoom),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.childrenPerRoom,
        widget.details.getPersonsPerRoom(widget.details.childrenPerRoom),
      ),
    ];
  }

  List<Widget> _getRestOfTheDetails(BuildContext context) {
    return [
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.pricePerNight),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.pricePerNight,
        widget.details.pricePerNight,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.totalPrice),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.totalPrice,
        widget.details.totalPrice,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.gst),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.gst,
        widget.details.gst,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.finalBilledPrice),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.finalBilledPrice,
        widget.details.finalBilledPrice,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.firstName),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.firstName,
        widget.details.firstName,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.lastName),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.lastName,
        widget.details.lastName,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.billingAddress),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.billingAddress,
        widget.details.billingAddress,
      ),
      const SizedBox(height: 20),
      _getLabel(BookingDetailsContent.orderNo),
      const SizedBox(height: 4),
      _getTextField(
        BookingDetailsSemanticKeys.orderNo,
        widget.details.orderID,
      ),
      const SizedBox(height: 40),
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
