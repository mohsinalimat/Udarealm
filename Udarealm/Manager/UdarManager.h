//
//  UdarManager.h
//  Udarealm
//
//  Created by 熊国锋 on 2016/8/31.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactInfo.h"
#import "GHContextMenuView.h"

#define PROVINCE_BACKGROUND_COLOR       UIColorFromHex(0x34475c)
#define CITY_BACKGROUND_COLOR           [UIColor whiteColor]
#define CITY_TITLE_BACKGROUND_COLOR     [UIColor whiteColor]

#define CONTENT_VIEW                    self.contentView

NS_ASSUME_NONNULL_BEGIN

@interface UdarManager : NSObject

@property (nullable, nonatomic, strong) ContactInfo     *selectedItem;
@property (nonatomic, strong)   GHContextMenuView       *contextMenu;

+ (instancetype)sharedClient;

- (UIViewController *)topMostViewController;
- (void)viewContact:(NSString *)contact_id;

@end

NS_ASSUME_NONNULL_END
