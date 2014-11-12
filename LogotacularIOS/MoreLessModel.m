//
//  MoreLessModel.m
//  LogotacularIOS
//
//  Created by John on 12/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MoreLessModel.h"

@implementation MoreLessModel

NSString* const MORE_SHOWN = @"moreshown";

-(void) setDefaults{
	[super setDefaults];
	[self reset];
}

- (void) reset{
	[self.propHash setValue:[NSNumber numberWithBool:NO] forKey:MORE_SHOWN];
}

- (NSArray*) getKeys{
	return [NSArray arrayWithObjects:MORE_SHOWN, nil];
}

@end
