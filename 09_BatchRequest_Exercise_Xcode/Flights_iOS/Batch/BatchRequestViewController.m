//
//  BatchRequestViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "BatchRequestViewController.h"
#import "BatchResultViewController.h"
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
#import "ActivityIndicatorUtility.h"

// Batch
#import "SODataRequestParamBatchDefault.h"
#import "SODataRequestChangesetDefault.h"
#import "SODataResponseBatch.h"

@interface BatchRequestViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) FlightsMAFLogonHandler *logonHandler;
@property (strong, nonatomic) MAFLogonRegistrationData *data;

@property (strong, nonatomic) UIView* loadingView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;

@property (strong, nonatomic) SODataRequestParamBatchDefault *batchRequestParam;
@property (strong, nonatomic) SODataRequestChangesetDefault *changeset;
@property (strong, nonatomic) id<SODataResponseBatch> batchResponse;

@end

@implementation BatchRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Setter methods

- (void)setCUDCount:(int)CUDCount {
    _CUDCount = CUDCount;
    self.CUDCountLabel.text = [NSString stringWithFormat:@"CUDs: %d", self.CUDCount];
}

- (void)setRetrievalCount:(int)retrievalCount {
    _retrievalCount = retrievalCount;
    self.retrievalCountLabel.text = [NSString stringWithFormat:@"Retrievals: %d", self.retrievalCount];
}

- (void)setChangeSetCount:(int)changeSetCount {
    _changeSetCount = changeSetCount;
    self.changeSetCountLabel.text = [NSString stringWithFormat:@"ChangeSets: %d", self.changeSetCount];
}

- (void)setTotalRequestCount:(int)totalRequestCount {
    _totalRequestCount = totalRequestCount;
    self.totalRequestCountLabel.text = [NSString stringWithFormat:@"Total Requests: %d", self.totalRequestCount];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self openOnlineStore];
    
////TODO: BEGIN (Prepare batch params)
//    
//    self.batchRequestParam = [[SODataRequestParamBatchDefault alloc] init];
//    self.changeset = [[SODataRequestChangesetDefault alloc] init];
//
////TODO: END (Prepare batch params)

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self hideActivityIndicatorLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - local methods

-(void) openOnlineStore
{
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
}

#pragma mark - SODataOnlineStoreDelegate 

-(void)onlineStoreOpenFinished:(SODataOnlineStore *)store
{
    [self.appDelegate.flightsStore scheduleReadEntitySet:[NSString stringWithFormat: @"%@?$top=1", kTravelAgencyCollection] delegate:self options:nil];
}

-(void)onlineStoreOpenFailed:(SODataOnlineStore *)store error:(NSError *)error
{
    NSString* msg = [NSString stringWithFormat:@"Error: %@", error.description];
    [Utilities showAlertWithTitle:@"Opening Online Store Failed!" andMessage:msg];
}

#pragma mark - local Batch methods

- (SODataRequestParamSingleDefault *)requestParamForReadWithAgencyEntity:(id<SODataEntity>)entity
{
    
////TODO: BEGIN (Read an entity)
//    
//    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc] initWithMode:SODataRequestModeRead resourcePath:entity.editResourcePath];
//    
////TODO: END (Read an entity)
    
    return requestParam;
}

- (SODataRequestParamSingleDefault *)requestParamForUpdateWithAgencyEntity:(id<SODataEntity>)entity
{
    
////TODO: BEGIN (Update an entity)
//    
//    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc] initWithMode:SODataRequestModeUpdate resourcePath:entity.editResourcePath];
//    requestParam.payload = entity;
//
////TODO: END (Update an entity)
    
    return requestParam;
}

- (SODataRequestParamSingleDefault *)requestParamForCreateWithAgencyEntity:(id<SODataEntity>)entity
{
    
////TODO: BEGIN (Create an entity)
//    
//    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc] initWithMode:SODataRequestModeCreate resourcePath:kTravelAgencyCollection];
//    requestParam.payload = entity;
//
////TODO: END (Create an entity)
    
    return requestParam;
}

- (SODataRequestParamSingleDefault *)requestParamForDeleteWithAgencyEntity:(id<SODataEntity>)entity
{

////TODO: BEGIN (Delete an entity)
//    
//    SODataRequestParamSingleDefault* requestParam = [[SODataRequestParamSingleDefault alloc] initWithMode:SODataRequestModeDelete resourcePath:entity.editResourcePath];
//
////TODO: END (Delete an entity)
    
    return requestParam;
}

- (IBAction)AddRequestToBatch:(UIButton *)sender
{
    //Validate - At least Agency ID is required

    NSString *currentButton = [sender currentTitle];
    if ([self.agencyIDInput.text length] == 0 && ![currentButton isEqualToString:@"Add Get Agencies"]) {
        [Utilities showAlertWithTitle:@"Agency ID Field Empty" andMessage:@"Agency ID is required"];
    } else {

        NSString *travelAgencyCollectionURLWithID = [NSString stringWithFormat: @"%@('%@')", kTravelAgencyCollection, self.agencyIDInput.text];
        
        //Add request to batch
        if ([currentButton isEqualToString:@"Add Read Agency"]){
            [self addRequestWithMethod:@"GET" andUrl:travelAgencyCollectionURLWithID];
        } else if ([currentButton isEqualToString:@"Add Create Agency"]){
            [self addRequestWithMethod:@"POST" andUrl:kTravelAgencyCollection];
        } else if ([currentButton isEqualToString:@"Add Update Agency"]){
            [self addRequestWithMethod:@"PUT" andUrl:travelAgencyCollectionURLWithID];
        } else if ([currentButton isEqualToString:@"Add Delete Agency"]){
            [self addRequestWithMethod:@"DELETE" andUrl:travelAgencyCollectionURLWithID];
        }
        
        //Dismiss keyboard
        if ([self.agencyIDInput isFirstResponder]){
            [self.agencyIDInput resignFirstResponder];
        } else if ([self.agencyTelephone isFirstResponder]) {
            [self.agencyTelephone resignFirstResponder];
        }
    }
    
}

