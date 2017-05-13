//
//  HomeViewController.m
//  cards
//
//  Created by 熊国锋 on 16/5/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "HomeViewController.h"
#import "ContactDataModal.h"
#import "ContactParser.h"
#import "AppDelegate.h"
#import "CityPageCell.h"
#import "ProvincePageCell.h"
#import "ProvinceInfo.h"


#pragma mark - HomeViewController

@interface HomeViewController () < UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,
                                BaseDataModalDelegate >

@property (nonatomic, strong)   UICollectionView        *collectionMain;

@property (nonatomic, strong)   RLMNotificationToken    *token;
@property (nonatomic, strong)   RLMResults              *results;

@property (nonatomic, strong)   RLMNotificationToken    *failedToken;
@property (atomic, assign)      NSInteger               failedCount;

@end

@implementation HomeViewController

- (void)loadView {
    self.view = [[UIView alloc] init];
    
    UICollectionViewFlowLayout *layoutMain = [[UICollectionViewFlowLayout alloc] init];
    layoutMain.minimumLineSpacing = 0;
    layoutMain.minimumInteritemSpacing = 0;
    layoutMain.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionMain = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layoutMain];
    
    self.collectionMain.backgroundColor = PROVINCE_BACKGROUND_COLOR;
    self.collectionMain.pagingEnabled = YES;
    self.collectionMain.showsVerticalScrollIndicator = NO;
    self.collectionMain.showsHorizontalScrollIndicator = NO;
    self.collectionMain.alwaysBounceHorizontal = NO;
    self.collectionMain.dataSource = self;
    self.collectionMain.delegate = self;
    [self.collectionMain registerClass:[ProvincePageCell class]
            forCellWithReuseIdentifier:[ProvincePageCell reuseIdentifier]];
    [self.view addSubview:self.collectionMain];
    
    UIView *superView = self.view;
    [self.collectionMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.results = [[ProvinceInfo allObjects] sortedResultsUsingKeyPath:@"usage" ascending:NO];
    self.failedCount = [[ContactInfo objectsWhere:@"state != 1"] count];
    [self.collectionMain reloadData];
    
    self.token = [[[ProvinceInfo allObjects] sortedResultsUsingKeyPath:@"usage" ascending:NO] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if ([change.insertions count] || [change.deletions count]) {
            self.results = results;
            [self.collectionMain reloadData];
        }
    }];
    
    self.failedToken = [[ContactInfo objectsWhere:@"state != 1"] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if ([change.insertions count] || [change.deletions count]) {
            self.failedCount = [results count];
            [self.collectionMain reloadData];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)onApplicationBecomeActive:(NSNotification *)notification {
    [self reloadContactData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)reloadContactData {
    [[ContactDataModal sharedClient] initContacts];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionMain) {
        return [self.results count] + (self.failedCount > 0?1:0);
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProvincePageCell *cell = (ProvincePageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ProvincePageCell reuseIdentifier]
                                                                                           forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat height = CGRectGetHeight(collectionView.bounds);
    if (collectionView == self.collectionMain) {
        return CGSizeMake(width, height);
    }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(ProvincePageCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionMain) {
        if (indexPath.item < [self.results count]) {
            ProvinceInfo *info = [self.results objectAtIndex:indexPath.item];
            cell.province = info.province;
        }
        else {
            cell.province = nil;
        }
        
        NSIndexPath *visibleIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
        if (visibleIndexPath) {
            if (indexPath.item < visibleIndexPath.item) {
                [cell startScrollPos:-1];
            }
            else if (indexPath.item > visibleIndexPath.item) {
                [cell startScrollPos:0];
            }
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSArray *cells = [self.collectionMain visibleCells];
    for (ProvincePageCell *item in cells) {
        [item endScroll];
    }
}



@end
