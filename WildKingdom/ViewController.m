//
//  ViewController.m
//  WildKingdom
//
//  Created by Richard Fellure on 5/31/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ViewController.h"
#import "AnimalObject.h"
#import "ImageCell.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property NSMutableArray *animalObjectArray;
@property NSMutableArray *photoArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property UICollectionViewFlowLayout *flowLayout;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.animalObjectArray = [[NSMutableArray alloc]init];
    self.photoArray = [[NSMutableArray alloc]init];
    if ([self.title isEqual:@"Lions"])
    {
        [self searchForPhotos: @"lion+animal+Africa"];
    }
    else if ([self.title isEqual:@"Tigers"])
    {
        [self searchForPhotos:@"Tiger+Bengal+animal"];
    }
    else if ([self.title isEqual:@"Bears"])
    {
        [self searchForPhotos:@"Bear+Grizzly+Polar"];
    }

    self.flowLayout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    UIImage *animalImage = [self.photoArray objectAtIndex:indexPath.row];

    cell.imageView.image = animalImage;
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)searchForPhotos: (NSString *) animal
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=83c95efbed1f460117e313a79f8ef38c&tags=animals&text=%@&per_page=10&format=json&nojsoncallback=1", animal];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {

         NSError *error = nil;
         NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
         NSDictionary *flickrDictionary = jsonDictionary[@"photos"];
         NSMutableArray *array = [flickrDictionary objectForKey:@"photo"];

         for (NSDictionary *dictionary in array)
         {
             NSNumber *farmID = dictionary[@"farm"];
             NSString *serverID = dictionary[@"server"];
             NSString *photoID = dictionary[@"id"];
             NSString *secret = dictionary[@"secret"];
             NSString *imageString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",farmID, serverID, photoID, secret];

             NSURL *imageURL = [NSURL URLWithString:imageString];
             UIImage *animalImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
             AnimalObject *animalObject = [[AnimalObject alloc]initWithAnimalImage:animalImage];
             [self.photoArray addObject:animalImage];
             [self.animalObjectArray addObject:animalObject];

         }

         [self.collectionView reloadData];
     }];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 25, 25, 50);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.minimumLineSpacing = 25;
        self.flowLayout.minimumInteritemSpacing = 500;
    }

    else
    {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.flowLayout.minimumLineSpacing = 25;
        self.flowLayout.minimumInteritemSpacing = 10;
    }

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.flowLayout.minimumLineSpacing = 25;
        self.flowLayout.minimumInteritemSpacing = 10;
    }
    else
    {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.minimumLineSpacing = 25;
        self.flowLayout.minimumInteritemSpacing = 500;
    }

}




@end
