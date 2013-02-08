//
//  ItemFiltroPacientesInternados.h
//  Hospitale
//
//  Created by AeC on 2/8/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemFiltroPacientesInternados : NSObject
@property (nonatomic,strong) NSString* text;
@property (nonatomic,weak) id detailText;
@property (nonatomic) SEL* valueChanged;
@property (nonatomic,strong) NSString* stereotype;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,strong) NSString* operacao;
@end
