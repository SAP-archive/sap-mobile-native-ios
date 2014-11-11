/*
 
 File: ConnectivitySettings.h
 Abstract: Holds the settings used for connecting to SAP Mobile Platform or SAP NetWeaver Gateway server.
 
 */

#import <Foundation/Foundation.h>


@interface ConnectivitySettings : NSObject

+ (NSString *)SMPAppID; ///< The Application Id as configured by the Administrator of Sybase Control Center (must be set if SMPMode is set to YES).
+ (void)setSMPAppID:(NSString *)SMPAppID;

//Added for JSON toggle
+ (BOOL)useJSON;

+ (void)setUseJSON:(BOOL)useJSON;

@end
