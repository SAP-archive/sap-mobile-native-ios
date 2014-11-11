//
//  FlightDetailsViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "FlightDetailsViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "SODataOnlineStore.h"
#import "ConnectivitySettings.h"
#import "SODataRequestParamSingleDefault.h"
#import "SODataRequestExecution.h"
#import "SODataResponseSingle.h"
#import "SODataEntitySet.h"
#import "SODataEntity.h"
#import "SODataEntityDefault.h"
#import "SODataProperty.h"
#import "SODataPropertyDefault.h"
#import "SODataError.h"
// REST
#import "RequestBuilder.h"

@interface FlightDetailsViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UILabel *airlineIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookFlightButton;

//Airport Status
@property (strong, nonatomic) NSDictionary *airportStatus;
@property (weak, nonatomic) IBOutlet UILabel *airportLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

- (IBAction)bookFlight:(id)sender;

@end

@implementation FlightDetailsViewController

- (void)setFlight:(id<SODataEntity>)flight
{
    
    if (_flight != flight) {
        _flight = flight;
        
        // Update the view.
        [self configureFlightView];
    }
}

- (void)setAirportStatus:(NSDictionary *)airportStatus
{
    if (_airportStatus != airportStatus) {
        _airportStatus = airportStatus;
    }
    [self configureAirportStatusView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *flightPath = self.flight.resourcePath;
    
    [self getODataEntries:flightPath];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - local methods

-(void)getODataEntries:(NSString *) query
{
    [self.appDelegate.flightsStore scheduleReadEntityWithResourcePath:query delegate:self options:nil];
}

- (void)loadAirportStatusUsingAirportCode:(NSString *)code
                                 delegate:(id <RequestDelegate>)delegate
                     andDidFinishSelector:(SEL)finishSelector
{
    NSError *error;
    MAFLogonRegistrationData* regData = [self.appDelegate.logonHandler.logonUIViewManager.logonManager registrationDataWithError:&error];
    
    NSString *airportStatusURL = [NSString stringWithFormat:@"http://%@:%d/%@/%@",regData.serverHost, regData.serverPort, kAirportStatus, code];
    
    NSLog(@"Airport Weather Status URL: %@", airportStatusURL);
    
    [RequestBuilder setRequestType:HTTPRequestType];
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:airportStatusURL]];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Accept" value:kApplicationJSON];
    
    [request setDelegate:delegate];
    
    //Set finish selector for request
    if (finishSelector) {
        request.didFinishSelector = finishSelector;
    }

    [request startAsynchronous];
}

- (void)airportStatusCompleted:(id<Requesting>)request
{
    NSData *responseData = [request responseData];
    
    //Parse JSON
    NSError *error;
    NSDictionary *statusInfo = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:kNilOptions
                                                                 error:&error];
    self.airportStatus = statusInfo;
}

-(void)createEntity:(id<SODataEntity>)entity
{

// TODO: BEGIN (Trigger HTTP PUT for Create)

    [self.appDelegate.flightsStore scheduleCreateEntity:entity collectionPath:kBookingCollection delegate:self options:nil];
    
// TODO: END (Trigger HTTP PUT for Create)

}

#pragma mark - SODataRequestDelegate

- (void) requestServerResponse:(id<SODataRequestExecution>)requestExecution
{
    id<SODataRequestParam> requestParam = requestExecution.request;
    id<SODataRequestParamSingle> request = (id<SODataRequestParamSingle>)requestParam;
    
    if ([requestParam conformsToProtocol:@protocol(SODataRequestParamSingle)]) {
        
        if (request.mode == SODataRequestModeRead) {
            id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)requestExecution.response;
            if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntitySet)]) {
                
            } else if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntity)]) {
                
                self.flight = (id<SODataEntity>)responseSingle.payload;

                NSDictionary *details = (NSDictionary *)[(id<SODataProperty>)self.flight.properties[kFlightDetails] value];
                NSString *airportDestination = (NSString *) [(id<SODataProperty>)details[kAirportDestination] value];
                
                [self loadAirportStatusUsingAirportCode:airportDestination delegate:self andDidFinishSelector:@selector(airportStatusCompleted:)];
                
            }
        } else if (request.mode == SODataRequestModeCreate) {

// TODO: BEGIN (Handle response of HTTP PUT/Create)
            
            id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)requestExecution.response;
            if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntity)]) {
                
                id<SODataEntity> booking = (id<SODataEntity>)responseSingle.payload;
                NSString *bookingID = (NSString *)[(id<SODataProperty>)booking.properties[kBookingID] value];
                
                NSString *message = [NSString stringWithFormat:@"Booking ID: %@", bookingID];
                [Utilities showAlertWithTitle:@"Booking Created Successfully!" andMessage:message];
            }

