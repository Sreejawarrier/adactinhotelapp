import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:adactin_hotel_app/base/hotel_overview/container/hotel_overview_container.dart';
import 'package:adactin_hotel_app/base/hotel_overview/model/hotel_overview_data.dart';
import 'package:adactin_hotel_app/global/global_constants.dart';
import 'package:adactin_hotel_app/hotels_search_list/constants/hotels_search_list_page_content.dart';
import 'package:adactin_hotel_app/hotels_search_list/constants/hotels_search_list_page_semantics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelsSearchListPage extends StatefulWidget {
  final List<HotelSearchResult> hotels;

  HotelsSearchListPage({Key key, @required this.hotels}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HotelsSearchListPageState();
}

class _HotelsSearchListPageState extends State<HotelsSearchListPage> {
  final DateFormat _fromDateFormat =
      DateFormat(GlobalConstants.dateFormatWithDash_ddMMyyyy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          HotelsSearchListPageContent.pageTitle,
          semanticsLabel: HotelsSearchListPageContent.pageTitle,
        ),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        child: Semantics(
          enabled: true,
          explicitChildNodes: true,
          label: HotelsSearchListPageSemantics.view_container,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Semantics(
                  enabled: true,
                  explicitChildNodes: true,
                  label:
                      '${HotelsSearchListPageSemantics.list_container}$index',
                  child: HotelOverviewContainer(
                    hotelData: HotelOverviewData(
                      hotelData: widget.hotels[index],
                      name: widget.hotels[index].hotelName,
                      location: widget.hotels[index].location,
                      fromDate: widget.hotels[index].arrivalDate,
                      toDate: widget.hotels[index].departureDate,
                      totalPrice: widget.hotels[index].totalPrice,
                    ),
                    isInitialItem: index == 0,
                    isLastItem: index == (widget.hotels.length - 1),
                    fromDateFormat: _fromDateFormat,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: widget.hotels.length,
            ),
          ),
        ),
      ),
    );
  }
}
