//
//  CityPageCell.h
//  cards
//
//  Created by 熊国锋 on 16/5/25.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDataModal.h"
#import "ContactCell.h"
#import "CityInfo.h"
#import "UICollectionViewCell+YuCloud.h"


@interface CityPageCell : UICollectionViewCell

@property (nonatomic, copy)     NSString            *city;
@property (nonatomic, assign)   BOOL                first;
@property (nonatomic, assign)   BOOL                last;


@end

