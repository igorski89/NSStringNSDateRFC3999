//
//  NSDate-rfc3999StringValue.m
//  NSDateNSStringRFC3999
//
//  Created by Igor Evsukov on 03.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import "NSDate-rfc3999StringValue.h"


@implementation NSDate (rfc3999StringValue)

- (NSString*)rfc3999StringValue {
	static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
		//[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600]];
    });
	
	NSString *string = [dateFormatter stringFromDate:self];
	
    // because in iOS4 formatter is broken. https://devforums.apple.com/thread/45837
	string = [NSString stringWithFormat:@"%@:%@",[string substringToIndex:22],[string substringFromIndex:22]];
	
	//NSLog(@"%s: %@ => %@",__PRETTY_FUNCTION__,self,string);
	
	return string;	
}

@end
