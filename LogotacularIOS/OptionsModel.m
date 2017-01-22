//
//  MenuModel.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//
// need to do this:  [NSUserDefaults.standardUserDefaults registerDefaults:userDefaultsDefaults];


#import "OptionsModel.h"
#import "Appearance.h"
#import "Colors.h"

@implementation OptionsModel

NSString* const GRID_TYPE = @"grid_type";
NSString* const GRID_CLR = @"grid_clr";
NSString* const FONT_SIZE = @"font_size";

NSInteger const MIN_FONT_SIZE =		12;
NSInteger const MAX_FONT_SIZE =		48;

- (void) setDefaults{
	NSInteger grid = [[NSUserDefaults standardUserDefaults] integerForKey:@"GridType"];
	NSInteger fs = [[NSUserDefaults standardUserDefaults] integerForKey:@"FontSize"];
	NSString* gridClr = [[NSUserDefaults standardUserDefaults] stringForKey:@"GridClr"];
	UIColor* clr = [Colors stringToClr:gridClr];
	[self setVal:[NSNumber numberWithInteger:grid] forKey:GRID_TYPE];
	if(clr){
		[self setVal:clr forKey:GRID_CLR];
	}
	if(!fs || fs < MIN_FONT_SIZE || fs > MAX_FONT_SIZE){
		fs = SYMM_FONT_SIZE_LOGO;
	}
	[self setVal:[NSNumber numberWithInteger:fs] forKey:FONT_SIZE];
}

- (NSArray*) getKeys{
	return @[GRID_TYPE, FONT_SIZE, GRID_CLR];
}

- (void) setVal:(id)val forKey:(NSString*)key{
	if([key isEqualToString:GRID_TYPE]){
		[super setVal:val forKey:key];
		[[NSUserDefaults standardUserDefaults] setInteger:[val integerValue] forKey:@"GridType"];
	}
	else if([key isEqualToString:GRID_CLR]){
		[super setVal:val forKey:key];
		[[NSUserDefaults standardUserDefaults] setObject:[Colors clrToString:val] forKey:@"GridClr"];
	}
	else if([key isEqualToString:FONT_SIZE]){
		float fval = [val floatValue];
		NSInteger intVal = (int)fval;
		if(intVal > MAX_FONT_SIZE){
			intVal = MAX_FONT_SIZE;
		}
		if(intVal < MIN_FONT_SIZE){
			intVal = MIN_FONT_SIZE;
		}
		[super setVal:val forKey:key];
		[[NSUserDefaults standardUserDefaults] setInteger:intVal forKey:@"FontSize"];
	}
}

@end
