import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

HotelSearchResult userDetailsFromJson(String str) =>
    HotelSearchResult.fromJson(json.decode(str));

class HotelSearchResult extends Equatable {
  final DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _responseDateFormat = DateFormat('dd-MM-yyyy');

  final String hotelName;
  final String location;
  final String rooms;
  final String arrivalDate;
  final String departureDate;
  final int noOfDays;
  final String roomsType;
  final String pricePerNight;
  final String totalPrice;

  HotelSearchResult({
    this.hotelName,
    this.location,
    this.rooms,
    this.arrivalDate,
    this.departureDate,
    this.noOfDays,
    this.roomsType,
    this.pricePerNight,
    this.totalPrice,
  });

  @override
  List<Object> get props => [
        hotelName,
        location,
        rooms,
        arrivalDate,
        departureDate,
        noOfDays,
        roomsType,
        pricePerNight,
        totalPrice,
      ];

  factory HotelSearchResult.fromJson(Map<String, dynamic> json) =>
      HotelSearchResult(
        hotelName: json["HotelName"],
        location: json["Location"],
        rooms: json["Rooms"],
        arrivalDate: json["ArrivalDate"],
        departureDate: json["DepartureDate"],
        noOfDays: json["NoOfDays"],
        roomsType: json["RoomsType"],
        pricePerNight: json["PricePerNight"],
        totalPrice: json["TotalPrice"],
      );

  @override
  String toString() {
    return 'HotelSearchResult { hotelName: $hotelName, location: $location, rooms: '
        '$rooms, arrivalDate: $arrivalDate, departureDate: $departureDate, '
        'noOfDays: $noOfDays, roomsType: $roomsType, '
        'pricePerNight: $pricePerNight, totalPrice: $totalPrice }';
  }

  String getNoOfRooms() {
    final List<String> splitList = rooms.split(' ');
    return splitList.first;
  }

  String getFormattedArrivalDate() {
    final DateTime responseDate = _responseDateFormat.parse(arrivalDate);

    return '${_displayDateFormat.format(responseDate)}';
  }

  String getFormattedDepartureDate() {
    final DateTime responseDate = _responseDateFormat.parse(departureDate);

    return '${_displayDateFormat.format(responseDate)}';
  }
}
