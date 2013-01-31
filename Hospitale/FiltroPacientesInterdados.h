//
//  FiltroPacientesInterdados.h
//  Hospitale
//
//  Created by AeC on 1/31/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FiltroPacientesInterdados : NSObject
@property (nonatomic) int codigoEspecialidade;
@property (nonatomic,strong) NSString* nomeEspecialidade;
@property (nonatomic,strong) NSDate* dataInicial;
@property (nonatomic,strong) NSDate* dataFinal;
@property (nonatomic) int codigoPaciente;
@property (nonatomic,strong) NSString* nomePaciente;
@property (nonatomic) int codigoMedico;
@property (nonatomic,strong) NSString* nomeMedico;
@property (nonatomic) int codigoUnidadeOrganizacional;
@property (nonatomic,strong) NSString* nomeUnidadeOrganizacional;
@property (nonatomic) int operacao;
@end
