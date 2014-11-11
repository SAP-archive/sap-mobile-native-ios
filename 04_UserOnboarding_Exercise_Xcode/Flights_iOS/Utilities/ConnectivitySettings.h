/*
 
 File: ConnectivitySettings.h
 Abstract: Holds the settings used for connecting to SAP Mobile Platform or SAP NetWeaver Gateway server.
 
 */

#import <Foundation/Foundation.h>

/**
 * Defines authentication type constants
 */
typedef enum AuthenticationType : NSUInteger {
	UsernamePasswordAuthenticationType	= 0xFE,  ///< denotes Username/Password/Domain(optional) authentication (Basic / NTLM).
	PortalAuthenticationType = 0xFF, ///< denotes SAP Portal SSO Authentication.
    CertificateAuthenticationType = 0xFD ///< denotes Certificate Authentication.
} AuthenticationType;

/**
 A class that holds the settings used for connecting the SAP NetWeaver Gateway server.
 */
@interface ConnectivitySettings : NSObject

+ (AuthenticationType)authenticationType; ///< The type of user authentication used for the SAP NetWeaver Gateway connectivity. Note that if SAML2 is used for authentication, this property indicates the authentication type used by the Identity Provider server.
+ (void)setAuthenticationType:(AuthenticationType)authenticationType;

+ (NSString *)SMPHost; ///< The SMP Server Host as configured by the Administrator of Sybase Control Center (must be set if SMPMode is set to YES).
+ (void)setSMPHost:(NSString *)SMPHost;

+ (NSInteger)SMPPort; ///< The SMP Server Port as configured by the Administrator of Sybase Control Center (must be set if SMPMode is set to YES).
+ (void)setSMPPort:(NSInteger)SMPPort;

+ (NSString *)SMPDomain; ///< The SMP server domain name (must be set if SMPMode is set to YES).
+ (void)setSMPDomain:(NSString *)SMPDomain;

+ (NSString *)SMPAppID; ///< The Application Id as configured by the Administrator of Sybase Control Center (must be set if SMPMode is set to YES).
+ (void)setSMPAppID:(NSString *)SMPAppID;

+ (NSString *)SMPSecurityConfiguration; ///< The Application Security Configuration name as configured by the Administrator of Sybase Control Center (must be set if SMPMode is set to YES).
+ (void)setSMPSecurityConfiguration:(NSString *)SMPSecurityConfiguration;

//Added for Service URL
+ (void)setServiceURL:(NSString *)serviceURL;
+ (NSString *)serviceURL;

//Added for MAF toggle
+ (BOOL)useMAF;

+ (void)setUseMAF:(BOOL)useMAF;

//Added for SSL toggle
+ (BOOL)useSSL;

+ (void)setUseSSL:(BOOL)useSSL;

//Added for JSON toggle
+ (BOOL)useJSON;

+ (void)setUseJSON:(BOOL)useJSON;

@end
