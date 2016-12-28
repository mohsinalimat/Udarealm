//
//  TodayViewController.m
//  Today
//
//  Created by 熊国锋 on 2016/9/10.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Contacts/Contacts.h>
#import "UIImage+YuCloud.h"
#import "UICollectionViewCell+YuCloud.h"


@interface TodayCell : UICollectionViewCell

@property (nonatomic, copy)     NSString                *contact_id;

@property (nonatomic, strong)   UIImageView             *imageView;
@property (nonatomic, strong)   UILabel                 *labelView;


@end

@implementation TodayCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *superView = self.contentView;
        
        self.imageView = [[UIImageView alloc] init];
        [superView addSubview:self.imageView];
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSInteger padding = 16;
        
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:superView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                               constant:padding]];
        
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:superView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                               constant:-padding]];
        
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:padding]];
        
        [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.imageView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0
                                                               constant:0]];
        
        self.labelView = [[UILabel alloc] init];
        self.labelView.textColor = [UIColor lightTextColor];
        [superView addSubview:self.labelView];
        
        self.labelView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.imageView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                               constant:.0]];
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:.0]];
    }
    
    return self;
}

- (void)setContact_id:(NSString *)contact_id {
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] != CNAuthorizationStatusAuthorized) {
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    NSArray *keys = @[CNContactIdentifierKey, CNContactThumbnailImageDataKey,
                      CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,
                      CNContactNicknameKey, CNContactOrganizationNameKey];
    
    CNContact *contact = [[store unifiedContactsMatchingPredicate:[CNContact predicateForContactsWithIdentifiers:@[contact_id]]
                                                     keysToFetch:keys
                                                           error:nil] firstObject];
    if (contact) {
        UIImage *image = [UIImage imageWithData:contact.thumbnailImageData];
        self.imageView.image = [image imageWithCornerRadius:image.size.width / 2 scale:1.0];
        [self setNeedsLayout];
        
        NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
        if ([name length] == 0) {
            name = contact.organizationName;
        }
        self.labelView.text = name;
    }
}

@end

#pragma mark - TodayViewController

@interface TodayViewController () < NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)   UICollectionView        *collectionView;
@property (nonatomic, strong)   NSArray                 *contacts;
@property (nonatomic, assign)   NSInteger               pageIndex;

@property (nonatomic, strong)   UIButton                *btnView;

@end

@implementation TodayViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    self.collectionView.backgroundColor = [UIColor darkGrayColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[TodayCell class]
            forCellWithReuseIdentifier:[TodayCell reuseIdentifier]];
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateData];
}

- (UIButton *)btnView {
    if (!_btnView) {
        _btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnView setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        [_btnView setTitle:@"无法显示推荐联系人，可能是你的通讯录隐私权限没有开启，或者联系人个数过少"
                  forState:UIControlStateNormal];
        _btnView.titleLabel.numberOfLines = 3;
        [self.view addSubview:_btnView];
        [_btnView addTarget:self
                     action:@selector(tapTodayView)
           forControlEvents:UIControlEventTouchUpInside];
        
        _btnView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:8]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-8]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_btnView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0]];
    }
    
    return _btnView;
}

- (void)tapTodayView {
    [[self extensionContext] openURL:[NSURL URLWithString:@"udar://"]
                   completionHandler:^(BOOL success) {
                   }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.pageIndex * 4 < [self.contacts count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.pageIndex * 4 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.pageIndex++;
    if (self.pageIndex * 4 >= [self.contacts count]) {
        self.pageIndex = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    [self updateData];
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

- (void)updateData {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.viroyal.TodayExtensionSharingDefaults"];
    self.contacts = [defaults objectForKey:@"Contacts"];
    
    self.btnView.hidden = [self.contacts count] >= 4;
    self.collectionView.hidden = [self.contacts count] < 4;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.contacts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TodayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TodayCell reuseIdentifier]
                                                                forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(TodayCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *contact_id = self.contacts[indexPath.item];
    cell.contact_id = contact_id;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat height = CGRectGetHeight(collectionView.bounds);
    return CGSizeMake(width / 4, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *contact_id = self.contacts[indexPath.item];
    
    NSString *string = [NSString stringWithFormat:@"udar://contact_id?%@", contact_id];
    [self.extensionContext openURL:[NSURL URLWithString:string]
                 completionHandler:nil];
}

@end
