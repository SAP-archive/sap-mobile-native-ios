//
//  TravelAgencyDataController.m
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "TravelAgencyDataController.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "Constants.h"

#import "SODataOnlineStore.h"
#import "SODataOnlineStoreDelegate.h"





@interface TravelAgencyDataController () <SODataOnlineStoreDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) id<SODataRequestExecution>requestExecution;
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

- (void)getErrors
{
    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc] initWithMode:SODataRequestModeRead resourcePath:@"ErrorArchive"];
    
    requestParam.customTag = @"Error";
    
    [self.travelAgencyStore scheduleRequest:requestParam delegate:self];
    
}

-(void)parseError
{
    for (id<SODataEntity> entity in self.errorSet.entities)
    {
        
        NSString *requestBody = (NSString *)[(id<SODataProperty>)[entity.properties objectForKey:@"RequestBody"] value];
        NSString *requestUrl = (NSString *)[(id<SODataProperty>)[entity.properties objectForKey:@"RequestURL"] value];
        
        NSLog(@" %@\n",requestBody);
        NSLog(@" %@\n",requestUrl);
    }
}

#pragma mark - Create, Update and Delete

-(void)updateEntity:(id<SODataEntity>) entity
{
    
     [self.travelAgencyStore scheduleUpdateEntity:entity delegate:self options:nil];
    
}

-(void)deleteEntity:(id<SODataEntity>) entity
{
    [self.travelAgencyStore scheduleDeleteEntity:entity delegate:self options:nil];
}

-(void)createEntity:(id<SODataEntity>) entity
{

    [self.travelAgencyStore scheduleCreateEntity:entity collectionPath:kTravelAgencyCollection delegate:self options:nil];
}

#pragma mark - SODataRequestDelegate 
- (void) requestStarted:(id<SODataRequestExecution>)requestExecution {
  
}

- (void) requestServerResponse:(id<SODataRequestExecution>)requestExecution
{
        [self handleResponse:requestExecution];

   
}

- (void) requestCacheResponse:(id<SODataRequestExecution>)requestExecution {
    
    //TODO: BEGIN (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
    
    id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)requestExecution.response;
    id<SODataEntitySet> payload = (id<SODataEntitySet>)responseSingle.payload;
    
    if (payload)
    {
        [self handleResponse:requestExecution];
    } else
    {
        NSLog(@"#####################################\n");
        NSLog(@"NO CACHED DATA");
        NSLog(@"#####################################\n");
    }
    
    //TODO: END (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
}

-(void)handleResponse:(id<SODataRequestExecution>)requestExecution {
    id<SODataRequestParam> requestParam = requestExecution.request;
    id<SODataRequestParamSingle> request = (id<SODataRequestParamSingle>)requestParam;
    
    if ([requestParam conformsToProtocol:@protocol(SODataRequestParamSingle)])
    {
        
        if (request.mode == SODataRequestModeRead)
        {
            id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)requestExecution.response;
            if ([responseSingle.payload conformsToProtocol:@protocol(SODataEntitySet) ])
            {
                if ([requestParam.customTag  isEqualToString: @"Error"])
                {
                    self.errorSet = (id<SODataEntitySet>)responseSingle.payload;
                    
                    [self parseError];
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
    [Utilities showAlertWithTitle:@"Request Failed" andMessage:msg];
    
   }

#pragma mark - OnlineStore
// Open an online store
-(void) openOnlineStore {
    
    if (!self.travelAgencyStore)
    {
        
        SODataOnlineStoreOptions* options = [[SODataOnlineStoreOptions alloc]init];
        
        //TODO: BEGIN (ADD TECHNICAL CACHE EXERCISE) ########################################
        options.useCache = TRUE;
        options.cacheEncryptionKey = kCacheEncryptionKey;
        
        //TODO: END (ADD TECHNICAL CACHE EXERCISE) ########################################
    
        SODataOnlineStore* onlineStore = [[SODataOnlineStore alloc] initWithURL:[NSURL URLWithString:self.endpointUrl]  httpConversationManager:self.logonHandler.httpConvManager options:options];
    
        [onlineStore setOnlineStoreDelegate:self];
        self.travelAgencyStore = onlineStore;
    }
    
    if (![self.travelAgencyStore isOpen])
    {
    
        NSError *error = nil;
        BOOL success = [self.travelAgencyStore openStoreWithError:&error];
        if (!success)
        {
            NSLog(@"Failed to open store: %@", [error description]);
        }
        
         //TODO: BEGIN (ADD TECHNICAL CACHE EXERCISE) ########################################
        else
        {
            [self.travelAgencyStore reopenCacheWithKey:kCacheEncryptionKey error:&error];
        }
         //TODO: END (ADD TECHNICAL CACHE EXERCISE) ########################################
    } else
    {
        [ self getODataEntries];
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

#pragma mark - Reset Cache


-(void) resetCache
{
    //TODO: BEGIN (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
    
     NSError* error = nil;
    
    [self.travelAgencyStore resetCache:&error];
    if (error)
    {
        [Utilities showAlertWithTitle:@"Reset Cache Failed" andMessage:[error description]];
    } else
    {
        [self.travelAgencyStore closeWithError:&error];
        if (error) {
            [Utilities showAlertWithTitle:@"Close Store Failed" andMessage:[error description]];
        } 
    }
    
    //TODO: END (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
    
}



#pragma mark - Passive mode

-(void)enablePassiveMode
{
    
    //TODO: BEGIN (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
    
     NSError* error = nil;
    [self.travelAgencyStore setPassive:YES error:&error];
    if (error)
        [Utilities showAlertWithTitle:@"Enable Passive Mode failed" andMessage:@"Error while setting passive mode"];
    
    //TODO: END (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
}

-(void)disablePassiveMode
{
    //TODO: BEGIN (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
    
    NSError* error = nil;
    [self.travelAgencyStore setPassive:NO error:&error];
    if (error)
        [Utilities showAlertWithTitle:@"Disable Passive Mode failed" andMessage:@"Error while disabling passive mode"];
    
    //TODO: END (UNCOMMENT TECHNICAL CACHE EXERCISE) ########################################
}


@end
