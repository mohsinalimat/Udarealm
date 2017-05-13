//
//  ObjectProcessor.m
//  YuCloud
//
//  Created by 熊国锋 on 15/12/19.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import "ObjectProcessor.h"
#import "ContactInfo.h"
#import "AvatarImage.h"
#import "ParseInfo.h"
#import "CityInfo.h"
#import "ProvinceInfo.h"
#import <Contacts/Contacts.h>
#import "ContactParser.h"
#import "UIImage+YuCloud.h"
#import "PhoneRegionParseInterface.h"
#import "AppDelegate.h"


NSString *initContactData = @"initContactData";
NSString *parseContactData = @"parseContactData";


@interface ObjectProcessor ()


@end

@implementation ObjectProcessor

- (void)startSyncContact {
    DDLogDebug(@"ObjectProcessor start sync for: Contact");
    RLMResults *results = [ContactInfo objectsWhere:@"refCount == 1"];
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    for (ContactInfo *item in results) {
        item.refCount = 0;
    }
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)finishSyncContact {
    DDLogDebug(@"ObjectProcessor end sync for: Contact");
    RLMResults *results = [ContactInfo objectsWhere:@"refCount == 0"];
    
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        for (ContactInfo *item in results) {
            ProvinceInfo *province = [ProvinceInfo objectForPrimaryKey:item.province];
            province.usage -= item.usage;
            
            CityInfo *city = [CityInfo objectForPrimaryKey:item.city];
            city.usage -= item.usage;
        }
        [[RLMRealm defaultRealm] deleteObjects:results];
    }];
    
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        for (ProvinceInfo *item in [ProvinceInfo allObjects]) {
            if ([[ContactInfo objectsWhere:@"province == %@", item.province] count] == 0) {
                [[RLMRealm defaultRealm] deleteObject:item];
            }
        }
        
        for (CityInfo *item in [CityInfo allObjects]) {
            if ([[ContactInfo objectsWhere:@"city == %@", item.city] count] == 0) {
                [[RLMRealm defaultRealm] deleteObject:item];
            }
        }
    }];
}

- (void)main {
    
    while ([self.insertDataInfo count]) {
        id object = [self.insertDataInfo firstObject];
        [self.insertDataInfo removeObject:object];
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)object;
            if ([string isEqualToString:initContactData]) {
                [self startSyncContact];
                [self initContact];
                [self finishSyncContact];
                
                [self saveGroupDefaults];
            }
            else if ([string isEqualToString:parseContactData]) {
                [self parseContacts];
            }
        }
        else {
            NSAssert(NO, @"add your code here in method %s", __PRETTY_FUNCTION__);
        }
    }
    
    [self.delegate processDidFinished:self];
}

- (void)initContact {
    //首先取得授权
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status != CNAuthorizationStatusAuthorized) {
        DDLogError(@"Contacts not authorized!");
        return;
    }
    
    NSArray *keys = @[CNContactIdentifierKey, CNContactThumbnailImageDataKey,
                      CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,
                      CNContactNicknameKey, CNContactOrganizationNameKey];
    
    WEAK(self, wself);
    CNContactFetchRequest *requestCN = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    [[[CNContactStore alloc] init] enumerateContactsWithFetchRequest:requestCN
                                       error:nil
                                  usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                                      [[RLMRealm defaultRealm] beginWriteTransaction];
                                      for (CNLabeledValue *value in contact.phoneNumbers) {
                                          
                                          ContactInfo *info = [ContactInfo objectForPrimaryKey:value.identifier];
                                          
                                          if (!info) {
                                              info = [[ContactInfo alloc] initWithNumberId:value.identifier];
                                              [[RLMRealm defaultRealm] addObject:info];
                                              
                                              info.contact_id   = contact.identifier;
                                              
                                              float usage = 0;
                                              usage += ([contact.familyName length] > 0 || [contact.givenName length] > 0)?1:0;
                                              usage += ([contact.nickname length] > 0 || [contact.organizationName length] > 0)?.2:0;
                                              usage += [contact.thumbnailImageData length] > 0?.3:0;
                                              info.usage = usage;
                                          }
                                          
                                          NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
                                          name = [name length] != 0?name:contact.organizationName;
                                          
                                          info.name = [name length]?name:value.label;
                                          
                                          NSData *imageData = contact.thumbnailImageData;
                                          if (imageData) {
                                              if ([imageData length] != info.thumbnailImageSize) {
                                                  info.thumbnailImageSize = [imageData length];
                                                  info.thumbnailImageID = [wself saveImage:imageData];
                                              }
                                          }
                                          else {
                                              //此处可以生成一个头像，加一个字符
                                          }
                                          
                                          CNPhoneNumber *number = value.value;
                                          NSString *string = [number stringValue];
                                          
                                          if ([string containsString:@"+86"] || [string containsString:@"*86"]) {
                                              string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                                              string = [string stringByReplacingOccurrencesOfString:@"*86" withString:@""];
                                              
                                              if ([[string substringToIndex:3] isEqualToString:@"400"]) {
                                                  info.state = 2;
                                              }
                                              else if ([[string substringToIndex:3] isEqualToString:@"106"]) {
                                                  info.state = 2;
                                              }
                                              else if ([string characterAtIndex:0] > '1') {
                                                  string = [@"0" stringByAppendingString:string];
                                              }
                                          }
                                          
                                          for (NSInteger index = 0; index < [string length]; index++) {
                                              unichar c = [string characterAtIndex:index];
                                              if (c < '0' || c > '9') {
                                                  NSString *str = [[NSString alloc] initWithCharacters:&c length:1];
                                                  string = [string stringByReplacingOccurrencesOfString:str withString:@""];
                                                  index = 0;
                                              }
                                          }
                                          
                                          if ([string length] < 5) {
                                              [[RLMRealm defaultRealm] deleteObject:info];
                                              continue;
                                          }
                                          
                                          if (![info.number isEqualToString:string]) {
                                              //number updated
                                              info.state = 0;
                                              info.number = string;
                                          }
                                          
                                          info.refCount = 1;
                                      }
                                      [[RLMRealm defaultRealm] commitWriteTransaction];
                                  }];
}

