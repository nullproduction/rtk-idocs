//
 (NSDictionary *)createCheckAuthRequestForUser:(UserInfo *)user;
 (NSDictionary *)createRequestOfTaskListInBlock:(NSString *)blockName forUser:(UserInfo *)user;
 (NSDictionary *)createRequestOfDocListOnControlForUser:(UserInfo *)user;
 (NSDictionary *)createRequestOfTaskInfoForTaskId:(NSString *)taskId andDocId:(NSString *)docId forUser:(UserInfo *)user; 
 (NSDictionary *)createRequestOfDocs:(NSArray *)docsToSync forUser:(UserInfo *)user;
 (NSDictionary *)createRequestOfAttachmentContent:(NSString *)attachmentId forUser:(UserInfo *)user;
 (NSDictionary *)createRequestOfAttachmentFile:(NSString *)attachmentId forUser:(UserInfo *)user;
 (NSDictionary *)createDictionariesSyncRequestForUser:(UserInfo *)user;
 (NSDictionary *)createClientSettingsCheckSumRequestForUser:(UserInfo *)user;
 (NSDictionary *)createClientSettingsSyncRequestForUser:(UserInfo *)user;
 (NSDictionary *)createRequestOfActionToSyncSubmit:(ActionToSync *)action forUser:(UserInfo *)user;
 (NSDictionary *)createRequestOfActionsToSyncSubmit:(NSArray *)actions forUser:(UserInfo *)user;