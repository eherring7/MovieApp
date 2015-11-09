//
//  RootViewController.h
//  Movie
//
//  Created by Eric Herring on 7/18/15.
//  Copyright (c) 2015 EKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) UIView* tableHeaderView;
@property (strong, nonatomic) NSArray *resultsArray;
@property (strong, nonatomic) NSMutableArray *posterArray;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end
