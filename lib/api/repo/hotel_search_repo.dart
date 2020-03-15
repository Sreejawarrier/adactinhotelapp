import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/hotel_search.dart';
import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:adactin_hotel_app/api/repo/error_checks.dart';
import 'package:adactin_hotel_app/base/connectivity/connectivity.dart';
import 'package:adactin_hotel_app/global/global_constants.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class HotelSearchRepository {
  Future<List<HotelSearchResult>> searchForHotels({
    @required String token,
    @required HotelSearch hotelSearch,
  }) async {
    try {
      final bool isConnected = await AppConnectivity.isConnected();
      if (isConnected) {
        String hotelSearchUrl = Constants.baseURL + Constants.hotelSearchURL;
        hotelSearchUrl =
            hotelSearchUrl.replaceAll(Constants.userTokenKey, token);
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
        print('HotelSearchRepository - searchForHotels - url - $encodedUrl');

        final Response response =
            await Dio(GlobalConstants().getDioOptions()).get(encodedUrl);
        print('HotelSearchRepository - searchForHotels - response - $response');

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

          if (responseMessage == Constants.hotelSearchSuccessMessage &&
              searchResponseMap?.isNotEmpty == true) {
            List<HotelSearchResult> resultDataList = [];
            for (int i = 1; i <= searchResponseMap.length; i++) {
              final String mapKey = "${Constants.hotelResultValueKey}$i";
              if (searchResponseMap.containsKey(mapKey)) {
                resultDataList.add(
                  HotelSearchResult.fromJson(
                    searchResponseMap[mapKey],
                    hotelSearch.adultsPerRoom,
                    hotelSearch.childrenPerRoom,
                  ),
                );
              }
            }
            return resultDataList;
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
