import 'package:adactin_hotel_app/api/repo/booked_itinerary_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/booked_itinerary/bloc/booked_itinerary_bloc.dart';
import 'package:adactin_hotel_app/booked_itinerary/content/booked_itinerary_content.dart';
import 'package:adactin_hotel_app/booked_itinerary/content/booked_itinerary_semantic_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookedItineraryPage extends StatefulWidget {
  final AppBloc appBloc;

  BookedItineraryPage({Key key, @required this.appBloc})
      : assert(appBloc != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _BookedItineraryPageState();
}

class _BookedItineraryPageState extends State<BookedItineraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return BookedItineraryBloc(
            bookedItineraryRepository: BookedItineraryRepository(),
          );
        },
        child: SafeArea(
          child: BlocListener<BookedItineraryBloc, BookedItineraryState>(
            listener: (context, state) {
              if (state is BookedItineraryInitial) {
                _fetchBookings(context);
              } else if (state is BookedItineraryFailure) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      semanticLabel: BookedItinerarySemanticKeys.failureAlert,
                      title: Text(BookedItineraryContent.alertFailureTitle),
                      content: Text(state.error),
                      actions: <Widget>[
                        FlatButton(
                          child: Semantics(
                            enabled: true,
                            label:
                                BookedItinerarySemanticKeys.failureAlertButton,
                            child: Text(BookedItineraryContent.alertButtonOk),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                  barrierDismissible: false,
                );
              }
            },
            child: BlocBuilder<BookedItineraryBloc, BookedItineraryState>(
              builder: (context, state) {
                return Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Text('Test 1'),
                    ),
                    state is SearchInProcess
                        ? Spinner()
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _fetchBookings(BuildContext context) {
    BlocProvider.of<BookedItineraryBloc>(context).add(
      FetchBookingsAction(appBloc: widget.appBloc),
    );
  }
}
