//
//  ListViewController.h
//  Essencial
//
//  Created by Julian on 03/11/2013.
//  Copyright (c) 2013 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, strong) AVAudioPlayer *player;

- (UIImage *)convertImageToGrayScale:(UIImage *)image;

@end
