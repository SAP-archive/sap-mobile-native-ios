//
//  FlightListViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "FlightListViewController.h"
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

@interface FlightListViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) id<SODataEntitySet> flightList;

@end

@implementation FlightListViewController

#pragma mark - Table view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];

//// TODO: BEGIN (Get Flight List)    
//    
//    NSString *carrierFlightsURL = [NSString stringWithFormat:@"%@/%@?%@=%@,%@,%@",
//                                   self.carrier.resourcePath,
//                                   kCarrierFlights,
//                                   kOrderBy,
//                                   kFlightAirlineID,
//                                   kFlightNumber,
//                                   kFlightDate];
//    [self getODataEntries:carrierFlightsURL];
//
//// TODO: END (Get Flight List)
    
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
    [self.appDelegate.flightsStore scheduleReadEntitySet:query delegate:self options:nil];
}

#pragma mark - SODataRequestDelegate

- (void) requestServerResponse:(id<SODataRequestExecution>)requestExecution
{
    id<SODataRequestParam> requestParam = requestExecution.request;
    id<SODataRequestParamSingle> request = (id<SODataRequestParamSingle>)requestParam;
    
    if ([requestParam conformsToProtocol:@protocol(SODataRequestParamSingle)]) {
        
        if (request.mode == SODataRequestModeRead){
            id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)requestExecution.response;
            if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntitySet)]) {
                
                self.flightList = (id<SODataEntitySet>)responseSingle.payload;
                [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                                 withObject:nil
                                              waitUntilDone:NO];
                
            } else if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntity)]) {

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

#pragma mark - Segue to detail

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowFlightDetails"]) {

    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.flightList.entities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"flightListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//// TODO: BEGIN (Render the Flight data)
//  
//    id<SODataEntity> entity = [self.flightList.entities objectAtIndex:[indexPath row]];
//    
//    NSString *airlineID = (NSString *)[(id<SODataProperty>)entity.properties[kFlightAirlineID] value];
//    NSString *flightNumber = (NSString *)[(id<SODataProperty>)entity.properties[kFlightNumber] value];
//    
//    NSDictionary *details = (NSDictionary *)[(id<SODataProperty>) entity.properties[kFlightDetails] value];
//    NSString *departureCity = (NSString *) [(id<SODataProperty>)details[kDepartureCity] value];
//    NSString *arrivalCity = (NSString *) [(id<SODataProperty>)details[kArrivalCity] value];
//    
//    NSDate *fldate = (NSDate *)[(id<SODataProperty>)entity.properties[kFlightDate] value];
//
//    NSString *strFlightDate = [fldate descriptionWithLocale:[NSLocale currentLocale]];
//    
//    NSString *airlineFlightNumber = [NSString stringWithFormat:@"%@ %@", airlineID, flightNumber];
//    NSString *flightInfo = [NSString stringWithFormat:@"%@ to %@\n%@", departureCity, arrivalCity, strFlightDate];
//    
//    [[cell textLabel] setText:airlineFlightNumber];
//    cell.detailTextLabel.numberOfLines = 2;
//    [[cell detailTextLabel] setText:flightInfo];
//    
//// TODO: END (Render the Flight data)
    
    return cell;
}

@end
