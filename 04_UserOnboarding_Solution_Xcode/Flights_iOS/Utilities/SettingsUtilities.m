/*
 
 File: SettingsUtilities.m
 Abstract: A utility class responsible for reading the application settings (as the service URL, the SAP client and the authentication configurations).
 
 */

#import "SettingsUtilities.h"
#import "ConnectivitySettings.h"

@implementation SettingsUtilities

+ (NSMutableDictionary *)findPreferenceIn:(NSArray *)list forKey:(NSString *)key
{
	for (NSMutableDictionary* pref in list) {
		NSString* value = pref[@"Key"];
		if ([value length] > 0 && [value isEqualToString:key]) {
			return pref;
		}
	}
	return nil;
}

+ (NSString *)getPreferenceValueOrDefaultValueForKey:(NSString *)key inPlist:(NSString *)plistName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *value = [defaults stringForKey:key];
	
	if (!value) {
		NSString *pathToBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
		NSMutableDictionary* rootPlist = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.plist", pathToBundle, plistName]];
		NSMutableDictionary *preferences = [SettingsUtilities findPreferenceIn:(NSArray*)rootPlist[@"PreferenceSpecifiers"] forKey:key];
		value = preferences[@"DefaultValue"];
		if (value) {
			NSDictionary *appDefaults = @{key: value};
			[defaults registerDefaults:appDefaults];
			[defaults synchronize];
		}
	}
	return value;
}


+ (void)updateConnectivitySettingsFromUserSettings
{
    // SMP Settings
    NSString *host = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpHost" inPlist:@"Root"];
    [ConnectivitySettings setSMPHost:host];
    
    NSString *port = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpPort" inPlist:@"Root"];
    [ConnectivitySettings setSMPPort:[port integerValue]]; // Must be a number since the keyboard type for this text field in settings screen is NumberPad.
    
    NSString *smpDomain = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpDomain" inPlist:@"Root"];
    [ConnectivitySettings setSMPDomain:smpDomain];
    
    NSString *securityConfig = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpSecConfig" inPlist:@"Root"];
    [ConnectivitySettings setSMPSecurityConfiguration:securityConfig];
    
    NSString *appID = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpAppID" inPlist:@"Root"];
    [ConnectivitySettings setSMPAppID:appID];
    
    NSString *useSSLValue = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpUseSSL" inPlist:@"Root"];
    BOOL useSSL = [useSSLValue boolValue];
    [ConnectivitySettings setUseSSL:useSSL];
    
    //Use MAF?
    NSString *useMAFValue = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpUseMAF" inPlist:@"Root"];
    BOOL useMAF = [useMAFValue boolValue];
    [ConnectivitySettings setUseMAF:useMAF];
    
}

@end
