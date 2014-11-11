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
#import "SODataProperty.h"
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

@property (strong) NSMutableArray* properties;


@end

@implementation FlightDetailsViewController

#pragma mark - Setter methods

- (void)setFlight:(id<SODataEntity>)flight
{
    
    if (_flight != flight) {
        _flight = flight;
        
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
    
// TODO: BEGIN (Get Flight Details)
    
    NSString *flightPath = self.flight.resourcePath;
    [self getODataEntries:flightPath];

// TODO: END (Get Flight Details)

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

// TODO: BEGIN (Invoking External REST Weather Info Service #1)
    
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
    
// TODO: END (Invoking External REST Weather Info Service #1)
    
}

- (void)airportStatusCompleted:(id<Requesting>)request
{

// TODO: BEGIN (Invoking External REST Weather Info Service #2)
    
    NSData *responseData = [request responseData];
    
    //Parse JSON
    NSError *error = nil;
    NSDictionary *statusInfo = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:kNilOptions
                                                                 error:&error];
    self.airportStatus = statusInfo;

// TODO: END (Invoking External REST Weather Info Service #2)

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

// TODO: BEGIN (Get Airport Info)
                
                self.flight = (id<SODataEntity>)responseSingle.payload;

                NSDictionary *details = (NSDictionary *)[(id<SODataProperty>)self.flight.properties[kFlightDetails] value];
                NSString *airportDestination = (NSString *) [(id<SODataProperty>)details[kAirportDestination] value];
                
                [self loadAirportStatusUsingAirportCode:airportDestination delegate:self andDidFinishSelector:@selector(airportStatusCompleted:)];

// TODO: END (Get Airport Info)
                
            }
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
    if (self.flight) {
        
// TODO: BEGIN (Render Flight Details)
        
        self.airlineIDLabel.text = (NSString *)[(id<SODataProperty>)self.flight.properties[kFlightAirlineID] value];
        self.flightNumberLabel.text = (NSString *)[(id<SODataProperty>)self.flight.properties[kFlightNumber] value];
        self.priceLabel.text = [NSString stringWithFormat:@"$%@",(NSString *)[(id<SODataProperty>)self.flight.properties[kFlightPrice] value]];
        NSDate *fldate = (NSDate *)[(id<SODataProperty>)self.flight.properties[kFlightDate] value];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        self.flightDateLabel.text = [dateFormatter stringFromDate:fldate];

// TODO: END (Render Flight Details)
    
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
}

- (void)configureAirportStatusView
{
    if (self.airportStatus) {

// TODO: BEGIN (Render Weather Info)
        
        NSDictionary* weatherData = [self.airportStatus objectForKey:kWeatherData];
        self.airportLabel.text = (NSString *)[self.airportStatus objectForKey:kAirportName];
        self.weatherLabel.text = (NSString *)[weatherData objectForKey:kWeather];
        self.temperatureLabel.text = (NSString *)[weatherData objectForKey:kTemperature];
        self.windLabel.text = (NSString *)[weatherData objectForKey:kWind];

// TODO: END (Render Weather Info)
        
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
}

@end
