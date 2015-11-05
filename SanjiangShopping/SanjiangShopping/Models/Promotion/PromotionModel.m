//
//  PromotionModel.m
//  SanjiangShop
//
//  Created by 薛纪杰 on 15/8/31.
//  Copyright (c) 2015年 薛纪杰. All rights reserved.
//

#import "PromotionModel.h"
#import "NetworkConstant.h"
#import "XSAPIManager.h"

#import <MJExtension.h>

@implementation PromotionItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [PromotionItemModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"itemID": @"id"
                     };
        }];
    }
    return self;
}

@end

@implementation PromotionDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [PromotionDataModel setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list": [PromotionItemModel class]
                     };
        }];
    }
    return self;
}

@end

@implementation PromotionModel

#pragma mark - private methods
- (void)loadPromotionSuccess:(SuccessPromotionBlock)success Failure:(FailurePromotionBlock)failure {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@:%@%@", PROTOCOL, SERVICE_ADDRESS, DEFAULT_PORT, ROUTER_PROMOTION];
    XSAPIManager *manager = [XSAPIManager manager];
    
    __weak typeof(self) weakSelf = self;
    
    [manager GET:urlStr parameters:nil success:^(id responseObject) {
        PromotionModel *model = [PromotionModel objectWithKeyValues:responseObject];
        weakSelf.data         = model.data;
        weakSelf.code         = model.code;
        weakSelf.codeMessage  = model.codeMessage;
        
        success();
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
