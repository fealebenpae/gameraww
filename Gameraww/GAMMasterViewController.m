//
//  GAMMainViewController.m
//  Gameraww
//
//  Created by Yavor Georgiev on 17.01.14.
//  Copyright (c) 2014 г. Telerik. All rights reserved.
//

#import "GAMMasterViewController.h"
#import "GAMDetailViewController.h"
#import "UIImageView+AsyncURL.h"

static NSDateFormatter *dateFormatter;

@implementation GAMMasterViewController {
    NSArray *items;
}

+ (void)initialize {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDoesRelativeDateFormatting:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    [self loadData];
}

- (void)loadData {
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:nil
                                                        delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://www.reddit.com/r/aww.json?limit=50"]
              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  if (error) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:error.localizedDescription
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles:nil];
                      [alert show];
                  } else {
                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                      NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                          id url = evaluatedObject[@"url"];
                          return [url isKindOfClass:[NSString class]] && [GAMDetailViewController isImageURL:url];
                      }];

                      self->items = [[json valueForKeyPath:@"data.children.data"] filteredArrayUsingPredicate:predicate];
                      [self.tableView reloadData];
                  }

                  [self.refreshControl endRefreshing];
    }];
    [dataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *item = self->items[indexPath.row];

    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
    textLabel.text = item[@"title"];

    NSDate *created = [NSDate dateWithTimeIntervalSince1970:[item[@"created_utc"] doubleValue]];
    UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:2];
    detailTextLabel.text = [dateFormatter stringFromDate:created];

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:3];
    imageView.image = [UIImage imageNamed:@"reddit-default"];
    [imageView loadFromURL:[NSURL URLWithString:item[@"thumbnail"]] completionHandler:nil];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSDictionary *item = self->items[self.tableView.indexPathForSelectedRow.row];
        [segue.destinationViewController setItem:item];
    } else if ([segue.identifier isEqualToString:@"showCanvas"]) {
        [segue.destinationViewController setItems:self->items];
    }
}

@end
