//
//  ConstantLineServices.h
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginInvocation.h"
#import "RegistrationInvocation.h"
#import "SAService.h"
#import "ConstantLineInvocation.h"
#import "ForgotPasswordInvocation.h"
#import "UserProfileInvocation.h"
#import "ChatListInvocation.h"
#import "ChatDetailInvocation.h"
#import "ContactListInvocation.h"
#import "SendChatInvocation.h"
#import "AddContactListInvocation.h"
#import "DeleteContactInvocation.h"
#import "ExistingAppUsersListInvocation.h"
#import "AddGroupInvocation.h"
#import "EditIntroOfGroupInvocation.h"
#import "GroupDetailInvocation.h"
#import "ChangePasswordInvocation.h"
#import "ClearAllMessageInvocation.h"
#import "DeleteChatInvocation.h"
#import "DeleteGroupChatInvocation.h"
#import "CloseGroupInvocation.h"
#import "QuitGroupInvocation.h"
#import "FindGroupInvocation.h"
#import "AddRatingInvocation.h"
#import "KickOffMemberInvocation.h"
#import "UnpaidRevenueInvocation.h"
#import "LogOutInvocation.h"
#import "SendPhoneContactsInvocation.h"
#import "AcceptRejectFriendRequestInvocation.h"
#import "BlockInvocation.h"
#import "BlockListInvocation.h"
#import "FriendProfileInvocation.h"
#import "SendPhoneListInvocation.h"
#import "ResetBedgeInvocation.h"
#import "GroupMemberListInvocation.h"
#import "AddRatingOwnerInvocation.h"
#import "AcceptRejectChatInvocation.h"
#import "AcceptRejectGroupChatInvocation.h"
#import "ShareGroupInvocation.h"
#import "AddPrivillegeInvocation.h"
#import "ManageGroupListInvocation.h"
#import "JoinGroupInvocation.h"
#import "AcceptRejectOwnerRequestInvocation.h"
#import "ClearGroupMessageInvocation.h"
#import "RevenueInvocation.h"
#import "GroupTypeEditInvocation.h"
#import "ClearIndivisualChatInvocation.h"
#import "LatestGroupInvocation.h"
#import "SendCreditCardDetailInvocation.h"
#import "UnSubcribeInvocation.h"
#import "SpecialGroupJoinInvocation.h"
#import "AboutUsInvocation.h"
#import "FacebookLoginInvocation.h"
#import "NotificationSettingInvocation.h"
#import "FBLoginInvocation.h"
#import "UrlSchemeInvocation.h"
#import "QuitSpecialGroupInvocation.h"

@interface ConstantLineServices : SAService

-(void)RegistrationInvocation:(NSString *)email password:(NSString *)password dispName:(NSString *)dispName userName:(NSString *)userName gender:(NSString *)gender dob:(NSString *)dob phoneNo:(NSString *)phoneNo image:(NSString *)image delegate: (id<RegistrationInvocationDelegate>)delegate;

-(void)LoginInvocation:(NSString *)email password:(NSString *)password delegate: (id<LoginInvocationDelegate>)delegate;

-(void)FBLoginInvocation:(NSString *)email password:(NSString *)password delegate: (id<FBLoginInvocationDelegate>)delegate;

-(void)ForgotPasswordInvocation:(NSString *)email delegate: (id<ForgotPasswordInvocationDelegate>)delegate;

-(void)ChatListInvocation:(NSString *)userId searchString:(NSString*)searchString delegate: (id<ChatListInvocationDelegate>)delegate;

-(void)ContactListInvocation:(NSString *)userId delegate: (id<ContactListInvocationDelegate>)delegate;

-(void)ChatDetailInvocation:(NSString *)userId friendId:(NSString *)friendId lastmsgId:(NSString *)lastmsgId type:(NSString *)type groupType:(NSString *)groupType  groupId:(NSString *)groupId page:(NSString *)page delegate: (id<ChatDetailInvocationDelegate>)delegate;

-(void)SendChatInvocation:(NSString *)userId friendId:(NSString *)friendId message:(NSString *)message type:(NSString *)type imageName:(NSString *)imageName audioName:(NSString *)audioName namecardId:(NSString *)namecardId threadId:(NSString *)threadId groupId:(NSString *)groupId groupType:(NSString *)groupType publicPrivateType:(NSString *)publicPrivateType delegate: (id<SendChatInvocationDelegate>)delegate;

