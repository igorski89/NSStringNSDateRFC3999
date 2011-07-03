//
//  NSString-dateFromRfc3999Value.m
//  NSDateNSStringRFC3999
//
//  Created by Igor Evsukov on 03.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import "NSString-dateFromRfc3999Value.h"


@implementation NSString (dateFromRfc3999Value)

- (NSDate*)dateFromRfc3999Value {

	static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
		NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:en_US_POSIX];
		//[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		[en_US_POSIX release];
    });
    
    
	// Process date
	NSDate *date = nil;
	NSString *RFC3339String = [self uppercaseString];
	RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
	// Remove colon in timezone as iOS 4+ NSDateFormatter breaks. See https://devforums.apple.com/thread/45837
	if (RFC3339String.length > 20) {
		RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
																 withString:@"" 
																	options:0
																	  range:NSMakeRange(20, RFC3339String.length-20)];
	}
	
	if (!date) { // 1996-12-19T16:39:57-0800
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27.87+0020
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possibly invalid format.", self);
	
	//NSLog(@"%s: %@ => %@",__PRETTY_FUNCTION__,RFC3339String,date);
	
	return date;
}

@end
