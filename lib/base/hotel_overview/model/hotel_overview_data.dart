import 'package:adactin_hotel_app/api/models/hotel_searech_result.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class HotelOverviewData extends Equatable {
  final HotelSearchResult hotelSearchResult;
  final String name;
  final String location;
  final String fromDate;
  final String toDate;
  final String totalPrice;

  final DateFormat _fromDateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _toDateFormat = DateFormat('dd MMM');

  HotelOverviewData({
    this.hotelSearchResult,
    this.name,
    this.location,
    this.fromDate,
    this.toDate,
    this.totalPrice,
  });

  @override
  List<Object> get props => [
        hotelSearchResult,
        name,
        location,
        fromDate,
        toDate,
        totalPrice,
      ];

  String getStayDates() {
    final DateTime from = _fromDateFormat.parse(fromDate);
    final DateTime to = _fromDateFormat.parse(toDate);

    return '${_toDateFormat.format(from)} - ${_toDateFormat.format(to)}';
  }
}