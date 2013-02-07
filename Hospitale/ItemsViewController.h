//
//  ItemsViewController.h
//  Hospitale
//
//  Created by Developer on 1/23/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray* data;
@property (nonatomic,strong) NSArray* allData;
@property (nonatomic,weak) NSString* operacao;
@end
