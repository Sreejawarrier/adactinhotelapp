import 'package:equatable/equatable.dart';

class BookedItinerary extends Equatable {
  final String bookingNo;
  final String orderId;
  final String hotelName;
  final String location;
  final String roomType;
  final String rooms;
  final String arrivalDate;
  final String departureDate;
  final String noOfDays;
  final String pricePerNight;
  final String finalPrice;
  final String firstName;
  final String lastName;

  BookedItinerary({
    this.bookingNo,
    this.orderId,
    this.hotelName,
    this.location,
    this.roomType,
    this.rooms,
    this.arrivalDate,
    this.departureDate,
    this.noOfDays,
    this.pricePerNight,
    this.finalPrice,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object> get props => [
        bookingNo,
        orderId,
        hotelName,
        location,
        roomType,
        rooms,
        arrivalDate,
        departureDate,
        noOfDays,
        pricePerNight,
        finalPrice,
        firstName,
        lastName,
      ];

  factory BookedItinerary.fromJson(Map<String, dynamic> json) =>
      BookedItinerary(
        bookingNo: json["BookingNo"],
        orderId: json["OrderId"],
        hotelName: json["HotelName"],
        location: json["Location"],
        roomType: json["RoomType"],
        rooms: json["Rooms"],
        arrivalDate: json["ArrivalDate"],
        departureDate: json["DepartureDate"],
        noOfDays: json["NoOfDays"],
        pricePerNight: json["PricePerNight"],
        finalPrice: json["FinalPrice"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
      );

  @override
  String toString() {
    return 'BookedItinerary { bookingNo: $bookingNo, orderId: $orderId, hotelName: '
        '$hotelName, location: $location, roomType: $roomType, '
        'rooms: $rooms, arrivalDate: $arrivalDate, '
        'departureDate: $departureDate, finalPrice: $finalPrice, '
        'firstName: $firstName, lastName: $lastName }';
  }
}
