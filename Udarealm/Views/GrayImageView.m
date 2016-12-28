//
//  GrayImageView.m
//  YuCloud
//
//  Created by 熊国锋 on 16/2/3.
//  Copyright © 2016年 VIROYAL-ELEC. All rights reserved.
//

#import "GrayImageView.h"
#import "UIImage+YuCloud.h"

@interface GrayImageView ()

@property (nonatomic, assign) BOOL          gray;
@property (nonatomic, strong) UIImage       *imageOriginal;
@property (nonatomic, strong) UIImage       *imageGray;

@end

@implementation GrayImageView

- (void)setImage:(UIImage *)image
{
    self.imageOriginal = image;
    self.imageGray = [image convertToGrayscale];
    
    [super setImage:self.gray?self.imageGray:self.imageOriginal];
}

- (void)setGray:(BOOL)gray
{
    _gray = gray;
    [super setImage:gray?self.imageGray:self.imageOriginal];
}

@end

