//
//  YuAlertViewController.h
//  YuCloud
//
//  Created by 熊国锋 on 16/3/10.
//  Copyright © 2016年 VIROYAL-ELEC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommPros.h"


#define YUCLOUD_NAME_MAX_LENGTH     20

@interface YuAlertViewController : UIAlertController

+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
             navController:(nullable UINavigationController *)navController
                   okTitle:(nullable NSString *)okTitle
                  okAction:(nullable void (^)(UIAlertAction * _Nonnull action))okAction
               cancelTitle:(nullable NSString *)cancelTitle
              cancelAction:(nullable void (^)(UIAlertAction * _Nonnull action))cancelAction
                completion:(nullable void (^)(void))completion;

+ (nullable YuAlertViewController *)alertWithTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                            textPlaceHolder:(nullable NSString *)placeHolder
                                       text:(nullable NSString *)text
                              textMaxLength:(NSInteger)maxInputLength
                               keyboardType:(UIKeyboardType)keyboardType
                                    okTitle:(nullable NSString *)okTitle
                                   okAction:(nullable void (^)(UIAlertAction * _Nonnull action, NSString * _Nonnull text))okAction
                                cancelTitle:(nullable NSString *)cancelTitle
                               cancelAction:(nullable void (^)(UIAlertAction * _Nonnull))cancelAction
                                 completion:(nullable void (^)(void))completion;

@end
