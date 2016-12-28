//
//  ProvincePageCell.h
//  Udar
//
//  Created by 熊国锋 on 2016/8/29.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "CityPageCell.h"
#import "ProvinceInfo.h"
#import "UdarManager.h"
#import "UICollectionViewCell+YuCloud.h"

@interface ProvincePageCell : UICollectionViewCell


@property (nonatomic, copy)     NSString        *province;

- (void)startScrollPos:(NSInteger)pos;
- (void)endScroll;

@end
