//
//  BatchResultViewController.m
//  Flights_iOS
//
//  Created by Shin, Jin & Unnai, Kenichi on 7/15/14.
//  Copyright (c) 2014 CEG. All rights reserved.
//

#import "BatchResultViewController.h"
#import "Request.h"
#import "SODataRequestParamSingleDefault.h"
#import "SODataRequestExecution.h"
#import "SODataResponseSingle.h"
#import "SODataEntitySet.h"
#import "SODataEntity.h"
#import "SODataEntityDefault.h"
#import "SODataProperty.h"
#import "SODataPropertyDefault.h"
#import "SODataError.h"
#import "ActivityIndicatorUtility.h"

#import "SODataResponseChangesetDefault.h"
#import "SODataResponseBatch.h"

@interface BatchResultViewController ()

@property (strong, nonatomic) UIView* loadingView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;

@property (strong, nonatomic) id<SODataResponseChangeset> changeset;

@end

@implementation BatchResultViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setRequestParam:(id<SODataResponseBatch>)batchResponse
{
    if (_batchResponse != batchResponse) {
        _batchResponse = batchResponse;
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                         withObject:nil
                                      waitUntilDone:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.changeset = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideActivityIndicatorLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"Request Status List";
    } else {
        return @"Change Set Result";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.batchResponse.responses count];
    } else {
        return [self.changeset.responses count];
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"statusCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (self.batchResponse) {

//TODO: BEGIN (Handle a batch response object)
            
            id<SODataResponseBatchItem> batchItem = [self.batchResponse.responses objectAtIndex:[indexPath row]];

            if ([batchItem conformsToProtocol:@protocol(SODataResponseChangeset)]) {
                // 20X
                id<SODataResponseChangeset> changeset = (id<SODataResponseChangeset>)batchItem;
                [[cell textLabel] setText:@"ChangeSet"];
                [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Count: %d", [changeset.responses count]]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            } else if ([batchItem conformsToProtocol:@protocol(SODataResponseSingle)]) {
                
                id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)batchItem;
                NSString *statusCode = responseSingle.headers[kSODataResponseHeaderCode];
                
                if ([[responseSingle payload] conformsToProtocol:@protocol(SODataError)]) {
                    
                    NSString *msg = [(id<SODataError>)[responseSingle payload] message];
                    cell.textLabel.font = [cell.textLabel.font fontWithSize:10];
                    [[cell textLabel] setText:[NSString stringWithFormat:@"%@", msg]];
                    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@", statusCode]];
                } else {
                    [[cell textLabel] setText:[NSString stringWithFormat:@"%@", @"HTTP Response Code"]];
                    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@", statusCode]];
                }
            }

//TODO: END (Handle a batch response object)
            
        }
        return cell;
        
    } else if (indexPath.section == 1){
        
        //Display selected changeset requests
        NSString *cellIdentifier = @"changesetCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (self.changeset) {

            id<SODataResponseSingle> responseSingle = (id<SODataResponseSingle>)[self.changeset.responses objectAtIndex:[indexPath row]];
            NSString *statusCode = responseSingle.headers[kSODataResponseHeaderCode];;
            
            [[cell textLabel] setText:[NSString stringWithFormat:@"%@", @"HTTP Response Code"]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@", statusCode]];
        }
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set changeset section corresponding to selected data
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        id<SODataResponseBatchItem> batchItem = [self.batchResponse.responses objectAtIndex:[indexPath row]];
        id<SODataResponseChangeset> changeset = (id<SODataResponseChangeset>)batchItem;
        if (changeset) {
            self.changeset = changeset;
        }
    } else {
        self.changeset = nil;
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
}

#pragma mark - for ActivityIndicator

- (void) showActivityIndicatorLayer
{
    if (self.loadingView) {
        return;
    }
    [self.createButton setEnabled:NO];
    self.loadingView = [ActivityIndicatorUtility createForView:self.view];
}

- (void) hideActivityIndicatorLayer
{
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
    [self.createButton setEnabled:YES];
    
}

@end
