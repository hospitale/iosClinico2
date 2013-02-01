//
//  NSArray+Categories.m
//  Hospitale
//
//  Created by AeC on 2/1/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "NSArray+Categories.h"

@implementation NSArray (Categories)
-(int)CountValuesForKey:(NSString*)key withValue:(NSString*)value {
    int count = 0;
    for(NSDictionary* dictionary in self){
        if ([[dictionary objectForKey:key] isEqualToString:value])
            count++;
        else if (count > 0)
            break;
    }
    return count;
}
-(int)CountDistinctValuesForKey:(NSString*)key {
    int count = 0;
    NSString* oldValue;
    for(NSDictionary* dictionary in self){
        NSString* currentValue = [dictionary objectForKey:key];
        if (![currentValue isEqualToString:oldValue]){
            oldValue = currentValue;
            count++;
        }
    }
    return count;
}
@end
