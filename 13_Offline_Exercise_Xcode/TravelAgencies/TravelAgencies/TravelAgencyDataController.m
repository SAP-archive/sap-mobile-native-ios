//
//  TravelAgencyDataController.m
//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "TravelAgencyDataController.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "Constants.h"

#import "SODataOnlineStore.h"
#import "SODataOnlineStoreDelegate.h"


//TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ######################################
//#import "SODataOfflineStoreOptions.h"
//#import "SODataOfflineStore.h"
//TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################

//TODO: BEGIN (ADD OFFLINE DELEGATE PROTOCOLS) #######################################

@interface TravelAgencyDataController () <SODataOnlineStoreDelegate>

//TODO: END (ADD OFFLINE DELEGATE PROTOCOLS) ######################################

@end


@implementation TravelAgencyDataController


- (id)init {
    if (self = [super init]) {
        
          NSError* error = nil;
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        self.logonHandler = appDelegate.logonHandler;
        
         getAfterCUDQueue = dispatch_queue_create("com.getAfterCUDQueue", NULL);
        
        self.data = [self.logonHandler.logonUIViewManager.logonManager registrationDataWithError:&error];
    
        
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            return nil;
        }
        
        self.endpointUrl = self.data.applicationEndpointURL;
        
      return self;
    }
    
    
    return nil;
}

#pragma mark - Singleton

+ (TravelAgencyDataController *)uniqueInstance
{
    static TravelAgencyDataController *instance;
	
    @synchronized(self) {
        if (!instance) {
            instance = [[TravelAgencyDataController alloc] init];
        }
        return instance;
    }
}



#pragma mark - Get

-(void)getODataEntries
{
    
    [self.travelAgencyStore scheduleReadEntitySet:kTravelAgencyCollection delegate:self options:nil];

}

#pragma mark - Create, Update and Delete

-(void)updateEntity:(id<SODataEntity>) entity
{
    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc]
                                                     initWithMode:SODataRequestModeUpdate
                                                     resourcePath:entity.editResourcePath];
    requestParam.payload = entity;
    requestParam.customTag = [NSString stringWithFormat:@"tag%@", [[NSUUID UUID] UUIDString]];
    [self.travelAgencyStore scheduleRequest:requestParam delegate:self];
    
}

-(void)deleteEntity:(id<SODataEntity>) entity
{
    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc]
                                                     initWithMode:SODataRequestModeDelete
                                                     resourcePath:entity.editResourcePath];
    requestParam.customTag = [NSString stringWithFormat:@"tag%@", [[NSUUID UUID] UUIDString]];
    [self.travelAgencyStore scheduleRequest:requestParam delegate:self];
}

-(void)createEntity:(id<SODataEntity>) entity
{
    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc]
                                                     initWithMode:SODataRequestModeCreate
                                                     resourcePath:kTravelAgencyCollection];
    requestParam.payload = entity;
    requestParam.customTag = [NSString stringWithFormat:@"tag%@", [[NSUUID UUID] UUIDString]];
    [self.travelAgencyStore scheduleRequest:requestParam delegate:self];
}

#pragma mark - SODataRequestDelegate implementation
- (void) requestStarted:(id<SODataRequestExecution>)requestExecution {
  
}

