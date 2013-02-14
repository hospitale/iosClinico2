//
//  CustomDatePicker.m
//  Hospitale
//
//  Created by Rafael on 2/14/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "CustomDatePicker.h"

@implementation CustomDatePicker

@synthesize btnCancelar;
@synthesize btnOk;
@synthesize datePicker;
@synthesize action;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
