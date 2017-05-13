//
//  WebCachedImageView.m
//  YuCloud
//
//  Created by 熊国锋 on 15/10/22.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import "WebCachedImageView.h"
#import "UIView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "GrayImageView.h"
#import "PhotoTweaksViewController.h"


@interface WebCachedImageView () < UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoTweaksViewControllerDelegate >

@property (weak, nonatomic, readwrite) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) GrayImageView     *imageView;
@property (nonatomic, strong) UIView            *containerView;
@property (atomic, assign)    CGSize            shadowOffset;
@property (nonatomic, strong) UIColor           *shadowColor;
@property (atomic, assign)    float             shadowOpacity;

@end

@implementation WebCachedImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
        
        self.containerView = [[UIView alloc] init];
        [self addSubview:self.containerView];
        
        self.imageView = [[GrayImageView alloc] init];
        [self.containerView addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top);
            make.bottom.equalTo(self.containerView.mas_bottom);
            make.left.equalTo(self.containerView.mas_left);
            make.right.equalTo(self.containerView.mas_right);
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
    }
    
    return self;
}

- (void)setDelegate:(id<WebCachedImageDelegate>)delegate
{
    _delegate = delegate;
    
    if(delegate)
    {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
        [self addGestureRecognizer:tap];
        self.tapGestureRecognizer = tap;
    }
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    self.userInteractionEnabled = YES;
    [super addGestureRecognizer:gestureRecognizer];
}

- (void)setShadowOffset:(CGSize)offset color:(UIColor *)color opacity:(float)opacity
{
    self.shadowOffset = offset;
    self.shadowColor = color;
    self.shadowOpacity = opacity;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    self.imageView.contentMode = contentMode;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    if (self.roundedEllipse) {
        CGRect rect = bounds;
        self.imageView.layer.cornerRadius = rect.size.width / 2.0;
        self.imageView.layer.masksToBounds = YES;
    }
    else if(self.roundedRect) {
        self.imageView.layer.cornerRadius = 6;
    }
    
    if (self.shadowOffset.height + self.shadowOffset.width > 0) {
        self.layer.shadowOffset     = self.shadowOffset;
        self.layer.shadowColor      = [self.shadowColor CGColor];
        self.layer.shadowOpacity    = self.shadowOpacity;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self.imageView setBackgroundColor:backgroundColor];
}

- (void)imageViewTaped:(UITapGestureRecognizer *)recognizer
{
    if(self.delegate == nil)
    {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:NSLocalizedString(@"Choose image", nil)
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.navigationBarHidden = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.delegate presentViewController:picker target:self];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:YUCLOUD_STRING_FAILED
                                                                                     message:NSLocalizedString(@"Camera not available", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:YUCLOUD_STRING_DONE
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:okAction];
            [self.delegate presentViewController:alertController target:self];
        }
    }];
    UIAlertAction *photos = [UIAlertAction actionWithTitle:NSLocalizedString(@"Photos", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action)
                             {
                                 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                 picker.delegate = self;
                                 picker.allowsEditing = NO;
                                 picker.navigationBarHidden = YES;
                                 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                 [self.delegate presentViewController:picker target:self];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:YUCLOUD_STRING_CANCEL style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:photos];
    [alert addAction:cancel];
    
    UIPopoverPresentationController *presentation = alert.popoverPresentationController;
    presentation.sourceView = self;
    presentation.sourceRect = self.bounds;
    
    [self.delegate presentViewController:alert target:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    WEAK(self, wself);
    [picker dismissViewControllerAnimated:YES completion:^{
        STRONG(wself, sself);
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
        photoTweaksViewController.delegate = wself;
        photoTweaksViewController.autoSaveToLibray = NO;
        
        [sself.delegate presentViewController:photoTweaksViewController target:self];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    WEAK(self, wself);
    [controller dismissViewControllerAnimated:YES completion:^{
        STRONG(wself, sself);
        [sself uploadImage:croppedImage
                    block:^(BOOL success, NSDictionary * _Nullable info) {

        }];
    }];
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image block:(void (^)(BOOL success, NSDictionary * _Nullable info))block
{
    /*
     *  图片已经拿到，我们需要做以下几件事情
     *  1. 临时保存到本地
     *  2. 上传到服务器
     */
    
    NSData *jpeg = UIImageJPEGRepresentation(image, 0.4);
    
    NSURL *url = [YUCLOUD_SANDBOX_APPLICATION_DIRECTORY URLByAppendingPathComponent:@"image.jpeg"];
    [jpeg writeToURL:url atomically:YES];
    
    [self uploadImageWithUrl:url block:^(BOOL success, NSDictionary * _Nullable info) {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        if (block)
        {
            block(success, info);
        }
    }];
}

- (void)uploadImageWithUrl:(NSURL *)url block:(void (^)(BOOL success, NSDictionary * _Nullable info))block
{

}

- (void)setWebImage:(NSString *)address placeholderImage:(UIImage *)image block:(void (^)(BOOL))block {
    if ([address length] > 10) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:address]
                          placeholderImage:image
                                   options:SDWebImageAllowInvalidSSLCertificates
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (error) {
                                         DDLogError(@"sd_setImageWithURL: %@ error: %@", address, [error localizedDescription]);
                                     }
                                     
                                     if (block) {
                                         block(error == nil);
                                     }
                                 }];
    }
    else {
        [self.imageView setImage:image];
    }
}

- (NSURL *)getImageUrl
{
    return [self.imageView sd_imageURL];
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (void)checkNeedUploadImage:(void (^)(BOOL success, NSDictionary * _Nullable info))block
{
    if(self.uploaded == NO)
    {
        UIImage *image = self.image;
        if(image)
        {
            [self uploadImage:image block:^(BOOL success, NSDictionary * _Nullable info) {
                if(block)
                {
                    block(success, nil);
                }
            }];
            return;
        }
    }
    
    if(block)
    {
        block(YES, nil);
    }
}

- (void)setGray:(BOOL)gray
{
    [self.imageView setGray:gray];
}

- (void)dealloc
{
    [self.tapGestureRecognizer removeTarget:nil action:nil];
    self.tapGestureRecognizer = nil;
}
@end