- (void) requestServerResponse:(id<SODataRequestExecution>)requestExecution {

    id<SODataRequestParam> requestParam = requestExecution.request;
    id<SODataRequestParamSingle> request = (id<SODataRequestParamSingle>)requestParam;
    
    if ([requestParam conformsToProtocol:@protocol(SODataRequestParamSingle)])
    {
        
        if (request.mode == SODataRequestModeRead)
        {
            id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)requestExecution.response;
            if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntitySet) ])
            {
                if ([requestParam.customTag hasPrefix:@"tag"])
                {
                    id<SODataEntitySet> errors = (id<SODataEntitySet>)responseSingle.payload;
                    
                    for (id<SODataEntity> entity in errors.entities) {
                        NSString *requestBody = (NSString *)[(id<SODataProperty>)[entity.properties objectForKey:@"RequestBody"] value];
                        NSString *requestUrl = (NSString *)[(id<SODataProperty>)[entity.properties objectForKey:@"RequestURL"] value];
                        
                        NSLog(@" %@\n",requestBody);
                        NSLog(@" %@\n",requestUrl);
                        
                        [self.travelAgencyStore scheduleDeleteEntity:entity delegate:self options:nil];
                    }
                    
                } else
                {
                    self.entitySet = (id<SODataEntitySet>)responseSingle.payload;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRequestCompleted object:nil];
                }
            }
        } else if ((request.mode == SODataRequestModeUpdate) || (request.mode == SODataRequestModeDelete) || (request.mode == SODataRequestModeCreate) || (request.mode == SODataRequestModePatch))
        {
            dispatch_async(getAfterCUDQueue,^{
                [self getODataEntries];
            });
            
        } else
            
        {
            [NSException raise:@"Error"
                        format:@"Unknown Error! (%s)", __PRETTY_FUNCTION__];
        }
    }
}


- (void) requestFinished:(id<SODataRequestExecution>)requestExecution {
  
}

-(void)requestFailed:(id<SODataRequestExecution>)requestExecution error:(NSError *)error {
    
    NSString* msg = [NSString stringWithFormat:@"Request failed: %@", error.description];
    if ([requestExecution.response conformsToProtocol:@protocol(SODataResponseSingle)]) {
        id<SODataResponseSingle> response = (id<SODataResponseSingle>)requestExecution.response;
        if ([[response payload] conformsToProtocol:@protocol(SODataError)]) {
            msg = [(id<SODataError>)[response payload] message];
        }
    } else {
        [NSException raise:@"Error"
                    format:@"Unknown Error! (%s)", __PRETTY_FUNCTION__];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRequestCompleted object:msg];
}

#pragma mark - OnlineStore
// Open an online store
-(void) openOnlineStore {
    
    SODataOnlineStore* onlineStore = [[SODataOnlineStore alloc] initWithURL:[NSURL URLWithString:self.endpointUrl]  httpConversationManager:self.logonHandler.httpConvManager];
    
    self.travelAgencyStore = onlineStore;
    
    [onlineStore setOnlineStoreDelegate:self];
    
    NSError *error = nil;
    BOOL success = [onlineStore openStoreWithError:&error];
    if (!success)
    {
        NSLog(@"Failed to open store: %@", [error description]);
    }
    
}

#pragma mark - SODataOnlineStoreDelegates

-(void)onlineStoreOpenFinished:(SODataOnlineStore *)store{
    [self getODataEntries];
    
}

-(void)onlineStoreOpenFailed:(SODataOnlineStore *)store error:(NSError *)error{
    
    NSString *msg = error.description;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRequestCompleted object:msg];
}

#pragma mark - OfflineStore
//TODO: BEGIN ( ADD OPEN OFFLINE STORE) #######################################################


//TODO: END ( ADD OPEN OFFLINE STORE) #######################################################
 


 #pragma mark - OfflineStore Delegate methods
 //TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################
 
// - (void) offlineStoreStateChanged:(SODataOfflineStore *)store state:(SODataOfflineStoreState)newState
// {
// 
//    switch (newState)
//    {
//     case SODataOfflineStoreOpening:  // The store has started to open
//     NSLog(@"SODataOfflineStoreOpening: The store has started to open\n");
//     break;
// 
//     case SODataOfflineStoreInitializing:
//     NSLog(@"SODataOfflineStoreInitializing :Initializing the resources for a new store\n");
//     break;
//     
//     case SODataOfflineStorePopulating:
//     NSLog(@" SODataOfflineStorePopulating: Creating and populating the store in the mid-tier\n");
//     break;
//     
//     case SODataOfflineStoreDownloading:
//     NSLog(@" SODataOfflineStoreDownloading:  Downloading the populated store.\n");
//     break;
//     
//     case SODataOfflineStoreOpen:
//     NSLog(@"SODataOfflineStoreOpen : The store has opened successfully\n");
//     [self getODataEntries];
//     break;
//     
//     case SODataOfflineStoreClosed:
//     NSLog(@"SODataOfflineStoreClosed :The store has been closed by the user while still opening\n");
//     break;
// 
//    }
//
// }
//
//- (void) offlineStoreOpenFailed:(SODataOfflineStore*) store error:(NSError*) error
//{
//    NSLog(@"Store Open failed %@", error.description);
//}
//TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################


