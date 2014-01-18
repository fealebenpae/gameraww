//
//  UIImageView+AsyncURL.m
//  Gameraww
//
//  Created by Yavor Georgiev on 17.01.14.
//  Copyright (c) 2014 г. Telerik. All rights reserved.
//

#import "UIImageView+AsyncURL.h"

@implementation UIImageView (AsyncURL)

- (void)loadFromURL:(NSURL *)url completionHandler:(void (^)(NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image;
        if (!error && (image = [UIImage imageWithData:data])) {
            self.image = image;
        }

        if (completionHandler)
            completionHandler(error);
    }];
    [dataTask resume];
}

@end
