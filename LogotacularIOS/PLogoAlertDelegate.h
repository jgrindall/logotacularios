//
//  PLogoAlertDelegate.h
//  LogotacularIOS
//
//  Created by John on 07/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLogoAlertDelegate <NSObject>

- (void) clickButtonAt:(NSInteger)i withPayload:(id)payload;

@end
