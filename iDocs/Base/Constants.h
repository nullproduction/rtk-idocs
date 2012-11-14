/*
 *  Constants.h
 *  iDoc
 *
 *  Created by Dmitry Likhachev on 1/24/09.
 *  Copyright KORUS Consulting 2009. All rights reserved.
 *
 */

//app settings
#pragma mark App Settings
//system
#define constAppSettingsUpdated @"AppSettingsUpdated"
#define constAppVersion @"AppVersion"
#define constDictionariesLastUpdatedDate @"DictionariesVersion"
#define constSyncDictionaries @"SyncORDDictionaries"
#define constServerRequestTimeout @"ServerRequestTimeout"
#define constUse3GNetwork @"Use3GNetwork"
#define constErrandDueDateInterval @"CurrentErrandDueDateInterval"
#define constClientSettingsServerCheckSum @"ClientSettingsServerCheckSum"
#define constLastSuccessfullSyncDate @"LastSuccessfullSyncDate"
#define constLastORDServerUrl @"LastORDServerUrl"
#define constLastLoggedInORDUser @"LastLoggedInORDUser"
#define constLastUsedORDRServerRepository @"LastUsedORDServerRepository"
#define constLastWebDavServerUrl @"LastWebDavServerUrl"
#define constLastLoggedInWebDavUser @"LastLoggedInWebDavUser"
#define constLastUsedTheme @"LastUsedTheme"
#define constUseTestData @"UseTestData"
#define constDocInfoPackageSize @"DocInfoPackageSize"
#define constSyncOnStartup @"SyncOnStartup"
#define constDefaultFileExtension @"none"
//system - optional (iDocSync)
#define constDBFile @"iDoc.sqlite"
#define constBackupExtension @".backup"
#define constORDFolderPath @"ORDFolder"
#define constWebDavFolderPath @"WebDavFolder"
#define constDBFilePath @"DBFile"
#define constDeviceAppFolder @"DeviceAppFolder"
//user
//server inbox - ord
#define constORDServerUrl @"ORDServerUrl"
#define constORDServerUser @"ORDServerUser"
#define constORDServerPassword @"ORDServerPassword"
#define constORDServerRepositoryName @"ORDServerRepositoryName"
#define constORDAttachmentDownloadType @"ORDAttachmentDownloadType"
#define constORDAttachmentDownloadBase64Type @"base64"
#define constORDAttachmentDownloadServletType @"servlet"
#define constUseORDServer @"UseORDServer"
#define keyRequestUrl @"WebServiceUrl"
#define keyRequestMessage @"WebServiceMessage"
#define keyRequestTimeout @"ServerRequestTimeout"
#define constORDFolder @"ORD"
//server doc - webdav
#define constWebDavServerUrl @"WebDavServerUrl"
#define constWebDavServerUser @"WebDavServerUser"
#define constWebDavServerPassword @"WebDavServerPassword"
#define constUseWebDavServer @"UseWebDavServer"
#define constWebDavFolder @"WebDav"


//web services
#pragma mark web services
//support request container sections
#pragma mark support request container sections
#define constRequestPropFile @"RequestProperty.xml"
#define constRequestDataObjectFile @"RequestDataObject.xml"
#define maskRequestPropName @"#PROPNAME#"
#define maskRequestPropValue @"#PROPVALUE#"
#define maskRequestProperties @"#PROPERTIES#"
#define maskRequestDataObjects @"#DATA_OBJECTS#"
//login service
#pragma mark login service
#define constAuthWSName @"/services/inboxService/KcInboxDataProvider"
#define constAuthWSRequestFile @"AuthRequest.xml"
#define maskUser @"#USERNAME#"
#define maskPassword @"#PASSWORD#"
#define maskToken @"#TOKEN#"
#define maskRepository @"#REPOSITORY#"
//dictionaries service
#pragma mark dictionaries service
#define constDicWSName @"/services/inboxService/KcSyncDictionaryService"
#define constDicWSRequestFile @"SyncDictionariesRequest.xml"
#define maskDicCheckDate @"#CHECKDATE#"
#define constTestDicDataFile @"test_dictionaries_data.xml"
#define constDicItemActionTypeFullRefresh @"full_refresh"
#define constDicItemActionTypeNew @"new"
#define constDicItemActionTypeDelete @"delete"
#define constDicItemActionTypeChange @"change"
#define constDicItemTypeSystemInfo @"serverTime"
#define constDicItemTypeEmployee @"users"
#define constDicItemTypeEmployeeGroup @"group_user"
#define constDicItemTypeResolutionTemplate @"common_resolution"

