//
//  GAMDetailViewController.h
//  Gameraww
//
//  Created by Yavor Georgiev on 17.01.14.
//  Copyright (c) 2014 г. Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAMDetailViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) NSDictionary *item;

@property (strong, nonatomic) IBOutlet UIScrollView *view;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (BOOL)isImageURL:(NSString *)URL;

- (IBAction)toggleTopBarVisibility;

@end
