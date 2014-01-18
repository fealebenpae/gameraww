//
//  GAMCanvasViewController.m
//  Gameraww
//
//  Created by Yavor Georgiev on 18.01.14.
//  Copyright (c) 2014 г. Telerik. All rights reserved.
//

#import "GAMCanvasViewController.h"
#import "GAMDetailViewController.h"
#import "UIImageView+AsyncURL.h"

@implementation GAMCanvasViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *item = self.items[indexPath.item];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.image = [UIImage imageNamed:@"reddit-default"];
    [imageView loadFromURL:[NSURL URLWithString:item[@"thumbnail"]] completionHandler:nil];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *selectedItemPath = self.collectionView.indexPathsForSelectedItems.firstObject;
        NSDictionary *item = self.items[selectedItemPath.item];
        [segue.destinationViewController setItem:item];
    }
}

@end
