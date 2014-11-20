//
//  BgModel.m
//  LogotacularIOS
//
//  Created by John on 20/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BgModel.h"
#import <UIKit/UIKit.h>
#import "Colors.h"

@implementation BgModel

NSString* const BG_COLOR = @"bgcolor";

- (void) reset{
	[self setDefaults];
}

- (void) setDefaults{
	NSString* c = [Colors getDark:0];
	[self setVal:c forKey:BG_COLOR];
}

- (NSArray*) getKeys{
	return @[BG_COLOR];
}

@end