//client settings service
#pragma mark client settings service
#define constClientSettingsSyncWSName @"/services/inboxService/KcGetClientsSettingService"
#define constClientSettingsSyncWSRequestFile @"ClientSettingsDataRequest.xml"
#define constClientSettingsDataFile @"test_clientSettings.xml"
#define constClientSettingsCheckSumWSRequestFile @"ClientSettingsCheckSumRequest.xml"
#define constTestClientSettingsCheckSum @"TestCheckSum"

//actions to sync service
#pragma mark actions to sync service
#define constExecuteActionsToSyncWSName @"/services/inboxService/KcActionService"
#define constExecuteActionsToSyncWSRequestFile @"ExecuteActionsToSyncRequest.xml"
#define constActionToSyncTask @"task_id"
#define constActionToSyncAction @"action_id"
#define constActionToSyncDocument @"document_id"
#define constActionToSyncComment @"comment"
#define constActionToSyncResolution @"text_resolution"
#define constActionToSyncAttachments @"attachments"

#define constActionToSyncPerformer @"performer_id"
#define constActionToSyncOnControl @"on_control"
#define constActionToSyncControlDate @"control_date"
#define constActionToSyncErrand @"mission_id"
#define constActionToSyncErrandMajorExecutorId @"major_executor_id"

//task list service
#pragma mark task list service
#define constTaskListWSName @"/services/inboxService/KcInboxDataProvider"
#define constTaskListWSRequestFile @"TaskListRequest.xml"
#define constTaskListBlockWSRequestFile @"TaskListBlockRequest.xml"
#define maskTaskBlockName @"#BLOCK_NAME#"
#define constTestTaskListDataFilePrefix @"test_task_list_"
#define constTestFileExtension @".xml"

//task and doc info service
#pragma mark task and doc info service
#define constTaskInfoWSName @"/services/inboxService/KcInboxDataProvider"
#define constTaskInfoWSRequestFile @"TaskDataRequest.xml"
#define maskTaskId @"#TASK_ID#"
#define maskDocId @"#DOC_ID#"
#define constTestTaskInfoDataFilePrefix @"test_task_"
#define constDocsInfoWSName @"/services/inboxService/KcInboxDataProvider"
#define constDocsInfoWSRequestFile @"DocDataRequest.xml"
#define constDocsInfoParamName @"document_id"
#define constTestDocInfoDataFilePrefix @"test_doc_package_"


#define constDocListOnControlWSName @"/services/inboxService/KcDocumentCategoryDataProvider"
#define constDocListOnControlWSRequestFile @"DocListOnControlRequest.xml"
#define constTestDocListOnControlDataFilePrefix @"test_doc_list_on_control"

//attachment service
#pragma mark attachment service
#define constAttachmentContentWSName @"/services/inboxService/KcInboxDataProvider"
#define constTestDocumentContentFile @"attachment_content.xml"
#define constAttachmentContentWSRequestFile @"AttachmentContentRequest.xml"
#define maskAttachmentId @"#ATTACHMENT_ID#"
#define constTestAttachmentDataFilePrefix @"test_attachment_"
//attachments servlet
#pragma mark attachment servlet
#define constAttachmentServletName @"/fileservlet"
#define constAttachmentServletRequest @"/#REPOSITORY#/#USERNAME#/#PASSWORD#/#ATTACHMENT_ID#"


