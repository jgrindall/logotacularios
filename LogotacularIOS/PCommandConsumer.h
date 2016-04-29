//
//  PFileBrowserModel.h
//  LogotacularIOS
//
//  Created by John on 03/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PCommandConsumer

- (void)consume:(NSDictionary*) data;

@end
