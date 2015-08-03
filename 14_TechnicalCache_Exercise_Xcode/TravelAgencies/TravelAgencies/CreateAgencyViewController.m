//
//  CreateAgencyViewController.m
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "CreateAgencyViewController.h"
#import "TravelAgencyDataController.h"

#import "SODataPropertyDefault.h"
#import "SODataEntityDefault.h"
#import "Constants.h"

@interface CreateAgencyViewController ()

@property (strong) NSMutableArray* properties;
@end

@implementation CreateAgencyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.agencyIDInput) || (textField == self.nameInput) ||
        (textField == self.streetInput) || (textField == self.cityInput) ||
        (textField == self.regionInput) || (textField == self.zipInput) ||
        (textField == self.countryInput) || (textField == self.telephoneInput) ||
        (textField == self.urlInput))
    {
        [textField resignFirstResponder];
    }
    return YES;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInputFromAdd"]) {
        if ([self.agencyIDInput.text length] || [self.nameInput.text length] ||
            [self.streetInput.text length] || [self.cityInput.text length] ||
            [self.regionInput.text length] || [self.zipInput.text length] ||
            [self.countryInput.text length] || [self.telephoneInput.text length] ||
            [self.urlInput.text length]) {
            
            self.properties = [NSMutableArray array];
            id<SODataProperty> prop = [[SODataPropertyDefault alloc] initWithName:@"agencynum"];
            prop.value = self.agencyIDInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"NAME"];
            prop.value = self.nameInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"CITY"];
            prop.value = self.cityInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"STREET"];
            prop.value = self.streetInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"REGION"];
            prop.value = self.regionInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"POSTCODE"];
            prop.value = self.zipInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"COUNTRY"];
            prop.value = self.countryInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"TELEPHONE"];
            prop.value = self.telephoneInput.text;
            [self.properties addObject:prop];
            prop = [[SODataPropertyDefault alloc] initWithName:@"URL"];
            prop.value = self.urlInput.text;
            [self.properties addObject:prop];
            
            SODataEntityDefault* entity = [[SODataEntityDefault alloc] initWithType:@"RMTSAMPLEFLIGHT.Travelagency_DQ"];
            for (id<SODataProperty> prop in self.properties) {
                [entity.properties setObject:prop forKey:prop.name];
            }
            
            self.travelAgency = entity;
        }
    }
}

@end
