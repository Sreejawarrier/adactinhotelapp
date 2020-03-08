import 'dart:convert';
import 'dart:io';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/base/connectivity/connectivity.dart';
import 'package:adactin_hotel_app/global/global_constants.dart'
    as globalConstants;
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
            await Dio(globalConstants.GlobalConstants().getDioOptions())
                .get(encodedUrl);
        print('BookedItineraryRepository - bookings - response - $response');

        final Map<String, dynamic> data = json.decode(response.toString());

        if (data != null && data.isNotEmpty) {
          Map<String, dynamic> bookedItinerariesResponseMap =
              data[Constants.bookedItinerarySearchSuccessKey];
          if (bookedItinerariesResponseMap?.isNotEmpty == true) {
            List<BookedItinerary> resultDataList = [];
            for (int i = 1; i <= bookedItinerariesResponseMap.length; i++) {
              final String mapKey =
                  "${Constants.bookedItineraryResultValueKey}$i";
              if (bookedItinerariesResponseMap.containsKey(mapKey)) {
                resultDataList.add(
                  BookedItinerary.fromJson(
                    bookedItinerariesResponseMap[mapKey],
                  ),
                );
              }
            }
            return resultDataList;
          }
        }

        if (data.containsKey(Constants.errorFieldValidationsKey)) {
          throw data[Constants.errorFieldValidationsKey];
        } else if (data.containsKey(Constants.errorStatusKey)) {
          throw data[Constants.errorStatusKey];
        } else if (data.containsKey(Constants.errorResponseKey)) {
          throw data[Constants.errorResponseKey];
        } else {
          throw globalConstants.GlobalConstants.unknown_error;
        }
      } else {
        throw globalConstants.GlobalConstants.network_unavailable;
      }
    } catch (error) {
      if (error is DioError && error.error is SocketException) {
        if (((error.error as SocketException).osError.errorCode == 51) ||
            ((error.error as SocketException).osError.errorCode == 8) ||
            ((error.error as SocketException).osError.message ==
                globalConstants.GlobalConstants.dio_error_not_known) ||
            ((error.error as SocketException).osError.message ==
                globalConstants.GlobalConstants.dio_error_no_internet)) {
          throw globalConstants.GlobalConstants.network_unavailable;
        } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
            error.type == DioErrorType.SEND_TIMEOUT ||
            error.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw globalConstants.GlobalConstants.sessionTimeout;
        } else {
          throw globalConstants.GlobalConstants.unknown_error;
        }
      } else {
        throw globalConstants.GlobalConstants.unknown_error;
      }
    }
  }
}