- (NSString *)saveImage:(NSData *)imageData {
    NSString *md5 = [[CommPros sharedClient] md5OfData:imageData];
    if ([self imageExistsWithKey:md5]) {
        return md5;
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    CGSize size = image.size;
    UIImage *imageCornered = [image imageWithCornerRadius:size.width / 2 scale:1.0];
    
    AvatarImage *info = [[AvatarImage alloc] initWithKey:md5];
    info.imageData = UIImagePNGRepresentation(imageCornered);
    [[RLMRealm defaultRealm] addObject:info];
    
    return md5;
}

- (BOOL)imageExistsWithKey:(NSString *)key {
    AvatarImage *info = [AvatarImage objectForPrimaryKey:key];
    return info != nil;
}

- (void)saveGroupDefaults {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.viroyal.TodayExtensionSharingDefaults"];
    
    RLMResults *objects = [[ContactInfo objectsWhere:@"state == 1"] sortedResultsUsingKeyPath:@"usage" ascending:NO];
    NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:10];
    NSInteger index = 0;
    while (index < [objects count] && [contacts count] < MIN(32, [objects count])) {
        ContactInfo *contact = objects[index++];
        if ([contacts containsObject:contact.contact_id]) {
            continue;
        }
        [contacts insertObject:contact.contact_id atIndex:(NSUInteger)arc4random_uniform((uint32_t)[contacts count])];
    }
    
    [defaults setObject:[NSArray arrayWithArray:contacts] forKey:@"Contacts"];
    [defaults synchronize];
}

- (void)parseContacts {
    //1.查询所有需要匹配的号码
    RLMResults *results = [ContactInfo objectsWithPredicate:[NSPredicate predicateWithFormat:@"refCount == 1 && state == 0"]];
    
    //2.开始匹配
    [[RLMRealm defaultRealm] beginWriteTransaction];
    
    NSInteger count = 0;
    for (ContactInfo *item in results) {
        if ([item isInvalidated]) {
            continue;
        }
        
        if (item.state != 0) {
            continue;
        }
        
        if (count++ > 10) {
            count = 0;
            [[RLMRealm defaultRealm] commitWriteTransaction];
            [[RLMRealm defaultRealm] beginWriteTransaction];
        }
        
        if ([item.number length] >= 8) {
            //首先从数据库匹配
            ParseData *data = [self dbQueryForMobileCode:item.number];
            if (data) {
                [self updateWithParse:data updateParseData:NO];
            }
            else {
                NSRange range = [item.number rangeOfString:@"1"];
                if (range.location != 0) {
                    item.state = 2;
                    continue;
                }
                
                range = [item.number rangeOfString:@"106"];
                if (range.location == 0) {
                    item.state = 2;
                    continue;
                }
                
                //从网络匹配
                [self internetQueryForNumber:item.number
                                       block:^(BOOL success, ParseData * _Nullable data) {
                                           if (success) {
                                               [self updateWithParse:data updateParseData:YES];
                                           }
                                           else {
                                               item.state = 2;
                                           }
                                       }];
            }
        }
        else if ([item.number length] < 11) {
            item.state = 2;
        }
    }
    
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)updateWithParse:(ParseData *)data updateParseData:(BOOL)updateParseData {
    if (updateParseData) {
        //保存到匹配库
        ParseInfo *parse = [ParseInfo objectForPrimaryKey:data.mobileCode];
        if (!parse) {
            parse = [[ParseInfo alloc] initWithMobileCode:data.mobileCode];
            [[RLMRealm defaultRealm] addObject:parse];
            
            parse.province  = data.province;
            parse.city      = data.city;
            parse.cityCode  = data.cityCode;
            parse.zipCode   = data.zipCode;
            parse.opName    = data.opName;
        }
    }
    
    //更新匹配信息
    ProvinceInfo *province = [ProvinceInfo objectForPrimaryKey:data.province];
    if (!province) {
        province = [[ProvinceInfo alloc] initWithProvince:data.province];
        [[RLMRealm defaultRealm] addObject:province];
    }
    
    CityInfo *city = [CityInfo objectForPrimaryKey:data.city];
    if (!city) {
        city = [[CityInfo alloc] initWithCity:data.city];
        city.province = data.province;
        
        [[RLMRealm defaultRealm] addObject:city];
    }
    
    NSPredicate *predicate;
    if ([data.cityCode length]) {
        predicate = [NSPredicate predicateWithFormat:@"state != 1 && refCount == 1 && (number BEGINSWITH %@ || number BEGINSWITH %@)", data.mobileCode, data.cityCode];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"state != 1 && refCount == 1 && (number BEGINSWITH %@)", data.mobileCode];
    }
    
    RLMResults *results = [ContactInfo objectsWithPredicate:predicate];
    for (ContactInfo *item in results) {
        if ([item isInvalidated]) {
            continue;
        }
        
        item.province = data.province;
        item.city = data.city;
        item.state      = 1;
        
        city.usage += item.usage;
        province.usage += item.usage;
    }
}

