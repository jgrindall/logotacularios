//
//  TurtleModel.m
//  LogotacularIOS
//
//  Created by John on 18/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TurtleModel.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TextLayout.h"

@implementation TurtleModel

NSString* const TURTLE_PEN_DOWN = @"turtle_pendown";
NSString* const TURTLE_COLOR = @"turtle_color";
NSString* const TURTLE_BG_COLOR = @"turtle_bgcolor";
NSString* const TURTLE_PEN_THICK = @"turtle_penthick";
NSString* const TURTLE_HEADING = @"turtle_angle";
NSString* const TURTLE_POS = @"turtle_pos";

- (void) setDefaults{
	[self setVal:@YES forKey:TURTLE_PEN_DOWN];
	[self setVal:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1] forKey:TURTLE_COLOR];
	[self setVal:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1] forKey:TURTLE_BG_COLOR];
	[self setVal:[NSNumber numberWithInteger:3] forKey:TURTLE_PEN_THICK];
	[self setVal:[NSNumber numberWithInteger:-90] forKey:TURTLE_HEADING];
	CGPoint centre = [self getCentre];
	[self setVal:[NSValue valueWithCGPoint:centre] forKey:TURTLE_POS];
}

- (CGPoint) getCentre{
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	UINavigationController* presenter = [delegate navigationController];
	CGSize size = presenter.view.frame.size;
	float visibleWidth = (1 - TEXT_WIDTH)*size.width;
	float fullWidth = size.width;
	float weighted = (2.0*visibleWidth + 1.0*fullWidth)/3.0;
	return CGPointMake(weighted/2.0, size.height/2.0);
}

- (void) reset{
	[self setDefaults];
}

- (void) home{
	[self setVal:[NSNumber numberWithInteger:-90] forKey:TURTLE_HEADING];
	CGPoint centre = [self getCentre];
	[self setVal:[NSValue valueWithCGPoint:centre] forKey:TURTLE_POS];
}

- (void) setxyWithX:(float) x andY:(float)y{
	CGPoint centre = [self getCentre];
	CGPoint p = CGPointMake(x + centre.x, -y + centre.y);
	[self setVal:[NSValue valueWithCGPoint:p] forKey:TURTLE_POS];
}

- (void) moveFdBy:(float) amount{
	float heading = [[self getVal:TURTLE_HEADING] floatValue];
	CGPoint p0 = [[self getVal:TURTLE_POS] CGPointValue];
	float newX = p0.x + cosf(heading * M_PI/180)*amount;
	float newY = p0.y + sinf(heading * M_PI/180)*amount;
	CGPoint p = CGPointMake(newX, newY);
	[self setVal:[NSValue valueWithCGPoint:p] forKey:TURTLE_POS];
}

- (void) rotateBy:(float) angle{
	NSNumber* angle0 = [self getVal:TURTLE_HEADING];
	float angle1 = angle + [angle0 floatValue];
	NSNumber* angle2 = [NSNumber numberWithFloat:angle1];
	[self setVal:angle2 forKey:TURTLE_HEADING];
}

- (NSArray*) getKeys{
	return @[TURTLE_PEN_DOWN, TURTLE_COLOR, TURTLE_BG_COLOR, TURTLE_PEN_THICK, TURTLE_HEADING];
}

@end
