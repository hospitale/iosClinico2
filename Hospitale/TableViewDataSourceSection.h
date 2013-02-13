//
//  SecaoItemFiltroPacientesInternados.h
//  Hospitale
//
//  Created by AeC on 2/8/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewDataSourceSection : NSObject
@property (nonatomic,strong) NSString* headerTitle;
@property (nonatomic,strong) UIView* footer;
@property (nonatomic,strong) NSArray* rows;
@end
