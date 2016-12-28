//
//  ContactAuthViewController.m
//  Udar
//
//  Created by 熊国锋 on 2016/8/22.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ContactAuthViewController.h"
#import "FlatButton.h"
#import <Contacts/Contacts.h>
#import "ContactDataModal.h"



@interface ContactAuthViewController ()

@property (nonatomic, strong)   FlatButton      *authButton;
@property (nonatomic, strong)   UILabel         *msgView;

@end

@implementation ContactAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.authButton];
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.view addSubview:self.msgView];
    [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.authButton.mas_bottom).offset(8);
    }];
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusNotDetermined:
            self.authButton.title = @"通讯录访问授权";
            break;
            
        case CNAuthorizationStatusAuthorized:
            self.authButton.title = @"点击以继续";
            break;
            
        default:
            self.authButton.hidden = YES;
            self.msgView.text = @"请在[设置][隐私][通讯录]中开启访问权限";
            self.msgView.hidden = NO;
            break;
    }
}

- (FlatButton *)authButton {
    if (!_authButton) {
        _authButton = [FlatButton button];
        _authButton.titleColor = [UIColor whiteColor];
        _authButton.titleFont = [UIFont systemFontOfSize:24];
        _authButton.cornerRadius = 8;
        
        [_authButton addTarget:self
                        action:@selector(touchupAuthButton:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _authButton;
}

- (UILabel *)msgView {
    if (!_msgView) {
        _msgView = [[UILabel alloc] init];
        _msgView.font = [UIFont systemFontOfSize:20];
        _msgView.textColor = [UIColor flatRedColor];
        _msgView.hidden = YES;
    }
    
    return _msgView;
}

- (void)touchupAuthButton:(id)sender {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts
                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
                            if (granted) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[ContactDataModal sharedClient] initContacts];
                                    [self.delegate showNextPageOf:self];
                                });
                            }
                        }];
    }
    else if (status == CNAuthorizationStatusAuthorized) {
        [self.delegate showNextPageOf:self];
    }
    else {
        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CONTACTS"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
