//
//  GAMDetailViewController.m
//  Gameraww
//
//  Created by Yavor Georgiev on 17.01.14.
//  Copyright (c) 2014 г. Telerik. All rights reserved.
//

#import "GAMDetailViewController.h"
#import "UIImageView+AsyncURL.h"

static NSSet *imageExtensions;
static NSRegularExpression *imgurSingleRegex;

@implementation GAMDetailViewController

+ (void)initialize {
    imageExtensions = [NSSet setWithArray:@[ @"png", @"jpg", @"gif", @"jpeg" ]];

    imgurSingleRegex = [NSRegularExpression regularExpressionWithPattern:@"http://imgur.com/.[^/]" options:0 error:NULL];
}

+ (BOOL)isImageURL:(NSString *)URL {
    NSRange range = NSMakeRange(0, URL.length);
    return [imageExtensions containsObject:URL.pathExtension] || [imgurSingleRegex matchesInString:URL options:0 range:range].count > 0;
}

- (IBAction)toggleTopBarVisibility {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];

    [UIView animateWithDuration:0.33 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.item[@"title"];

    [self.activityIndicator startAnimating];
    NSMutableString *url = [self.item[@"url"] mutableCopy];
    if (url.pathExtension.length == 0)
        [url appendString:@".jpg"];

    [self.imageView loadFromURL:[NSURL URLWithString:url] completionHandler:^(NSError *error) {
        [self.activityIndicator stopAnimating];
        [self toggleTopBarVisibility];
    }];

    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
