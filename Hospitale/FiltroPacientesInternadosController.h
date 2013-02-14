//
//  FiltroPacientesInternadosController.h
//  Hospitale
//
//  Created by AeC on 1/31/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroPacientesInterdados.h"

@interface FiltroPacientesInternadosController : UITableViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>{
    UITextField *currentEditingField;
}
@property (nonatomic,strong) FiltroPacientesInterdados* filtroPacientesInternados;


@end

