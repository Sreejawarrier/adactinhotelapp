import 'package:adactin_hotel_app/api/models/book_hotel.dart';
import 'package:adactin_hotel_app/api/models/hotel_search_result.dart';
import 'package:adactin_hotel_app/api/repo/book_hotel_repo.dart';
import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/routes/app_routes.dart';
import 'package:adactin_hotel_app/base/ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:adactin_hotel_app/base/spinner/spinner.dart';
import 'package:adactin_hotel_app/book_hotel/bloc/book_hotel_bloc.dart';
import 'package:adactin_hotel_app/book_hotel/constants/book_hotel_constants.dart';
import 'package:adactin_hotel_app/book_hotel/constants/book_hotel_content.dart';
import 'package:adactin_hotel_app/book_hotel/constants/book_hotel_semantic_keys.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class BookHotelPage extends StatefulWidget {
  final AppBloc appBloc;
  final HotelSearchResult hotelSearchResult;

  BookHotelPage({
    Key key,
    @required this.appBloc,
    @required this.hotelSearchResult,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookHotelPageState();
}

class _BookHotelPageState extends State<BookHotelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final DateFormat _displayDateFormat =
      DateFormat(BookHotelConstants.displayDateFormat);
  final TextEditingController _firstNameTextFieldController =
      TextEditingController();
  final FocusNode _firstNameTextFieldFocusNode = FocusNode();
  final TextEditingController _lastNameTextFieldController =
      TextEditingController();
  final FocusNode _lastNameTextFieldFocusNode = FocusNode();
  final TextEditingController _billingAddressTextFieldController =
      TextEditingController();
  final FocusNode _billingAddressTextFieldFocusNode = FocusNode();
  final TextEditingController _creditCardNoTextFieldController =
      TextEditingController();
  final FocusNode _creditCardNoTextFieldFocusNode = FocusNode();
  final TextEditingController _creditCardTypeTextFieldController =
      TextEditingController();
  final FocusNode _creditCardTypeTextFieldFocusNode = FocusNode();
  final TextEditingController _expiryDateTextFieldController =
      TextEditingController();
  final FocusNode _expiryDateTextFieldFocusNode = FocusNode();
  final TextEditingController _cvvTextFieldController = TextEditingController();
  final FocusNode _cvvTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _creditCardTypeTextFieldFocusNode.addListener(_ccTypeFieldInputDisplay);
    _expiryDateTextFieldFocusNode.addListener(_expiryDateTypeFieldInputDisplay);
  }

  @override
  void dispose() {
    _firstNameTextFieldController.dispose();
    _firstNameTextFieldFocusNode.dispose();
    _lastNameTextFieldController.dispose();
    _lastNameTextFieldFocusNode.dispose();
    _billingAddressTextFieldController.dispose();
    _billingAddressTextFieldFocusNode.dispose();
    _creditCardNoTextFieldController.dispose();
    _creditCardNoTextFieldFocusNode.dispose();
    _creditCardTypeTextFieldController.dispose();
    _creditCardTypeTextFieldFocusNode.removeListener(_ccTypeFieldInputDisplay);
    _creditCardTypeTextFieldFocusNode.dispose();
    _expiryDateTextFieldController.dispose();
    _expiryDateTextFieldFocusNode
        .removeListener(_expiryDateTypeFieldInputDisplay);
    _expiryDateTextFieldFocusNode.dispose();
    _cvvTextFieldController.dispose();
    _cvvTextFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          BookHotelContent.pageTitle,
          semanticsLabel: BookHotelSemanticKeys.pageTitle,
        ),
      ),
      body: BlocProvider(
        create: (context) {
          return BookHotelBloc(
            bookHotelRepository: BookHotelRepository(),
          );
        },
        child: BlocListener<BookHotelBloc, BookHotelState>(
          listener: (context, state) {
            if (state is BookingSuccessful) {
              Navigator.of(context).pushNamed(
                AppRoutes.BOOKING_DETAILS,
                arguments: state.bookingDetails,
              );
            } else if (state is BookingFailure) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    semanticLabel: BookHotelSemanticKeys.failureAlert,
                    title: Text(BookHotelContent.alertFailureTitle),
                    content: Text(state.error),
                    actions: <Widget>[
                      FlatButton(
                        child: Semantics(
                          enabled: true,
                          label: BookHotelSemanticKeys.failureAlertButton,
                          child: Text(BookHotelContent.alertButtonOk),
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
          child: BlocBuilder<BookHotelBloc, BookHotelState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _removeFocus(),
                    child: Container(
                      color: Colors.white,
                      child: _getBookHotelForm(context),
                    ),
                  ),
                  state is BookingInProcess
                      ? Spinner()
                      : const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// --- --- --- Search Form --- --- ---

  Widget _getBookHotelForm(BuildContext context) {
    final List<Widget> _formChildren = [];
    _formChildren.addAll(_disabledFormFields(context));
    _formChildren.addAll(_billingFormFields(context));
    _formChildren.addAll(_bookNowButtonArea(context));
    _formChildren.add(const SizedBox(height: 40));

    return Form(
      key: _formKey,
      autovalidate: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _formChildren,
        ),
      ),
    );
  }

  /// --- --- --- Disabled Form --- --- ---

  List<Widget> _disabledFormFields(BuildContext context) {
    return [
      _getLabel(context, BookHotelContent.hotelName),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.hotelName,
        textEditingController:
            TextEditingController(text: widget.hotelSearchResult.hotelName),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.location),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.location,
        textEditingController:
            TextEditingController(text: widget.hotelSearchResult.location),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.roomType),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.roomType,
        textEditingController:
            TextEditingController(text: widget.hotelSearchResult.roomsType),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.numberOfRooms),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.numberOfRooms,
        textEditingController: TextEditingController(
            text: widget.hotelSearchResult.getNoOfRooms()),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.totalDays),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.totalDays,
        textEditingController: TextEditingController(
            text: widget.hotelSearchResult.noOfDays.toString()),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.pricePerNight),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.pricePerNight,
        textEditingController:
            TextEditingController(text: widget.hotelSearchResult.pricePerNight),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.totalPrice),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.totalPrice,
        textEditingController:
            TextEditingController(text: widget.hotelSearchResult.totalPrice),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.gst),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.gst,
        textEditingController:
            TextEditingController(text: widget.hotelSearchResult.getGSTPrice()),
      ),
      const SizedBox(height: 20),
      _getLabel(context, BookHotelContent.finalBilledPrice),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        enabled: false,
        semanticLabel: BookHotelSemanticKeys.finalBilledPrice,
        textEditingController: TextEditingController(
            text: widget.hotelSearchResult.getBillingPrice()),
      ),
      const SizedBox(height: 18),
    ];
  }

  /// --- --- --- Billing Form --- --- ---

  List<Widget> _billingFormFields(BuildContext context) {
    return [
      _getLabel(context, BookHotelContent.firstName, isRequiredField: true),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        semanticLabel: BookHotelSemanticKeys.firstName,
        hintText: BookHotelContent.firstNameHint,
        textEditingController: _firstNameTextFieldController,
        textFocusNode: _firstNameTextFieldFocusNode,
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? BookHotelContent.errorFistName
              : (value.length > 255 ? BookHotelContent.errorFistName : null);
        },
        nextFocusNode: _lastNameTextFieldFocusNode,
      ),
      const SizedBox(height: 18),
      _getLabel(context, BookHotelContent.lastName, isRequiredField: true),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        semanticLabel: BookHotelSemanticKeys.lastName,
        hintText: BookHotelContent.lastNameHint,
        textEditingController: _lastNameTextFieldController,
        textFocusNode: _lastNameTextFieldFocusNode,
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? BookHotelContent.errorLastName
              : (value.length > 255 ? BookHotelContent.errorLastName : null);
        },
        nextFocusNode: _billingAddressTextFieldFocusNode,
      ),
      const SizedBox(height: 18),
      _getLabel(context, BookHotelContent.billingAddress,
          isRequiredField: true),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        semanticLabel: BookHotelSemanticKeys.billingAddress,
        hintText: BookHotelContent.billingAddressHint,
        textEditingController: _billingAddressTextFieldController,
        textFocusNode: _billingAddressTextFieldFocusNode,
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? BookHotelContent.errorBillingAddress
              : null;
        },
        maxLines: 6,
      ),
      const SizedBox(height: 18),
      _getLabel(context, BookHotelContent.creditCardNo, isRequiredField: true),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        semanticLabel: BookHotelSemanticKeys.creditCardNo,
        hintText: BookHotelContent.creditCardNoHint,
        textEditingController: _creditCardNoTextFieldController,
        textFocusNode: _creditCardNoTextFieldFocusNode,
        keyboardType: TextInputType.number,
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? BookHotelContent.errorCreditCardNo
              : ((value.length > 16 || value.length < 16)
                  ? BookHotelContent.errorCreditCardNo
                  : null);
        },
        nextFocusNode: _creditCardTypeTextFieldFocusNode,
        helperText: BookHotelContent.creditCardNoHelper,
      ),
      const SizedBox(height: 18),
      _getLabel(context, BookHotelContent.creditCardType,
          isRequiredField: true),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        semanticLabel: BookHotelSemanticKeys.creditCardType,
        hintText: BookHotelContent.creditCardTypeHint,
        textEditingController: _creditCardTypeTextFieldController,
        textFocusNode: _creditCardTypeTextFieldFocusNode,
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? BookHotelContent.errorCreditCardType
              : null;
        },
      ),
      const SizedBox(height: 18),
      _getLabel(context, BookHotelContent.expiryDate, isRequiredField: true),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        semanticLabel: BookHotelSemanticKeys.expiryDate,
        hintText: BookHotelContent.expiryDateHint,
        textEditingController: _expiryDateTextFieldController,
        textFocusNode: _expiryDateTextFieldFocusNode,
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? BookHotelContent.errorExpiryDate
              : null;
        },
      ),
      const SizedBox(height: 18),
      _getLabel(context, BookHotelContent.cvvNumber, isRequiredField: true),
      const SizedBox(height: 6),
      _getTextFormField(
        context: context,
        semanticLabel: BookHotelSemanticKeys.cvvNumber,
        hintText: BookHotelContent.cvvNumberHint,
        textEditingController: _cvvTextFieldController,
        textFocusNode: _cvvTextFieldFocusNode,
        keyboardType: TextInputType.number,
        validator: (String value) {
          return (value == null || value.isEmpty)
              ? BookHotelContent.errorCVV
              : (value.length > 4 ? BookHotelContent.errorCVVLength : null);
        },
      ),
      const SizedBox(height: 40),
    ];
  }

  /// --- --- --- Book Now Button Area --- --- ---

  List<Widget> _bookNowButtonArea(BuildContext context) {
    return [
      _getButton(
        context,
        BookHotelSemanticKeys.bookNow,
        BookHotelContent.bookNow,
        Palette.primaryColor,
        () {
          _bookHotel(context);
        },
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Semantics(
          enabled: true,
          label: BookHotelSemanticKeys.mandatoryFieldsMessage,
          child: RichText(
            text: TextSpan(
              text: BookHotelContent.allFields,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              children: [
                TextSpan(
                  text: BookHotelContent.asterisk,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: BookHotelContent.mandatory,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _getButton(
    BuildContext context,
    String semanticKey,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Semantics(
      label: semanticKey,
      enabled: true,
      child: RaisedButton(
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// --- --- --- Label --- --- ---

  Widget _getLabel(
    BuildContext context,
    String label, {
    bool isRequiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Semantics(
        enabled: true,
        label: label,
        child: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Palette.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            children: isRequiredField
                ? [
                    TextSpan(
                      text: BookHotelContent.asterisk,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  /// --- --- --- Text form field --- --- ---

  Widget _getTextFormField({
    BuildContext context,
    String semanticLabel,
    TextEditingController textEditingController,
    FocusNode textFocusNode,
    String hintText,
    FormFieldValidator<String> validator,
    bool enabled = true,
    FocusNode nextFocusNode,
    int maxLines = 1,
    TextInputType keyboardType,
    String helperText,
  }) {
    return Semantics(
      label: semanticLabel,
      enabled: true,
      child: textFocusNode != null
          ? EnsureVisibleWhenFocused(
              focusNode: textFocusNode,
              child: _getFormField(
                context: context,
                semanticLabel: semanticLabel,
                textEditingController: textEditingController,
                textFocusNode: textFocusNode,
                hintText: hintText,
                validator: validator,
                enabled: enabled,
                nextFocusNode: nextFocusNode,
                maxLines: maxLines,
                keyboardType: keyboardType,
                helperText: helperText,
              ))
          : _getFormField(
              context: context,
              semanticLabel: semanticLabel,
              textEditingController: textEditingController,
              textFocusNode: textFocusNode,
              hintText: hintText,
              validator: validator,
              enabled: enabled,
              nextFocusNode: nextFocusNode,
              maxLines: maxLines,
              keyboardType: keyboardType,
              helperText: helperText,
            ),
    );
  }

  Widget _getFormField({
    BuildContext context,
    String semanticLabel,
    TextEditingController textEditingController,
    FocusNode textFocusNode,
    String hintText,
    FormFieldValidator<String> validator,
    bool enabled,
    FocusNode nextFocusNode,
    int maxLines,
    TextInputType keyboardType,
    String helperText,
  }) {
    return TextFormField(
      enabled: enabled,
      maxLines: maxLines,
      controller: textEditingController,
      focusNode: textFocusNode,
      keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : ((nextFocusNode != null)
              ? TextInputAction.next
              : TextInputAction.done),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: !enabled ? Colors.grey.withOpacity(0.1) : null,
        filled: !enabled,
        helperText: helperText,
      ),
      validator: validator,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null)
          FocusScope.of(context).requestFocus(nextFocusNode);
      },
      onChanged: (value) {
        if (maxLines > 1) {
          /// For multi line textFormField removing unnecessary spaces or new lines
          /// for an empty text entered
          final String singleLine = value.replaceAll("\n", "");
          final String noSpaces = singleLine.replaceAll(" ", "");
          if (noSpaces.isEmpty) textEditingController.text = "";
        }
      },
    );
  }

  /// --- --- --- Text Form Field Listeners --- --- ---

  void _ccTypeFieldInputDisplay() {
    _removeFocus();
    _showBottomModalSheet(
      values: BookHotelContent().creditCardTypeValues(),
      textEditingController: _creditCardTypeTextFieldController,
      title: BookHotelContent.creditCardTypeHint,
    );
  }

  void _expiryDateTypeFieldInputDisplay() {
    _removeFocus();
    _showExpiryDatePicker(
      textEditingController: _expiryDateTextFieldController,
      initialDate: (_expiryDateTextFieldController.text?.isEmpty == true)
          ? _displayDateFormat.parse(BookHotelConstants.cardExpiryDateStarting)
          : _displayDateFormat.parse(_expiryDateTextFieldController.text),
      minDate:
          _displayDateFormat.parse(BookHotelConstants.cardExpiryDateStarting),
      maxDate:
          _displayDateFormat.parse(BookHotelConstants.cardExpiryDateEnding),
      onDatePickerConfirm: (DateTime date) {
        _expiryDateTextFieldController.text = _displayDateFormat.format(date);
      },
    );
  }

  /// --- --- --- Remove Focus --- --- ---

  /// Will remove focus from the current Focus node
  void _removeFocus() {
    FocusScope.of(context).unfocus();
  }

  /// --- --- --- Bottom modal sheet --- --- ---

  void _showBottomModalSheet({
    @required List<String> values,
    @required TextEditingController textEditingController,
    @required String title,
  }) {
    final Widget modalSheet = _buildBottomMenu(
      title,
      values,
      textEditingController,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Semantics(
          enabled: true,
          label: BookHotelSemanticKeys.bottomSheet,
          child: Container(
            color: Color(0xFF737373),
            child: Wrap(
              children: <Widget>[
                Container(
                  child: modalSheet,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(30),
                      topRight: const Radius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomMenu(
    String title,
    List<String> values,
    TextEditingController textEditingController,
  ) {
    return Semantics(
      enabled: true,
      label: BookHotelSemanticKeys.bottomSheetOptionsColumn,
      child: Column(
        children: <Widget>[
          _getTitleOfSheet(title),
          _getBottomSheetOptions(values, textEditingController),
          _getBottomModalSheetButton(),
        ],
      ),
    );
  }

  Widget _getTitleOfSheet(String title) {
    if (title.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 8,
        ),
        child: Text(
          title,
          semanticsLabel: '${BookHotelSemanticKeys.bottomOptionTitle}$title',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container();
  }

  Widget _getBottomSheetOptions(
    List<String> values,
    TextEditingController textEditingController,
  ) {
    if (values != null && values.isNotEmpty) {
      final List<Widget> itemWidgets = values
          .map(
            (value) => Semantics(
              enabled: true,
              label: '${BookHotelSemanticKeys.bottomOption}$value',
              child: ListTile(
                title: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  textEditingController.text = value;
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
          .toList();

      return Container(
        constraints: BoxConstraints(maxHeight: 480),
        child: ListView(
          shrinkWrap: true,
          semanticChildCount: values.length,
          children: itemWidgets,
        ),
      );
    }

    return Container();
  }

  Widget _getBottomModalSheetButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Semantics(
        enabled: true,
        label: BookHotelSemanticKeys.bottomSheetCancel,
        child: Container(
          width: double.infinity,
          height: 55.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Palette.primaryColor,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              BookHotelContent.cancel,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  /// --- --- --- Date Picker --- --- ---

  void _showExpiryDatePicker({
    @required TextEditingController textEditingController,
    @required DateTime initialDate,
    @required DateTime minDate,
    @required DateTime maxDate,
    Function(DateTime) onDatePickerConfirm,
  }) {
    DatePicker.showDatePicker(
      context,
      minDateTime: minDate,
      maxDateTime: maxDate,
      dateFormat: BookHotelConstants.bottomSheetExpirySelectionFormat,
      initialDateTime: initialDate,
      onConfirm: (date, _) {
        textEditingController.text = _displayDateFormat.format(date);
        if (onDatePickerConfirm != null) {
          onDatePickerConfirm(date);
        }
      },
    );
  }

  /// --- --- --- Book Hotel --- --- ---

  void _bookHotel(BuildContext context) {
    _removeFocus();

    if (_isValidFormContent(context)) {
      BlocProvider.of<BookHotelBloc>(context).add(
        BookHotelAction(
          appBloc: widget.appBloc,
          bookHotel: BookHotel(
            hotelSearchResult: widget.hotelSearchResult,
            firstName: _firstNameTextFieldController.text,
            lastName: _lastNameTextFieldController.text,
            address: _billingAddressTextFieldController.text,
            cCardNo: _creditCardNoTextFieldController.text,
            cCardType: _creditCardTypeTextFieldController.text,
            expiryDate: _expiryDateTextFieldController.text,
            cvvNum: _cvvTextFieldController.text,
          ),
        ),
      );
    }
  }

  bool _isValidFormContent(BuildContext context) {
    _formKey.currentState.validate();
    bool isValid = true;
    String fieldsRequiredData = '';
    if (_firstNameTextFieldController.text.isEmpty ||
        _firstNameTextFieldController.text.length > 255) {
      fieldsRequiredData = BookHotelContent.firstName;
      isValid = false;
    } else if (_lastNameTextFieldController.text.isEmpty ||
        _lastNameTextFieldController.text.length > 255) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = BookHotelContent.lastName
          : fieldsRequiredData = ', ${BookHotelContent.lastName}';
      isValid = false;
    } else if (_billingAddressTextFieldController.text.isEmpty) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = BookHotelContent.billingAddress
          : fieldsRequiredData = ', ${BookHotelContent.billingAddress}';
      isValid = false;
    } else if (_creditCardNoTextFieldController.text.isEmpty ||
        _creditCardNoTextFieldController.text.length > 16 ||
        _creditCardNoTextFieldController.text.length < 16) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = BookHotelContent.creditCardNo
          : fieldsRequiredData = ', ${BookHotelContent.creditCardNo}';
      isValid = false;
    } else if (_creditCardTypeTextFieldController.text.isEmpty) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = BookHotelContent.creditCardType
          : fieldsRequiredData = ', ${BookHotelContent.creditCardType}';
      isValid = false;
    } else if (_expiryDateTextFieldController.text.isEmpty) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = BookHotelContent.expiryDate
          : fieldsRequiredData = ', ${BookHotelContent.expiryDate}';
      isValid = false;
    } else if (_cvvTextFieldController.text.isEmpty ||
        _cvvTextFieldController.text.length > 4) {
      fieldsRequiredData.isEmpty
          ? fieldsRequiredData = BookHotelContent.cvvNumber
          : fieldsRequiredData = ', ${BookHotelContent.cvvNumber}';
      isValid = false;
    }

    if (!isValid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            semanticLabel: BookHotelSemanticKeys.failureAlert,
            title: Text(BookHotelContent.errorMissingData),
            content: Text(
                '${BookHotelContent.errorRequireData} $fieldsRequiredData'),
            actions: <Widget>[
              FlatButton(
                child: Semantics(
                  enabled: true,
                  label: BookHotelSemanticKeys.failureAlertButton,
                  child: Text(BookHotelContent.alertButtonOk),
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

    return isValid;
  }
}
