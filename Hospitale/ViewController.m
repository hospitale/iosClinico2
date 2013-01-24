//
//  ViewController.m
//  Hospitale
//
//  Created by Developer on 1/23/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "ItemsViewController.h"
#import <Foundation/NSURLConnection.h>
#import <Foundation/NSURLAuthenticationChallenge.h>

@interface ViewController () <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property BOOL ErrorAlreadyDisplayed;
@property int erroCount;
@end

@implementation ViewController

@synthesize responseData = _responseData;
@synthesize data = _data;
@synthesize ErrorAlreadyDisplayed;
@synthesize erroCount;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Segue Itens"]){
        ((ItemsViewController*)segue.destinationViewController).Data = self.data;
    }
}

- (IBAction)btnTestClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://192.168.100.197/testeIos/Service1.svc/GetAnotherData"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if(connection) {
        self.responseData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"connection failed");
    }

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
                                                credentialWithUser:@"GRUPO_A&C\\rafael.bertholdo"
                                                password:@"P@ssw0rd01*"
                                                persistence:NSURLCredentialPersistenceNone]
                    forAuthenticationChallenge:challenge];
        }
        else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    
    NSString* stringData = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@",stringData);
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *keys = [jsonObjects allKeys];
    
    // values in foreach loop
    for (NSString *key in keys) {
        self.data = [jsonObjects objectForKey:key];
        
        [self performSegueWithIdentifier:@"Segue Itens" sender: self];
        break;
        /*
        for(id arrayItem in item)
        {
            NSLog(@"Id: %@ is %@",[arrayItem objectForKey:@"Key"], [arrayItem objectForKey:@"Value"]);
        }
         */
     }
 
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection error");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection success");
}

@end
