//
//  TravelAgencyDataController.h
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#import "SODataOnlineStore.h"


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
@property (nonatomic, strong) SODataOnlineStore *travelAgencyStore;
@property (nonatomic, strong) id<SODataEntitySet> entitySet;
@property (nonatomic, strong) id<SODataEntitySet> errorSet;


+ (TravelAgencyDataController *)uniqueInstance;
- (void)getODataEntries;

-(void)updateEntity:(id<SODataEntity>) entity;
-(void)deleteEntity:(id<SODataEntity>) entity;
-(void)createEntity:(id<SODataEntity>) entity;

-(void)openOnlineStore;

// Functionality related to technical cache
-(void)resetCache;
-(void)enablePassiveMode;
-(void)disablePassiveMode;




@end
