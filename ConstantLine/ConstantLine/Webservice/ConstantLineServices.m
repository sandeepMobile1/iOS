//
//  ConstantLineServices.m
//  ConstantLine
//
//  Created by octal i-phone2 on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ConstantLineServices.h"

@implementation ConstantLineServices

-(void)RegistrationInvocation:(NSString *)email password:(NSString *)password dispName:(NSString *)dispName userName:(NSString *)userName gender:(NSString *)gender dob:(NSString *)dob phoneNo:(NSString *)phoneNo image:(NSString *)image delegate: (id<RegistrationInvocationDelegate>)delegate
{
    RegistrationInvocation *invocation = [[[RegistrationInvocation alloc] init] autorelease];
    invocation.email = email;
	invocation.userName = userName;
    invocation.password = password;
	invocation.dispName = dispName;
    invocation.image=image;
    invocation.gender = gender;
	invocation.phoneNo = phoneNo;
    invocation.dob=dob;
   	
    [self invoke:invocation withDelegate:delegate];
}

-(void)LoginInvocation:(NSString *)email password:(NSString *)password delegate: (id<LoginInvocationDelegate>)delegate
{
    LoginInvocation *invocation = [[[LoginInvocation alloc] init] autorelease];
    invocation.email = email;
    invocation.password = password;
    
    [self invoke:invocation withDelegate:delegate];

}
-(void)FBLoginInvocation:(NSString *)email password:(NSString *)password delegate: (id<FBLoginInvocationDelegate>)delegate
{
    FBLoginInvocation *invocation = [[[FBLoginInvocation alloc] init] autorelease];
    invocation.email = email;
    invocation.password = password;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)ForgotPasswordInvocation:(NSString *)email delegate: (id<ForgotPasswordInvocationDelegate>)delegate
{
    ForgotPasswordInvocation *invocation = [[[ForgotPasswordInvocation alloc] init] autorelease];
    invocation.emailId = email;
    
    [self invoke:invocation withDelegate:delegate];

}

