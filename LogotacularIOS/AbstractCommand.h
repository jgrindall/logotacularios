//
//  AbstractCommand.h
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractCommand : NSObject

- (void) execute:(id) payload;

@end
