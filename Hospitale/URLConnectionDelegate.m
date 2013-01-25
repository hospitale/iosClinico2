//
//  URLConnectionDelegate.m
//  Hospitale
//
//  Created by AeC on 1/25/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "URLConnectionDelegate.h"
#import <Foundation/Foundation.h>

@interface URLConnectionDelegate()

@property (nonatomic,strong) NSURL* URL;
@property BOOL ErrorAlreadyDisplayed;
@property int erroCount;
@property (retain, nonatomic) NSMutableData *responseData;
@property (nonatomic, strong) NSArray* data;


@end

@implementation URLConnectionDelegate

@synthesize URL = _URL;
@synthesize ErrorAlreadyDisplayed;
@synthesize erroCount;

-(id) initWithURL:(NSString *)URL{
    self = [super init];
    
    self.URL = [NSURL URLWithString:URL];
    return self;
}

-(void) post:(NSString *)content withCallBack:(void (^)(NSURLResponse *, id )) callBack {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.URL];
    NSData* dataJsonRequest = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [dataJsonRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: dataJsonRequest];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    if(connection) {
        self.responseData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"connection failed");
    }
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
//        
//        if ([data length] > 0 && error == nil)
//        {
//            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            callBack(response,jsonData);
//        }
//        else if ([data length] == 0 && error == nil)
//            callBack(response,nil);
//        else if (error != nil && error.code == NSURLErrorTimedOut)
//            NSLog(@"Connection Timeout");
//        else if (error != nil)
//            NSLog(@"%@",error);
//    }];
}


-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"%d",[challenge previousFailureCount]);
    if([[[challenge protectionSpace] authenticationMethod] isEqual:NSURLAuthenticationMethodNTLM])
    {
        if([challenge previousFailureCount]>=1 && !ErrorAlreadyDisplayed)
        {
            erroCount++;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Incorrect Credentials"
                                                              message:@"You got your user/password wrong."
                                                             delegate:nil
                                                    cancelButtonTitle:@"I'll try again."
                                                    otherButtonTitles:nil];
            
            [message show];
            //            [textBoxPassword becomeFirstResponder];
            ErrorAlreadyDisplayed=YES;
            erroCount++;
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
        if (erroCount <= 3) {
            
            [[challenge sender]  useCredential:[NSURLCredential
                                                credentialWithUser:@""
                                                password:@"teste"
                                                persistence:NSURLCredentialPersistenceNone]
                    forAuthenticationChallenge:challenge];
        }
        else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    id jsonObjects = [NSJSONSerialization JSONObjectWithData: self.responseData options:NSJSONReadingMutableContainers error:nil];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    
//    NSString* stringData = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
//    NSLog(@"%@",stringData);
    
    
//    NSArray *keys = [jsonObjects allKeys];
//    
//    // values in foreach loop
//    for (NSString *key in keys) {
//        self.data = [jsonObjects objectForKey:key];
//        
//        break;
//        /*
//         for(id arrayItem in item)
//         {
//         NSLog(@"Id: %@ is %@",[arrayItem objectForKey:@"Key"], [arrayItem objectForKey:@"Value"]);
//         }
//         */
//    }
    
}


@end
