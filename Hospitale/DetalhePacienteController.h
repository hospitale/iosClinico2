//
//  DetalhePacienteController.h
//  Hospitale
//
//  Created by Rafael on 2/5/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PacienteInternado.h"

@interface DetalhePacienteController : UITableViewController
@property (nonatomic,strong) PacienteInternado* pacienteInternado;
@end
