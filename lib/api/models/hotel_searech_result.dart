import 'dart:convert';

import 'package:equatable/equatable.dart';

HotelSearchResult userDetailsFromJson(String str) =>
    HotelSearchResult.fromJson(json.decode(str));

class HotelSearchResult extends Equatable {
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
}
