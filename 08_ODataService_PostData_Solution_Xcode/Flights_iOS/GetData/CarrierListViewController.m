//
//  CarrierListViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "CarrierListViewController.h"
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

@interface CarrierListViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) id<SODataEntitySet> carrierList;

@end

@implementation CarrierListViewController

#pragma mark - Table view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self openOnlineStore];
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

-(void) openOnlineStore
{
    NSError *error;
    MAFLogonRegistrationData *regData = [self.appDelegate.logonHandler.logonManager registrationDataWithError:&error];
    NSString *endpointUrl = regData.applicationEndpointURL;
    SODataOnlineStore *onlineStore;
    
    if ([ConnectivitySettings useJSON]) {
        //Use options toconfigure the store to send the request payload in JSON format
        SODataOnlineStoreOptions *storeOptions = [[SODataOnlineStoreOptions alloc] init];
        storeOptions.requestFormat = SODataDataFormatJSON;
        onlineStore = [[SODataOnlineStore alloc] initWithURL:[NSURL URLWithString:endpointUrl]
                                     httpConversationManager:self.appDelegate.logonHandler.httpConvManager
                                                     options:storeOptions];
    } else {
        onlineStore = [[SODataOnlineStore alloc] initWithURL:[NSURL URLWithString:endpointUrl]
                                     httpConversationManager:self.appDelegate.logonHandler.httpConvManager];
    }
    
    self.appDelegate.flightsStore = onlineStore;
    
    [onlineStore setOnlineStoreDelegate:self];
    [onlineStore openStoreWithError:&error];
}

#pragma mark - SODataOnlineStoreDelegate

-(void)onlineStoreOpenFinished:(SODataOnlineStore *)store
{
    [Utilities showAlertWithTitle:@"OnlineStoreOpenFinished!" andMessage:nil];
    [self getODataEntries:[NSString stringWithFormat:@"%@?%@=%@", kCarrierCollection, kOrderBy, kAirlineID]];
}

-(void)onlineStoreOpenFailed:(SODataOnlineStore *)store error:(NSError *)error
{
    NSString* msg = [NSString stringWithFormat:@"Error: %@", error.description];
    [Utilities showAlertWithTitle:@"OnlineStoreOpenFailed: " andMessage:msg];
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
        
        if (request.mode == SODataRequestModeRead) {
            id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)requestExecution.response;
            if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntitySet)]) {
                
                self.carrierList = (id<SODataEntitySet>)responseSingle.payload;
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
    if ([[segue identifier] isEqualToString:@"ShowFlightList"]) {
        FlightListViewController *flightListViewController = [segue destinationViewController];
        flightListViewController.carrier = self.carrierList.entities[[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.carrierList.entities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"carrierListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    id<SODataEntity> entity = [self.carrierList.entities objectAtIndex:[indexPath row]];
    
    NSString *carrierID = (NSString *)[(id<SODataProperty>)entity.properties[kAirlineID] value];
    NSString *carrierName = (NSString *)[(id<SODataProperty>)entity.properties[kAirlineName] value];
    NSString *carrierURL = (NSString *)[(id<SODataProperty>)entity.properties[kAirlineURL] value];
    
    [[cell textLabel] setText:carrierID];
    cell.detailTextLabel.numberOfLines = 2;
    NSString *carrierDetails = [NSString stringWithFormat:@"%@\n%@", carrierName, carrierURL];
    [[cell detailTextLabel] setText:carrierDetails];
    
    return cell;
}


@end
