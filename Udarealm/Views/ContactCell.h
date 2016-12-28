//
//  ContactCell.h
//  cards
//
//  Created by 熊国锋 on 16/5/26.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDataModal.h"
#import "UICollectionViewCell+YuCloud.h"

@interface ContactCell : UICollectionViewCell

@property (nonatomic, strong)       ContactInfo         *contact;

+ (CGFloat)cellSize;


@end