//set task as read service
#pragma mark task as read service
#define constTaskAsReadWSName @"/services/inboxService/KcInboxDataProvider"
#define constTaskAsReadWSRequestFile @"SetAsRead.xml"
#define maskTaskAsReadId @"#TASK_ID#"
#define constActionToSyncTask @"task_id"


//types
#pragma mark types
//field types
#define constParamViewCheckbox @"checkbox"
#define constParamViewTextField @"textField"
#define constParamViewTextView @"textView"
#define constParamViewText @"text"
//request types
#define constRequestTypeTaskAction 1
#define constRequestTypeErrandWorkflowAction 2
#define constRequestTypeCreateOrUpdateErrandAction 3
//ipad dashboard widget types 
#define constWidgetTypeORDGroup @"itemORDCategoryGroup"
#define constWidgetTypeWebDavFolder @"itemWebDavFolder"
#define maskMyDocsWebDavFolder @"__MY_WEBDAV_DOCUMENTS__"
#define constWidgetTypeFolder @"folder"


//app access params
#pragma mark app access params
//access types for cells - view, view with links, all
#define constAccessTypeView 0
#define constAccessTypeViewWithLinks 1
#define constAccessTypeAll 2
//modes for errand /notice
#define constModeView 0
#define constModeEdit 1
#define constModeCreate 2

//endorsement statuses
#define constEndorsementStatusFuture @"*"
#define constEndorsementStatusInProcess @"?"
#define constEndorsementStatusApproved @"+"
#define constEndorsementStatusRejected @"-"
//errand statuses
#define constErrandStatusProject 2
#define constErrandStatusInProcess 0
#define constErrandStatusApproved 1
#define constErrandStatusRejected -1
//notice statuses
#define constNoticeStatusInProcess 0
#define constNoticeStatusDone 1
//task actions
#define keyTaskActionType @"action_type"
#define constTaskActionTypeSubmit @"close_task"
#define constTaskActionTypeSubmitWithComment @"new_comment"
#define constTaskActionTypeAddErrand @"new_resolution"
#define constTaskActionTypeAddMultiErrand @"new_multi_resolution"
#define constTaskActionTypeAddErrandReport @"new_report"
#define constTaskActionTypeAddNotice @"new_notice"
//task buttons desc
#define keyTaskActionButtonColor @"color"
#define constTaskActionButtonColorRed @"red"
#define constTaskActionButtonColorGreen @"green"
//errand actions
#define constErrandActionTypeCancel @"mission_reject_action"
#define constErrandActionTypeDeleteLocal @"mission_delete_local"
#define constErrandActionTypeSaveProject @"save_mission_project"
#define constErrandActionTypeDeleteProject @"delete_mission_project"
#define constErrandActionTypeSendOnExecutionProject @"send_on_execution"

//sync statuses
#define constSyncStatusToLoad @"toLoad"
#define constSyncStatusWorking @"working"
#define constSyncStatusToDelete @"toDelete"
#define constSyncStatusInSync @"inSync"

#define constSyncDashboardItemId @"syncDashboardItemId"

//file properties
#pragma file properties
#define HFS_FileAttributesDictionaryFileName @"fileName"
#define HFS_FileAttributesDictionaryFileExtension @"fileExtension"
#define HFS_FileAttributesDictionaryFileIcon @"fileIcon"
#define HFS_FileAttributesDictionaryFilePath @"filePath"

//common actions
#pragma common actions
#define constActionIdSendMail 1
#define constActionIdCalendarEntry 2


