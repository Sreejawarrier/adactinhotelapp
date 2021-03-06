import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/book_hotel.dart';
import 'package:adactin_hotel_app/api/models/booking_details.dart';
import 'package:adactin_hotel_app/api/repo/error_checks.dart';
import 'package:adactin_hotel_app/base/connectivity/connectivity.dart';
import 'package:adactin_hotel_app/book_hotel/constants/book_hotel_constants.dart';
import 'package:adactin_hotel_app/global/global_constants.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class BookHotelRepository {
  final DateFormat _displayDateFormat =
      DateFormat(BookHotelConstants.displayDateFormat);
  final DateFormat _expiryMonthFormat =
      DateFormat(BookHotelConstants.expiryMonth);
  final DateFormat _expiryYearFormat =
      DateFormat(BookHotelConstants.expiryYear);

  Future<BookingDetails> book({
    @required String token,
    @required BookHotel bookHotel,
  }) async {
    try {
      final bool isConnected = await AppConnectivity.isConnected();
      if (isConnected) {
        final DateTime expiryDate =
            _displayDateFormat.parse(bookHotel.expiryDate);

        String bookHotelUrl = Constants.baseURL + Constants.bookHotelURL;
        bookHotelUrl = bookHotelUrl.replaceAll(Constants.userTokenKey, token);
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.hotelNameKey, bookHotel.hotelSearchResult.hotelName);
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.locationKey, bookHotel.hotelSearchResult.location);
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.roomTypeKey, bookHotel.hotelSearchResult.roomsType);
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.roomNosKey, bookHotel.hotelSearchResult.rooms);
        bookHotelUrl = bookHotelUrl.replaceAll(Constants.arrDateKey,
            bookHotel.hotelSearchResult.getFormattedArrivalDate());
        bookHotelUrl = bookHotelUrl.replaceAll(Constants.depDateKey,
            bookHotel.hotelSearchResult.getFormattedDepartureDate());
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.adultNoKey, bookHotel.hotelSearchResult.adultNos);
        if (bookHotel.hotelSearchResult.childNos?.isNotEmpty == true) {
          bookHotelUrl = bookHotelUrl +
              Constants.bookHotelChildNoUrl.replaceAll(
                  Constants.childNoKey, bookHotel.hotelSearchResult.childNos);
        }
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.priceNightKey,
            bookHotel.hotelSearchResult.pricePerNight
                .replaceAll(GlobalConstants.audPriceFormat, ''));
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.totalPriceKey,
            bookHotel.hotelSearchResult.totalPrice
                .replaceAll(GlobalConstants.audPriceFormat, ''));
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.firstNameKey, bookHotel.firstName);
        bookHotelUrl =
            bookHotelUrl.replaceAll(Constants.lastNameKey, bookHotel.lastName);
        bookHotelUrl =
            bookHotelUrl.replaceAll(Constants.addressKey, bookHotel.address);
        bookHotelUrl =
            bookHotelUrl.replaceAll(Constants.cCardNoKey, bookHotel.cCardNo);
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.cCardTypeKey, bookHotel.cCardType);
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.expiryMonthKey, _expiryMonthFormat.format(expiryDate));
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.expiryYearKey, _expiryYearFormat.format(expiryDate));
        bookHotelUrl =
            bookHotelUrl.replaceAll(Constants.cvvNumKey, bookHotel.cvvNum);
        bookHotelUrl = bookHotelUrl.replaceAll(
            Constants.statusKey, bookHotel.status.toString());

        final String encodedUrl = Uri.encodeFull(bookHotelUrl);
        print('BookHotelRepository - book - url - $encodedUrl');

        final Response response =
            await Dio(GlobalConstants().getDioOptions()).get(encodedUrl);
        print('BookHotelRepository - book - response - $response');

        final Map<String, dynamic> data = json.decode(response.toString());

        if (data?.values?.isNotEmpty == true) {
          String responseMessage;
          Map<String, dynamic> searchResponseMap;

          data.values.forEach((result) {
            if (result is String) {
              responseMessage = result;
            } else if (result is Map<String, dynamic>) {
              searchResponseMap = result;
            }
          });

          if (responseMessage == Constants.bookingSuccessMessage &&
              searchResponseMap?.isNotEmpty == true) {
            return BookingDetails.fromJson(searchResponseMap);
          }
        }

        throw ErrorChecks.serviceResponseErrorCheck(data);
      } else {
        throw GlobalConstants.network_unavailable;
      }
    } catch (error) {
      throw ErrorChecks.checkError(error);
    }
  }
}
