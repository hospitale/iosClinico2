//
//  URLUtil.m
//  Hospitale
//
//  Created by Rafael on 2/6/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "URLUtil.h"

@implementation URLUtil
+(NSString*)getBackEndUrl{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"urlBackEnd"] == nil)
    {
        [defaults setObject:@"http://hospitaleteste.aec.com.br/hospitaleintegrationservicesteste/" forKey:@"urlBackEnd"];
        [defaults synchronize];
    }
    return (NSString*)[defaults objectForKey:@"urlBackEnd"];
}
@end
