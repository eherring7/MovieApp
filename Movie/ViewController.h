//
//  ViewController.h
//  Movie
//
//  Created by Eric Herring on 7/17/15.
//  Copyright (c) 2015 EKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSDictionary *results;
@property (strong, nonatomic)  AsyncImageView *image;
@property (strong, nonatomic)  NSString *date;
@property (strong, nonatomic)  NSString *rating;
@property (strong, nonatomic)  NSURL *url;
@property (assign, nonatomic)  BOOL searchStarted;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet AsyncImageView *posterImage;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *runtimeLabel;

@end

