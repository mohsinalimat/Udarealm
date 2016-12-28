//
//  ProvincePageCell.m
//  Udar
//
//  Created by 熊国锋 on 2016/8/29.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ProvincePageCell.h"
#import "UdarAdsViewCell.h"


@interface ProvincePageCell () < UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UICollectionView        *collectionSub;
@property (atomic, assign)      BOOL                    beginScrolling;

@property (nonatomic, strong)   RLMNotificationToken    *token;
@property (nonatomic, strong)   RLMResults              *results;

@end

@implementation ProvincePageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:72 weight:8];
        [CONTENT_VIEW addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(CONTENT_VIEW);
            make.top.equalTo(CONTENT_VIEW.mas_top).offset(40);
        }];
        
        UICollectionViewFlowLayout *layoutSub = [[UICollectionViewFlowLayout alloc] init];
        layoutSub.minimumLineSpacing = 4;
        layoutSub.minimumInteritemSpacing = 0;
        layoutSub.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionSub = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:layoutSub];
        
        self.collectionSub.backgroundColor = [UIColor clearColor];
        self.collectionSub.pagingEnabled = NO;
        self.collectionSub.alwaysBounceHorizontal = YES;
        self.collectionSub.showsVerticalScrollIndicator = NO;
        self.collectionSub.showsHorizontalScrollIndicator = YES;
        self.collectionSub.dataSource = self;
        self.collectionSub.delegate = self;
        [self.collectionSub registerClass:[CityPageCell class]
               forCellWithReuseIdentifier:[CityPageCell reuseIdentifier]];
        
        [self.collectionSub registerClass:[UdarAdsViewCell class]
               forCellWithReuseIdentifier:[UdarAdsViewCell reuseIdentifier]];
        
        UIView *superView = self.contentView;
        [superView addSubview:self.collectionSub];
        
        [self.collectionSub mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
            make.left.equalTo(superView.mas_left).offset(2);
            make.right.equalTo(superView.mas_right).offset(-2);
            make.bottom.equalTo(superView.mas_bottom).offset(-0);
        }];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateTitleColors];
}

- (void)updateTitleColors {
    UIColor *backgroundColor = self.backgroundColor;
    
    UIColor *textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:backgroundColor isFlat:YES alpha:0.9];
    self.titleLabel.textColor = textColor;
}

- (void)setProvince:(NSString *)province {
    _province = [province copy];
    
    self.titleLabel.text = _province?:@"未匹配";
    
    if ([_province length]) {
        self.results = [[CityInfo objectsWhere:@"province == %@", _province] sortedResultsUsingProperty:@"usage" ascending:NO];
        [self.collectionSub reloadData];
        
        self.token = [[[CityInfo objectsWhere:@"province == %@", _province] sortedResultsUsingProperty:@"usage" ascending:NO] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
            self.results = results;
            [self.collectionSub reloadData];
        }];
    }
    else {
        self.results = nil;
        [self.collectionSub reloadData];
    }
}

- (void)startScrollPos:(NSInteger)pos {
    if (pos == -1) {
        NSInteger count = [self.collectionSub numberOfItemsInSection:0];
        if (count > 0) {
            NSIndexPath *last = [NSIndexPath indexPathForItem:count - 1 inSection:0];
            [self.collectionSub scrollToItemAtIndexPath:last
                                       atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                               animated:NO];
            
            self.beginScrolling = YES;
        }
    }
    else {
        [self.collectionSub scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
}

- (void)endScroll {
    if (self.beginScrolling) {
        self.beginScrolling = NO;
        [self.collectionSub scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.beginScrolling = NO;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.province?[self.results count]:1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.province || indexPath.item == 0) {
        CityPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CityPageCell reuseIdentifier]
                                                                       forIndexPath:indexPath];
        
        return cell;
    }
    else {
        UdarAdsViewCell *ads = [collectionView dequeueReusableCellWithReuseIdentifier:[UdarAdsViewCell reuseIdentifier]
                                                                         forIndexPath:indexPath];
        
        return ads;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CityPageCell *cityCell = (CityPageCell *)cell;
    if (self.province) {
        CityInfo *city = self.results[indexPath.item];
        cityCell.city = city.city;
        
        NSInteger count = [self.results count];
        cityCell.first = indexPath.item == 0;
        cityCell.last = indexPath.item == count - 1;
    }
    else {
        cityCell.city = nil;
        cityCell.first = YES;
        cityCell.last = YES;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat height = CGRectGetHeight(collectionView.bounds);
    NSInteger count = [collectionView numberOfItemsInSection:indexPath.section];
    if (count > 1) {
        CGFloat size = [ContactCell cellSize] * 3;
        UIEdgeInsets edge = self.collectionSub.layoutMargins;
        return CGSizeMake(size + edge.left + edge.right, height);
    }
    else {
        return CGSizeMake(width, height);
    }
}

- (void)dealloc {
}

@end
