/*
 
 File: ConnectivitySettings.m
 Abstract: Holds the settings used for connecting to SAP Mobile Platform or SAP NetWeaver Gateway server.
 
 */

#import "ConnectivitySettings.h"

static AuthenticationType _authType = UsernamePasswordAuthenticationType;

static NSString *_SMPHost = nil;
static NSInteger _SMPPort = 0;
static NSString *_SMPDomain = nil;
static NSString *_SMPAppId = nil;
static NSString *_SMPsecurityConfiguration = nil;

static NSString *_serviceURL = nil;

static BOOL _useSSL = NO;
static BOOL _useJSON = NO;
static BOOL _useMAF = NO;


@implementation ConnectivitySettings

+ (AuthenticationType)authenticationType
{
    return _authType;
}

+ (void)setAuthenticationType:(AuthenticationType)authenticationType
{
    _authType = authenticationType;
}

+ (NSString *)SMPHost
{
    return _SMPHost;
}
+ (void)setSMPHost:(NSString *)SMPHost
{
    _SMPHost = SMPHost;
}

+ (NSInteger)SMPPort
{
    return _SMPPort;
}

+ (void)setSMPPort:(NSInteger)SMPPort
{
    _SMPPort = SMPPort;
}

+ (NSString *)SMPDomain
{
    return _SMPDomain;
}

+ (void)setSMPDomain:(NSString *)SMPDomain
{
    _SMPDomain = SMPDomain;
}

+ (NSString *)SMPAppID
{
    return _SMPAppId;
}

+ (void)setSMPAppID:(NSString *)SMPAppID
{
    _SMPAppId = SMPAppID;
}

+ (NSString *)SMPSecurityConfiguration
{
    return _SMPsecurityConfiguration;
}

+ (void)setSMPSecurityConfiguration:(NSString *)SMPSecurityConfiguration
{
    _SMPsecurityConfiguration = SMPSecurityConfiguration;
}

+ (void)setServiceURL:(NSString *)serviceURL {
    _serviceURL = serviceURL;
}

+ (NSString *)serviceURL {
    return _serviceURL;
}

+ (BOOL)useSSL {
    return _useSSL;
}

+ (void)setUseSSL:(BOOL)useSSL {
    _useSSL = useSSL;
}

+ (BOOL)useJSON {
    return _useJSON;
}

+ (void)setUseJSON:(BOOL)useJSON {
    _useJSON = useJSON;
}

+ (BOOL)useMAF {
    return _useMAF;
}

+ (void)setUseMAF:(BOOL)useMAF {
    _useMAF = useMAF;
}

@end
