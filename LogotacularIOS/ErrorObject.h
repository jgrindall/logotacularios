//
//  ErrorObject.h
//  LogotacularIOS
//
//  Created by John on 12/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorObject : NSObject

- (instancetype) initWithNSDictionary:(NSDictionary*) dic;

- (NSString*) getHumanMessage;

- (NSNumber*) getLine;

@end
