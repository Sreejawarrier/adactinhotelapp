import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/global/global_constants.dart'
    as globalConstants;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class BookedItineraryRepository {
  Future<void> bookedHotels({
    @required String token,
  }) async {
    try {
      String bookedItineraryUrl = Constants.baseURL + Constants.bookingsURL;
      bookedItineraryUrl = bookedItineraryUrl.replaceAll(
        Constants.userTokenKey,
        token,
      );

      final String encodedUrl = Uri.encodeFull(bookedItineraryUrl);
      print('BookedItineraryRepository - bookingItinerary - url - $encodedUrl');

      final Response response = await Dio().get(encodedUrl);
      print('BookedItineraryRepository - bookings - response - $response');

      final Map<String, dynamic> data = json.decode(response.toString());

      if (data?.values?.isNotEmpty == true) {
        String responseMessage;
        Map<String, dynamic> bookingsResponseMap;

        data.values.forEach((result) {
          if (result is String) {
            responseMessage = result;
          } else if (result is Map<String, dynamic>) {
            bookingsResponseMap = result;
          }
        });

        print(responseMessage);
        print(bookingsResponseMap);
//        if (responseMessage == Constants.hotelSearchSuccessMessage &&
//            searchResponseMap?.isNotEmpty == true) {
//          List<HotelSearchResult> resultDataList = [];
//          for (int i = 1; i <= searchResponseMap.length; i++) {
//            final String mapKey = "${Constants.hotelResultValueKey}$i";
//            if (searchResponseMap.containsKey(mapKey)) {
//              resultDataList.add(
//                HotelSearchResult.fromJson(
//                  searchResponseMap[mapKey],
//                  hotelSearch.adultsPerRoom,
//                  hotelSearch.childrenPerRoom,
//                ),
//              );
//            }
//          }
//          return resultDataList;
//        }
      }

      if (data.containsKey(Constants.errorFieldValidationsKey)) {
        throw data[Constants.errorFieldValidationsKey];
      } else if (data.containsKey(Constants.errorStatusKey)) {
        throw data[Constants.errorStatusKey];
      } else if (data.containsKey(Constants.errorResponseKey)) {
        throw data[Constants.errorResponseKey];
      } else {
        throw globalConstants.GlobalConstants.unknownError;
      }
    } catch (error) {
      throw error;
    }
  }
}
