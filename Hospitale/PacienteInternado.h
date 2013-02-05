//
//  PacienteInternado.h
//  Hospitale
//
//  Created by Rafael on 2/5/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PacienteInternado : NSObject
@property (nonatomic,strong) NSString* numeroLeito;
@property (nonatomic,strong) NSString* idAtendimento;
@property (nonatomic,strong) NSString* nomePaciente;
@property (nonatomic,strong) NSString* dataAtendimento;
@property (nonatomic,strong) NSString* nomeMedico;
@property (nonatomic,strong) NSString* nomeOperadora;
@property (nonatomic,strong) NSString* diagnostico;
@property (nonatomic,strong) NSString* idSolicitacao;
@property (nonatomic,strong) NSString* idEspecialidade;
@property (nonatomic,strong) NSString* nomeEspecialidade;
@property (nonatomic,strong) NSString* nomeUnidadeOrganizacional;

@end
