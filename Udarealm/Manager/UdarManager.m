//
//  UdarManager.m
//  Udarealm
//
//  Created by 熊国锋 on 2016/8/31.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "UdarManager.h"
#import <ContactsUI/ContactsUI.h>
#import "AppDelegate.h"

@interface ContactViewController : CNContactViewController

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(CloseContactViewController)];
}

- (void)CloseContactViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@interface UdarManager ()

@end

@implementation UdarManager

+ (instancetype)sharedClient {
    static UdarManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[UdarManager alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init {
    if (self = [super init]) {
        self.contextMenu = [[GHContextMenuView alloc] init];
    }
    
    return self;
}

- (UIViewController *)topMostViewController {
    AppDelegate *app = [AppDelegate sharedAppDelegate];
    return app.window.rootViewController;
}

- (void)viewContact:(NSString *)contact_id {
    NSArray *keys = @[CNContactIdentifierKey, CNContactThumbnailImageDataKey,
                      CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactNicknameKey, CNContactOrganizationNameKey,
                      [CNContactViewController descriptorForRequiredKeys]];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    CNContact *contact = [store unifiedContactWithIdentifier:contact_id
                                                 keysToFetch:keys
                                                       error:nil];
    
    ContactViewController *vc = [ContactViewController viewControllerForContact:contact];
    vc.allowsEditing = NO;
    
    UIViewController *topMostViewController = [self topMostViewController];
    [topMostViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    
    [topMostViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                        animated:YES
                                      completion:nil];
}


@end
