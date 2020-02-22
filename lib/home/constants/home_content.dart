class HomeContent {
  static const String searchHotel = 'Search Hotel';
  static const String location = 'Location';
  static const String locationHint = 'Select Location';
  static const String errorLocation = 'Select a valid location';
  static const String hotels = 'Hotels';
  static const String hotelsHint = 'Select Hotel';
  static const String roomType = 'Room Type';
  static const String roomTypeHint = 'Select Room Type';
  static const String numberOfRooms = 'Number of Rooms';
  static const String numberOfRoomsHint = 'Select Number of Rooms';
  static const String errorNumberOfRooms = 'Select proper number of rooms';
  static const String checkInDate = 'Check-in Date';
  static const String checkInDateHint = 'Select Check-in Date';
  static const String errorCheckInDate = 'Select valid check-in date';
  static const String checkOutDate = 'Check-out Date';
  static const String checkOutDateHint = 'Select Check-out Date';
  static const String errorCheckOutDate = 'Select valid check-out date';
  static const String adultsPerRoom = 'Adults per Room';
  static const String adultsPerRoomHint = 'Select Adults per Room';
  static const String errorAdultsPerRoom = 'Select proper adults per room';
  static const String childrenPerRoom = 'Children per Room';
  static const String childrenPerRoomHint = 'Select Children per Room';
  static const String search = 'Search';
  static const String reset = 'Reset';
  static const String cancel = 'Cancel';

  List<String> locationValues() => [
        'Sydney',
        'Melbourne',
        'Brisbane',
        'Adelaide',
        'London',
        'New York',
        'Los Angeles',
        'Paris',
      ];

  List<String> hotelValues() => [
        'Hotel Creek',
        'Hotel Sunshine',
        'Hotel Hervey',
        'Hotel Cornice',
      ];

  List<String> roomTypeValues() => [
        'Standard',
        'Deluxe',
        'Double',
        'Super Deluxe',
      ];

  List<String> numberOfRoomsValues() => [
        '1 - One',
        '2 - Two',
        '3 - Three',
        '4 - Four',
        '5 - Five',
        '6 - Six',
        '7 - Seven',
        '8 - Eight',
        '9 - Nine',
        '10 - Ten',
      ];

  List<String> personsPerRoomValues() => [
        '1 - One',
        '2 - Two',
        '3 - Three',
        '4 - Four',
      ];
}