-(void)ChatListInvocation:(NSString *)userId searchString:(NSString*)searchString delegate: (id<ChatListInvocationDelegate>)delegate
{
    ChatListInvocation *invocation = [[[ChatListInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.searchString=searchString;
    [self invoke:invocation withDelegate:delegate];
}

-(void)ContactListInvocation:(NSString *)userId delegate: (id<ContactListInvocationDelegate>)delegate
{
    ContactListInvocation *invocation = [[[ContactListInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    [self invoke:invocation withDelegate:delegate];

}

-(void)ChatDetailInvocation:(NSString *)userId friendId:(NSString *)friendId lastmsgId:(NSString *)lastmsgId  type:(NSString *)type groupType:(NSString *)groupType groupId:(NSString *)groupId page:(NSString *)page delegate: (id<ChatDetailInvocationDelegate>)delegate
{
    ChatDetailInvocation *invocation = [[[ChatDetailInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    invocation.lastMsg_id=lastmsgId;
    invocation.lastMsg_id=lastmsgId;
    invocation.type=type;
    invocation.groupType=groupType;
    invocation.groupId=groupId;
    invocation.page=page;
    
    [self invoke:invocation withDelegate:delegate];

}

-(void)SendChatInvocation:(NSString *)userId friendId:(NSString *)friendId message:(NSString *)message type:(NSString *)type imageName:(NSString *)imageName audioName:(NSString *)audioName namecardId:(NSString *)namecardId threadId:(NSString *)threadId groupId:(NSString *)groupId groupType:(NSString *)groupType publicPrivateType:(NSString *)publicPrivateType delegate: (id<SendChatInvocationDelegate>)delegate
{
    SendChatInvocation *invocation = [[[SendChatInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    invocation.message=message;
    invocation.type=type;
    invocation.imageName=imageName;
    invocation.audioName=audioName;
    invocation.namecardId=namecardId;
    invocation.threadId=threadId;
    invocation.groupType=groupType;
    invocation.groupId=groupId;
    invocation.publicPrivateType=publicPrivateType;

    [self invoke:invocation withDelegate:delegate];

}

-(void)AddContactListInvocation:(NSString *)userId friendId:(NSString *)friendId intro:(NSString *)intro delegate: (id<AddContactListInvocationDelegate>)delegate;
{
    AddContactListInvocation *invocation = [[[AddContactListInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    invocation.intro=intro;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)DeleteContactInvocation:(NSString *)userId friendId:(NSString *)friendId delegate: (id<DeleteContactInvocationDelegate>)delegate
{
    DeleteContactInvocation *invocation = [[[DeleteContactInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    
    [self invoke:invocation withDelegate:delegate];

}

-(void)ExistingAppUsersListInvocation:(NSString *)userId searchString:(NSString *)searchString delegate: (id<ExistingAppUsersListInvocationDelegate>)delegate
{
    ExistingAppUsersListInvocation *invocation = [[[ExistingAppUsersListInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.search_string=searchString;
    
    [self invoke:invocation withDelegate:delegate];

}

-(void)EditIntroOfGroupInvocation:(NSString *)userId groupId:(NSString *)groupId intro:(NSString *)intro delegate: (id<EditIntroOfGroupInvocationDelegate>)delegate
{
    EditIntroOfGroupInvocation *invocation = [[[EditIntroOfGroupInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.intro=intro;
    invocation.group_id=groupId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)GroupDetailInvocation:(NSString *)userId groupId:(NSString *)groupId delegate: (id<GroupDetailInvocationDelegate>)delegate
{
    GroupDetailInvocation *invocation = [[[GroupDetailInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.group_id=groupId;
    
    [self invoke:invocation withDelegate:delegate];
}


-(void)UserProfileInvocation:(NSString *)userId delegate: (id<UserProfileInvocationDelegate>)delegate
{
    UserProfileInvocation *invocation = [[[UserProfileInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    
    [self invoke:invocation withDelegate:delegate];

}

-(void)ChangePasswordInvocation:(NSString *)userId oldPass:(NSString *)oldPass newPass:(NSString *)newPass delegate: (id<ChangePasswordInvocationDelegate>)delegate
{
    ChangePasswordInvocation *invocation = [[[ChangePasswordInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.oPass=oldPass;
    invocation.nPass=newPass;

    [self invoke:invocation withDelegate:delegate];

}

-(void)ClearAllMessageInvocation:(NSString *)userId delegate: (id<ClearAllMessageInvocationDelegate>)delegate
{
    ClearAllMessageInvocation *invocation = [[[ClearAllMessageInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)ClearIndivisualChatInvocation:(NSString *)userId friendId:(NSString *)friendId delegate: (id<ClearIndivisualChatInvocationDelegate>)delegate;
{
    ClearIndivisualChatInvocation *invocation = [[[ClearIndivisualChatInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id = friendId;

    [self invoke:invocation withDelegate:delegate];
}
-(void)DeleteChatInvocation:(NSString *)userId friendId:(NSString *)friendId messageId:(NSString *)messageId delegate: (id<DeleteChatInvocationDelegate>)delegate
{
    DeleteChatInvocation *invocation = [[[DeleteChatInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.message_id=messageId;
    invocation.friend_id=friendId;
    [self invoke:invocation withDelegate:delegate];

}

-(void)DeleteGroupChatInvocation:(NSString *)userId groupId:(NSString *)groupId messageId:(NSString *)messageId delegate: (id<DeleteGroupChatInvocationDelegate>)delegate
{
    DeleteGroupChatInvocation *invocation = [[[DeleteGroupChatInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.message_id=messageId;
    invocation.group_id=groupId;
    [self invoke:invocation withDelegate:delegate];

}

-(void)CloseGroupInvocation:(NSString *)groupId groupStatus:(NSString *)groupStatus userId:(NSString *)userId threadId:(NSString *)threadId delegate: (id<CloseGroupInvocationDelegate>)delegate
{
    CloseGroupInvocation *invocation = [[[CloseGroupInvocation alloc] init] autorelease];
    invocation.group_id=groupId;
    invocation.group_status=groupStatus;
    invocation.user_id=userId;
    invocation.thread_id=threadId;
    
    [self invoke:invocation withDelegate:delegate];
    
}

-(void)QuitGroupInvocation:(NSString *)userId groupId:(NSString *)groupId ownerId:(NSString *)ownerId type:(NSString *)type delegate: (id<QuitGroupInvocationDelegate>)delegate
{
    QuitGroupInvocation *invocation = [[[QuitGroupInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.group_id=groupId;
    invocation.owner_id=ownerId;
    invocation.type=type;
    
    [self invoke:invocation withDelegate:delegate];

}
-(void)QuitSpecialGroupInvocation:(NSString *)userId groupId:(NSString *)groupId ownerId:(NSString *)ownerId type:(NSString *)type delegate: (id<QuitSpecialGroupInvocationDelegate>)delegate
{
    QuitSpecialGroupInvocation *invocation = [[[QuitSpecialGroupInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.group_id=groupId;
    invocation.owner_id=ownerId;
    invocation.type=type;
    
    [self invoke:invocation withDelegate:delegate];

}


-(void)FindGroupInvocation:(NSString *)userId searchCriteria:(NSString *)searchCriteria pageString:(NSString *)pageString delegate: (id<FindGroupInvocationDelegate>)delegate
{
    FindGroupInvocation *invocation = [[[FindGroupInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.searchCriteria=searchCriteria;
    invocation.pageString=pageString;
    [self invoke:invocation withDelegate:delegate];

}

-(void)AddRatingInvocation:(NSString *)userId groupId:(NSString *)groupId rating:(NSString *)rating delegate: (id<AddRatingInvocationDelegate>)delegate
{
    AddRatingInvocation *invocation = [[[AddRatingInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.rating=rating;
    invocation.group_id=groupId;
    [self invoke:invocation withDelegate:delegate];
    

}
-(void)AddRatingOwnerInvocation:(NSString *)userId ownerId:(NSString *)ownerId rating:(NSString *)rating delegate: (id<AddRatingOwnerInvocationDelegate>)delegate
{
    AddRatingOwnerInvocation *invocation = [[[AddRatingOwnerInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.rating=rating;
    invocation.owner_id=ownerId;
    [self invoke:invocation withDelegate:delegate];
    
    
}

-(void)KickOffMemberInvocation:(NSString *)userId friendId:(NSString *)friendId threadId:(NSString *)threadId groupId:(NSString *)groupId delegate: (id<KickOffMemberInvocationDelegate>)delegate
{
    NSLog(@"%@",threadId);
    
    KickOffMemberInvocation *invocation = [[[KickOffMemberInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    invocation.thread_id=threadId;
    invocation.group_id=groupId;
    [self invoke:invocation withDelegate:delegate];
}

-(void)UnpaidRevenueInvocation:(NSString *)userId delegate: (id<UnpaidRevenueInvocationDelegate>)delegate
{
    UnpaidRevenueInvocation *invocation = [[[UnpaidRevenueInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    [self invoke:invocation withDelegate:delegate];

}
-(void)LogOutInvocation:(NSString*)userId deviceToken:(NSString *)deviceToken delegate: (id<LogOutInvocationDelegate>)delegate
{
    LogOutInvocation *invocation=[[[LogOutInvocation alloc] init] autorelease];
    invocation.userId=userId;
    invocation.deviceToken=deviceToken;
    
    [self invoke:invocation withDelegate:delegate];
    
}

-(void)SendPhoneContactsInvocation:(NSString*)userId phoneList:(NSString *)phoneList  userName:(NSString *)userName delegate: (id<SendPhoneContactsInvocationDelegate>)delegate
{
    SendPhoneContactsInvocation *invocation=[[[SendPhoneContactsInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.phone_num_list=phoneList;
    invocation.user_name=userName;

    [self invoke:invocation withDelegate:delegate];
}
-(void)AcceptRejectFriendRequestInvocation:(NSString *)userId friendId:(NSString *)friendId type:(NSString *)type delegate: (id<AcceptRejectFriendRequestInvocationDelegate>)delegate;
{
    AcceptRejectFriendRequestInvocation *invocation = [[[AcceptRejectFriendRequestInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    invocation.type=type;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)AcceptRejectChatInvocation:(NSString *)userId friendId:(NSString *)friendId type:(NSString *)type delegate: (id<AcceptRejectChatInvocationDelegate>)delegate
{
    AcceptRejectChatInvocation *invocation = [[[AcceptRejectChatInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    invocation.type=type;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)AcceptRejectGroupChatInvocation:(NSString *)userId groupId:(NSString *)groupId groupUserTableId:(NSString *)groupUserTableId groupOwnerId:(NSString *)groupOwnerId status:(NSString *)status delegate: (id<AcceptRejectGroupChatInvocationDelegate>)delegate
{
    AcceptRejectGroupChatInvocation *invocation = [[[AcceptRejectGroupChatInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.groupId=groupId;
    invocation.groupUserTableId=groupUserTableId;
    invocation.groupOwnerId=groupOwnerId;
    invocation.status=status;

    
    [self invoke:invocation withDelegate:delegate];
}
-(void)BlockInvocation:(NSString*)userId friendId:(NSString *)friendId blockType:(NSString *)blockType delegate: (id<BlockInvocationDelegate>)delegate
{
    BlockInvocation *invocation = [[[BlockInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    invocation.type=blockType;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)BlockListInvocation:(NSString *)userId delegate: (id<BlockListInvocationDelegate>)delegate
{
    BlockListInvocation *invocation = [[[BlockListInvocation alloc] init] autorelease];
    invocation.user_id = userId;
      
    [self invoke:invocation withDelegate:delegate];

}

-(void)FriendProfileInvocation:(NSString *)userId friendId:(NSString *)friendId delegate: (id<FriendProfileInvocationDelegate>)delegate
{
    FriendProfileInvocation *invocation = [[[FriendProfileInvocation alloc] init] autorelease];
    invocation.user_id = userId;
    invocation.friend_id=friendId;
    
    [self invoke:invocation withDelegate:delegate];
    
}

-(void)SendPhoneListInvocation:(NSString *)userId phoneList:(NSString *)phoneList delegate: (id<SendPhoneListInvocationDelegate>)delegate
{
    SendPhoneListInvocation *invocation=[[[SendPhoneListInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.phone_num_list=phoneList;
    
    [self invoke:invocation withDelegate:delegate];

}

-(void)ResetBedgeInvocation:(NSString*)userId delegate: (id<ResetBedgeInvocationDelegate>)delegate
{
    ResetBedgeInvocation *invocation=[[[ResetBedgeInvocation alloc] init] autorelease];
    invocation.userId=userId;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)GroupMemberListInvocation:(NSString *)userId groupId:(NSString *)groupId delegate: (id<GroupMemberListInvocationDelegate>)delegate
{
    GroupMemberListInvocation *invocation=[[[GroupMemberListInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;

    [self invoke:invocation withDelegate:delegate];
}
-(void)ShareGroupInvocation:(NSString *)userId groupId:(NSString *)groupId  friendId:(NSString *)friendId  groupCode:(NSString *)groupCode delegate: (id<ShareGroupInvocationDelegate>)delegate
{
    ShareGroupInvocation *invocation=[[[ShareGroupInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;
    invocation.friend_id=friendId;
    invocation.group_code=groupCode;

    [self invoke:invocation withDelegate:delegate];

}
-(void)AddPrivillegeInvocation:(NSString *)ownerId groupId:(NSString *)groupId  friendId:(NSString *)friendId delegate: (id<AddPrivillegeInvocationDelegate>)delegate
{
    AddPrivillegeInvocation *invocation=[[[AddPrivillegeInvocation alloc] init] autorelease];
    invocation.owner_id=ownerId;
    invocation.group_id=groupId;
    invocation.friend_id=friendId;
    
    [self invoke:invocation withDelegate:delegate];
}

-(void)ManageGroupListInvocation:(NSString *)userId page:(NSString *)page searchText:(NSString *)searchText delegate: (id<ManageGroupListInvocationDelegate>)delegate
{
    ManageGroupListInvocation *invocation=[[[ManageGroupListInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.pageString=page;
    invocation.searchtext=searchText;
    [self invoke:invocation withDelegate:delegate];
}

-(void)JoinGroupInvocation:(NSString *)userId friendId:(NSString *)friendId groupId:(NSString *)groupId delegate: (id<JoinGroupInvocationDelegate>)delegate
{
    JoinGroupInvocation *invocation=[[[JoinGroupInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;
    invocation.friend_id=friendId;
    [self invoke:invocation withDelegate:delegate];
}
-(void)SpecialGroupJoinInvocation:(NSString *)userId friendId:(NSString *)friendId groupId:(NSString *)groupId delegate: (id<SpecialGroupJoinInvocationDelegate>)delegate
{
    SpecialGroupJoinInvocation *invocation=[[[SpecialGroupJoinInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;
    invocation.friend_id=friendId;
    [self invoke:invocation withDelegate:delegate];
}
-(void)AcceptRejectOwnerRequestInvocation:(NSString *)userId groupId:(NSString *)groupId memberId:(NSString *)memberId status:(NSString *)status messageId:(NSString *)messageId delegate: (id<AcceptRejectOwnerRequestInvocationDelegate>)delegate

{
    AcceptRejectOwnerRequestInvocation *invocation=[[[AcceptRejectOwnerRequestInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.groupId=groupId;
    invocation.memberId=memberId;
    invocation.status=status;
    invocation.messageId=messageId;
    
    [self invoke:invocation withDelegate:delegate];

}
-(void)ClearGroupMessageInvocation:(NSString *)userId groupId:(NSString *)groupId delegate: (id<ClearGroupMessageInvocationDelegate>)delegate
{
    ClearGroupMessageInvocation *invocation=[[[ClearGroupMessageInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;
   
    [self invoke:invocation withDelegate:delegate];
    

}
-(void)RevenueInvocation:(NSString *)userId groupId:(NSString *)groupId transactionId:(NSString *)transactionId subCharge:(NSString *)subCharge delegate: (id<RevenueInvocationDelegate>)delegate
{
    RevenueInvocation *invocation=[[[RevenueInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;
    invocation.transaction_id=transactionId;
    invocation.subscription_charge=subCharge;

    [self invoke:invocation withDelegate:delegate];

}
-(void)GroupTypeEditInvocation:(NSString *)userId groupId:(NSString *)groupId groupType:(NSString *)groupType delegate: (id<GroupTypeEditInvocationDelegate>)delegate
{
    GroupTypeEditInvocation *invocation=[[[GroupTypeEditInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;
    invocation.group_type=groupType;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)LatestGroupInvocation:(NSString *)userId  page:(NSString *)page delegate: (id<LatestGroupInvocationDelegate>)delegate
{
    LatestGroupInvocation *invocation=[[[LatestGroupInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.pageString=page;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)SendCreditCardDetailInvocation:(NSString *)userId cardname:(NSString *)cardname account_number:(NSString *)account_number card_type:(NSString *)card_type expiry_date:(NSString *)expiry_date crn_number:(NSString *)crn_number groupId:(NSString *)groupId delegate: (id<SendCreditCardDetailInvocationDelegate>)delegate
{
    SendCreditCardDetailInvocation *invocation=[[[SendCreditCardDetailInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.credit_card_name=cardname;
    invocation.credit_card_account=account_number;
    invocation.credit_card_type=card_type;
    invocation.credit_card_expirydate=expiry_date;
    invocation.credit_card_crnNumber=crn_number;
    invocation.group_id=groupId;
    [self invoke:invocation withDelegate:delegate];
}
-(void)UnSubcribeInvocation:(NSString *)userId groupId:(NSString *)groupId  transactionId:(NSString *)transactionId delegate: (id<UnSubcribeInvocationDelegate>)delegate
{
    UnSubcribeInvocation *invocation=[[[UnSubcribeInvocation alloc] init] autorelease];
    invocation.user_id=userId;
    invocation.group_id=groupId;
    invocation.transection_id=transactionId;
    
    [self invoke:invocation withDelegate:delegate];
}
-(void)AboutUsInvocation:(NSString *)userId delegate: (id<AboutUsInvocationDelegate>)delegate
{
    AboutUsInvocation *invocation=[[[AboutUsInvocation alloc] init] autorelease];
  
    [self invoke:invocation withDelegate:delegate];

}

-(void)FacebookLoginInvocation:(NSString *)fbId email:(NSString *)email display_name:(NSString *)display_name dob:(NSString *)dob gender:(NSString *)gender image:(NSString *)image delegate: (id<FacebookLoginInvocationDelegate>)delegate
{
    FacebookLoginInvocation *invocation=[[[FacebookLoginInvocation alloc] init] autorelease];
    invocation.email=email;
    invocation.fbId=fbId;
    invocation.displayName=display_name;
    invocation.dob=dob;
    invocation.gender=gender;
    invocation.UserImage=image;

    [self invoke:invocation withDelegate:delegate];
}

-(void)NotificationSettingInvocation:(NSString *)userId notificationStatus:(NSString *)notificationStatus delegate: (id<NotificationSettingInvocationDelegate>)delegate
{
    NotificationSettingInvocation *invocation=[[[NotificationSettingInvocation alloc] init] autorelease];
  
    invocation.user_id=userId;
    invocation.notificationStatus=notificationStatus;
    
    [self invoke:invocation withDelegate:delegate];

}
-(void)UrlSchemeInvocation:(NSString *)userId groupCode:(NSString *)groupCode delegate: (id<UrlSchemeInvocationDelegate>)delegate
{
    UrlSchemeInvocation *invocation=[[[UrlSchemeInvocation alloc] init] autorelease];
   
    invocation.user_id=userId;
    invocation.groupCode=groupCode;
    
    [self invoke:invocation withDelegate:delegate];

}

@end
