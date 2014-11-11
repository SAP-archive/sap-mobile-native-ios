//
//  TravelAgencyDataController.h
//  TravelAgency_RKT
//
//  Created by Hameed, Thasneem Yasmin
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#import "SODataStore.h"
#import "SODataStoreAsync.h"


#import "SODataRequestDelegate.h"
#import "SODataRequestExecution.h"
#import "SODataResponseSingle.h"
#import "SODataError.h"
#import "SODataRequestParamSingleDefault.h"


#import "SODataEntitySet.h"
#import "SODataEntity.h"
#import "SODataProperty.h"
#import "MAFLogonHandler.h"

@interface TravelAgencyDataController : NSObject<SODataRequestDelegate>
{
    dispatch_queue_t getAfterCUDQueue;
}

@property (nonatomic, strong) MAFLogonHandler *logonHandler;
@property (nonatomic, strong) MAFLogonRegistrationData *data;

@property (nonatomic, strong) NSString *endpointUrl;
@property (nonatomic) id<SODataStore, SODataStoreAsync> travelAgencyStore;
@property (nonatomic, strong) id<SODataEntitySet> entitySet;
@property (nonatomic, strong) id<SODataEntitySet> errorSet;


+ (TravelAgencyDataController *)uniqueInstance;
- (void)getODataEntries;

-(void)updateEntity:(id<SODataEntity>) entity;
-(void)deleteEntity:(id<SODataEntity>) entity;
-(void)createEntity:(id<SODataEntity>) entity;

-(void)openOnlineStore;

-(void)openOfflineStore;
-(void)flushAndRefreshData;
-(void)clearStore;


@end
