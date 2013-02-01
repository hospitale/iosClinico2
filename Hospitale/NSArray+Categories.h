//
//  NSArray+Categories.h
//  Hospitale
//
//  Created by AeC on 2/1/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Categories)
-(int)CountValuesForKey:(NSString*)key withValue:(NSString*)value;
-(int)CountDistinctValuesForKey:(NSString*)key;

@end
