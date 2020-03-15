import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/api/repo/error_checks.dart';
import 'package:adactin_hotel_app/base/connectivity/connectivity.dart';
import 'package:adactin_hotel_app/global/global_constants.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class BookedItineraryRepository {
  Future<List<BookedItinerary>> bookedHotels({
    @required String token,
  }) async {
    try {
      final bool isConnected = await AppConnectivity.isConnected();
      if (isConnected) {
        String bookedItineraryUrl =
            Constants.baseURL + Constants.bookedItinerariesURL;
        bookedItineraryUrl = bookedItineraryUrl.replaceAll(
          Constants.userTokenKey,
          token,
        );

        final String encodedUrl = Uri.encodeFull(bookedItineraryUrl);
        print(
            'BookedItineraryRepository - bookingItinerary - url - $encodedUrl');

        final Response response =
            await Dio(GlobalConstants().getDioOptions()).get(encodedUrl);
        print('BookedItineraryRepository - bookings - response - $response');

        final Map<String, dynamic> data = json.decode(response.toString());

        if (data != null &&
            data.isNotEmpty &&
            data.containsKey(Constants.bookedItinerarySearchSuccessKey)) {
          dynamic bookedItinerariesResponse =
              data[Constants.bookedItinerarySearchSuccessKey];
          List<BookedItinerary> resultDataList = [];

          if (bookedItinerariesResponse is Map<String, dynamic> &&
              bookedItinerariesResponse.isNotEmpty) {
            for (int i = 1; i <= bookedItinerariesResponse.length; i++) {
              final String mapKey =
                  "${Constants.bookedItineraryResultValueKey}$i";
              if (bookedItinerariesResponse.containsKey(mapKey)) {
                resultDataList.add(
                  BookedItinerary.fromJson(
                    bookedItinerariesResponse[mapKey],
                  ),
                );
              }
            }
          }

          return resultDataList;
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
