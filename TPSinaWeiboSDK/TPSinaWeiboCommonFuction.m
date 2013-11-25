//
//  TPSinaWeiboCommonFuction.m
//  TPSinaWeiboSDK
//
//  Created by simon on 13-9-7.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPSinaWeiboCommonFuction.h"

@implementation TPSinaWeiboCommonFuction

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"])
            {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

@end
