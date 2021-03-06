//
//  AlertManager.h
//  LogotacularIOS
//
//  Created by John on 07/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLogoAlertDelegate.h"
#import "AContainerViewController_Protected.h"
#import "AbstractOverlayController.h"

@interface AlertManager : NSObject

+ (AbstractOverlayController*) addAlert:(Class) class intoController:(AContainerViewController*) controller withDelegate:(id<PLogoAlertDelegate>)delegate withOptions:(id)options;
+ (void) removeAlert;

@end