//app ui params
#pragma mark app ui params
//format strings
#define constEmptyStringValue @""
#define constTrueStringValue @"true"
#define constFalseStringValue @"false"
#define constNullStringValue @"(null)"
#define constDateFormat @"dd.MM.yyyy"
#define constDateTimeFormat @"dd.MM.yyyy HH:mm"
#define constDateTimeSecondsFormat @"dd.MM.yyyy HH:mm:ss"
#define constDateTimeFormatShort @"dd.MM.yy HH:mm"
#define constDateTimeFormatDateJustPicked @"EEE, dd MMM yyyy HH:mm"
#define constFileDateFormat @"yyyy-MM-dd hh:mm:ss"
#define constDateTimeFormatDictionariesSyncCheckDate @""
//fonts
#define constXSmallFontSize 10.0f
#define constSmallFontSize 12.0f
#define constMediumFontSize 14.0f
#define constLargeFontSize 16.0f
#define constXLargeFontSize 20.0f
#define constXXLargeFontSize  20.0f
#define constXXXLargeFontSize  22.0f

//sizes
#define constListItemCellHeight 60.0f
#define constDateTextCellHeight 60.0f
#define constInboxTabCellHeight 40.0f

#define constTaskListPanelWidthLandscapeNormal 321.0f
#define constTaskListPanelWidthLandscapeSlidedOff 25.0f
#define constTaskPanelTablesSectionHeight 40.0f
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define constCornerRadius 5.0f
#define constViewScaleFactor 3.0f

#define constSectionHeight 35.0f

//app ui ids
#pragma mark app ui ids
#define constActivityIndicatorView 1000
#define constProgressBarView 1001
#define constImageLoadingActivityIndicator 1011
#define constHeaderCenterTitleWithCaption 1012
#define constHeaderRightButton 1013
#define constHeaderLeftButton 1014


//misc
#pragma misc
#define constSeparatorSymbol @":"
#define constErrandNumberSeparatorSymbol @"."
#define constCheckedValue @"1"
#define constUncheckedValue @"0"

#define constSortField @"sortField"
#define constSortType @"sortType"

//sync notifications
#define constDataSyncEventNotification @"DataSyncEvent"
#define constDSEventDataKeyCode @"code"
#define constDSEventDataKeyTitle @"title"
#define constDSEventDataKeyStatus @"status"
#define constDSEventDataKeyMessage @"message"
#define constDSEventDataKeySenderClassName @"classname"

//sync on control
#define constOnControlFolderId @"on_control" 

typedef enum _DataSyncEventCode {
    DSEventCodeUnknown = 0,
    DSEventCodeLoaderStarted = 1,
    DSEventCodeLoaderFinished = 2,
    DSEventCodeSyncModuleStarted = 3,
    DSEventCodeSyncModuleFinished = 4,
    DSEventCodeLoaderSubevent = 5,
} DataSyncEventCode;  

typedef enum _DataSyncEventStatus {
    DSEventStatusUnknown = 0,
    DSEventStatusQueued = 1,
    DSEventStatusProcessing = 2,
    DSEventStatusInfo = 3,
    DSEventStatusWarning = 4,
    DSEventStatusError = 5
} DataSyncEventStatus;  

//sync modules
#pragma mark sync modules params
typedef enum _DataSyncModule {
    DSModuleUnknown = 0,
    DSModuleClientSettings = 1,
    DSModuleORDServer = 2,
    DSModuleWebDavServer = 3,
    DSModuleActionsOnly = 4
} DataSyncModule;

#pragma mark ORD engine enums
typedef enum _ORDTaskType {
    ORDTaskTypeUnknown = 0,
    ORDTaskTypeRegular = 1,
    ORDTaskTypeOnControl = 2
} ORDTaskType;

#define constSyncStatus @"SyncStatus"
typedef enum _SyncStatus {
    SyncStatusNone = 0,
    SyncStatusIsRunningSync = 1,
    SyncStatusAbortedInBackground = 2
} SyncStatus;
#define constLastSyncCompletedStep @"LastSyncCompletedStep"

#define constSyncSuspendDate @"SyncSuspendDate"
#define constExpirationInterval 600


#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


