//
//  DetailViewController.m
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "TravelAgencyDataController.h"


#import "SODataStore.h"
#import "SODataStoreSync.h"
#import "SODataEntity.h"
#import "SODataEntitySet.h"
#import "SODataProperty.h"

#import "Utilities.h"
#import "Constants.h"

@interface DetailViewController ()

@property (strong,nonatomic)TravelAgencyDataController *travelAgencyDataController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id<SODataEntity>)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    
}

- (void)configureView
{
    if (_detailItem) {
        self.agencyName.text = (NSString *)[(id<SODataProperty>)[_detailItem.properties objectForKey:kTravelAgencyName] value];
        NSString *agencyidNumber = (NSString *)[(id<SODataProperty>)[_detailItem.properties objectForKey:kTravelAgencyID] value];
        
        self.agencyId.text = [NSString stringWithFormat:@"ID: %@",agencyidNumber];
        self.agencyNumber.text = (NSString *)[(id<SODataProperty>)[_detailItem.properties objectForKey:kTravelAgencyTelephoneNumber] value];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
     self.travelAgencyDataController =[TravelAgencyDataController uniqueInstance];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateAgency:(id)sender
{
     NSString *originalNumber = (NSString *)[(id<SODataProperty>)[self.detailItem.properties objectForKey:kTravelAgencyTelephoneNumber] value];
    
     if ([self.agencyNumber.text compare:originalNumber] != NSOrderedSame)
     {
         [(id<SODataProperty>)[self.detailItem.properties objectForKey:kTravelAgencyTelephoneNumber] setValue:self.agencyNumber.text];
         
         // Update the entry.
         [self.travelAgencyDataController updateEntity:self.detailItem];
         
         [(UINavigationController *)self.parentViewController popViewControllerAnimated:YES];
     }
}

- (IBAction)keyboardOff:(id)sender {
    [sender resignFirstResponder];
}


-(void)handleSingleTap:(UITapGestureRecognizer *)sender {
    [self.agencyNumber resignFirstResponder];
}



@end
