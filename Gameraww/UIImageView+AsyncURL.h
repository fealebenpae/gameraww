//
//  UIImageView+AsyncURL.h
//  Gameraww
//
//  Created by Yavor Georgiev on 17.01.14.
//  Copyright (c) 2014 г. Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncURL)

- (void)loadFromURL:(NSURL *)url completionHandler:(void (^)(NSError *error))completionHandler;

@end
