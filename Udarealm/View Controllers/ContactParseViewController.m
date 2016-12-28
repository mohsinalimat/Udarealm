
//  ContactParseViewController.m
//  Udar
//
//  Created by 熊国锋 on 2016/8/22.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ContactParseViewController.h"
#import "FlatButton.h"
#import "ContactParser.h"


@interface ContactParseViewController ()

@property (nonatomic, strong)   UILabel             *label1;
@property (nonatomic, strong)   UILabel             *label2;
@property (nonatomic, strong)   UILabel             *label3;

@property (nonatomic, strong)   FlatButton          *continueButton;

@property (nonatomic, strong)   RLMNotificationToken    *token;
@property (nonatomic, strong)   RLMResults              *results;

@end

@implementation ContactParseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label1 = [[UILabel alloc] init];
    self.label1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_leftMargin);
        make.centerY.equalTo(self.view);
    }];
    
    self.label2 = [[UILabel alloc] init];
    self.label2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.label2];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label1);
        make.top.equalTo(self.label1.mas_bottom).offset(4);
    }];
    
    self.label3 = [[UILabel alloc] init];
    self.label3.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.label3];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label1);
        make.top.equalTo(self.label2.mas_bottom).offset(4);
    }];
    
    self.continueButton = [FlatButton button];
    self.continueButton.title = @"继续";
    self.continueButton.titleColor = [UIColor whiteColor];
    self.continueButton.titleFont = [UIFont systemFontOfSize:24];
    self.continueButton.cornerRadius = 8;
    
    [self.continueButton addTarget:self
                            action:@selector(touchupContinueButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.continueButton];
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.label3.mas_bottom).offset(8);
    }];
    
    self.results = [ContactInfo objectsWhere:@"state == 1"];
    [self updateInfo];
    
    self.token = [[ContactInfo objectsWhere:@"state == 1"] addNotificationBlock:^(RLMResults * _Nullable results,
                                                                                  RLMCollectionChange * _Nullable change,
                                                                                  NSError * _Nullable error) {
        if ([change.insertions count] || [change.deletions count]) {
            self.results = results;
            [self updateInfo];
        }
    }];
}

- (void)touchupContinueButton:(id)sender {
    [self.delegate finishPageOf:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.token stop];
}

- (void)updateInfo {
    NSDictionary *attr1 = @{ NSFontAttributeName : [UIFont systemFontOfSize:20],
                             NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    
    NSDictionary *attr2 = @{ NSFontAttributeName : [UIFont systemFontOfSize:34],
                             NSForegroundColorAttributeName : [UIColor flatRedColor]};
    
    //全部
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] init];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)[self.results count]]
                                                                   attributes:attr2]];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t个号码匹配到归属地"
                                                                    attributes:attr1]];
    self.label1.attributedText = [[NSAttributedString alloc] initWithAttributedString:mString];
    
    //省
    RLMResults *province = [ProvinceInfo allObjects];
    mString = [[NSMutableAttributedString alloc] init];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)[province count]]
                                                                    attributes:attr2]];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t个省"
                                                                    attributes:attr1]];
    self.label2.attributedText = [[NSAttributedString alloc] initWithAttributedString:mString];
    
    //市
    RLMResults *city = [CityInfo allObjects];
    mString = [[NSMutableAttributedString alloc] init];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)[city count]]
                                                                    attributes:attr2]];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t个市"
                                                                    attributes:attr1]];
    self.label3.attributedText = [[NSAttributedString alloc] initWithAttributedString:mString];
}

@end
