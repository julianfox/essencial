//
//  ListViewController.m
//  Essencial
//
//  Created by Julian on 03/11/2013.
//  Copyright (c) 2013 Julian. All rights reserved.
//

#import "SCUI.h"
#import "ListViewController.h"

@interface ListViewController ()

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ListViewController

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    SCAccount *account = [SCSoundCloud account];
    NSLog(@"account %@", account);
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            self.tracks = (NSArray *)jsonResponse;
            NSLog(@"tracks: %@", self.tracks);
            [self.collectionView reloadData];
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"tracks count %lu", (unsigned long)[self.tracks count]);
    return [self.tracks count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    if([cell.contentView.subviews count] == 0) {
        [cell.contentView addSubview:[[UIImageView alloc] initWithFrame:cell.contentView.bounds]];
    }
    
    UIImageView *cellImageView = cell.contentView.subviews[0];
    
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    NSString *imageUrl = [track objectForKey:@"artwork_url"];
    
    NSLog(@"image url %@", imageUrl);
    
    if ( imageUrl != ( NSString *) [ NSNull null ] )
    {
        NSError *error = nil;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl] options:NSDataReadingUncached error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSLog(@"Data has loaded successfully.");
            UIImage *greyImage = [self convertImageToGrayScale:[UIImage imageWithData: imageData]];
            cellImageView.image = greyImage;
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(100, 100);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end