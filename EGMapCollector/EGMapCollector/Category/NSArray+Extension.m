//
//  NSArray+Extension.m
//  GFlight
//
//  Created by EG on 16/10/26.
//  Copyright © 2016年 GDU. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)



-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *msr = [NSMutableString string];
    [msr appendString:@"["];
    for (id obj in self) {
        [msr appendFormat:@"\n\t%@,",obj];
    }
    //去掉最后一个逗号（,）
    if ([msr hasSuffix:@","]) {
        NSString *str = [msr substringToIndex:msr.length - 1];
        msr = [NSMutableString stringWithString:str];
    }
    [msr appendString:@"\n]"];
    return msr;
}


@end
