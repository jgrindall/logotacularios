

#import "Colors.h"

@interface Colors ()

@property NSDictionary* dic;

@end

@implementation Colors

static NSMutableDictionary* _dic = nil;

+ (UIColor*) getColorForString:(NSString*)name{
	if(![Colors dictionary]){
		[Colors loadDic];
	}
	return [Colors dictionary][name];
}

+ (NSDictionary*) dictionary{
	return _dic;
}

+ (void) loadDic{
	_dic = [[NSMutableDictionary alloc] initWithDictionary:@{}];
	_dic[@"red"] = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
	_dic[@"green"] = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
	_dic[@"blue"] = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
	
	//'turquoise'/ 'turq'/ 'green'/ 'blue'/ 'purple'/ 'midnight'
	//'darkkturqoise'/ 'dkturq'/ 'dkturquoise'/ 'darkgreen'/ 'dkgreen'/
	//'yellow'/ 'carrot'/ 'orange'/ 'org'/ 'red'/ 'snow'/ 'gray'/ 'grey'/
	//'ltorange'/ 'lightorange'/ 'lightorg'/ 'ltorg'/ 'dkorange'/ 'darkorg'/
	//'dkorg'/ 'darkorange'/ 'terracotta'/ 'dkred'/ 'darkred'/ 'ltgray'/
	//'ltgrey'/ 'lightgray'/ 'lightgrey'/ 'darkgray'/ 'darkgrey'/ 'dkgrey'/
	//'dkgray'/ 'white'/ 'black'
}

@end

