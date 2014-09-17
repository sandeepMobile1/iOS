//
//  SAServiceAsyncInvocation.m
//  SmackTalk360
//
//  Created by octal i-phone2 on 5/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import "SAServiceAsyncInvocation.h"
#import "Config.h"

const NSString* const kResponseKey = @"response";
const NSString* const kDescriptionKey = @"description";
const NSString* const kMessageKey = @"message";
const NSString* const kIdKey =  @"id";
const NSString* const kStatusKey = @"status";

#define kDefaultClientVersionHeaderName @"SA-Client-Version"
#define kServiceDomain @"service"
#define kOperationFailed @"Operation Failed"

ISO8601DateFormatter* gJSONTimeFormatter = nil;
NSDateFormatter* gJSONDateFormatter = nil;
@implementation JSON
+(ISO8601DateFormatter*)timeFormatter {
	if (!gJSONTimeFormatter) {
		gJSONTimeFormatter = [[ISO8601DateFormatter alloc] init];
		[gJSONTimeFormatter setIncludeTime:YES];
		[gJSONTimeFormatter setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	return gJSONTimeFormatter;
}
+(NSDateFormatter*)dateFormatter {
	if (!gJSONDateFormatter) {
		gJSONDateFormatter = [[NSDateFormatter alloc] init];
		[gJSONDateFormatter setDateFormat:@"yyyy-MM-dd"];
	}
	return gJSONDateFormatter;
}
+(NSDate*)dateFromTimeString:(NSString*)string {
	return [[JSON timeFormatter] dateFromString:string];
}
+(NSDate*)dateFromDateString:(NSString*)string {
	return [[JSON dateFormatter] dateFromString:string];
}
+(NSString*)dateString:(NSDate*)date {
	return [[JSON dateFormatter] stringFromDate:date];
}
+(NSString*)timeString:(NSDate*)time {
	return [[JSON timeFormatter] stringFromDate:time];
}
+(NSString*)uuid {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString* uuidstr = [(NSString*)CFUUIDCreateString(NULL, uuid) autorelease];
	CFRelease(uuid);
	return uuidstr;
}
@end

@interface SAServiceAsyncInvocation (private) 
-(void)addHeaders:(NSMutableURLRequest*)request;
@end

@implementation SAServiceAsyncInvocation
@synthesize store = _store;
@synthesize finalizer = _finalizer;
@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize key = _key;
@synthesize clientVersion = _clientVersion;
@synthesize clientVersionHeaderName = _clientVersionHeaderName;
@synthesize apiKey = _apiKey;
@synthesize deviceIdentifier = _deviceIdentifier;
@synthesize timestamp = _timestamp;
@synthesize response = _response;
@synthesize receivedData = _receivedData;

+(BOOL)isOk:(NSNumber *)statusCode {
	return 200 <= [statusCode intValue] && [statusCode intValue] <= 299;
}

+(NSDictionary*) responseFromJSONDictionary:(NSDictionary*)resultsd error:(NSError**)error {
	if (error) {
		*error = Nil;
	}
	
	NSDictionary *statusd = [resultsd objectForKey:kStatusKey];
	
	if (statusd) {
		NSNumber *statusCode = [statusd objectForKey:kIdKey];
		if (![SAServiceAsyncInvocation isOk:statusCode]) {
			NSMutableDictionary *userInfo = [[[NSMutableDictionary alloc] init] autorelease];
			NSString* message = [statusd objectForKey:kMessageKey];
			if (!message) {
				message = @""; // we should never get to this but setting it to empty string
				// so that the following code doesn't crash.
			}
			[userInfo setObject:message forKey:kMessageKey];
			
            
			// known error
			if (error) {
				*error = [NSError errorWithDomain:kServiceDomain 
                                             code:[statusCode intValue]
                                         userInfo:[NSDictionary dictionaryWithObject:[statusd objectForKey:kMessageKey] forKey:kMessageKey]];
			}
			return Nil;
		}
		
		NSDictionary *responsed = [resultsd objectForKey:kResponseKey];
		return responsed;
	}
	
	if (error) {
		*error = [NSError errorWithDomain:kServiceDomain
                                     code:500 
                                 userInfo:[NSDictionary dictionaryWithObject:kOperationFailed forKey:kMessageKey]];
	}
	return Nil;
}

-(id)init {
	
	self = [super init];
	[self setKey:[JSON uuid]];
	[self setTimestamp:[NSDate date]];
	_receivedData = [[NSMutableData alloc] initWithLength:0];
	return self;
}

-(id)retain {
	
	return [super retain];
}

-(void)dealloc {
	
    [_context release]; _context = nil;
	[_key release];
	[_apiKey release];
	[_timestamp release];
	[_response release];
	[_receivedData release];
	[super dealloc];
}

/*-(NSString*)udid {
	return [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
}*/

-(BOOL)isReady {
	return YES;
}

-(void)invoke { }

-(void)get:(NSString*)path {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url = [NSMutableString stringWithFormat:@"%@%@", WebserviceUrl,path];
	
    NSLog(@"%@",url);
    
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
	[self addHeaders:request];
	[NSURLConnection connectionWithRequest:request delegate:self];
	[pool release];
}

-(void)execute:(NSString*)method path:(NSString*)path body:(NSString*)body {
	
    NSLog(@"Body------------------------:%@",body);
    
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
	NSString* url = [NSMutableString stringWithFormat:@"%@%@",WebserviceUrl,path];
    
    NSLog(@"%@",url);
    
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:method];
	NSData *data = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
	[request setHTTPBody:data];
    
	[NSURLConnection connectionWithRequest:request delegate:self];
    
	
	[pool release];
}


-(void)post:(NSString*)path body:(NSString*)body {
	
    [self execute:@"POST" path:path body:body];
}

-(void)put:(NSString*)path body:(NSString*)body {
	[self execute:@"PUT"  path:path body:body];
}

-(void)addHeaders:(NSMutableURLRequest*)request {
    if (_clientVersion) {
		NSString* headerName = _clientVersionHeaderName;
		if (!headerName) {
			headerName = kDefaultClientVersionHeaderName;
		}
        
        
        [request setValue:_clientVersion forHTTPHeaderField:headerName];
    }
	//[request setValue:[ISUser currentDeviceId] forHTTPHeaderField:@"IS-Device-ID"];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
	
    NSLog(@"didReceiveResponse");
    
	[self setResponse:(NSHTTPURLResponse*)response];
	
	if (![[self response] isOK]) {
		[self handleHttpError:[[self response] statusCode]];
		[self.finalizer finalize:self]; // Move this outside the if-block?
	}
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
	
    NSLog(@"didReceiveData");
	if ([_response isOK]) {
		[_receivedData appendData:data];
	}
}

-(BOOL)handleHttpError:(NSInteger)code { 
	// Override to handle gracefully
    return YES;
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
	
    NSLog(@"%@",[error description]);
    
	[self handleHttpError:[[self response] statusCode]];
	//[self.finalizer finalize:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	
    NSLog(@"connectionDidFinishLoading");

    BOOL finalize = YES;
	if ([[self response] isOK]) {
		finalize = [self handleHttpOK:self.receivedData];
	} else {
		finalize = [self handleHttpError:[[self response] statusCode]];
	}
    if (finalize) {
        // [self.finalizer finalize:self];
    }
}

-(BOOL)handleHttpOK:(NSMutableData*)data {
	// Override to handle gracefully
    return YES;
}

-(void)setObject:(id)object forKey:(NSString*)key {
    if (!_context) {
        _context = [[NSMutableDictionary alloc] init];
    }
    [_context setObject:object forKey:key];
}

-(id)objectForKey:(NSString*)key {
    return [_context objectForKey:key];
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
@end
