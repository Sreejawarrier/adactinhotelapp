import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BookHotel extends Equatable {
  final HotelSearchResult hotelSearchResult;
  final String firstName;
  final String lastName;
  final String address;
  final String cCardNo;
  final String cCardType;
  final String expiryDate;
  final String cvvNum;
  final int status;

  BookHotel({
    @required this.hotelSearchResult,
    @required this.firstName,
    @required this.lastName,
    @required this.address,
    @required this.cCardNo,
    @required this.cCardType,
    @required this.expiryDate,
    @required this.cvvNum,
    this.status = 1,
  })  : assert(hotelSearchResult != null, 'Mandatory hotelSearchResult field'),
        assert(firstName?.isNotEmpty == true, 'Mandatory firstName field'),
        assert(lastName?.isNotEmpty == true, 'Mandatory lastName field'),
        assert(address?.isNotEmpty == true, 'Mandatory address field'),
        assert(cCardNo?.isNotEmpty == true, 'Mandatory cCardNo field'),
        assert(cCardType?.isNotEmpty == true, 'Mandatory cCardType field'),
        assert(expiryDate?.isNotEmpty == true, 'Mandatory expiryDate field'),
        assert(cvvNum?.isNotEmpty == true, 'Mandatory cvvNum field');

  @override
  List<Object> get props => [
        hotelSearchResult,
        firstName,
        lastName,
        address,
        cCardNo,
        cCardType,
        expiryDate,
        cvvNum,
        status,
      ];

  @override
  String toString() {
    return 'BookHotel { hotelSearchResult: $hotelSearchResult firstName: '
        '$firstName, lastName: $lastName, address: $address, '
        'cCardNo: $cCardNo, cCardType: $cCardType, expiryDate: $expiryDate, '
        'cvvNum: $cvvNum, status: $status}';
  }
}
