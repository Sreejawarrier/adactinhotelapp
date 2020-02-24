import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/hotel_search.dart';
import 'package:adactin_hotel_app/global/constants.dart' as globalConstants;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class HotelSearchRepository {
  Future<String> searchForHotels({
    @required String token,
    @required HotelSearch hotelSearch,
  }) async {
    try {
      String hotelSearchUrl = Constants.baseURL + Constants.hotelSearchURL;
      hotelSearchUrl = hotelSearchUrl.replaceAll(Constants.userTokenKey, token);
      hotelSearchUrl = hotelSearchUrl.replaceAll(
          Constants.locationKey, hotelSearch.location);
      hotelSearchUrl = hotelSearchUrl.replaceAll(
          Constants.roomNosKey, hotelSearch.numberOfRooms);
      hotelSearchUrl = hotelSearchUrl.replaceAll(
          Constants.checkInDateKey, hotelSearch.checkInDate);
      hotelSearchUrl = hotelSearchUrl.replaceAll(
          Constants.checkOutDateKey, hotelSearch.checkOutDate);
      hotelSearchUrl = hotelSearchUrl.replaceAll(
          Constants.adultRoomKey, hotelSearch.adultsPerRoom);
      if (hotelSearch.hotels?.isNotEmpty == true) {
        hotelSearchUrl = hotelSearchUrl +
            Constants.hotelSearchHotelsUrl
                .replaceAll(Constants.hotelsKey, hotelSearch.hotels);
      }
      if (hotelSearch.roomType?.isNotEmpty == true) {
        hotelSearchUrl = hotelSearchUrl +
            Constants.hotelSearchRoomTypeUrl
                .replaceAll(Constants.roomTypeKey, hotelSearch.roomType);
      }
      if (hotelSearch.childrenPerRoom?.isNotEmpty == true) {
        hotelSearchUrl = hotelSearchUrl +
            Constants.hotelSearchChildRoomUrl.replaceAll(
                Constants.childRoomKey, hotelSearch.childrenPerRoom);
      }

      final String encodedUrl = Uri.encodeFull(hotelSearchUrl);

      final Response response = await Dio().get(encodedUrl);
      final Map<String, dynamic> data = json.decode(response.toString());

      if (data?.values?.isNotEmpty == true) {
        data.values.forEach((result) {
          print(result);
          print(result is Map<String, dynamic>);
        });
      }

      if (data.containsKey(Constants.hotelSearchSuccessKey) == true) {
        return data.toString();
      } else {
        if (data.containsKey(Constants.errorFieldValidationsKey)) {
          throw Constants.errorFieldValidationDescription;
        } else if (data.containsKey(Constants.errorStatusKey)) {
          throw data[Constants.errorStatusKey];
        } else if (data.containsKey(Constants.errorResponseKey)) {
          throw data[Constants.errorResponseKey];
        } else {
          throw globalConstants.Constants.unknownError;
        }
      }
    } catch (error) {
      throw error;
    }
  }
}
