//
//  RootViewController.m
//  Movie
//
//  Created by Eric Herring on 7/18/15.
//  Copyright (c) 2015 EKJ. All rights reserved.
//

#import "RootViewController.h"
#import "AsyncImageView.h"
#import "ViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init values
    _resultsArray = [[NSArray alloc] init];
    _posterArray = [[NSMutableArray alloc] init];
    
    // Table view setup
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.splitViewController.delegate = self;
    
    // Set magnifying glass for search box
    UILabel *magnifyingGlass = [[UILabel alloc] init];
    [magnifyingGlass setText:[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"]];
    [magnifyingGlass sizeToFit];
 
    [_searchField setRightView:magnifyingGlass];
    [_searchField setRightViewMode:UITextFieldViewModeAlways];
}

- (IBAction)searchButtonPressed:(id)sender {

    [self.tableView setContentOffset:CGPointZero animated:YES];
    [_searchField resignFirstResponder];
    id results = [self stringWithUrl:_searchField.text];
    _resultsArray = [results objectForKey:@"results"];
    [self.tableView reloadData];
    
    
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    //remove button from navigation bar in detail navigation controller
    ((UINavigationController*)[svc.viewControllers objectAtIndex:1]).topViewController.navigationItem.leftBarButtonItem = nil;
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc{
    
    //add button to navigation bar in detail navigation controller
    barButtonItem.title = @"Search";
    ((UINavigationController*)[svc.viewControllers objectAtIndex:1]).topViewController.navigationItem.leftBarButtonItem = barButtonItem;
    
}

#pragma mark - TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count = %lu", (unsigned long)[_resultsArray count]);
    return [_resultsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

static NSString *CellIdentifier = @"CellIdentifier";

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
    AsyncImageView *imageView = (AsyncImageView *)[cell.contentView viewWithTag:3];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@",
                                       [[_resultsArray objectAtIndex: indexPath.row] objectForKey:@"poster_path"]]];
    imageView.imageURL = url;

    NSString * title = [[_resultsArray objectAtIndex: indexPath.row] objectForKey:@"title"];
    NSString * release = [[_resultsArray objectAtIndex: indexPath.row] objectForKey:@"release_date"];
    
    if(![title isEqual:[NSNull null]]) {
        titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", title, [release isEqual:[NSNull null]] ? @"Unknown" : [self showDate:release]];
    } else {
        titleLabel.text = @"Unknown Title";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailMovie"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
        ViewController *controller = (ViewController *)[destViewController topViewController];
        controller.results = [_resultsArray objectAtIndex:indexPath.row];
        controller.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@",
                                                          [[_resultsArray objectAtIndex: indexPath.row] objectForKey:@"poster_path"]]];
        controller.searchStarted = YES;
        // Get date
        NSString *date = [[_resultsArray objectAtIndex: indexPath.row] objectForKey:@"release_date"];
        controller.date = [date isEqual:[NSNull null]] ? @"Unknown" : [self showDate:date];

    }
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self stringWithUrl:textField.text];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    // The clear button is visible when there's any text, so
    // show the right view when there's no text.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidChange
{
    
}


#pragma mark - Data

- (id)stringWithUrl:(NSString *)query
{
    NSString *apiKey = @"1419277c31b39f8ca591b8da5d77b5f8";
    
    // Replace spaces in query string
    NSString *searchQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    // Create and fetch url
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/search/movie?api_key=%@&query=%@&certification_country=US", apiKey, searchQuery];
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

- (NSString *)showDate:(NSString *)releaseDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/mm/dd"];
    NSDate *date = [dateFormat dateFromString:releaseDate];
    [dateFormat setDateFormat:@"yyyy"];
    return [dateFormat stringFromDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end