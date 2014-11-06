//
//  InjectionModule.m
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "InjectionModule.h"
#import "Logger.h"
#import "PLogger.h"
#import "CommandMap.h"
#import "PCommandMap.h"
#import "EventDispatcher.h"
#import "PEventDispatcher.h"
#import "Models.h"

@interface InjectionModule ()

@property id<PLogger> logger;
@property id<PEventDispatcher> eventDispatcher;
@property id<PCommandMap> commandMap;
@property id<PFileModel> fileModel;
@property id<PDrawingModel> drawingModel;
@property id<PLogoModel> logoModel;
@property id<PMenuModel> menuModel;
@property id<PLogoErrorModel> logoErrorModel;
@property id<PFileBrowserModel> browserModel;
@property id<PFileListModel> fileListModel;

@end

@implementation InjectionModule

- (void)configure {
	[self bindClasses];
}

- (void) bindClasses{
	[self bindUtils];
	[self bindCommandMap];
	[self bindEventDispatcher];
	[self bindModels];
}

- (void) bindUtils{
	self.logger = [[Logger alloc] init];
	[self bind:self.logger toProtocol:@protocol(PLogger)];
}

- (void) bindCommandMap{
	self.commandMap = [[CommandMap alloc] init];
	[self bind:self.commandMap toProtocol:@protocol(PCommandMap)];
}

- (void) bindEventDispatcher{
	self.eventDispatcher = [[EventDispatcher alloc] init];
	[self bind:self.eventDispatcher toProtocol:@protocol(PEventDispatcher)];
}

- (void) bindModels{
	self.fileModel = [[FileModel alloc] init];
	[self bind:self.fileModel toProtocol:@protocol(PFileModel)];
	self.drawingModel = [[DrawingModel alloc] init];
	[self bind:self.drawingModel toProtocol:@protocol(PDrawingModel)];
	self.logoModel = [[LogoModel alloc] init];
	[self bind:self.logoModel toProtocol:@protocol(PLogoModel)];
	self.menuModel = [[MenuModel alloc] init];
	[self bind:self.menuModel toProtocol:@protocol(PMenuModel)];
	self.logoErrorModel = [[LogoErrorModel alloc] init];
	[self bind:self.logoErrorModel toProtocol:@protocol(PLogoErrorModel)];
	self.browserModel = [[FileBrowserModel alloc] init];
	[self bind:self.browserModel toProtocol:@protocol(PFileBrowserModel)];
	self.fileListModel = [[FileListModel alloc] init];
	[self bind:self.fileListModel toProtocol:@protocol(PFileListModel)];
}

@end