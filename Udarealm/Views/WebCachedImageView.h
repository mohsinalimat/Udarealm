//
//  WebCachedImageView.h
//  YuCloud
//
//  Created by 熊国锋 on 15/10/22.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol WebCachedImageDelegate <NSObject>

- (void)presentViewController:(UIViewController *)alert target:(id)target;
- (void)imageUploadFinished:(BOOL)success info:(nullable NSDictionary *)info;

- (id)showHUDWithTitle:(NSString *)title;
@end

@interface WebCachedImageView : UIView

@property (nonatomic, weak) id <WebCachedImageDelegate>     delegate;
@property (nonatomic, strong) NSNumber                      *loginid;
@property (nonatomic, strong) NSString                      *token;
@property (atomic, assign)    BOOL                          uploaded;
@property (atomic, assign)    BOOL                          roundedEllipse;
@property (atomic, assign)    BOOL                          roundedRect;
@property (nonatomic, strong) UIImage                       *image;

- (void)addGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;

- (void)setShadowOffset:(CGSize)offset color:(UIColor *)color opacity:(float)opacity;
- (void)setContentMode:(UIViewContentMode)contentMode;

- (void)setWebImage:(nullable NSString *)address
   placeholderImage:(nullable UIImage *)image
              block:(void (^)(BOOL success))block;

- (NSURL *)getImageUrl;

- (void)checkNeedUploadImage:(void (^)(BOOL success, NSDictionary * _Nullable info))block;

- (void)setGray:(BOOL)gray;

@end

NS_ASSUME_NONNULL_END

