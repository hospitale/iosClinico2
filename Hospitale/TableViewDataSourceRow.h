//
//  ItemFiltroPacientesInternados.h
//  Hospitale
//
//  Created by AeC on 2/8/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import <Foundation/Foundation.h>
enum Stereotype { Search = 1, Date = 2 };

@interface TableViewDataSourceRow : NSObject
@property (nonatomic,strong) NSString* text;
@property (nonatomic,weak) id detailText;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic) SEL action;
@property (nonatomic) enum Stereotype stereotype;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,strong) NSString* operation;
@property (nonatomic) BOOL selected;
@end
