//
//  LoginController.h
//  Hospitale
//
//  Created by Rafael on 1/30/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic,weak) UITextField* textUsername;
@property (nonatomic,weak) UITextField* textPassword;
@property (nonatomic,weak) UIButton* buttonLogin;
@end
