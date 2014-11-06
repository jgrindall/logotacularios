//
//  ConcreteClass.m
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Logger.h"

@implementation Logger

bool doLog = true;

- (void) log:(id) message{
	if(doLog){
		NSLog(@"LOG %@", message);
	}
}

@end
