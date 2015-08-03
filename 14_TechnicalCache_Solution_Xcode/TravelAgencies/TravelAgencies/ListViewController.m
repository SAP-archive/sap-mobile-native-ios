//
//  MasterViewController.m
//  TravelAgency_RKT
//
//  Copyright (c) 2014 SAP. All rights reserved.
//


#import "ListViewController.h"
#import "MainMenuViewController.h"
#import "DetailViewController.h"
#import "TravelAgencyDataController.h"
#import "CreateAgencyViewController.h"
#import "AppDelegate.h"

#import "UsernamePasswordProviderProtocol.h"
#import "CommonAuthenticationConfigurator.h"

#import "SODataPropertyDefault.h"
#import "SODataEntityDefault.h"

#import "Constants.h"
#import "Utilities.h"



@interface ListViewController () 


@property (strong,nonatomic)TravelAgencyDataController *travelAgencyDataController;
@property (nonatomic, strong) id<SODataEntitySet> entitySet;
@property (nonatomic,strong) NSArray *sortedEntities;
@property (strong) HttpConversationManager* conversationManager;
@property (nonatomic, strong) UIView* loadingView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (strong) NSMutableArray* properties;

@end

@implementation ListViewController {

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestCompleted:) name:kRequestCompleted object:nil];

    self.travelAgencyDataController = [TravelAgencyDataController uniqueInstance];
    [self.travelAgencyDataController openOnlineStore];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

-(void) viewWillAppear:(BOOL)animated {
}


#pragma mark - Segue from AddTravelAgency

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInputFromAdd"]) {
        
        CreateAgencyViewController *addController = [segue sourceViewController];
        if (addController.travelAgency) {
            
            // Create the entry
            [self.travelAgencyDataController createEntity:addController.travelAgency];
            
        }
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInputFromAdd"]) {
    }
}


#pragma mark - Notification observer
-(void)requestCompleted:(NSNotification *)notification
{
    if (notification.object != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities showAlertWithTitle:@"Online Store Open Failed" andMessage:notification.object];
            });
    } else
    {
        self.entitySet = self.travelAgencyDataController.entitySet;
        [self sortByName:self.entitySet.entities];
        //Refresh table with new travel agency list
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
        });
    }
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedEntities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"agencyListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.detailTextLabel.textColor=[UIColor grayColor];
    cell.textLabel.textColor = [UIColor blackColor];
    
    id<SODataEntity> entity = [self.sortedEntities objectAtIndex:[indexPath row]];
    
    NSString *agencyName = (NSString *)[(id<SODataProperty>)entity.properties[kTravelAgencyName] value];
    NSString *agencyId = (NSString *)[(id<SODataProperty>)entity.properties[kTravelAgencyID] value];
    NSString *agencyNumber = (NSString *)[(id<SODataProperty>)entity.properties[kTravelAgencyTelephoneNumber] value];
    
    [[cell textLabel] setText:agencyName];
    
    cell.detailTextLabel.numberOfLines = 2;
    NSString *travelAgencyDetails = [NSString stringWithFormat:@"%@\n%@", agencyId, agencyNumber];
    [[cell detailTextLabel] setText:travelAgencyDetails];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<SODataEntity> entity = self.sortedEntities[indexPath.row];
        
        [self.travelAgencyDataController deleteEntity:entity];
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView*) tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger editingStyle = UITableViewCellEditingStyleNone;
    if ([self.sortedEntities count] > 0) {
        editingStyle = UITableViewCellEditingStyleDelete;
    }
    return editingStyle;
}


#pragma mark - Segue to detail
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowTravelAgencyDetails"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id<SODataEntity> entity = [self.sortedEntities objectAtIndex:[indexPath row]];
        [[segue destinationViewController] setDetailItem:entity];
    }
    
}

#pragma mark Helper methods
-(void)sortByName:(NSMutableArray *)entities
{
    self.sortedEntities = [entities sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        NSString *first = (NSString *)[(id<SODataProperty>)((id<SODataEntity>)a).properties[kTravelAgencyName] value];
        NSString *second = (NSString *)[(id<SODataProperty>)((id<SODataEntity>)b).properties[kTravelAgencyName] value];
        return [first compare:second];
    }];
}


#pragma mark RefreshData
- (IBAction)RefreshData:(id)sender {
    
    [self.travelAgencyDataController getODataEntries];

}


@end
