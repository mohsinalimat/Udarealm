//
//  UILabel+YuCloud.m
//  cards
//
//  Created by 熊国锋 on 16/5/26.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "UILabel+YuCloud.h"

@implementation UILabel (YuCloud)

- (void)setShadowOffset:(CGSize)offset
                  color:(UIColor *)color
                opacity:(float)opacity {
    
    self.layer.shadowOffset     = offset;
    self.layer.shadowColor      = [color CGColor];
    self.layer.shadowOpacity    = opacity;
}

@end
