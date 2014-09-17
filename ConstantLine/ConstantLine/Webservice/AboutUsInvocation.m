//
//  AboutUsInvocation.m
//  ConstantLine
//
//  Created by Shweta Sharma on 29/01/14.
//
//

#import "AboutUsInvocation.h"
#import "Config.h"

@implementation AboutUsInvocation

-(void)invoke {
	NSString *a= @"home_message";
	[self post:a body:[self body]];
}

-(NSString*)body {
	
    
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init]autorelease];
    
    NSLog(@"Request: %@",bodyD);
    
    return [bodyD JSONRepresentation];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
	
    NSLog(@"Noice Web Service:(1)-------------->%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
	
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]autorelease] JSONValue];
    
	NSError* error = Nil;
    
    NSDictionary *responseDic=[resultsd objectForKey:@"Home"];
	
    [self.delegate AboutUsInvocationDidFinish:self withResults:responseDic  withMessages:[responseDic objectForKey:@"error"]  withError:error];
	
	return YES;
	
	
	
}

-(BOOL)handleHttpError:(NSInteger)code {
    moveTabG=FALSE;
    
	
    [self.delegate AboutUsInvocationDidFinish:self
                                     withResults:Nil
                                    withMessages:Nil
                                       withError:[NSError errorWithDomain:@"UserId"
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to register. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
