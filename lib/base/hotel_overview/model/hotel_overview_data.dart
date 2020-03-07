import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class HotelOverviewData<T> extends Equatable {
  final T hotelData;
  final String name;
  final String location;
  final String fromDate;
  final String toDate;
  final String totalPrice;

  final DateFormat _toDateFormat = DateFormat('dd MMM');

  HotelOverviewData({
    this.hotelData,
    this.name,
    this.location,
    this.fromDate,
    this.toDate,
    this.totalPrice,
  });

  @override
  List<Object> get props => [
        hotelData,
        name,
        location,
        fromDate,
        toDate,
        totalPrice,
      ];

  String getStayDates(DateFormat fromDateFormat) {
    final DateTime from = fromDateFormat.parse(fromDate);
    final DateTime to = fromDateFormat.parse(toDate);

    return '${_toDateFormat.format(from)} - ${_toDateFormat.format(to)}';
  }
}
