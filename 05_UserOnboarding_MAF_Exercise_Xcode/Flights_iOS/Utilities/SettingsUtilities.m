/*
 
 File: SettingsUtilities.m
 Abstract: A utility class responsible for reading the application settings (as the service URL, the SAP client and the authentication configurations).
 
 */

#import "SettingsUtilities.h"
#import "AppDelegate.h"
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
    //Application ID configured on SMP server
    NSString *appID = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"smpAppID" inPlist:@"Root"];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.smpAppID = appID;
}


@end
