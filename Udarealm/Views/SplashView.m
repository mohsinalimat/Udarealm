//
//  SplashView.m
//  Udar
//
//  Created by 熊国锋 on 2016/8/21.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "SplashView.h"
#import "ContactAuthViewController.h"
#import "ContactInitViewController.h"
#import "ContactParseViewController.h"
#import <Contacts/Contacts.h>
#import "ContactDataModal.h"


@interface SplashView () < UIPageViewControllerDataSource, UIPageViewControllerDelegate, SplashPageProtocol >

@property (nonatomic, strong)   UILabel                 *labelView;

@property (nonatomic, strong)   UIPageViewController    *pageViewController;
@property (nonatomic, strong)   NSArray                 *arrPages;


@end

@implementation SplashView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.labelView = [[UILabel alloc] init];
        self.labelView.font = [UIFont systemFontOfSize:38];
        self.labelView.textAlignment = NSTextAlignmentCenter;
        self.labelView.text = @"朋友遍天下";
        [self addSubview:self.labelView];
        [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        NSInteger total = [[ContactInfo allObjects] count];
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authStatus != CNAuthorizationStatusAuthorized || total == 0) {
            [self initializePageViewController];
            [self performSelector:@selector(switchView)
                       withObject:nil
                       afterDelay:.3];
        }
        else {
            [self performSelector:@selector(dismissView)
                       withObject:nil
                       afterDelay:.3];
        }
    }
    
    return self;
}

- (void)initializePageViewController {
    ContactAuthViewController *auth = [[ContactAuthViewController alloc] init];
    auth.delegate = self;
    
    ContactInitViewController *init = [[ContactInitViewController alloc] init];
    init.delegate = self;
    
    ContactParseViewController *parse = [[ContactParseViewController alloc] init];
    parse.delegate = self;
    
    self.arrPages = @[auth, init, parse];
    [self addSubview:self.pageViewController.view];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelView.mas_right);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-120);
    }];
    
    [self activatePage:0
               forward:YES
              animated:NO
            completion:nil];
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        for (UIScrollView *item in [_pageViewController.view subviews]) {
            if ([item isKindOfClass:[UIScrollView class]]) {
                item.scrollEnabled = NO;
            }
        }
    }
    
    return _pageViewController;
}

- (void)activatePage:(NSInteger)index forward:(BOOL)forward animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion {
    [self.pageViewController setViewControllers:@[self.arrPages[index]]
                                      direction:forward?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse
                                       animated:animated
                                     completion:completion];
}

- (void)switchView {
    CGFloat width = CGRectGetWidth(self.labelView.frame);
    [self.labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@(width));
        make.right.equalTo(self.mas_left);
    }];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self.labelView removeFromSuperview];
                         self.labelView = nil;
                         
                         [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.equalTo(self.mas_left);
                             make.right.equalTo(self.mas_right);
                             make.top.equalTo(self.mas_top);
                             make.bottom.equalTo(self.mas_bottom).offset(-120);
                         }];
                     }];
}

- (void)dismissView {
    [UIView animateWithDuration:.3
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.delegate finishSplash:self];
                     }];
}

#pragma mark - UIPageViewControllerDataSource, UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

#pragma mark - SplashPageProtocol

- (void)showNextPageOf:(UIViewController *)viewController {
    NSInteger index = [self.arrPages indexOfObject:viewController];
    [self activatePage:index + 1
               forward:YES
              animated:YES
            completion:nil];
}

- (void)finishPageOf:(UIViewController *)viewController {
    [self dismissView];
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

