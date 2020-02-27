import 'package:adactin_hotel_app/base/hotel_overview/constants/hotel_overview_semantics.dart';
import 'package:adactin_hotel_app/base/hotel_overview/model/hotel_overview_data.dart';
import 'package:flutter/material.dart';

class HotelOverview extends StatefulWidget {
  final HotelOverviewData hotelData;

  HotelOverview({Key key, this.hotelData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HotelOverviewState();
}

class _HotelOverviewState extends State<HotelOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
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
                      semanticsLabel: HotelOverviewSemantics.hotel_stay_dates,
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
                  semanticsLabel: HotelOverviewSemantics.hotel_stay_total_price,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