// TODO: END (Handle response of HTTP PUT/Create)
            
        }
    }
}

-(void)requestFailed:(id<SODataRequestExecution>)requestExecution error:(NSError *)error
{
    NSString* msg = [NSString stringWithFormat:@"Request failed: %@", error.description];
    if ([requestExecution.response conformsToProtocol:@protocol(SODataResponseSingle)]) {
        id<SODataResponseSingle> response = (id<SODataResponseSingle>)requestExecution.response;
        if ([[response payload] conformsToProtocol:@protocol(SODataError)]) {
            msg = [(id<SODataError>)[response payload] message];
            [Utilities showAlertWithTitle:@"Request failed: " andMessage:msg];
        }
    }
}

#pragma mark - Update UI

- (void)configureFlightView
{
    // Update the user interface for the flight detail item
    if (self.flight) {
        
        self.airlineIDLabel.text = (NSString *)[(id<SODataProperty>)self.flight.properties[kFlightAirlineID] value];
        self.flightNumberLabel.text = (NSString *)[(id<SODataProperty>)self.flight.properties[kFlightNumber] value];
        self.priceLabel.text = [NSString stringWithFormat:@"$%@",(NSString *)[(id<SODataProperty>)self.flight.properties[kFlightPrice] value]];
        NSDate *fldate = (NSDate *)[(id<SODataProperty>)self.flight.properties[kFlightDate] value];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        self.flightDateLabel.text = [dateFormatter stringFromDate:fldate];
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
}

- (void)configureAirportStatusView
{
    // Update the user interface with airport status data
    if (self.airportStatus) {
        
        NSDictionary* weatherData = [self.airportStatus objectForKey:kWeatherData];
        self.airportLabel.text = (NSString *)[self.airportStatus objectForKey:kAirportName];
        self.weatherLabel.text = (NSString *)[weatherData objectForKey:kWeather];
        self.temperatureLabel.text = (NSString *)[weatherData objectForKey:kTemperature];
        self.windLabel.text = (NSString *)[weatherData objectForKey:kWind];
        
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
}

- (IBAction)bookFlight:(id)sender
{
    
// TODO: BEGIN (Set Booking Info)
    
    NSMutableArray *properties = [NSMutableArray array];
    
    //Get current date for comparison and set up date formatter
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    //Check if Flight Date is in the past.
    NSString *strFldate = self.flightDateLabel.text;
    NSDate *fldate = [dateFormatter dateFromString:strFldate];
    if ([fldate compare:currDate ] == NSOrderedAscending) {
        [Utilities showAlertWithTitle:@"Past Flight"
                           andMessage:@"Flight date is in the past.\nChoose a future flight."];
    } else {
        
        id<SODataProperty> prop = [[SODataPropertyDefault alloc] initWithName:kBookingAirlineID];
        prop.value = self.airlineIDLabel.text;
        [properties addObject:prop];
        prop = [[SODataPropertyDefault alloc] initWithName:kBookingFlightNumber];
        prop.value = self.flightNumberLabel.text;
        [properties addObject:prop];
        prop = [[SODataPropertyDefault alloc] initWithName:kBookingFlightDate];
        prop.value = fldate;
        [properties addObject:prop];
        //CustomerID and AgencyID is hardcoded for simplicity
        prop = [[SODataPropertyDefault alloc] initWithName:kBookingCustomerID];
        prop.value = @"00000001";
        [properties addObject:prop];
        prop = [[SODataPropertyDefault alloc] initWithName:kBookingAgencyID];
        prop.value = @"00000114";
        [properties addObject:prop];
        
        SODataEntityDefault* entity = [[SODataEntityDefault alloc] initWithType:@"RMTSAMPLEFLIGHT.Booking"];
        for (id<SODataProperty> prop in properties) {
            [entity.properties setObject:prop forKey:prop.name];
        }
        
        [self createEntity:entity];
    }

// TODO: END (Set Booking Info)
    
}

@end
