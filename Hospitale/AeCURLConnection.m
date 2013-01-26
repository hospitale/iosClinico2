//
//  URLConnectionDelegate.m
//  Hospitale
//
//  Created by AeC on 1/25/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "AeCURLConnection.h"
#import <Foundation/Foundation.h>

@interface AeCURLConnection()

@property BOOL ErrorAlreadyDisplayed;
@property int erroCount;

@end

@implementation AeCURLConnection

@synthesize ErrorAlreadyDisplayed;
@synthesize erroCount;

+ (id)request:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    return [[self alloc] initWithRequest:requestUrl
                            successBlock:successBlock errorBlock:errorBlock completeBlock:completeBlock];
}

+ (id)post:(NSString *)requestUrl withContent:(NSString*)content successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    return [[self alloc] initWithRequest:requestUrl withContent:content
                           successBlock:successBlock errorBlock:errorBlock completeBlock:completeBlock];
}


- (id)initWithRequest:(NSString *)requestUrl successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock completeBlock:(completeBlock_t) completeBlock
{
    
    if ((self=[super init])) {
        data_ = [[NSMutableData alloc] init];
        
        successBlock_ = [successBlock copy];
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    return self;
}


- (id) initWithRequest:(NSString *)requestUrl withContent:(NSString*)content successBlock:(successBlock_t)successBlock errorBlock:(errorBlock_t)errorBlock  completeBlock:(completeBlock_t) completeBlock
{
    if ((self=[super init])) {
        data_ = [[NSMutableData alloc] init];
        
        successBlock_ = [successBlock copy];
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSData* dataJsonRequest = [content dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:[NSString stringWithFormat:@"%d", [dataJsonRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: dataJsonRequest];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    return self;
}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"Failure count: %d",[challenge previousFailureCount]);
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:data_ options:NSJSONReadingMutableContainers error:nil];
    
    id key = [[jsonObjects allKeys] objectAtIndex:0];
    id jsonResult = [jsonObjects objectForKey:key];
    
    successBlock_(data_,jsonResult);
    completeBlock_();
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    errorBlock_(error);
    completeBlock_();
}


@end