- (void)addRequestWithMethod:(NSString *)method andUrl:(NSString *)url
{
    NSLog(@"Adding %@ Travel Agency request to batch", method);

////TODO: BEGIN (Prepare an entity)
//    
//    SODataEntityDefault *entity = [[SODataEntityDefault alloc] initWithType:@"RMTSAMPLEFLIGHT.Travelagency"];
//    [entity setResourcePath:url editResourcePath:url];
//
////TODO: END (Prepare an entity)
    
    //Add GET (Read single Travel Agency)
    if ([method isEqualToString:@"GET"]) {

        [self.batchRequestParam.batchItems addObject:[self requestParamForReadWithAgencyEntity:entity]];
        
        self.retrievalCount++;
        self.totalRequestCount++;
        return;
    }

    //Add DELETE
    if ([method isEqualToString:@"DELETE"]) {

        [self.changeset.requestParams addObject:[self requestParamForDeleteWithAgencyEntity:entity]];
        
        self.CUDCount++;
        self.totalRequestCount++;
        return;
    }
    
////TODO: BEGIN (Setting the property values for the entity)
//    
//    //Add CREATE or UPDATE
//    NSMutableArray *properties = [NSMutableArray array];
//
//    id<SODataProperty> prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyID];
//    prop.value = self.agencyIDInput.text;
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyName];
//    prop.value = @"SMP Batch Travel";
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyCity];
//    prop.value = @"Palo Alto";
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyStreet];
//    prop.value = @"123 SMP Street";
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyRegion];
//    prop.value = @"CA";
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyPostalCode];
//    prop.value = @"94304";
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyCountry];
//    prop.value = @"US";
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyTelephoneNumber];
//    prop.value = self.agencyTelephone.text;
//    [properties addObject:prop];
//    prop = [[SODataPropertyDefault alloc] initWithName:kTravelAgencyURL];
//    prop.value = @"www.smp-travel.com";
//    [properties addObject:prop];
//    
//    for (id<SODataProperty> prop in properties) {
//        [entity.properties setObject:prop forKey:prop.name];
//    }
//    
////TODO: END (Setting the property values for the entity)
    
    if ([method isEqualToString:@"POST"]) {
        [self.changeset.requestParams addObject:[self requestParamForCreateWithAgencyEntity:entity]];
    } else if ([method isEqualToString:@"PUT"]) {
        [self.changeset.requestParams addObject:[self requestParamForUpdateWithAgencyEntity:entity]];
    }
    
    self.CUDCount++;
    self.totalRequestCount++;
}


- (IBAction)AddCloseChangeset:(UIButton *)sender
{
    NSLog(@"Adding Close changeset to batch");

////TODO: BEGIN (Adding a changeset to the batch)
//    
//    [self.batchRequestParam.batchItems addObject:self.changeset];
//    
////TODO: END (Adding a changeset to the batch)
    
    self.changeset = [[SODataRequestChangesetDefault alloc] init];
    self.changeSetCount++;
}

- (IBAction)executeAsyncBatchRequest:(UIButton *)sender
{
    
////TODO: BEGIN (Execute the batch request)
//    
//    [self.appDelegate.flightsStore scheduleRequest:self.batchRequestParam delegate:self];
//    
////TODO: END (Execute the batch request)
    
    //Reset BatchRequest and counters
    self.batchRequestParam = [[SODataRequestParamBatchDefault alloc] init];
    self.changeset = [[SODataRequestChangesetDefault alloc] init];
    
    self.CUDCount = 0;
    self.retrievalCount = 0;
    self.changeSetCount = 0;
    self.totalRequestCount = 0;
    
    [self showActivityIndicatorLayer];
}

#pragma mark - SODataRequestDelegate 

- (void) requestServerResponse:(id<SODataRequestExecution>)requestExecution
{
    if ([requestExecution.response conformsToProtocol:@protocol(SODataResponseBatch)]) {

////TODO: BEGIN (Receive the batch response)
//        
//        self.batchResponse = (id<SODataResponseBatch>)requestExecution.response;
//        
////TODO: END (Receive the batch response)
        
        [self performSegueWithIdentifier: @"ShowBatchResults" sender:self];
    }
}

- (void)requestFailed:(id<SODataRequestExecution>)requestExecution error:(NSError *)error
{
    NSString* msg = [NSString stringWithFormat:@"Request failed: %@", error.description];
    if ([requestExecution.response conformsToProtocol:@protocol(SODataResponseSingle)]) {
        id<SODataResponseSingle> response = (id<SODataResponseSingle>)requestExecution.response;
        if ([[response payload] conformsToProtocol:@protocol(SODataError)]) {
            msg = [(id<SODataError>)[response payload] message];
        }
    }
    [Utilities showAlertWithTitle:@"HTTP Request Failed!" andMessage:msg];
    [self hideActivityIndicatorLayer];
}

#pragma mark - Segue to batch response scene

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowBatchResults"]) {
        BatchResultViewController *batchResultViewController = [segue destinationViewController];
        batchResultViewController.batchResponse = self.batchResponse;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

#pragma mark - for ActivityIndicator

- (void) showActivityIndicatorLayer
{
    if (self.loadingView) {
        return;
    }
    [self.createButton setEnabled:NO];
    self.loadingView = [ActivityIndicatorUtility createForView:self.view];
}

- (void) hideActivityIndicatorLayer
{
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
    [self.createButton setEnabled:YES];
    
}

@end