-(void)AddContactListInvocation:(NSString *)userId friendId:(NSString *)friendId intro:(NSString *)intro delegate: (id<AddContactListInvocationDelegate>)delegate;

-(void)DeleteContactInvocation:(NSString *)userId friendId:(NSString *)friendId delegate: (id<DeleteContactInvocationDelegate>)delegate;

-(void)ExistingAppUsersListInvocation:(NSString *)userId searchString:(NSString *)searchString delegate: (id<ExistingAppUsersListInvocationDelegate>)delegate;

-(void)EditIntroOfGroupInvocation:(NSString *)userId groupId:(NSString *)groupId intro:(NSString *)intro delegate: (id<EditIntroOfGroupInvocationDelegate>)delegate;

-(void)GroupDetailInvocation:(NSString *)userId groupId:(NSString *)groupId delegate: (id<GroupDetailInvocationDelegate>)delegate;

-(void)UserProfileInvocation:(NSString *)userId delegate: (id<UserProfileInvocationDelegate>)delegate;

-(void)ChangePasswordInvocation:(NSString *)userId oldPass:(NSString *)oldPass newPass:(NSString *)newPass delegate: (id<ChangePasswordInvocationDelegate>)delegate;

-(void)ClearAllMessageInvocation:(NSString *)userId delegate: (id<ClearAllMessageInvocationDelegate>)delegate;

-(void)ClearIndivisualChatInvocation:(NSString *)userId friendId:(NSString *)friendId delegate: (id<ClearIndivisualChatInvocationDelegate>)delegate;

-(void)DeleteChatInvocation:(NSString *)userId friendId:(NSString *)friendId messageId:(NSString *)messageId delegate: (id<DeleteChatInvocationDelegate>)delegate;

-(void)DeleteGroupChatInvocation:(NSString *)userId groupId:(NSString *)groupId messageId:(NSString *)messageId delegate: (id<DeleteGroupChatInvocationDelegate>)delegate;

-(void)CloseGroupInvocation:(NSString *)groupId groupStatus:(NSString *)groupStatus userId:(NSString *)userId threadId:(NSString *)threadId delegate: (id<CloseGroupInvocationDelegate>)delegate;

-(void)QuitGroupInvocation:(NSString *)userId groupId:(NSString *)groupId ownerId:(NSString *)ownerId type:(NSString *)type delegate: (id<QuitGroupInvocationDelegate>)delegate;

-(void)QuitSpecialGroupInvocation:(NSString *)userId groupId:(NSString *)groupId ownerId:(NSString *)ownerId type:(NSString *)type delegate: (id<QuitSpecialGroupInvocationDelegate>)delegate;


-(void)FindGroupInvocation:(NSString *)userId searchCriteria:(NSString *)searchCriteria pageString:(NSString *)pageString delegate: (id<FindGroupInvocationDelegate>)delegate;

-(void)AddRatingInvocation:(NSString *)userId groupId:(NSString *)groupId rating:(NSString *)rating delegate: (id<AddRatingInvocationDelegate>)delegate;

-(void)AddRatingOwnerInvocation:(NSString *)userId ownerId:(NSString *)ownerId rating:(NSString *)rating delegate: (id<AddRatingOwnerInvocationDelegate>)delegate;


-(void)KickOffMemberInvocation:(NSString *)userId friendId:(NSString *)friendId threadId:(NSString *)threadId groupId:(NSString *)groupId delegate: (id<KickOffMemberInvocationDelegate>)delegate;

-(void)UnpaidRevenueInvocation:(NSString *)userId delegate: (id<UnpaidRevenueInvocationDelegate>)delegate;

-(void)LogOutInvocation:(NSString*)userId deviceToken:(NSString *)deviceToken delegate: (id<LogOutInvocationDelegate>)delegate;

-(void)SendPhoneContactsInvocation:(NSString*)userId phoneList:(NSString *)phoneList  userName:(NSString *)userName delegate: (id<SendPhoneContactsInvocationDelegate>)delegate;

-(void)AcceptRejectFriendRequestInvocation:(NSString *)userId friendId:(NSString *)friendId type:(NSString *)type delegate: (id<AcceptRejectFriendRequestInvocationDelegate>)delegate;

-(void)AcceptRejectChatInvocation:(NSString *)userId friendId:(NSString *)friendId type:(NSString *)type delegate: (id<AcceptRejectChatInvocationDelegate>)delegate;

-(void)AcceptRejectGroupChatInvocation:(NSString *)userId groupId:(NSString *)groupId groupUserTableId:(NSString *)groupUserTableId groupOwnerId:(NSString *)groupOwnerId status:(NSString *)status delegate: (id<AcceptRejectGroupChatInvocationDelegate>)delegate;

