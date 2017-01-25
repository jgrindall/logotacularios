//
//  ClickSaveAsCommand.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "EditGridClrCommand.h"
#import "SymmNotifications.h"
#import "POptionsModel.h"
#import "Colors.h"

@implementation EditGridClrCommand

- (void) execute:(id) payload{
	UIColor* c0 = [[self getOptionsModel] getVal:GRID_CLR];
	float newOpacity = [payload floatValue];
	CGFloat r = 0.0, g = 0.0, b = 0.0, a = 1.0;
	BOOL conv = [c0 getRed: &r green: &g blue: &b alpha: &a];
	if(conv && newOpacity >= 0 && newOpacity <= 1){
		c0 = [UIColor colorWithRed:r green:g blue:b alpha:newOpacity];
		[[self getOptionsModel] setVal:c0 forKey:GRID_CLR];
	}
}

- (id<POptionsModel>) getOptionsModel{
	return [[JSObjection defaultInjector] getObject:@protocol(POptionsModel)];
}

@end
