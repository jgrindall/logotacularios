//
//  TestProtocol.h
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLogger <NSObject>

- (void) log:(id) message;

@end
