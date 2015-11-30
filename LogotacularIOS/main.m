//
//  main.m
//  LogotacularIOS
//
//  Created by John on 26/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
	int retval;
	@autoreleasepool {
		@try{
			retval =  UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
		}
		@catch (NSException *exception)
		{
			NSLog(@"Gosh!!! %@", [exception callStackSymbols]);
			@throw;
		}
		return retval;
	}
}
