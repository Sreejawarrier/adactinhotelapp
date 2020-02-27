import 'package:adactin_hotel_app/api/models/hotel_searech_result.dart';
import 'package:adactin_hotel_app/base/hotel_overview/container/hotel_overview.dart';
import 'package:adactin_hotel_app/base/hotel_overview/model/hotel_overview_data.dart';
import 'package:adactin_hotel_app/hotels_search_list/constants/hotels_list_page_content.dart';
import 'package:adactin_hotel_app/hotels_search_list/constants/hotels_list_page_semantics.dart';
import 'package:flutter/material.dart';

class HotelsListPage extends StatefulWidget {
  final List<HotelSearchResult> hotels;

  HotelsListPage({Key key, @required this.hotels}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HotelsListPageState();
}

class _HotelsListPageState extends State<HotelsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HotelsListPageContent.pageTitle),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.4),
        child: SafeArea(
          child: Builder(
            builder: (context) {
              return Semantics(
                enabled: true,
                label: HotelsListPageSemantics.view_container,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 40,
                  ),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Semantics(
                        enabled: true,
                        label:
                            '${HotelsListPageSemantics.list_container}$index',
                        child: HotelOverview(
                          hotelData: HotelOverviewData(
                            name: widget.hotels[index].hotelName,
                            location: widget.hotels[index].location,
                            fromDate: widget.hotels[index].arrivalDate,
                            toDate: widget.hotels[index].departureDate,
                            totalPrice: widget.hotels[index].totalPrice,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                    itemCount: widget.hotels.length,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
