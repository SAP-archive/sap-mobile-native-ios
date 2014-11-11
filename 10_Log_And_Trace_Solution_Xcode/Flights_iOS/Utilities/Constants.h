//
//  Constants.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//


static NSString * const kApplicationJSON = @"application/json";
static NSString * const kApplicationXML = @"application/xml";
static NSString * const kApplicationAtom = @"application/atom+xml";
static NSString * const kCharSetUTF8 = @"charset=utf-8";
static NSString * const kFormatJSON = @"$format=json";
static NSString * const kApplicationConnectionId = @"ApplicationConnectionId";
static NSString * const kErrorDomain = @"SAP Mobile Platform Service Proxy";
static NSString * const kBatch = @"$batch";
static NSString * const kX_SUP_APPCID = @"X-SUP-APPCID";
static NSString * const kx_csrf_token = @"x-csrf-token";
static NSString * const kAuthenticationNeeded = @"AuthenticationNeeded";
static NSString * const kMetadata = @"$metadata";
static NSString * const kFilter = @"$filter";
static NSString * const kDateTime = @"datetime";

#pragma mark - Carrier
static NSString * const kCarrierCollection = @"CarrierCollection";
static NSString * const kAirlineID = @"carrid";
static NSString * const kAirlineName = @"CARRNAME";
static NSString * const kAirlineURL = @"URL";

#pragma mark - Flight
static NSString * const kFlightCollection = @"FlightCollection";
static NSString * const kFlightAirlineID = @"carrid";
static NSString * const kFlightNumber = @"connid";
static NSString * const kFlightDate = @"fldate";
static NSString * const kFlightPrice = @"PRICE";
static NSString * const kFlightServiceDocument = @"FlightServiceDocument";
static NSString * const kCarrierFlights = @"carrierFlights";

#pragma mark - Flight Details
static NSString * const kFlightLinkTitle = @"Flight";
static NSString * const kFlightLinkTitle1JSON = @"RMTSAMPLEFLIGHT.Flight";
static NSString * const kFlightLinkTitle2JSON = @"RMTSAMPLEFLIGHTCOMPOSITION.Flight";
static NSString * const kFlightLinkRel = @"edit";
static NSString * const kFlightDetails = @"flightDetails";
static NSString * const kDepartureCity = @"cityFrom";
static NSString * const kArrivalCity = @"cityTo";
static NSString * const kAirportOrigin = @"airportFrom";
static NSString * const kAirportDestination = @"airportTo";

#pragma mark - Booking
static NSString * const kBookingCollection = @"BookingCollection";
static NSString * const kBookingAirlineID = @"carrid";
static NSString * const kBookingFlightNumber = @"connid";
static NSString * const kBookingFlightDate = @"fldate";
static NSString * const kBookingID = @"bookid";
static NSString * const kBookingCustomerID = @"CUSTOMID";
static NSString * const kBookingAgencyID = @"AGENCYNUM";
static NSString * const kBookingOrderDate = @"ORDER_DATE";
static NSString * const kPassengerBirthdate = @"PASSBIRTH";
//Edm.Decimal values - have to supply due to "null=true" bug
static NSString * const kBookingLuggageWeight = @"LUGGWEIGHT";
static NSString * const kBookingLocalCurrencyAmount = @"LOCCURAM";
static NSString * const kBookingForeignCurrencyAmount = @"FORCURAM";

#pragma mark - Travel Agency
static NSString * const kTravelAgencyCollection = @"TravelagencyCollection";
static NSString * const kTravelAgencyID = @"agencynum";
static NSString * const kTravelAgencyName = @"NAME";
static NSString * const kTravelAgencyStreet = @"STREET";
static NSString * const kTravelAgencyCity = @"CITY";
static NSString * const kTravelAgencyRegion = @"REGION";
static NSString * const kTravelAgencyPostalCode = @"POSTCODE";
static NSString * const kTravelAgencyCountry = @"COUNTRY";
static NSString * const kTravelAgencyTelephoneNumber = @"TELEPHONE";
static NSString * const kTravelAgencyURL = @"URL";

#pragma mark - Airport Weather Status
static NSString * const kAirportStatus = @"AirportStatus";
static NSString * const kAirportName = @"name";
static NSString * const kWeatherData = @"weather";
static NSString * const kWeather = @"weather";
static NSString * const kTemperature = @"temp";
static NSString * const kWind = @"wind";
