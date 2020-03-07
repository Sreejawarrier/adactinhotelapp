import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/booked_itinerary.dart';
import 'package:adactin_hotel_app/base/connectivity/connectivity.dart';
import 'package:adactin_hotel_app/global/global_constants.dart'
    as globalConstants;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class CancelBookingRepository {
  Future<bool> cancelHotel({
    @required String token,
    @required BookedItinerary bookedItinerary,
  }) async {
    try {
      final bool isConnected = await AppConnectivity.isConnected();
      if (isConnected) {
        String cancelBookingUrl =
            Constants.baseURL + Constants.cancelBookingURL;
        cancelBookingUrl =
            cancelBookingUrl.replaceAll(Constants.userTokenKey, token);
        cancelBookingUrl = cancelBookingUrl.replaceAll(
            Constants.orderIdKey, bookedItinerary.orderId);

        final String encodedUrl = Uri.encodeFull(cancelBookingUrl);
        print('CancelBookingRepository - cancelHotel - url - $encodedUrl');

        final Response response =
            await Dio(globalConstants.GlobalConstants().getDioOptions())
                .get(encodedUrl);
        print('CancelBookingRepository - cancelHotel - response - $response');

        final Map<String, dynamic> cancellationMap =
            json.decode(response.toString());
        if (cancellationMap.containsKey(Constants.bookingCancelledKey) &&
            cancellationMap[Constants.bookingCancelledKey] != null) {
          return (cancellationMap[Constants.bookingCancelledKey] ==
              Constants.bookingCancellationMessage);
        }

        if (cancellationMap.containsKey(Constants.errorFieldValidationsKey)) {
          throw cancellationMap[Constants.errorFieldValidationsKey];
        } else if (cancellationMap.containsKey(Constants.errorStatusKey)) {
          throw cancellationMap[Constants.errorStatusKey];
        } else if (cancellationMap.containsKey(Constants.errorResponseKey)) {
          throw cancellationMap[Constants.errorResponseKey];
        } else {
          throw globalConstants.GlobalConstants.unknown_error;
        }
      } else {
        throw globalConstants.GlobalConstants.network_unavailable;
      }
    } catch (error) {
      throw error;
    }
  }
}
