//
//  ContactInitViewController.m
//  Udar
//
//  Created by 熊国锋 on 2016/8/22.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ContactInitViewController.h"
#import "ContactDataModal.h"
#import "FlatButton.h"


@interface ContactInitViewController () < BaseDataModalDelegate >

@property (nonatomic, strong)   FlatButton          *continueButton;
@property (nonatomic, strong)   UILabel             *labelView;

@property (nonatomic, strong)   RLMNotificationToken    *token;
@property (nonatomic, strong)   RLMResults              *results;

@end

@implementation ContactInitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelView];
    [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.view addSubview:self.continueButton];
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.labelView.mas_bottom).offset(20);
    }];
    
    self.results = [ContactInfo objectsWhere:@"refCount == 1"];
    [self updateMsg];
    
    self.token = [[ContactInfo objectsWhere:@"refCount == 1"] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if ([change.insertions count] || [change.deletions count]) {
            self.results = results;
            [self updateMsg];
        }
    }];
}

- (UILabel *)labelView {
    if (!_labelView) {
        _labelView = [[UILabel alloc] init];
        _labelView.font = [UIFont systemFontOfSize:34];
        _labelView.textColor = [UIColor flatRedColor];
    }
    
    return _labelView;
}

- (FlatButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [FlatButton button];
        _continueButton.title = @"继续";
        _continueButton.titleColor = [UIColor whiteColor];
        _continueButton.titleFont = [UIFont systemFontOfSize:24];
        _continueButton.cornerRadius = 8;
        
        [_continueButton addTarget:self
                            action:@selector(touchupContinueButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _continueButton;
}

- (void)touchupContinueButton:(id)sender {
    [self.delegate showNextPageOf:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMsg {
    NSInteger total = [self.results count];
    
    NSDictionary *attr1 = @{ NSFontAttributeName : [UIFont systemFontOfSize:20],
                            NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    
    NSDictionary *attr2 = @{ NSFontAttributeName : [UIFont systemFontOfSize:34],
                            NSForegroundColorAttributeName : [UIColor flatRedColor]};
    
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] init];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:@"总共发现了 " attributes:attr1]];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)total] attributes:attr2]];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 个号码" attributes:attr1]];
    
    [self.labelView setAttributedText:[[NSAttributedString alloc] initWithAttributedString:mString]];
}

- (void)dealloc {
    [self.token stop];
}

@end
