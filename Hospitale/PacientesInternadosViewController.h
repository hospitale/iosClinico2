//
//  PacientesInternadosViewController.h
//  Hospitale
//
//  Created by Rafael on 1/29/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroPacientesInterdados.h"
@interface PacientesInternadosViewController : UITableViewController
@property (nonatomic,weak) FiltroPacientesInterdados* filtro;
@end
