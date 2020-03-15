class BookHotelContent {
  static const String pageTitle = 'Book A Hotel';
  static const String hotelName = 'Hotel Name';
  static const String location = 'Location';
  static const String roomType = 'Room Type';
  static const String numberOfRooms = 'Number of Rooms';
  static const String totalDays = 'Total Days';
  static const String pricePerNight = 'Price per Night';
  static const String totalPrice = 'Total Price';
  static const String gst = 'GST';
  static const String finalBilledPrice = 'Final Billed Price';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String billingAddress = 'Billing Address';
  static const String creditCardNo = 'Dummy CC Number';
  static const String creditCardType = 'Dummy CC Type';
  static const String expiryDate = 'Expiry Date';
  static const String cvvNumber = 'Dummy CVV Number';
  static const String bookNow = 'Book Now';
  static const String firstNameHint = 'Enter First Name';
  static const String lastNameHint = 'Enter Last Name';
  static const String billingAddressHint = 'Enter Billing Address';
  static const String creditCardNoHint = 'Enter Card Number';
  static const String creditCardNoHelper = 'Use 16 digit Dummy Data';
  static const String creditCardTypeHint = 'Select Credit Card Type';
  static const String expiryDateHint = 'Select Expiry Month & Year';
  static const String cvvNumberHint = 'Enter CVV Number';
  static const String errorFistName = 'Please enter your first name';
  static const String errorLastName = 'Please enter your last name';
  static const String errorBillingAddress = 'Please Enter your address';
  static const String errorCreditCardNo =
      'Please Enter 16 Digits of Credit Card Number !!!';
  static const String errorCreditCardType =
      'Please select your credit card type';
  static const String errorExpiryDate =
      'Please select valid Expiry Month & Year of your Card';
  static const String errorCVV = 'Please enter your CVV mumber';
  static const String errorCVVLength =
      'CVV Number should be less than 5 digits !!!';
  static const String cancel = 'Cancel';
  static const String errorMissingData = 'Missing Data';
  static const String errorRequireData =
      'Please provide data for following fields -';
  static const String alertButtonOk = 'OK';
  static const String alertFailureTitle = 'Failure';

  List<String> creditCardTypeValues() => [
        'American Express',
        'VISA',
        'Master Card',
        'Other',
      ];
}
