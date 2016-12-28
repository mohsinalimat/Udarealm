//
//  YuAlertViewController.m
//  YuCloud
//
//  Created by 熊国锋 on 16/3/10.
//  Copyright © 2016年 VIROYAL-ELEC. All rights reserved.
//

#import "YuAlertViewController.h"
#import "AFViewShaker.h"

@interface YuAlertViewController ()

@property (atomic, assign)   NSInteger              maxInputLength;
@property (nonatomic, copy)  NSString               *preContent;

@end

@implementation YuAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             navController:(UINavigationController *)navController
                   okTitle:(NSString *)okTitle
                  okAction:(void (^)(UIAlertAction *))okAction
               cancelTitle:(NSString *)cancelTitle
              cancelAction:(void (^)(UIAlertAction *))cancelAction
                completion:(void (^)(void))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:okAction];
    [alert addAction:ok];
    
    if ([cancelTitle length]) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:cancelAction];
        [alert addAction:cancel];
    }
    
    [navController presentViewController:alert animated:YES completion:completion];
}

+ (YuAlertViewController *)alertWithTitle:(NSString *)title
                                     message:(NSString *)message
                             textPlaceHolder:(NSString *)placeHolder
                                        text:(NSString *)text
                               textMaxLength:(NSInteger)maxInputLength
                                keyboardType:(UIKeyboardType)keyboardType
                                     okTitle:(NSString *)okTitle
                                    okAction:(void (^)(UIAlertAction * _Nonnull, NSString * _Nonnull))okAction
                                 cancelTitle:(NSString *)cancelTitle
                                cancelAction:(void (^)(UIAlertAction * _Nonnull))cancelAction
                                  completion:(void (^)(void))completion
{
    YuAlertViewController *alert = [YuAlertViewController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alert.maxInputLength = maxInputLength;
    
    WEAK(alert, walert);
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeHolder;
        textField.text = text;
        textField.font = YUCLOUD_SYSTEM_FONT_WITH_SIZE(FontSizeNormal);
        textField.keyboardType = keyboardType;
        
        if (walert.maxInputLength > 0) {
            walert.preContent = text;
            [[NSNotificationCenter defaultCenter] addObserver:walert
                                                     selector:@selector(textFieldTextDidChangeNotification:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:textField];
        }
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:okTitle
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   UITextField *textField = [alert.textFields firstObject];
                                                   
                                                   okAction(action, textField.text);
                                               }];
    [alert addAction:ok];
    
    if ([cancelTitle length]) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alert addAction:cancel];
    }
    
    return alert;
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    
    NSString *lang = [[textField textInputMode] primaryLanguage];
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *marked = [textField markedTextRange];
        if (marked) {
            //正在拼音输入中，
            return;
        }
    }
    
    if (self.maxInputLength > 0 && [textField.text length] > self.maxInputLength) {
        textField.text = self.preContent;
        
        [[[AFViewShaker alloc] initWithView:textField] shakeWithDuration:0.5 completion:nil];
        return;
    }
    
    self.preContent = textField.text;
}


@end
