//
//  UICollectionViewCell+YuCloud.m
//  Udarealm
//
//  Created by 熊国锋 on 2016/12/8.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "UICollectionViewCell+YuCloud.h"

@implementation UICollectionViewCell (YuCloud)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
