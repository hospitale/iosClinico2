//
//  URLConnectionDelegate.h
//  Hospitale
//
//  Created by AeC on 1/25/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConnectionDelegate : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
-(id) initWithURL:(NSString*) URL;
-(void) post:(NSString *)content withCallBack:(void (^)(NSURLResponse *, id )) callBack;

@end