-(void)BlockInvocation:(NSString*)userId friendId:(NSString *)friendId blockType:(NSString *)blockType delegate: (id<BlockInvocationDelegate>)delegate;

-(void)BlockListInvocation:(NSString *)userId delegate: (id<BlockListInvocationDelegate>)delegate;

-(void)FriendProfileInvocation:(NSString *)userId friendId:(NSString *)friendId delegate: (id<FriendProfileInvocationDelegate>)delegate;

-(void)SendPhoneListInvocation:(NSString *)userId phoneList:(NSString *)phoneList delegate: (id<SendPhoneListInvocationDelegate>)delegate;

-(void)ResetBedgeInvocation:(NSString*)userId delegate: (id<ResetBedgeInvocationDelegate>)delegate;

-(void)GroupMemberListInvocation:(NSString *)userId groupId:(NSString *)groupId delegate: (id<GroupMemberListInvocationDelegate>)delegate;

-(void)ShareGroupInvocation:(NSString *)userId groupId:(NSString *)groupId  friendId:(NSString *)friendId  groupCode:(NSString *)groupCode delegate: (id<ShareGroupInvocationDelegate>)delegate;

-(void)AddPrivillegeInvocation:(NSString *)ownerId groupId:(NSString *)groupId  friendId:(NSString *)friendId delegate: (id<AddPrivillegeInvocationDelegate>)delegate;

-(void)ManageGroupListInvocation:(NSString *)userId page:(NSString *)page searchText:(NSString *)searchText delegate: (id<ManageGroupListInvocationDelegate>)delegate;

-(void)JoinGroupInvocation:(NSString *)userId friendId:(NSString *)friendId groupId:(NSString *)groupId delegate: (id<JoinGroupInvocationDelegate>)delegate;

-(void)SpecialGroupJoinInvocation:(NSString *)userId friendId:(NSString *)friendId groupId:(NSString *)groupId delegate: (id<SpecialGroupJoinInvocationDelegate>)delegate;


-(void)AcceptRejectOwnerRequestInvocation:(NSString *)userId groupId:(NSString *)groupId memberId:(NSString *)memberId status:(NSString *)status messageId:(NSString *)messageId delegate: (id<AcceptRejectOwnerRequestInvocationDelegate>)delegate;

-(void)ClearGroupMessageInvocation:(NSString *)userId groupId:(NSString *)groupId delegate: (id<ClearGroupMessageInvocationDelegate>)delegate;

-(void)RevenueInvocation:(NSString *)userId groupId:(NSString *)groupId transactionId:(NSString *)transactionId subCharge:(NSString *)subCharge delegate: (id<RevenueInvocationDelegate>)delegate;

-(void)GroupTypeEditInvocation:(NSString *)userId groupId:(NSString *)groupId groupType:(NSString *)groupType delegate: (id<GroupTypeEditInvocationDelegate>)delegate;

-(void)LatestGroupInvocation:(NSString *)userId  page:(NSString *)page delegate: (id<LatestGroupInvocationDelegate>)delegate;

-(void)SendCreditCardDetailInvocation:(NSString *)userId cardname:(NSString *)cardname account_number:(NSString *)account_number card_type:(NSString *)card_type expiry_date:(NSString *)expiry_date crn_number:(NSString *)crn_number groupId:(NSString *)groupId delegate: (id<SendCreditCardDetailInvocationDelegate>)delegate;

-(void)UnSubcribeInvocation:(NSString *)userId groupId:(NSString *)groupId  transactionId:(NSString *)transactionId delegate: (id<UnSubcribeInvocationDelegate>)delegate;

-(void)AboutUsInvocation:(NSString *)userId delegate: (id<AboutUsInvocationDelegate>)delegate;

-(void)FacebookLoginInvocation:(NSString *)fbId email:(NSString *)email display_name:(NSString *)display_name dob:(NSString *)dob gender:(NSString *)gender image:(NSString *)image delegate: (id<FacebookLoginInvocationDelegate>)delegate;

-(void)NotificationSettingInvocation:(NSString *)userId notificationStatus:(NSString *)notificationStatus delegate: (id<NotificationSettingInvocationDelegate>)delegate;

-(void)UrlSchemeInvocation:(NSString *)userId groupCode:(NSString *)groupCode delegate: (id<UrlSchemeInvocationDelegate>)delegate;


@end
