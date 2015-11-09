//
//  ViewController.m
//  Movie
//
//  Created by Eric Herring on 7/17/15.
//  Copyright (c) 2015 EKJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)init
{

    // Init the frame based on the width and height of the view in the nib
    self = [super init];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _results = [[NSDictionary alloc] init];
        _posterImage = [[AsyncImageView alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showOrHideItems];
    // Get more information about movie for display
    id info = [self movieInformation:[_results objectForKey:@"id"]];
    
    _posterImage.imageURL = _url;
    _titleLabel.text = [_results objectForKey:@"title"];
    _dateLabel.text =  _date;
    _ratingLabel.text = [self ratingInformation:[info objectForKey:@"releases"]];
    _runtimeLabel.text = [NSString stringWithFormat:@"%@ minutes", [info objectForKey:@"runtime"]];
    _descriptionLabel.text = [[_results objectForKey:@"overview"] isEqual: [NSNull null]] ? @"No Description" : [_results objectForKey:@"overview"];
}

- (NSString *)movieInformation:(id)movieID
{
    NSString *apiKey = @"1419277c31b39f8ca591b8da5d77b5f8";
    
    // Create and fetch url
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@&append_to_response=releases", movieID, apiKey];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    NSError *e = nil;
    id movieData = [NSJSONSerialization JSONObjectWithData:urlData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&e];
    
    return movieData;
    
}

- (NSString *)ratingInformation:(NSDictionary *)ratingInfo
{
    for(NSDictionary *countries in [ratingInfo objectForKey:@"countries"]) {
        if([[countries objectForKey:@"iso_3166_1"] isEqualToString:@"US"]) {
            return [[countries objectForKey:@"certification"] isEqualToString:@""] ? @"Not Yet Rated" : [countries objectForKey:@"certification"];
        }
    }
    return @"No Rating";
}

- (void)showOrHideItems
{
    self.posterImage.hidden = !_searchStarted;
    self.titleLabel.hidden = !_searchStarted;
    self.dateLabel.hidden = !_searchStarted;
    self.ratingLabel.hidden = !_searchStarted;
    self.runtimeLabel.hidden = !_searchStarted;
    self.descriptionLabel.hidden = !_searchStarted;
    

}

#pragma mark - Data

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
