//
//  ActivityIndicatorUtility.m
//  ODataOnlineSample_CR
//
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "ActivityIndicatorUtility.h"

@implementation ActivityIndicatorUtility

+(UIView*) createForView:(UIView*)parentView;
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    const float width = orientation == UIInterfaceOrientationPortrait ? parentView.frame.size.width : parentView.frame.size.height;
    const float height = orientation == UIInterfaceOrientationPortrait ? parentView.frame.size.height : parentView.frame.size.width;
    UIView* activityIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    activityIndicator.backgroundColor = [UIColor grayColor];
    activityIndicator.alpha = 0.5f;
    activityIndicator.layer.masksToBounds = YES;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(width / 2 - 50, height / 2 - 50, 100, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Loading";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [activityIndicator addSubview:label];
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    activity.frame = CGRectMake(width / 2 - 20, height / 2 - 90, 40, 40);
    [activityIndicator addSubview:activity];
    [activity startAnimating];
    
    [parentView addSubview:activityIndicator];
    return activityIndicator;
}


@end
