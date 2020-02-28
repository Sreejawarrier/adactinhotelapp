import 'package:adactin_hotel_app/app/routes/app_routes.dart';
import 'package:adactin_hotel_app/base/hotel_overview/constants/hotel_overview_semantics.dart';
import 'package:adactin_hotel_app/base/hotel_overview/model/hotel_overview_data.dart';
import 'package:adactin_hotel_app/hotels_search_list/constants/hotels_search_list_page_semantics.dart';
import 'package:flutter/material.dart';

class HotelOverviewContainer extends StatefulWidget {
  final HotelOverviewData hotelData;
  final bool isInitialItem;
  final bool isLastItem;

  HotelOverviewContainer({
    Key key,
    @required this.hotelData,
    @required this.isInitialItem,
    @required this.isLastItem,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HotelOverviewContainerState();
}

class _HotelOverviewContainerState extends State<HotelOverviewContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: widget.isInitialItem
          ? const EdgeInsets.only(top: 20)
          : (widget.isLastItem
              ? const EdgeInsets.only(top: 10, bottom: 40)
              : const EdgeInsets.only(top: 10)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Semantics(
          enabled: true,
          label: HotelsSearchListPageSemantics.hotel_list_item,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.HOTEL_DETAIL,
                arguments: widget.hotelData.hotelSearchResult,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.hotelData.name,
                          style: TextStyle(fontSize: 18),
                          semanticsLabel: HotelOverviewSemantics.hotel_name,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.hotelData.location,
                          style: TextStyle(fontSize: 14),
                          semanticsLabel: HotelOverviewSemantics.hotel_location,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.hotelData.getStayDates(),
                          style: TextStyle(fontSize: 12),
                          semanticsLabel:
                              HotelOverviewSemantics.hotel_stay_dates,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      widget.hotelData.totalPrice,
                      style: TextStyle(fontSize: 16),
                      semanticsLabel:
                          HotelOverviewSemantics.hotel_stay_total_price,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
