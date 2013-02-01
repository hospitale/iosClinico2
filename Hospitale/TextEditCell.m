//
//  TextEditCell.m
//  Hospitale
//
//  Created by AeC on 2/1/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "TextEditCell.h"

@implementation TextEditCell
@synthesize textLabel2 = _textLabel2;
@synthesize textEdit2 = _textEdit2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
