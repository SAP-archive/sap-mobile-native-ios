//
//  Utilities.m
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
