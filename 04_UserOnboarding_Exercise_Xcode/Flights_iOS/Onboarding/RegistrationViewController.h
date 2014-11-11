//
//  RegistrationViewController.h
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/25/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFLogonCoreDelegate.h"

@interface RegistrationViewController : UIViewController <MAFLogonCoreDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@end
