//
//  CustomDatePicker.h
//  Hospitale
//
//  Created by Rafael on 2/14/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePicker : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnOk;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancelar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLimparFiltro;
@property (nonatomic) SEL action;
@end
