//
//  ContactCell.m
//  cards
//
//  Created by 熊国锋 on 16/5/26.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ContactCell.h"
#import "WebCachedImageView.h"
#import "UILabel+YuCloud.h"
#import "ContactDataModal.h"
#import "AvatarCache.h"
#import "UdarManager.h"
#import "ParseInfo.h"


void * ContactCellContext = &ContactCellContext;

#pragma mark - ContactCell

@interface ContactCell ()

@property (nonatomic, strong)   UIImageView             *avatarView;
@property (nonatomic, strong)   UILabel                 *nameLabel;

@property (atomic, assign)      BOOL                    grayed;

@end

@implementation ContactCell
@synthesize grayed = _grayed;

+ (CGFloat)cellSize {
    return 88;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapCell:)]];
        
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(longPressCell:)]];
        
        [[UdarManager sharedClient] addObserver:self
                                     forKeyPath:NSStringFromSelector(@selector(selectedItem))
                                        options:NSKeyValueObservingOptionNew
                                        context:ContactCellContext];
        
        self.avatarView = [[UIImageView alloc] init];
        [self.avatarView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.avatarView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = YUCLOUD_SYSTEM_FONT_WITH_SIZE(FontSizeXS);
        self.nameLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:self.nameLabel];
        
        UIView *superView = self;
        int padding = 10;
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(padding);
            make.right.equalTo(superView.mas_right).offset(-padding);
            make.top.equalTo(superView.mas_top).offset(2);
            make.height.equalTo(self.avatarView.mas_width);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superView.mas_centerX);
            make.top.equalTo(self.avatarView.mas_bottom);
            make.width.lessThanOrEqualTo(self);
        }];
    }
    
    return self;
}

- (void)setContact:(ContactInfo *)contact {
    _contact = contact;
    if (contact.thumbnailImageID) {
        AvatarCache *cache = [AvatarCache cache];
        UIImage *image = [cache objectForKey:contact.thumbnailImageID];
        if (image) {
            self.avatarView.image = image;
        }
        else {
            image = [[ContactDataModal sharedClient] imageWithKey:contact.thumbnailImageID];
            self.avatarView.image = image;
            [cache setObject:image forKey:contact.thumbnailImageID];
        }
    }
    else {
        self.avatarView.image = [UIImage imageNamed:@"icon_contact_avatar_default"];
    }
    
    self.nameLabel.text = contact.name;
}

- (void)tapCell:(UITapGestureRecognizer *)gestureRecognizer {
    [[UdarManager sharedClient] viewContact:self.contact.contact_id];
}

- (void)longPressCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [UdarManager sharedClient].selectedItem = self.contact;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UdarManager sharedClient].selectedItem = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (context == ContactCellContext) {
        ContactInfo *item = change[NSKeyValueChangeNewKey];
        if (![item isKindOfClass:[ContactInfo class]]) {
            item = nil;
        }
        
        if (item) {
            self.grayed = item != self.contact;
        }
        else {
            self.grayed = NO;
        }
    }
}

- (BOOL)grayed {
    return _grayed;
}

- (void)setGrayed:(BOOL)grayed {
    _grayed = grayed;
    
    [UIView animateWithDuration:.3
                     animations:^{
                         self.alpha = grayed?.3:1;
                     }
                     completion:nil];
}

- (void)dealloc {
    [[UdarManager sharedClient] removeObserver:self
                                    forKeyPath:NSStringFromSelector(@selector(selectedItem))
                                       context:ContactCellContext];
}
@end