# pragma mark - Schedule Flush Call

//TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################
//-(void)flushAndRefreshData
//{
//    [(SODataOfflineStore*)self.travelAgencyStore scheduleFlushQueuedRequestsWithDelegate:self];
//}
//TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################


#pragma mark - Flush Delegate methods
//TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################

//- (void) offlineStoreFlushStarted:(SODataOfflineStore*) store
//{
//    NSLog(@"Flush started");
//}
//
//- (void) offlineStoreFlushFinished:(SODataOfflineStore*) store
//{
//    NSLog(@"Flush finished");
//}
//
//- (void) offlineStoreFlushSucceeded:(SODataOfflineStore*) store
//{
//    NSLog(@"Flush succeeded");
//    [(SODataOfflineStore*)self.travelAgencyStore scheduleRefreshWithDelegate:self];
//    
//}
//- (void) offlineStoreFlushFailed:(SODataOfflineStore*) store error:(NSError*) error
//{
//    NSLog(@"Flush failed");
//}
//TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################


#pragma mark - SODataOfflineStoreRequestErrorDelegate
//TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################
//- (void) offlineStoreRequestFailed:(SODataOfflineStore *)store request:(id<SODataRequestExecution>)requestExecution error:(NSError *)error
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [Utilities showAlertWithTitle:@"Oops: " andMessage:error.description];
//    });
//    
//    id<SODataRequestParam> requestParam = requestExecution.request;
//    
//    SODataRequestParamSingleDefault *requestP = [[SODataRequestParamSingleDefault alloc]
//                                                 initWithMode:SODataRequestModeRead
//                                                 resourcePath:[NSString stringWithFormat:@"ErrorArchive?$filter=CustomTag eq '%@'", requestParam.customTag]];
//    requestP.customTag = requestParam.customTag;
//    [self.travelAgencyStore scheduleRequest:requestP delegate:self];
//}
//TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################

#pragma mark - OfflineStore Refresh Delegate methods
//TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################

//- (void) offlineStoreRefreshSucceeded:(SODataOfflineStore *)store
//{
//    NSLog(@"Refresh succeeded");
//    // Retrieve from db
//    [self getODataEntries];
//}
//
//- (void) offlineStoreRefreshFailed:(SODataOfflineStore *)store error:(NSError *)error
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [Utilities showAlertWithTitle:@"Offline StoreRefresh Failed" andMessage:error.description];
//    });
//}
//
//-(void)offlineStoreRefreshFinished:(SODataOfflineStore *)store
//{
//    NSLog(@"Refresh finished");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [Utilities showAlertWithTitle:@"Success" andMessage:@"Flush and Refresh Completed"];
//    });
//}
//
//-(void)offlineStoreRefreshStarted:(SODataOfflineStore *)store
//{
//    NSLog(@"Refresh started");
//}

//TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################




#pragma mark - Clear OfflineStore
 //TODO: BEGIN (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################

//-(void) clearStore {
// 
//     NSError *error = nil;
//     [(SODataOfflineStore*)self.travelAgencyStore closeStoreWithError:&error];
//     [SODataOfflineStore RemoveStoreWithOptions:[self storeOptions] error:&error];
//     if (error)
//     {
//        [Utilities showAlertWithTitle:@"Error" andMessage:[error description]];
//     } else
//     {
//        [Utilities showAlertWithTitle:@"Success" andMessage:@"Offline store removed"];
//     }
//}

 //TODO: END (UNCOMMENT OFFLINE ODATA EXERCISE) ########################################


@end
