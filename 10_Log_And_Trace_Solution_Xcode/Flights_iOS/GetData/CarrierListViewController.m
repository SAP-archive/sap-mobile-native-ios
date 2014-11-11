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

// TODO: BEGIN (Required imports)

#import "SAPSupportabilityFacade.h"
#import "SAPClientLogManager.h"
#import "SAPClientLogger.h"
#import "SAPE2ETraceManager.h"
#import "SAPE2ETrace.h"
#import "SAPE2ETraceRequest.h"
#import "SupportabilityUploader.h"
#import "SupportabilityUploading.h"

// TODO: END (Required imports)

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

-(SupportabilityUploader *)configuredUploader:(NSString *)type
{
    NSError *error = nil;
    MAFLogonRegistrationData *regData = [self.appDelegate.logonHandler.logonManager registrationDataWithError:&error];
    
// TODO: BEGIN (Creating the uploader instance)
    
    NSString *uploadURL = [NSString stringWithFormat:@"%@://%@:%i/%@", regData.isHttps ? @"https" : @"http",regData.serverHost, regData.serverPort, type];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uploadURL]];
    [request setValue:regData.applicationConnectionId forHTTPHeaderField:@"X-SMP-APPCID"];
    
    SupportabilityUploader* uploader = [[SupportabilityUploader alloc]
                                        initWithHttpConversationManager:self.appDelegate.logonHandler.httpConvManager
                                                             urlRequest:request];
    
// TODO: END (Creating the uploader instance)
    
    return uploader;
}

- (void)doLogging
{
    
// TODO: BEGIN (Do the basic logging for debug)
    
    NSString *loggerId = @"com.sap.logging.all";
    id<SAPClientLogManager> logManager = [[SAPSupportabilityFacade sharedManager] getClientLogManager];
    [logManager setLogLevel:AllClientLogLevel forIdentifier:loggerId];
    [logManager setLogDestination:(CONSOLE | FILESYSTEM) forIdentifier:loggerId];
    
    id<SAPClientLogger> logger = [[SAPSupportabilityFacade sharedManager] getClientLogger:loggerId];
    
    // Logging a message
    [logger logDebug:@"Log something..."];
    
// TODO: END (Do the basic logging for debug)
    
// TODO: BEGIN (Upload the log file to SMP server)
    
    [[[SAPSupportabilityFacade sharedManager] getClientLogManager] uploadClientLogs:[self configuredUploader:@"clientlogs"] completion:^(NSError* error) {
        if (error == nil) {
            [Utilities showAlertWithTitle:@"Log upload succeeded!" andMessage:nil];
        } else {
            [Utilities showAlertWithTitle:@"Log upload failed:" andMessage:[error description]];
        }
    }];

// TODO: END (Upload the log file to SMP server)
    
}

-(void)startTrace
{
    NSError *error;
    MAFLogonRegistrationData *regData = [self.appDelegate.logonHandler.logonManager registrationDataWithError:&error];
    NSString *traceName = regData.applicationConnectionId ? regData.applicationConnectionId : @"New Registration";
    
// TODO: BEGIN (Starting the E2E trace)
    
    id<SAPE2ETraceManager> e2eTraceManager = [[SAPSupportabilityFacade sharedManager] getE2ETraceManager];
    id<SAPE2ETraceTransaction> e2eTraceTransaction = [e2eTraceManager startTransaction:traceName error:&error];
    
    [e2eTraceTransaction startStep:&error];

// TODO: END (Starting the E2E trace)
    
}

-(void)endAndUploadTrace
{
    NSError *error;
    
// TODO: BEGIN (Ending the E2E trace)
    
    id<SAPE2ETraceManager> e2eTraceManager = [[SAPSupportabilityFacade sharedManager] getE2ETraceManager];
    
    [[e2eTraceManager getActiveTransaction] endStep:&error];
    
    if (error) {
        NSLog(@"end trace error = %@", error);
    } else {
        
        /*
         Commit the end of the transaction
         */
        [[e2eTraceManager getActiveTransaction] endTransaction:&error];
        
        if (error) {
            NSLog(@"end trace error = %@", error);
        } else {
            error = nil;
            NSString* btx = [e2eTraceManager getBTX:&error];
            NSLog(@"btx = \n%@", btx);
 
// TODO: END (Ending the E2E trace)
    
// TODO: BEGIN (Upload the trace file)
            
            [e2eTraceManager uploadBTX:[self configuredUploader:@"btx"] completion:^(NSError* error) {
                if (error == nil) {
                    [Utilities showAlertWithTitle:@"Trace upload succeeded!" andMessage:nil];
                } else {
                    [Utilities showAlertWithTitle:@"Trace upload failed:" andMessage:[error description]];
                }
            }];

        }
    }
// TODO: END (Upload the trace file)

}

-(void) openOnlineStore
{

// TODO: BEGIN (Run the logging code)
    
    [self doLogging];
    
// TODO: END (Run the logging code)
    
// TODO: BEGIN (Toggle the start trace)
    
    [self startTrace];

// TODO: END (Toggle the start trace)
    
    NSError *error = nil;
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

// TODO: BEGIN (Toggle the end trace)
    
    [self endAndUploadTrace];

// TODO: END (Toggle the end trace)
    
}

#pragma mark - SODataOnlineStoreDelegate

-(void)onlineStoreOpenFinished:(SODataOnlineStore *)store
{
    [self getODataEntries:kCarrierCollection];
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
