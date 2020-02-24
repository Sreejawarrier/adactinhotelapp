import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class HotelSearch extends Equatable {
  final String location;
  final String hotels;
  final String roomType;
  final String numberOfRooms;
  final String checkInDate;
  final String checkOutDate;
  final String adultsPerRoom;
  final String childrenPerRoom;

  HotelSearch({
    @required this.location,
    @required this.hotels,
    @required this.roomType,
    @required this.numberOfRooms,
    @required this.checkInDate,
    @required this.checkOutDate,
    @required this.adultsPerRoom,
    @required this.childrenPerRoom,
  })  : assert(location?.isNotEmpty == true, 'Mandatory location field'),
        assert(numberOfRooms?.isNotEmpty == true,
            'Mandatory number of rooms field'),
        assert(
            checkInDate?.isNotEmpty == true, 'Mandatory check in date field'),
        assert(
            checkOutDate?.isNotEmpty == true, 'Mandatory check out date field'),
        assert(adultsPerRoom?.isNotEmpty == true,
            'Mandatory adults per room field');

  @override
  List<Object> get props => [
        location,
        hotels,
        roomType,
        numberOfRooms,
        checkInDate,
        checkOutDate,
        adultsPerRoom,
        childrenPerRoom,
      ];

  @override
  String toString() {
    return 'HotelSearch { location: $location, hotels: $hotels, roomType: '
        '$roomType, numberOfRooms: $numberOfRooms, checkInDate: $checkInDate, '
        'checkOutDate: $checkOutDate, adultsPerRoom: $adultsPerRoom, '
        'childrenPerRoom: $childrenPerRoom }';
  }
}
