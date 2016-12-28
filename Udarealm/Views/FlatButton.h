//
//  FlatButton.h
//  Doubi
//
//  Created by 熊国锋 on 16/5/30.
//  Copyright © 2016年 Nanjing Viroyal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlatButton : UIButton

+ (instancetype)button;

@property (nonatomic, copy) NSString    *title;

@property (nonatomic, copy) UIColor     *titleColor;
@property (nonatomic, copy) UIFont      *titleFont;

@property CGFloat cornerRadius;


@end
