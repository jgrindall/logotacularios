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
NSString* const BG_IMAGE = @"bgimage";

- (void) reset{
	[self setDefaults];
}

- (void) setDefaults{
	NSString* c = [Colors getDark:@"main"];
	[self setVal:c forKey:BG_COLOR];
	[self setVal:nil forKey:BG_IMAGE];
}

- (NSArray*) getKeys{
	return @[BG_COLOR, BG_IMAGE];
}

@end

