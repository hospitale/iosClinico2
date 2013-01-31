//
//  LoginController.m
//  Hospitale
//
//  Created by Rafael on 1/30/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "LoginController.h"
#import "AeCURLConnection.h"

@interface LoginController ()
@property int idUsuario;
@end

@implementation LoginController

@synthesize idUsuario = _idUsuario;
@synthesize textUsername = _textUsername;
@synthesize textPassword = _textPassword;
@synthesize buttonLogin = _buttonLogin;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // we aren't editing any fields yet, it will be in edit when the user touches an edit field
    self.editing = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width - 20, 40) ];
    
    UIButton *buttonLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonLogin.frame = footerView.frame;
    [buttonLogin setTitle:@"Login" forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(btnLogin_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonLogin = buttonLogin;
    [footerView addSubview:buttonLogin];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSUInteger row = [indexPath row];
    static NSString *kCellTextField_ID = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
    if (cell == nil)
    {
        // a new cell needs to be created
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellTextField_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    if(indexPath.section == 0)
    {
        if (row == 0)
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+10, cell.frame.origin.y +10,cell.frame.size.width -20, cell.frame.size.height-20)];
            textField.placeholder = @"Usuário";
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.delegate = self;
            textField.borderStyle = UITextBorderStyleNone;
            textField.tag = 1;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.textUsername = textField;
            [cell.contentView addSubview:textField];
        }
        else
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+10, cell.frame.origin.y +10,cell.frame.size.width -20, cell.frame.size.height-20)];
            textField.placeholder = @"Senha";
            textField.delegate = self;
            textField.borderStyle = UITextBorderStyleNone;
            textField.secureTextEntry = YES;
            textField.tag = 2;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.textPassword = textField;
            [cell.contentView addSubview:textField];
        }
        
    }

//    else
//    {
//        // a cell is being recycled, remove the old edit field (if it contains one of our tagged edit fields)
//        UIView *viewToCheck = nil;
//        viewToCheck = [cell.contentView viewWithTag:kViewTag];
//        if (viewToCheck)
//            [viewToCheck removeFromSuperview];
//    }

       return cell;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // the user pressed the "Done" button, so dismiss the keyboard
    //[textField resignFirstResponder];
    
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }    
    
    if(textField == self.textPassword)
    {        
        [self.buttonLogin sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
    return YES;
}


- (void)btnLogin_TouchUpInside:(id)sender {
    //Autentica o usuário
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* jsonRequest = [NSString stringWithFormat:@"{\"dto\":{\"Usuario\":\"%@\",\"Senha\":\"%@\"}}", self.textUsername.text, self.textPassword.text];
    [AeCURLConnection post:@"http://hospitaleteste.aec.com.br/hospitaleintegrationservicesteste/seguranca/controleacesso.svc/RealizaLoginUsuario"
               withContent:jsonRequest successBlock:^(NSData *data, id jsonData) {
                   if ([jsonData integerValue] != 0)
                   {
                       self.idUsuario = [jsonData integerValue];
                       [self performSegueWithIdentifier:@"Segue Itens" sender: self];
                   }
                   else
                   {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Autenticação"
                                                                       message:@"Usuário ou senha incorretos."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                       [alert show];
                       [self.textUsername becomeFirstResponder];
                   }
               } errorBlock:^(NSError *error) {
                   NSLog(@"%@",error);
               } completeBlock:^{
                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               }];

}

@end
