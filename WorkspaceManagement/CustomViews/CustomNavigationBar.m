//
//  CustomNavigationBar.m
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation UINavigationBar (customNav)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(414,70);
    return newSize;
}

@end
