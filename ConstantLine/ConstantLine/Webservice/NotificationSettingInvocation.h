//
//  NotificationSettingInvocation.h
//  ConstantLine
//
//  Created by Shweta Sharma on 10/02/14.
//
//

#import "SAServiceAsyncInvocation.h"
#import "ConstantLineInvocation.h"

@class NotificationSettingInvocation;

@protocol NotificationSettingInvocationDelegate

-(void)NotificationSettingInvocationDidFinish:(NotificationSettingInvocation*)invocation
                        withResults:(NSString*)result
                       withMessages:(NSString*)msg
                          withError:(NSError*)error;

@end

@interface NotificationSettingInvocation : ConstantLineInvocation {
	
}

@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *notificationStatus;

-(NSString*)body;

@end
