/*
 
 File: ConnectivitySettings.m
 Abstract: Holds the settings used for connecting to SAP Mobile Platform or SAP NetWeaver Gateway server.
 
 */

#import "ConnectivitySettings.h"

static NSString *_SMPAppId = nil;

static BOOL _useJSON = NO;



@implementation ConnectivitySettings

+ (NSString *)SMPAppID
{
    return _SMPAppId;
}

+ (void)setSMPAppID:(NSString *)SMPAppID
{
    _SMPAppId = SMPAppID;
}

+ (BOOL)useJSON {
    return _useJSON;
}

+ (void)setUseJSON:(BOOL)useJSON {
    _useJSON = useJSON;
}

@end
