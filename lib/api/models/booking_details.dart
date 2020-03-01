import 'dart:convert';

import 'package:equatable/equatable.dart';

BookingDetails bookingDetailsFromJson(String str) =>
    BookingDetails.fromJson(json.decode(str));

class BookingDetails extends Equatable {
  final String hotelName;
  final String location;
  final String roomType;
  final String arrivalDate;
  final String departureDate;
  final String totalRooms;
  final String adultsPerRoom;
  final String childrenPerRoom;
  final String pricePerNight;
  final String totalPrice;
  final String gst;
  final String finalBilledPrice;
  final String firstName;
  final String lastName;
  final String billingAddress;
  final String orderID;

  BookingDetails({
    this.hotelName,
    this.location,
    this.roomType,
    this.arrivalDate,
    this.departureDate,
    this.totalRooms,
    this.adultsPerRoom,
    this.childrenPerRoom,
    this.pricePerNight,
    this.totalPrice,
    this.gst,
    this.finalBilledPrice,
    this.firstName,
    this.lastName,
    this.billingAddress,
    this.orderID,
  });

  @override
  List<Object> get props => [
        this.hotelName,
        this.location,
        this.roomType,
        this.arrivalDate,
        this.departureDate,
        this.totalRooms,
        this.adultsPerRoom,
        this.childrenPerRoom,
        this.pricePerNight,
        this.totalPrice,
        this.gst,
        this.finalBilledPrice,
        this.firstName,
        this.lastName,
        this.billingAddress,
        this.orderID,
      ];

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        hotelName: json["HotelName"],
        location: json["Location"],
        roomType: json["RoomType"],
        arrivalDate: json["ArrivalDate"],
        departureDate: json["DepartureDate"],
        totalRooms: json["TotalRooms"],
        adultsPerRoom: json["AdultsPerRoom"],
        childrenPerRoom: json["ChildrenPerRoom"],
        pricePerNight: json["PricePerNight"],
        totalPrice: json["TotalPrice"],
        gst: json["GST"],
        finalBilledPrice: json["FinalBilledPrice"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        billingAddress: json["BillingAddress"],
        orderID: json["OrderID"],
      );

  @override
  String toString() {
    return 'BookingDetails { hotelName: $hotelName, location: $location,'
        'roomType: $roomType, arrivalDate: $arrivalDate, departureDate: '
        '$departureDate, totalRooms: $totalRooms, adultsPerRooms: '
        '$adultsPerRoom, childrenPerRoom: $childrenPerRoom, pricePerNight: '
        '$pricePerNight, totalPrice: $totalPrice, gst: $gst, finalBilledPrice: '
        '$finalBilledPrice, firstName: $firstName, lastName: $lastName, '
        'billingAddress: $billingAddress, orderID: $orderID }';
  }

  String getTotalRooms() {
    final totalRoomsSplit = totalRooms.split('-');
    return totalRoomsSplit.first;
  }

  String getPersonsPerRoom(String persons) {
    final personsPerRoomSplit = persons.split('-');
    return personsPerRoomSplit.first;
  }
}
