//
//  ViewController.m
//  Hospitale
//
//  Created by Developer on 1/23/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "ViewController.h"
#import "ItemsViewController.h"
#import "AeCURLConnection.h"

@interface ViewController () 
@property id idUsuario;
@end

@implementation ViewController

@synthesize txtUsuario = _txtUsuario;
@synthesize txtSenha = _txtSenha;
@synthesize idUsuario = _idUsuario;

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
//    if([segue.identifier isEqualToString:@"Segue Itens"]){
//        ((ItemsViewController*)segue.destinationViewController).Data = self.data;
//    }
}

- (IBAction)btnTestClick:(id)sender {

    //Autentica o usuário
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* jsonRequest = [NSString stringWithFormat:@"{\"dto\":{\"Usuario\":\"%@\",\"Senha\":\"%@\"}}", self.txtUsuario.text, self.txtSenha.text];
    [AeCURLConnection post:@"http://hospitaleteste.aec.com.br/hospitaleintegrationservicesteste/seguranca/controleacesso.svc/RealizaLoginUsuario"
               withContent:jsonRequest successBlock:^(NSData *data, id jsonData) {
                   self.idUsuario = jsonData;
                   [self performSegueWithIdentifier:@"Segue Itens" sender: self];
               } errorBlock:^(NSError *error) {
                   NSLog(@"%@",error);
               } completeBlock:^{
                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               }];

}


@end