- (void)internetQueryForNumber:(NSString *)number
                         block:(void (^)(BOOL success, ParseData * _Nullable data))block {
    
    number = [number stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    NSString *string = [NSString stringWithFormat:@"/v1/mobile/address/query?key=%@&phone=%@", @"131ef6baafdc9", number];
    NSURL *url = [NSURL URLWithString:string relativeToURL:[NSURL URLWithString:@"https://apicloud.mob.com/"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:10];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!error) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSNumber *retCode = object[@"retCode"];
        if ([retCode integerValue] == 200) {
            if (block) {
                NSDictionary *dic = object[@"result"];
                NSString *city = dic[@"city"];
                NSString *cityCode = dic[@"cityCode"];
                
                if ([cityCode isEqualToString:@"0974"]) {
                    city = @"海南藏族自治州";
                }
                else if ([cityCode isEqualToString:@"0979"]) {
                    city = @"海西蒙古族藏族自治州";
                }
                else if ([cityCode isEqualToString:@"0970"]) {
                    city = @"海北藏族自治州";
                }
                else if ([cityCode isEqualToString:@"0975"]) {
                    city = @"果洛藏族自治州";
                }
                else if ([cityCode isEqualToString:@"0941"]) {
                    city = @"甘南藏族自治州";
                }
                else if ([cityCode isEqualToString:@"0973"]) {
                    city = @"黄南藏族自治州";
                }
                
                ParseData *data = [[ParseData alloc] init];
                data.city       = city;
                data.province   = dic[@"province"];
                data.cityCode   = cityCode;
                data.mobileCode = dic[@"mobileNumber"];
                data.opName     = dic[@"operator"];
                data.zipCode    = dic[@"zipCode"];
                
                DDLogDebug(@"apicloud.mob.com return %@ %@", data.city, data.mobileCode);
                block(YES, data);
            }
            return;
        }
    }
    
    if (block) {
        block(NO, nil);
    }
}

- (ParseData *)dbQueryForMobileCode:(NSString *)number {
    NSString *mobileCode, *cityCode;
    if ([[number substringToIndex:1] isEqualToString:@"0"]) {
        cityCode = [number substringToIndex:4];
        NSArray *shortCode = @[@"010", @"020", @"021", @"023", @"024", @"025", @"027", @"028", @"029"];
        for (NSString *item in shortCode) {
            if ([cityCode containsString:item]) {
                cityCode = item;
                break;
            }
        }
    }
    else {
        mobileCode = [number substringToIndex:7];
    }
    
    ParseInfo *info;
    if (cityCode) {
        info = [[ParseInfo objectsWhere:@"cityCode == %@", cityCode] firstObject];
    }
    else {
        info = [ParseInfo objectForPrimaryKey:mobileCode];
    }
    
    if (info) {
        ParseData *data = [[ParseData alloc] initWithInfo:info];
        return data;
    }
    
    return nil;
}

- (void)dealloc {
}

- (NSMutableArray *)editDataInfo {
    if (_editDataInfo == nil) {
        _editDataInfo = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _editDataInfo;
}

- (NSMutableArray *)editMessageDataInfo {
    if (_editMessageDataInfo == nil) {
        _editMessageDataInfo = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _editMessageDataInfo;
}

- (NSMutableArray *)insertDataInfo {
    if (_insertDataInfo == nil) {
        _insertDataInfo = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _insertDataInfo;
}

- (NSMutableArray *)clearDataInfo {
    if (_clearDataInfo == nil) {
        _clearDataInfo = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _clearDataInfo;
}

- (NSMutableArray *)clearUnreadInfo {
    if (_clearUnreadInfo == nil) {
        _clearUnreadInfo = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _clearUnreadInfo;
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = [[NSUUID UUID] UUIDString];
    }
    
    return _identifier;
}

@end


