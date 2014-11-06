//
//  DrawingObject.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileObject.h"
@implementation FileObject

- (id) init{
	self = [super init];
	if(self){
		_logo = @"";
	}
	return self;
}

- (NSString*) description{
	return [NSString stringWithFormat:@"logo obj %@ ", self.logo];
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.logo forKey:@"logo"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [super init];
	if(self){
		self.logo = (NSString*)[aDecoder decodeObjectForKey:@"logo"];
	}
	return self;
}

- (void) dealloc{
	self.logo = nil;
}

@end
