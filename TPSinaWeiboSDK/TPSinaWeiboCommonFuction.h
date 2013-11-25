//
//  TPSinaWeiboCommonFuction.h
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPSinaWeiboCommonFuction : NSObject

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

@end
