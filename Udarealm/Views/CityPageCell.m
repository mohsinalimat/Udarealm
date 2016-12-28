//
//  CityPageCell.m
//  cards
//
//  Created by 熊国锋 on 16/5/25.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "CityPageCell.h"
#import "WebCachedImageView.h"
#import "ContactDataModal.h"
#import "UILabel+YuCloud.h"
#import "UIImage+YuCloud.h"
#import "UdarManager.h"
#import "ZXContexMenu.h"



#pragma mark - CityPageCell

@interface CityPageCell () < UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, BaseDataModalDelegate,
                            GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>

@property (nonatomic, strong)   UIImageView             *titleBackView;
@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIImage                 *topCenterImage;
@property (nonatomic, strong)   UIImage                 *topLeftImage;
@property (nonatomic, strong)   UIImage                 *topRightImage;

@property (nonatomic, strong)   UICollectionView        *collectionContacts;
@property (nonatomic, strong)   RLMNotificationToken    *token;
@property (nonatomic, strong)   RLMResults              *results;

@property (nonatomic, strong)   UILongPressGestureRecognizer    *longPressGesture;

@end

@implementation CityPageCell

@synthesize first = _first;
@synthesize last = _last;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.titleBackView = [[UIImageView alloc] init];
        [CONTENT_VIEW addSubview:self.titleBackView];
        [self.titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@48);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:26];
        self.titleLabel.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:CITY_TITLE_BACKGROUND_COLOR isFlat:YES alpha:0.8];
        [self.titleBackView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleBackView.mas_left).offset(8);
            make.right.equalTo(self.titleBackView.mas_right).offset(8);
            make.top.equalTo(self.titleBackView);
            make.bottom.equalTo(self.titleBackView);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionContacts = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:layout];
        
        self.collectionContacts.backgroundColor = CITY_BACKGROUND_COLOR;
        self.collectionContacts.showsVerticalScrollIndicator = YES;
        self.collectionContacts.alwaysBounceVertical = YES;
        self.collectionContacts.dataSource = self;
        self.collectionContacts.delegate = self;
        [self.collectionContacts registerClass:[ContactCell class]
                    forCellWithReuseIdentifier:[ContactCell reuseIdentifier]];
        [CONTENT_VIEW addSubview:self.collectionContacts];
        
        [self.collectionContacts mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.titleBackView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    
    return self;
}

- (void)setCity:(NSString *)city {
    _city = [city copy];
    
//    [UdarManager sharedClient].contextMenu.dataSource = self;
//    [UdarManager sharedClient].contextMenu.delegate = self;
    
    if (self.longPressGesture) {
//        [self.collectionContacts removeGestureRecognizer:self.longPressGesture];
    }
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:[UdarManager sharedClient].contextMenu
                                                                          action:@selector(longPressDetected:)];
//    [self.collectionContacts addGestureRecognizer:self.longPressGesture];
    
    if ([UdarManager sharedClient].selectedItem == nil) {
        if ([_city isEqualToString:@"ads"]) {
            
        }
        else if ([_city length]) {
            self.results = [[ContactInfo objectsWhere:@"city == %@", _city] sortedResultsUsingProperty:@"usage" ascending:NO];
            [self.collectionContacts reloadData];
            self.titleLabel.text = _city;
            
            self.token = [[[ContactInfo objectsWhere:@"city == %@", _city] sortedResultsUsingProperty:@"usage" ascending:NO] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
                if ([change.insertions count] || [change.deletions count]) {
                    self.results = results;
                    [self.collectionContacts reloadData];
                }
            }];
        }
        else {
            self.results = [[ContactInfo objectsWhere:@"state != 1"] sortedResultsUsingProperty:@"usage" ascending:NO];
            [self.collectionContacts reloadData];
            self.titleLabel.text = [NSString stringWithFormat:@"未匹配: %ld", (long)[self.results count]];
            
            self.token = [[[ContactInfo objectsWhere:@"state != 1"] sortedResultsUsingProperty:@"usage" ascending:NO] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
                if ([change.insertions count] || [change.deletions count]) {
                    self.titleLabel.text = [NSString stringWithFormat:@"未匹配: %ld", (long)[results count]];
                    self.results = results;
                    [self.collectionContacts reloadData];
                }
            }];
        }
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.token stop];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateTitleBackView];
}

- (BOOL)first {
    return _first;
}

- (void)setFirst:(BOOL)first {
    _first = first;
    
    [self updateTitleBackView];
}

- (BOOL)last {
    return _last;
}

- (void)setLast:(BOOL)last {
    _last = last;
    
    [self updateTitleBackView];
}

- (void)updateTitleBackView {
    CGFloat width = CGRectGetWidth(self.titleBackView.frame);
    CGFloat size = CGRectGetHeight(self.titleBackView.frame);
    if (size == 0) {
        return;
    }
    
    if (!self.first && !self.last) {
        self.titleBackView.image = nil;
        self.titleBackView.backgroundColor = CITY_TITLE_BACKGROUND_COLOR;
        return;
    }
    
    self.titleBackView.backgroundColor = [UIColor clearColor];
    if (self.first && self.last) {
        if (self.topCenterImage == nil) {
            self.topCenterImage = [UIImage imageWithColor:CITY_TITLE_BACKGROUND_COLOR size:CGSizeMake(width, size)
                                        byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                              cornerRadii:CGSizeMake(12, 12)];
        }
        self.titleBackView.image = self.topCenterImage;
    }
    else {
        if (self.first) {
            if (!self.topLeftImage) {
                self.topLeftImage = [UIImage imageWithColor:CITY_TITLE_BACKGROUND_COLOR size:CGSizeMake(width, size)
                                          byRoundingCorners:UIRectCornerTopLeft
                                                cornerRadii:CGSizeMake(12, 12)];
            }
            self.titleBackView.image = self.topLeftImage;
        }
        else if (self.last) {
            if (!self.topRightImage) {
                self.topRightImage = [UIImage imageWithColor:CITY_TITLE_BACKGROUND_COLOR size:CGSizeMake(width, size)
                                           byRoundingCorners:UIRectCornerTopRight
                                                 cornerRadii:CGSizeMake(12, 12)];
            }
            self.titleBackView.image = self.topRightImage;
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.results count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = (ContactCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ContactCell reuseIdentifier]
                                                                                 forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCell *contactCell = (ContactCell *)cell;
    contactCell.contact = self.results[indexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat size = [ContactCell cellSize];
    return CGSizeMake(size, size);
}

#pragma mark - GHContextOverlayViewDataSource, GHContextOverlayViewDelegate

- (BOOL)shouldShowMenuAtPoint:(CGPoint)point {
    NSIndexPath *indexPath = [self.collectionContacts indexPathForItemAtPoint:point];
    return indexPath != nil;
}

- (NSInteger)numberOfMenuItems {
    return 5;
}

- (UIImage *)imageForItemAtIndex:(NSInteger)index {
    return [UIImage imageNamed:@"icon_contact_avatar_default"];
}

- (void)didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point {
    
}

- (void)dealloc {
}

@end

