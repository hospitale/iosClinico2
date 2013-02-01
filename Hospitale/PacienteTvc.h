//
//  PatientCell.h
//  Hospitale
//
//  Created by Rafael on 1/29/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PacienteTvc: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPaciente;
@property (weak, nonatomic) IBOutlet UILabel *lblAtendimento;
@property (weak, nonatomic) IBOutlet UILabel *lblEndereco;

@end
