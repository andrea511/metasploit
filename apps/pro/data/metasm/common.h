#define NULL 0
#define SERVICES_ACTIVE_DATABASEA "ServicesActive"
#define SERVICES_ACTIVE_DATABASEW L"ServicesActive"
#define SERVICES_FAILED_DATABASEA "ServicesFailed"
#define SERVICES_FAILED_DATABASEW L"ServicesFailed"
#define SC_GROUP_IDENTIFIERA '+'
#define SC_GROUP_IDENTIFIERW L'+'
#define SC_MANAGER_ALL_ACCESS	0xf003f
#define SC_MANAGER_CONNECT	1
#define SC_MANAGER_CREATE_SERVICE	2
#define SC_MANAGER_ENUMERATE_SERVICE	4
#define SC_MANAGER_LOCK	8
#define SC_MANAGER_QUERY_LOCK_STATUS	16
#define SC_MANAGER_MODIFY_BOOT_CONFIG	32
#define SERVICE_NO_CHANGE	(-1)
#define SERVICE_STOPPED	1
#define SERVICE_START_PENDING	2
#define SERVICE_STOP_PENDING	3
#define SERVICE_RUNNING	4
#define SERVICE_CONTINUE_PENDING	5
#define SERVICE_PAUSE_PENDING	6
#define SERVICE_PAUSED	7
#define SERVICE_ACCEPT_STOP	1
#define SERVICE_ACCEPT_PAUSE_CONTINUE	2
#define SERVICE_ACCEPT_SHUTDOWN 4
#define SERVICE_CONTROL_STOP	1
#define SERVICE_CONTROL_PAUSE	2
#define SERVICE_CONTROL_CONTINUE	3
#define SERVICE_CONTROL_INTERROGATE	4
#define SERVICE_CONTROL_SHUTDOWN	5
#define SERVICE_ACTIVE 1
#define SERVICE_INACTIVE 2
#define SERVICE_STATE_ALL 3
#define SERVICE_QUERY_CONFIG 1
#define SERVICE_CHANGE_CONFIG 2
#define SERVICE_QUERY_STATUS 4
#define SERVICE_ENUMERATE_DEPENDENTS 8
#define SERVICE_START 16
#define SERVICE_STOP 32
#define SERVICE_PAUSE_CONTINUE 64
#define SERVICE_INTERROGATE 128
#define SERVICE_USER_DEFINED_CONTROL 256

#define SERVICE_WIN32_SHARE_PROCESS 0x00000020
#define SERVICE_WIN32_OWN_PROCESS 0x00000010
#define SERVICE_RECOGNIZER_DRIVER 0x00000008
#define SERVICE_KERNEL_DRIVER 0x00000001
#define SERVICE_FILE_SYSTEM_DRIVER 0x00000002
#define SERVICE_ADAPTER 0x00000004

#define ERROR_ALREADY_EXISTS 183
#define TRUE 1
#define FALSE 0

#define CREATE_SUSPENDED		0x00000004
#define IDLE_PRIORITY_CLASS		0x00000040

#define SIZE_OF_80387_REGISTERS	80
#define CONTEXT_i386	0x10000
#define CONTEXT_i486	0x10000
#define CONTEXT_CONTROL	(CONTEXT_i386|0x00000001L)
#define CONTEXT_INTEGER	(CONTEXT_i386|0x00000002L)
#define CONTEXT_SEGMENTS	(CONTEXT_i386|0x00000004L)
#define CONTEXT_FLOATING_POINT	(CONTEXT_i386|0x00000008L)
#define CONTEXT_DEBUG_REGISTERS	(CONTEXT_i386|0x00000010L)
#define CONTEXT_EXTENDED_REGISTERS (CONTEXT_i386|0x00000020L)
#define CONTEXT_FULL	(CONTEXT_CONTROL|CONTEXT_INTEGER|CONTEXT_SEGMENTS)
#define MAXIMUM_SUPPORTED_EXTENSION  512

#define PAGE_NOACCESS	0x0001
#define PAGE_READONLY	0x0002
#define PAGE_READWRITE	0x0004
#define PAGE_WRITECOPY	0x0008
#define PAGE_EXECUTE	0x0010
#define PAGE_EXECUTE_READ	0x0020
#define PAGE_EXECUTE_READWRITE	0x0040
#define PAGE_EXECUTE_WRITECOPY	0x0080
#define PAGE_GUARD		0x0100
#define PAGE_NOCACHE		0x0200

#define MEM_COMMIT           0x1000
#define MEM_RESERVE          0x2000
#define MEM_DECOMMIT         0x4000
#define MEM_RELEASE          0x8000
#define MEM_FREE            0x10000
#define MEM_PRIVATE         0x20000
#define MEM_MAPPED          0x40000
#define MEM_RESET           0x80000
#define MEM_TOP_DOWN       0x100000
#define MEM_WRITE_WATCH	   0x200000 /* 98/Me */
#define MEM_PHYSICAL	   0x400000
#define MEM_4MB_PAGES    0x80000000

#define KEY_READ 0x20019
#define KEY_WRITE 0x20006
#define HKEY_LOCAL_MACHINE 0x80000002
#define REG_SZ 1


struct _RTL_CRITICAL_SECTION;
typedef int BOOL;
typedef unsigned char BYTE;
typedef char CHAR;
__stdcall int CountClipboardFormats __attribute__((dllimport))(void);
typedef unsigned long DWORD;
__stdcall void DebugBreak __attribute__((dllimport))(void);
typedef __stdcall int (*FARPROC)();
typedef float FLOAT;
typedef long FXPT2DOT30;
__stdcall long GetDialogBaseUnits __attribute__((dllimport))(void);
__stdcall int GetKeyboardType __attribute__((dllimport))(int nTypeFlag __attribute__((in)));
__stdcall int GetSystemMetrics __attribute__((dllimport))(int nIndex __attribute__((in)));

struct HACCEL__ {
	int unused;
};
typedef void *HANDLE;

struct HBITMAP__ {
	int unused;
};

struct HBRUSH__ {
	int unused;
};

struct HCOLORSPACE__ {
	int unused;
};

struct HDC__ {
	int unused;
};

struct HDESK__ {
	int unused;
};

struct HENHMETAFILE__ {
	int unused;
};
typedef int HFILE;

struct HFONT__ {
	int unused;
};
typedef void *HGDIOBJ;

struct HHOOK__ {
	int unused;
};

struct HICON__ {
	int unused;
};

struct HIMC__ {
	int unused;
};

struct HINSTANCE__ {
	int unused;
};

struct HKEY__ {
	int unused;
};

struct HKL__ {
	int unused;
};

struct HMENU__ {
	int unused;
};

struct HMETAFILE__ {
	int unused;
};

struct HMONITOR__ {
	int unused;
};

struct HPALETTE__ {
	int unused;
};

struct HPEN__ {
	int unused;
};

struct HRAWINPUT__ {
	int unused;
};

struct HRGN__ {
	int unused;
};

struct HRSRC__ {
	int unused;
};

struct HWINEVENTHOOK__ {
	int unused;
};

struct HWINSTA__ {
	int unused;
};

struct HWND__ {
	int unused;
};
typedef int INT;
typedef int INT_PTR;
typedef long LONG;
typedef __int64 LONGLONG;
typedef long LONG_PTR;
typedef const void *LPCVOID;
typedef int *LPINT;
typedef long *LPLONG;
typedef void *LPVOID;
typedef void MENUTEMPLATEA;
__stdcall int MulDiv __attribute__((dllimport))(int nNumber __attribute__((in)), int nNumerator __attribute__((in)), int nDenominator __attribute__((in)));
typedef const char *PCSZ;
typedef unsigned int *PUINT;
typedef unsigned long *PULONG_PTR;
typedef void *PVOID;
__stdcall void PostQuitMessage __attribute__((dllimport))(int nExitCode __attribute__((in)));

struct SC_HANDLE__ {
	int unused;
};

struct SERVICE_STATUS_HANDLE__ {
	int unused;
};
typedef short SHORT;
__stdcall void SetFileApisToANSI __attribute__((dllimport))(void);
__stdcall void SetFileApisToOEM __attribute__((dllimport))(void);
typedef unsigned char UCHAR;
typedef unsigned int UINT;
typedef unsigned int UINT_PTR;
typedef unsigned long ULONG;
typedef unsigned __int64 ULONGLONG;
typedef unsigned long ULONG_PTR;
typedef unsigned short USHORT;
typedef enum { WinNullSid, WinWorldSid, WinLocalSid, WinCreatorOwnerSid, WinCreatorGroupSid, WinCreatorOwnerServerSid, WinCreatorGroupServerSid, WinNtAuthoritySid, WinDialupSid, WinNetworkSid, WinBatchSid, WinInteractiveSid, WinServiceSid, WinAnonymousSid, WinProxySid, WinEnterpriseControllersSid, WinSelfSid, WinAuthenticatedUserSid, WinRestrictedCodeSid, WinTerminalServerSid, WinRemoteLogonIdSid, WinLogonIdsSid, WinLocalSystemSid, WinLocalServiceSid, WinNetworkServiceSid, WinBuiltinDomainSid, WinBuiltinAdministratorsSid, WinBuiltinUsersSid, WinBuiltinGuestsSid, WinBuiltinPowerUsersSid, WinBuiltinAccountOperatorsSid, WinBuiltinSystemOperatorsSid, WinBuiltinPrintOperatorsSid, WinBuiltinBackupOperatorsSid, WinBuiltinReplicatorSid, WinBuiltinPreWindows2000CompatibleAccessSid, WinBuiltinRemoteDesktopUsersSid, WinBuiltinNetworkConfigurationOperatorsSid, WinAccountAdministratorSid, WinAccountGuestSid, WinAccountKrbtgtSid, WinAccountDomainAdminsSid, WinAccountDomainUsersSid, WinAccountDomainGuestsSid, WinAccountComputersSid, WinAccountControllersSid, WinAccountCertAdminsSid, WinAccountSchemaAdminsSid, WinAccountEnterpriseAdminsSid, WinAccountPolicyAdminsSid, WinAccountRasAndIasServersSid, WinNTLMAuthenticationSid, WinDigestAuthenticationSid, WinSChannelAuthenticationSid, WinThisOrganizationSid, WinOtherOrganizationSid, WinBuiltinIncomingForestTrustBuildersSid, WinBuiltinPerfMonitoringUsersSid, WinBuiltinPerfLoggingUsersSid, WinBuiltinAuthorizationAccessSid, WinBuiltinTerminalServerLicenseServersSid, WinBuiltinDCOMUsersSid, WinBuiltinIUsersSid, WinIUserSid, WinBuiltinCryptoOperatorsSid, WinUntrustedLabelSid, WinLowLabelSid, WinMediumLabelSid, WinHighLabelSid, WinSystemLabelSid, WinWriteRestrictedCodeSid, WinCreatorOwnerRightsSid, WinCacheablePrincipalsGroupSid, WinNonCacheablePrincipalsGroupSid, WinEnterpriseReadonlyControllersSid, WinAccountReadonlyControllersSid, WinBuiltinEventLogReadersGroup, WinNewEnterpriseReadonlyControllersSid, WinBuiltinCertSvcDComAccessGroup, WinMediumPlusLabelSid, WinLocalLogonSid, WinConsoleLogonSid, WinThisOrganizationCertificateSid } WELL_KNOWN_SID_TYPE;
typedef unsigned short WORD;
enum _ACL_INFORMATION_CLASS { AclRevisionInformation = 1, AclSizeInformation };
enum _COMPUTER_NAME_FORMAT { ComputerNameNetBIOS, ComputerNameDnsHostname, ComputerNameDnsDomain, ComputerNameDnsFullyQualified, ComputerNamePhysicalNetBIOS, ComputerNamePhysicalDnsHostname, ComputerNamePhysicalDnsDomain, ComputerNamePhysicalDnsFullyQualified, ComputerNameMax };
enum _FINDEX_INFO_LEVELS { FindExInfoStandard, FindExInfoBasic, FindExInfoMaxInfoLevel };
enum _FINDEX_SEARCH_OPS { FindExSearchNameMatch, FindExSearchLimitToDirectories, FindExSearchLimitToDevices, FindExSearchMaxSearchOp };
enum _GET_FILEEX_INFO_LEVELS { GetFileExInfoStandard, GetFileExMaxInfoLevel };

struct _GUID {
	unsigned long Data1;
	unsigned short Data2;
	unsigned short Data3;
	unsigned char Data4[8];
};
enum _HEAP_INFORMATION_CLASS { HeapCompatibilityInformation, HeapEnableTerminationOnCorruption };
enum _JOBOBJECTINFOCLASS { JobObjectBasicAccountingInformation = 1, JobObjectBasicLimitInformation, JobObjectBasicProcessIdList, JobObjectBasicUIRestrictions, JobObjectSecurityLimitInformation, JobObjectEndOfJobTimeInformation, JobObjectAssociateCompletionPortInformation, JobObjectBasicAndIoAccountingInformation, JobObjectExtendedLimitInformation, JobObjectJobSetInformation, JobObjectGroupInformation, MaxJobObjectInfoClass };

struct _LIST_ENTRY {
	struct _LIST_ENTRY *Flink;
	struct _LIST_ENTRY *Blink;
};
enum _OBJECT_INFORMATION_CLASS { ObjectBasicInformation, ObjectTypeInformation = 2 };
enum _PROCESSINFOCLASS { ProcessBasicInformation, ProcessWow64Information = 26 };

struct _RASTERIZER_STATUS {
	short nSize;
	short wFlags;
	short nLanguageID;
};
enum _SC_ENUM_TYPE { SC_ENUM_PROCESS_INFO };
enum _SC_STATUS_TYPE { SC_STATUS_PROCESS_INFO };
enum _SECURITY_IMPERSONATION_LEVEL { SecurityAnonymous, SecurityIdentification, SecurityImpersonation, SecurityDelegation };
enum _SID_NAME_USE { SidTypeUser = 1, SidTypeGroup, SidTypeDomain, SidTypeAlias, SidTypeWellKnownGroup, SidTypeDeletedAccount, SidTypeInvalid, SidTypeUnknown, SidTypeComputer, SidTypeLabel };

struct _SINGLE_LIST_ENTRY {
	struct _SINGLE_LIST_ENTRY *Next;
};
enum _SYSTEM_INFORMATION_CLASS { SystemBasicInformation, SystemPerformanceInformation = 2, SystemTimeOfDayInformation, SystemProcessInformation = 5, SystemProcessorPerformanceInformation = 8, SystemInterruptInformation = 23, SystemExceptionInformation = 33, SystemRegistryQuotaInformation = 37, SystemLookasideInformation = 45 };
enum _THREADINFOCLASS { ThreadIsIoPending = 16 };
enum _TOKEN_INFORMATION_CLASS { TokenUser = 1, TokenGroups, TokenPrivileges, TokenOwner, TokenPrimaryGroup, TokenDefaultDacl, TokenSource, TokenType, TokenImpersonationLevel, TokenStatistics, TokenRestrictedSids, TokenSessionId, TokenGroupsAndPrivileges, TokenSessionReference, TokenSandBoxInert, TokenAuditPolicy, TokenOrigin, TokenElevationType, TokenLinkedToken, TokenElevation, TokenHasRestrictions, TokenAccessInformation, TokenVirtualizationAllowed, TokenVirtualizationEnabled, TokenIntegrityLevel, TokenUIAccess, TokenMandatoryPolicy, TokenLogonSid, MaxTokenInfoClass };
enum _TOKEN_TYPE { TokenPrimary = 1, TokenImpersonation };
__cdecl int ___mb_cur_max_func(void);
__cdecl int __isascii(int _C);
extern int __mb_cur_max;
__cdecl int _abnormal_termination(void);
__cdecl int _isctype(int _C, int _Type);
extern const unsigned short *_pctype;
__cdecl unsigned int _rotl(unsigned int Value __attribute__((in)), int Shift __attribute__((in)));
__cdecl int _strcmpi(const char *_Str1, const char *_Str2);
__cdecl char *_strdup(const char *_Src);
__cdecl char *_strerror __attribute__((deprecated))(const char *_ErrMsg);
__cdecl int _stricmp(const char *_Str1, const char *_Str2);
__cdecl int _stricoll(const char *_Str1, const char *_Str2);
__cdecl char *_strlwr __attribute__((deprecated))(char *_String);
__cdecl char *_strrev(char *_Str);
__cdecl char *_strupr __attribute__((deprecated))(char *_String);
__cdecl int _tolower(int _C);
__cdecl int _toupper(int _C);
__cdecl int isalnum(int _C);
__cdecl int isalpha(int _C);
__cdecl int iscntrl(int _C);
__cdecl int isdigit(int _C);
__cdecl int isgraph(int _C);
__cdecl int isleadbyte(int _C);
__cdecl int islower(int _C);
__cdecl int isprint(int _C);
__cdecl int ispunct(int _C);
__cdecl int isspace(int _C);
__cdecl int isupper(int _C);
__cdecl int isxdigit(int _C);
typedef unsigned int size_t;
__cdecl char *strcat __attribute__((deprecated))(char *_Dest, const char *_Source);
__cdecl char *strchr(const char *_Str, int _Val);
__cdecl int strcmp(const char *_Str1, const char *_Str2);
__cdecl int strcoll(const char *_Str1, const char *_Str2);
__cdecl char *strcpy __attribute__((deprecated))(char *_Dest, const char *_Source);
__cdecl char *strerror __attribute__((deprecated))(int);
__cdecl char *strpbrk(const char *_Str, const char *_Control);
__cdecl char *strrchr(const char *_Str, int _Ch);
__cdecl char *strstr(const char *_Str, const char *_SubStr);
__cdecl char *strtok __attribute__((deprecated))(char *_Str, const char *_Delim);
__cdecl int tolower(int _C);
__cdecl int toupper(int _C);
typedef char *va_list;
typedef unsigned short wchar_t;
typedef unsigned short wctype_t;
typedef unsigned short wint_t;


typedef DWORD ACCESS_MASK;
typedef enum _ACL_INFORMATION_CLASS ACL_INFORMATION_CLASS;
typedef WORD ATOM;
__stdcall BOOL ActivateActCtx __attribute__((dllimport))(HANDLE hActCtx, ULONG_PTR *lpCookie __attribute__((out)));
__stdcall void AddRefActCtx __attribute__((dllimport))(HANDLE hActCtx);
__stdcall BOOL AllocConsole __attribute__((dllimport))(void);
__stdcall BOOL AllowSetForegroundWindow __attribute__((dllimport))(DWORD dwProcessId __attribute__((in)));
__stdcall BOOL AnyPopup __attribute__((dllimport))(void);
__stdcall BOOL AreAllAccessesGranted __attribute__((dllimport))(DWORD GrantedAccess __attribute__((in)), DWORD DesiredAccess __attribute__((in)));
__stdcall BOOL AreAnyAccessesGranted __attribute__((dllimport))(DWORD GrantedAccess __attribute__((in)), DWORD DesiredAccess __attribute__((in)));
__stdcall BOOL AreFileApisANSI __attribute__((dllimport))(void);
__stdcall BOOL AssignProcessToJobObject __attribute__((dllimport))(HANDLE hJob __attribute__((in)), HANDLE hProcess __attribute__((in)));
__stdcall BOOL AttachThreadInput __attribute__((dllimport))(DWORD idAttach __attribute__((in)), DWORD idAttachTo __attribute__((in)), BOOL fAttach __attribute__((in)));
typedef BYTE BOOLEAN;
__stdcall BOOL Beep __attribute__((dllimport))(DWORD dwFreq __attribute__((in)), DWORD dwDuration __attribute__((in)));
typedef DWORD CALID;
typedef DWORD CALTYPE;
typedef USHORT COLOR16;
typedef DWORD COLORREF;
typedef enum _COMPUTER_NAME_FORMAT COMPUTER_NAME_FORMAT;
__stdcall BOOL CancelIo __attribute__((dllimport))(HANDLE hFile __attribute__((in)));
__stdcall BOOL CancelWaitableTimer __attribute__((dllimport))(HANDLE hTimer __attribute__((in)));
__stdcall BOOL ChangeTimerQueueTimer __attribute__((dllimport))(HANDLE TimerQueue __attribute__((in)), HANDLE Timer, ULONG DueTime __attribute__((in)), ULONG Period __attribute__((in)));
__stdcall BOOL ClearCommBreak __attribute__((dllimport))(HANDLE hFile __attribute__((in)));
__stdcall BOOL CloseClipboard __attribute__((dllimport))(void);
__stdcall void CloseEncryptedFileRaw __attribute__((dllimport))(PVOID pvContext __attribute__((in)));
__stdcall BOOL CloseEventLog __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)));
__stdcall BOOL CloseHandle __attribute__((dllimport))(HANDLE hObject __attribute__((in)));
__stdcall BOOL ContinueDebugEvent __attribute__((dllimport))(DWORD dwProcessId __attribute__((in)), DWORD dwThreadId __attribute__((in)), DWORD dwContinueStatus __attribute__((in)));
__stdcall BOOL ConvertFiberToThread __attribute__((dllimport))(void);
__stdcall LPVOID ConvertThreadToFiber __attribute__((dllimport)) __attribute__((out))(LPVOID lpParameter __attribute__((in)));
__stdcall HANDLE CopyImage __attribute__((dllimport))(HANDLE h __attribute__((in)), UINT type __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), UINT flags __attribute__((in)));
__stdcall HANDLE CreateIoCompletionPort __attribute__((dllimport)) __attribute__((out))(HANDLE FileHandle __attribute__((in)), HANDLE ExistingCompletionPort __attribute__((in)), ULONG_PTR CompletionKey __attribute__((in)), DWORD NumberOfConcurrentThreads __attribute__((in)));
__stdcall HANDLE CreateTimerQueue __attribute__((dllimport)) __attribute__((out))(void);
typedef
struct {
	DWORD style;
	DWORD dwExtendedStyle;
	WORD cdit;
	short x;
	short y;
	short cx;
	short cy;
} __attribute__((pack(2))) DLGTEMPLATE;
typedef ULONGLONG DWORDLONG;
typedef ULONG_PTR DWORD_PTR;
__stdcall BOOL DeactivateActCtx __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), ULONG_PTR ulCookie __attribute__((in)));
__stdcall BOOL DebugActiveProcess __attribute__((dllimport))(DWORD dwProcessId __attribute__((in)));
__stdcall void DeleteFiber __attribute__((dllimport))(LPVOID lpFiber __attribute__((in)));
__stdcall BOOL DeleteObject __attribute__((dllimport))(HGDIOBJ ho __attribute__((in)));
__stdcall BOOL DeleteTimerQueue __attribute__((dllimport))(HANDLE TimerQueue __attribute__((in)));
__stdcall BOOL DeleteTimerQueueEx __attribute__((dllimport))(HANDLE TimerQueue __attribute__((in)), HANDLE CompletionEvent __attribute__((in)));
__stdcall BOOL DeleteTimerQueueTimer __attribute__((dllimport))(HANDLE TimerQueue __attribute__((in)), HANDLE Timer __attribute__((in)), HANDLE CompletionEvent __attribute__((in)));
__stdcall BOOL DeregisterEventSource __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)));
__stdcall BOOL DestroyCaret __attribute__((dllimport))(void);
__stdcall BOOL DisconnectNamedPipe __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)));
typedef DWORD EXECUTION_STATE;
__stdcall BOOL EmptyClipboard __attribute__((dllimport))(void);
__stdcall BOOL EndMenu __attribute__((dllimport))(void);
__stdcall BOOL EndUpdateResourceA __attribute__((dllimport))(HANDLE hUpdate __attribute__((in)), BOOL fDiscard __attribute__((in)));
__stdcall UINT EnumClipboardFormats __attribute__((dllimport))(UINT format __attribute__((in)));
__stdcall DWORD EraseTape __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwEraseType __attribute__((in)), BOOL bImmediate __attribute__((in)));
__stdcall BOOL EscapeCommFunction __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwFunc __attribute__((in)));
__noreturn __stdcall void ExitProcess __attribute__((dllimport))(UINT uExitCode __attribute__((in)));
__noreturn __stdcall void ExitThread __attribute__((dllimport))(DWORD dwExitCode __attribute__((in)));
__stdcall BOOL ExitWindowsEx __attribute__((dllimport))(UINT uFlags __attribute__((in)), DWORD dwReason __attribute__((in)));
typedef enum _FINDEX_INFO_LEVELS FINDEX_INFO_LEVELS;
typedef enum _FINDEX_SEARCH_OPS FINDEX_SEARCH_OPS;
__stdcall BOOL FindClose __attribute__((dllimport))(HANDLE hFindFile);
__stdcall BOOL FindCloseChangeNotification __attribute__((dllimport))(HANDLE hChangeHandle __attribute__((in)));
__stdcall BOOL FindNextChangeNotification __attribute__((dllimport))(HANDLE hChangeHandle __attribute__((in)));
__stdcall BOOL FindVolumeClose __attribute__((dllimport))(HANDLE hFindVolume __attribute__((in)));
__stdcall BOOL FindVolumeMountPointClose __attribute__((dllimport))(HANDLE hFindVolumeMountPoint __attribute__((in)));
__stdcall BOOL FlushConsoleInputBuffer __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)));
__stdcall BOOL FlushFileBuffers __attribute__((dllimport))(HANDLE hFile __attribute__((in)));
__stdcall BOOL FreeConsole __attribute__((dllimport))(void);
typedef DWORD GEOCLASS;
typedef LONG GEOID;
typedef DWORD GEOTYPE;
typedef enum _GET_FILEEX_INFO_LEVELS GET_FILEEX_INFO_LEVELS;
typedef struct _GUID GUID;
__stdcall BOOL GdiFlush __attribute__((dllimport))(void);
__stdcall DWORD GdiSetBatchLimit __attribute__((dllimport))(DWORD dw __attribute__((in)));
__stdcall BOOL GenerateConsoleCtrlEvent __attribute__((dllimport))(DWORD dwCtrlEvent __attribute__((in)), DWORD dwProcessGroupId __attribute__((in)));
__stdcall UINT GetACP __attribute__((dllimport))(void);
__stdcall SHORT GetAsyncKeyState __attribute__((dllimport))(int vKey __attribute__((in)));
__stdcall UINT GetCaretBlinkTime __attribute__((dllimport))(void);
__stdcall HANDLE GetClipboardData __attribute__((dllimport))(UINT uFormat __attribute__((in)));
__stdcall DWORD GetClipboardSequenceNumber __attribute__((dllimport))(void);
__stdcall DWORD GetConsoleAliasExesLengthW __attribute__((dllimport))(void);
__stdcall UINT GetConsoleCP __attribute__((dllimport))(void);
__stdcall UINT GetConsoleOutputCP __attribute__((dllimport))(void);
__stdcall BOOL GetCurrentActCtx __attribute__((dllimport))(HANDLE *lphActCtx);
__stdcall HANDLE GetCurrentProcess __attribute__((dllimport)) __attribute__((out))(void);
__stdcall DWORD GetCurrentProcessId __attribute__((dllimport))(void);
__stdcall HANDLE GetCurrentThread __attribute__((dllimport)) __attribute__((out))(void);
__stdcall DWORD GetCurrentThreadId __attribute__((dllimport))(void);
__stdcall UINT GetDoubleClickTime __attribute__((dllimport))(void);
__stdcall DWORD GetFileType __attribute__((dllimport))(HANDLE hFile __attribute__((in)));
__stdcall DWORD GetGuiResources __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), DWORD uiFlags __attribute__((in)));
__stdcall BOOL GetInputState __attribute__((dllimport))(void);
__stdcall UINT GetKBCodePage __attribute__((dllimport))(void);
__stdcall SHORT GetKeyState __attribute__((dllimport))(int nVirtKey __attribute__((in)));
__stdcall DWORD GetLastError __attribute__((dllimport))(void);
__stdcall DWORD GetLogicalDrives __attribute__((dllimport))(void);
__stdcall LONG GetMenuCheckMarkDimensions __attribute__((dllimport))(void);
__stdcall DWORD GetMessagePos __attribute__((dllimport))(void);
__stdcall LONG GetMessageTime __attribute__((dllimport))(void);
__stdcall UINT GetOEMCP __attribute__((dllimport))(void);
__stdcall int GetObjectA __attribute__((dllimport))(HANDLE h __attribute__((in)), int c __attribute__((in)), LPVOID pv);
__stdcall DWORD GetObjectType __attribute__((dllimport))(HGDIOBJ h __attribute__((in)));
__stdcall int GetObjectW __attribute__((dllimport))(HANDLE h __attribute__((in)), int c __attribute__((in)), LPVOID pv);
__stdcall DWORD GetPriorityClass __attribute__((dllimport))(HANDLE hProcess __attribute__((in)));
__stdcall int GetPriorityClipboardFormat __attribute__((dllimport))(UINT *paFormatPriorityList __attribute__((in)), int cFormats __attribute__((in)));
__stdcall BOOL GetProcessDefaultLayout __attribute__((dllimport))(DWORD *pdwDefaultLayout __attribute__((out)));
__stdcall HANDLE GetProcessHeap __attribute__((dllimport)) __attribute__((out))(void);
__stdcall DWORD GetProcessId __attribute__((dllimport))(HANDLE Process __attribute__((in)));
__stdcall DWORD GetProcessVersion __attribute__((dllimport))(DWORD ProcessId __attribute__((in)));
__stdcall DWORD GetQueueStatus __attribute__((dllimport))(UINT flags __attribute__((in)));
__stdcall UINT GetRawInputDeviceInfoW __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), UINT uiCommand __attribute__((in)), LPVOID pData, PUINT pcbSize);
__stdcall DWORD GetSidLengthRequired __attribute__((dllimport))(UCHAR nSubAuthorityCount __attribute__((in)));
__stdcall HANDLE GetStdHandle __attribute__((dllimport))(DWORD nStdHandle __attribute__((in)));
__stdcall HGDIOBJ GetStockObject __attribute__((dllimport))(int i __attribute__((in)));
__stdcall DWORD GetSysColor __attribute__((dllimport))(int nIndex __attribute__((in)));
__stdcall DWORD GetTapeStatus __attribute__((dllimport))(HANDLE hDevice __attribute__((in)));
__stdcall int GetThreadPriority __attribute__((dllimport))(HANDLE hThread __attribute__((in)));
__stdcall DWORD GetTickCount __attribute__((dllimport))(void);
__stdcall DWORD GetVersion __attribute__((dllimport))(void);
typedef struct HACCEL__ *HACCEL;
typedef struct HBITMAP__ *HBITMAP;
typedef struct HBRUSH__ *HBRUSH;
typedef struct HCOLORSPACE__ *HCOLORSPACE;
typedef struct HDC__ *HDC;
typedef struct HDESK__ *HDESK;
typedef PVOID HDEVNOTIFY;
typedef HANDLE HDWP;
typedef enum _HEAP_INFORMATION_CLASS HEAP_INFORMATION_CLASS;
typedef struct HENHMETAFILE__ *HENHMETAFILE;
typedef struct HFONT__ *HFONT;
typedef HANDLE HGLOBAL;
typedef struct HHOOK__ *HHOOK;
typedef struct HICON__ *HICON;
typedef struct HIMC__ *HIMC;
typedef struct HINSTANCE__ *HINSTANCE;
typedef struct HKEY__ *HKEY;
typedef struct HKL__ *HKL;
typedef HANDLE HLOCAL;
typedef struct HMENU__ *HMENU;
typedef struct HMETAFILE__ *HMETAFILE;
typedef struct HMONITOR__ *HMONITOR;
typedef struct HPALETTE__ *HPALETTE;
typedef struct HPEN__ *HPEN;
typedef struct HRAWINPUT__ *HRAWINPUT;
typedef struct HRGN__ *HRGN;
typedef struct HRSRC__ *HRSRC;
typedef struct HWINEVENTHOOK__ *HWINEVENTHOOK;
typedef struct HWINSTA__ *HWINSTA;
typedef struct HWND__ *HWND;
__stdcall BOOL HeapDestroy __attribute__((dllimport))(HANDLE hHeap __attribute__((in)));
__stdcall BOOL HeapFree __attribute__((dllimport))(HANDLE hHeap, DWORD dwFlags __attribute__((in)), LPVOID lpMem);
__stdcall BOOL HeapLock __attribute__((dllimport))(HANDLE hHeap __attribute__((in)));
__stdcall BOOL HeapUnlock __attribute__((dllimport))(HANDLE hHeap __attribute__((in)));
__stdcall BOOL HeapValidate __attribute__((dllimport))(HANDLE hHeap __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCVOID lpMem __attribute__((in)));
__stdcall BOOL ImmDisableIME(DWORD __attribute__((in)));
__stdcall BOOL ImmDisableTextFrameService(DWORD idThread);
__stdcall BOOL ImpersonateAnonymousToken __attribute__((dllimport))(HANDLE ThreadHandle __attribute__((in)));
__stdcall BOOL ImpersonateLoggedOnUser __attribute__((dllimport))(HANDLE hToken __attribute__((in)));
__stdcall BOOL ImpersonateNamedPipeClient __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)));
__stdcall BOOL InSendMessage __attribute__((dllimport))(void);
__stdcall DWORD InSendMessageEx __attribute__((dllimport))(LPVOID lpReserved);
__stdcall BOOL InitAtomTable __attribute__((dllimport))(DWORD nSize __attribute__((in)));
__stdcall LONG InterlockedCompareExchange __attribute__((dllimport))(volatile LONG *Destination, LONG Exchange __attribute__((in)), LONG Comperand __attribute__((in)));
__stdcall LONG InterlockedDecrement __attribute__((dllimport))(volatile LONG *lpAddend);
__stdcall LONG InterlockedExchange __attribute__((dllimport))(volatile LONG *Target, LONG Value __attribute__((in)));
__stdcall LONG InterlockedExchangeAdd __attribute__((dllimport))(volatile LONG *Addend, LONG Value __attribute__((in)));
__stdcall LONG InterlockedIncrement __attribute__((dllimport))(volatile LONG *lpAddend);
__stdcall BOOL IsBadCodePtr __attribute__((dllimport))(FARPROC lpfn __attribute__((in)));
__stdcall BOOL IsBadHugeReadPtr __attribute__((dllimport))(const void *lp __attribute__((in)), UINT_PTR ucb __attribute__((in)));
__stdcall BOOL IsBadHugeWritePtr __attribute__((dllimport))(LPVOID lp __attribute__((in)), UINT_PTR ucb __attribute__((in)));
__stdcall BOOL IsBadReadPtr __attribute__((dllimport))(const void *lp __attribute__((in)), UINT_PTR ucb __attribute__((in)));
__stdcall BOOL IsBadWritePtr __attribute__((dllimport))(LPVOID lp __attribute__((in)), UINT_PTR ucb __attribute__((in)));
__stdcall BOOL IsCharAlphaA __attribute__((dllimport))(CHAR ch __attribute__((in)));
__stdcall BOOL IsCharAlphaNumericA __attribute__((dllimport))(CHAR ch __attribute__((in)));
__stdcall BOOL IsCharLowerA __attribute__((dllimport))(CHAR ch __attribute__((in)));
__stdcall BOOL IsCharUpperA __attribute__((dllimport))(CHAR ch __attribute__((in)));
__stdcall BOOL IsClipboardFormatAvailable __attribute__((dllimport))(UINT format __attribute__((in)));
__stdcall BOOL IsDBCSLeadByte __attribute__((dllimport))(BYTE TestChar __attribute__((in)));
__stdcall BOOL IsDBCSLeadByteEx __attribute__((dllimport))(UINT CodePage __attribute__((in)), BYTE TestChar __attribute__((in)));
__stdcall BOOL IsDebuggerPresent __attribute__((dllimport))(void);
__stdcall BOOL IsProcessorFeaturePresent __attribute__((dllimport))(DWORD ProcessorFeature __attribute__((in)));
__stdcall BOOL IsTextUnicode __attribute__((dllimport))(const void *lpv __attribute__((in)), int iSize __attribute__((in)), LPINT lpiResult);
__stdcall BOOL IsTokenRestricted __attribute__((dllimport))(HANDLE TokenHandle __attribute__((in)));
__stdcall BOOL IsValidCodePage __attribute__((dllimport))(UINT CodePage __attribute__((in)));
__stdcall BOOL IsWinEventHookInstalled __attribute__((dllimport))(DWORD event __attribute__((in)));
typedef enum _JOBOBJECTINFOCLASS JOBOBJECTINFOCLASS;
typedef WORD LANGID;
typedef DWORD LCID;
typedef LONG LCSCSTYPE;
typedef LONG LCSGAMUTMATCH;
typedef DWORD LCTYPE;
typedef DWORD LGRPID;
typedef struct _LIST_ENTRY LIST_ENTRY;
typedef LONG_PTR LPARAM;
typedef BOOL *LPBOOL;
typedef BYTE *LPBYTE;
typedef const CHAR *LPCCH;
typedef CHAR *LPCH;
typedef const CHAR *LPCSTR;
typedef DWORD *LPDWORD;
typedef HANDLE *LPHANDLE;
typedef __stdcall void (*LPHANDLER_FUNCTION)(DWORD dwControl);
typedef __stdcall DWORD (*LPHANDLER_FUNCTION_EX)(DWORD dwControl, DWORD dwEventType, LPVOID lpEventData, LPVOID lpContext);
typedef struct _RASTERIZER_STATUS *LPRASTERIZER_STATUS;
typedef CHAR *LPSTR;
typedef WORD *LPWORD;
typedef LONG_PTR LRESULT;
typedef LONG LSTATUS;
__stdcall BOOL LockFile __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwFileOffsetLow __attribute__((in)), DWORD dwFileOffsetHigh __attribute__((in)), DWORD nNumberOfBytesToLockLow __attribute__((in)), DWORD nNumberOfBytesToLockHigh __attribute__((in)));
__stdcall BOOL LockSetForegroundWindow __attribute__((dllimport))(UINT uLockCode __attribute__((in)));
__stdcall BOOL LockWorkStation __attribute__((dllimport))(void);
__stdcall UINT MapVirtualKeyA __attribute__((dllimport))(UINT uCode __attribute__((in)), UINT uMapType __attribute__((in)));
__stdcall UINT MapVirtualKeyW __attribute__((dllimport))(UINT uCode __attribute__((in)), UINT uMapType __attribute__((in)));
__stdcall BOOL MessageBeep __attribute__((dllimport))(UINT uType __attribute__((in)));
__stdcall DWORD MsgWaitForMultipleObjects __attribute__((dllimport))(DWORD nCount __attribute__((in)), const HANDLE *pHandles __attribute__((in)), BOOL fWaitAll __attribute__((in)), DWORD dwMilliseconds __attribute__((in)), DWORD dwWakeMask __attribute__((in)));
__stdcall DWORD MsgWaitForMultipleObjectsEx __attribute__((dllimport))(DWORD nCount __attribute__((in)), const HANDLE *pHandles __attribute__((in)), DWORD dwMilliseconds __attribute__((in)), DWORD dwWakeMask __attribute__((in)), DWORD dwFlags __attribute__((in)));
typedef LONG NTSTATUS;
__stdcall BOOL NotifyBootConfigStatus __attribute__((dllimport))(BOOL BootAcceptable __attribute__((in)));
__stdcall BOOL NotifyChangeEventLog __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), HANDLE hEvent __attribute__((in)));
typedef enum _OBJECT_INFORMATION_CLASS OBJECT_INFORMATION_CLASS;
__stdcall DWORD OemKeyScan __attribute__((dllimport))(WORD wOemChar __attribute__((in)));
__stdcall HANDLE OpenProcess __attribute__((dllimport))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), DWORD dwProcessId __attribute__((in)));
__stdcall HANDLE OpenThread __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), DWORD dwThreadId __attribute__((in)));
typedef __stdcall void (*PAPCFUNC)(ULONG_PTR Parameter __attribute__((in)));
typedef BOOL *PBOOL;
typedef BYTE *PBYTE;
typedef CHAR *PCHAR;
typedef const CHAR *PCNZCH;
typedef DWORD *PDWORD;
typedef ULONG_PTR *PDWORD_PTR;
typedef __stdcall void (*PFIBER_START_ROUTINE)(LPVOID lpFiberParameter);
typedef FLOAT *PFLOAT;
typedef HANDLE *PHANDLE;
typedef __stdcall BOOL (*PHANDLER_ROUTINE)(DWORD CtrlType __attribute__((in)));
typedef LONG *PLONG;
typedef enum _PROCESSINFOCLASS PROCESSINFOCLASS;
typedef PVOID PSECURITY_DESCRIPTOR;
typedef WORD *PSECURITY_DESCRIPTOR_CONTROL;
typedef DWORD *PSECURITY_INFORMATION;
typedef PVOID PSID;
typedef enum _SID_NAME_USE *PSID_NAME_USE;
typedef struct _SINGLE_LIST_ENTRY *PSINGLE_LIST_ENTRY;
typedef ULONG_PTR *PSIZE_T;
typedef CHAR *PSTR;
typedef __stdcall DWORD (*PTHREAD_START_ROUTINE)(LPVOID lpThreadParameter);
typedef __stdcall void (*PTIMERAPCROUTINE)(LPVOID lpArgToCompletionRoutine __attribute__((in)), DWORD dwTimerLowValue __attribute__((in)), DWORD dwTimerHighValue __attribute__((in)));
typedef UCHAR *PUCHAR;
typedef ULONG *PULONG;
__stdcall DWORD PrepareTape __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwOperation __attribute__((in)), BOOL bImmediate __attribute__((in)));
__stdcall BOOL ProcessIdToSessionId __attribute__((dllimport))(DWORD dwProcessId __attribute__((in)), DWORD *pSessionId __attribute__((out)));
__stdcall BOOL PulseEvent __attribute__((dllimport))(HANDLE hEvent __attribute__((in)));
__stdcall BOOL PurgeComm __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall void RaiseException __attribute__((dllimport))(DWORD dwExceptionCode __attribute__((in)), DWORD dwExceptionFlags __attribute__((in)), DWORD nNumberOfArguments __attribute__((in)), const ULONG_PTR *lpArguments __attribute__((in)));
__stdcall BOOL ReadEventLogA __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), DWORD dwReadFlags __attribute__((in)), DWORD dwRecordOffset __attribute__((in)), LPVOID lpBuffer, DWORD nNumberOfBytesToRead __attribute__((in)), DWORD *pnBytesRead __attribute__((out)), DWORD *pnMinNumberOfBytesNeeded __attribute__((out)));
__stdcall BOOL ReadEventLogW __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), DWORD dwReadFlags __attribute__((in)), DWORD dwRecordOffset __attribute__((in)), LPVOID lpBuffer, DWORD nNumberOfBytesToRead __attribute__((in)), DWORD *pnBytesRead __attribute__((out)), DWORD *pnMinNumberOfBytesNeeded __attribute__((out)));
__stdcall void ReleaseActCtx __attribute__((dllimport))(HANDLE hActCtx);
__stdcall BOOL ReleaseCapture __attribute__((dllimport))(void);
__stdcall BOOL ReleaseMutex __attribute__((dllimport))(HANDLE hMutex __attribute__((in)));
__stdcall BOOL ReleaseSemaphore __attribute__((dllimport))(HANDLE hSemaphore __attribute__((in)), LONG lReleaseCount __attribute__((in)), LPLONG lpPreviousCount __attribute__((out)));
__stdcall BOOL ResetEvent __attribute__((dllimport))(HANDLE hEvent __attribute__((in)));
__stdcall DWORD ResumeThread __attribute__((dllimport))(HANDLE hThread __attribute__((in)));
__stdcall BOOL RevertToSelf __attribute__((dllimport))(void);
__stdcall PVOID RtlPcToFileHeader __attribute__((dllimport))(PVOID PcValue __attribute__((in)), PVOID *BaseOfImage __attribute__((out)));
typedef enum _SC_ENUM_TYPE SC_ENUM_TYPE;
typedef struct SC_HANDLE__ *SC_HANDLE;
typedef LPVOID SC_LOCK;
typedef enum _SC_STATUS_TYPE SC_STATUS_TYPE;
typedef WORD SECURITY_DESCRIPTOR_CONTROL;
typedef enum _SECURITY_IMPERSONATION_LEVEL SECURITY_IMPERSONATION_LEVEL;
typedef DWORD SECURITY_INFORMATION;
typedef struct SERVICE_STATUS_HANDLE__ *SERVICE_STATUS_HANDLE;
typedef struct _SINGLE_LIST_ENTRY SINGLE_LIST_ENTRY;
typedef ULONG_PTR SIZE_T;
typedef enum _SYSTEM_INFORMATION_CLASS SYSTEM_INFORMATION_CLASS;
__stdcall BOOL SetCaretBlinkTime __attribute__((dllimport))(UINT uMSeconds __attribute__((in)));
__stdcall BOOL SetCaretPos __attribute__((dllimport))(int X __attribute__((in)), int Y __attribute__((in)));
__stdcall HANDLE SetClipboardData __attribute__((dllimport))(UINT uFormat __attribute__((in)), HANDLE hMem __attribute__((in)));
__stdcall BOOL SetCommBreak __attribute__((dllimport))(HANDLE hFile __attribute__((in)));
__stdcall BOOL SetCommMask __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwEvtMask __attribute__((in)));
__stdcall BOOL SetConsoleActiveScreenBuffer __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)));
__stdcall BOOL SetConsoleCP __attribute__((dllimport))(UINT wCodePageID __attribute__((in)));
__stdcall BOOL SetConsoleMode __attribute__((dllimport))(HANDLE hConsoleHandle __attribute__((in)), DWORD dwMode __attribute__((in)));
__stdcall BOOL SetConsoleOutputCP __attribute__((dllimport))(UINT wCodePageID __attribute__((in)));
__stdcall BOOL SetConsoleTextAttribute __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), WORD wAttributes __attribute__((in)));
__stdcall BOOL SetCursorPos __attribute__((dllimport))(int X __attribute__((in)), int Y __attribute__((in)));
__stdcall BOOL SetDoubleClickTime __attribute__((dllimport))(UINT __attribute__((in)));
__stdcall BOOL SetEndOfFile __attribute__((dllimport))(HANDLE hFile __attribute__((in)));
__stdcall UINT SetErrorMode __attribute__((dllimport))(UINT uMode __attribute__((in)));
__stdcall BOOL SetEvent __attribute__((dllimport))(HANDLE hEvent __attribute__((in)));
__stdcall UINT SetHandleCount __attribute__((dllimport))(UINT uNumber __attribute__((in)));
__stdcall BOOL SetHandleInformation __attribute__((dllimport))(HANDLE hObject __attribute__((in)), DWORD dwMask __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall void SetLastError __attribute__((dllimport))(DWORD dwErrCode __attribute__((in)));
__stdcall void SetLastErrorEx __attribute__((dllimport))(DWORD dwErrCode __attribute__((in)), DWORD dwType __attribute__((in)));
__stdcall BOOL SetMailslotInfo __attribute__((dllimport))(HANDLE hMailslot __attribute__((in)), DWORD lReadTimeout __attribute__((in)));
__stdcall BOOL SetMessageQueue __attribute__((dllimport))(int cMessagesMax __attribute__((in)));
__stdcall BOOL SetPriorityClass __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), DWORD dwPriorityClass __attribute__((in)));
__stdcall BOOL SetProcessDefaultLayout __attribute__((dllimport))(DWORD dwDefaultLayout __attribute__((in)));
__stdcall BOOL SetProcessShutdownParameters __attribute__((dllimport))(DWORD dwLevel __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL SetStdHandle __attribute__((dllimport))(DWORD nStdHandle __attribute__((in)), HANDLE hHandle __attribute__((in)));
__stdcall BOOL SetSystemTimeAdjustment __attribute__((dllimport))(DWORD dwTimeAdjustment __attribute__((in)), BOOL bTimeAdjustmentDisabled __attribute__((in)));
__stdcall DWORD SetTapeParameters __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwOperation __attribute__((in)), LPVOID lpTapeInformation __attribute__((in)));
__stdcall DWORD SetTapePosition __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwPositionMethod __attribute__((in)), DWORD dwPartition __attribute__((in)), DWORD dwOffsetLow __attribute__((in)), DWORD dwOffsetHigh __attribute__((in)), BOOL bImmediate __attribute__((in)));
__stdcall DWORD SetThreadIdealProcessor __attribute__((dllimport))(HANDLE hThread __attribute__((in)), DWORD dwIdealProcessor __attribute__((in)));
__stdcall BOOL SetThreadPriority __attribute__((dllimport))(HANDLE hThread __attribute__((in)), int nPriority __attribute__((in)));
__stdcall BOOL SetThreadPriorityBoost __attribute__((dllimport))(HANDLE hThread __attribute__((in)), BOOL bDisablePriorityBoost __attribute__((in)));
__stdcall BOOL SetUserObjectInformationA __attribute__((dllimport))(HANDLE hObj __attribute__((in)), int nIndex __attribute__((in)), PVOID pvInfo __attribute__((in)), DWORD nLength __attribute__((in)));
__stdcall BOOL SetUserObjectInformationW __attribute__((dllimport))(HANDLE hObj __attribute__((in)), int nIndex __attribute__((in)), PVOID pvInfo __attribute__((in)), DWORD nLength __attribute__((in)));
__stdcall BOOL SetupComm __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwInQueue __attribute__((in)), DWORD dwOutQueue __attribute__((in)));
__stdcall int ShowCursor __attribute__((dllimport))(BOOL bShow __attribute__((in)));
__stdcall DWORD SignalObjectAndWait __attribute__((dllimport))(HANDLE hObjectToSignal __attribute__((in)), HANDLE hObjectToWaitOn __attribute__((in)), DWORD dwMilliseconds __attribute__((in)), BOOL bAlertable __attribute__((in)));
__stdcall void Sleep __attribute__((dllimport))(DWORD dwMilliseconds __attribute__((in)));
__stdcall DWORD SleepEx __attribute__((dllimport))(DWORD dwMilliseconds __attribute__((in)), BOOL bAlertable __attribute__((in)));
__stdcall DWORD SuspendThread __attribute__((dllimport))(HANDLE hThread __attribute__((in)));
__stdcall BOOL SwapMouseButton __attribute__((dllimport))(BOOL fSwap __attribute__((in)));
__stdcall void SwitchToFiber __attribute__((dllimport))(LPVOID lpFiber __attribute__((in)));
__stdcall BOOL SwitchToThread __attribute__((dllimport))(void);
__stdcall BOOL SystemParametersInfoA __attribute__((dllimport))(UINT uiAction __attribute__((in)), UINT uiParam __attribute__((in)), PVOID pvParam, UINT fWinIni __attribute__((in)));
__stdcall BOOL SystemParametersInfoW __attribute__((dllimport))(UINT uiAction __attribute__((in)), UINT uiParam __attribute__((in)), PVOID pvParam, UINT fWinIni __attribute__((in)));
typedef enum _THREADINFOCLASS THREADINFOCLASS;
typedef enum _TOKEN_INFORMATION_CLASS TOKEN_INFORMATION_CLASS;
typedef enum _TOKEN_TYPE TOKEN_TYPE;
__stdcall BOOL TerminateJobObject __attribute__((dllimport))(HANDLE hJob __attribute__((in)), UINT uExitCode __attribute__((in)));
__stdcall BOOL TerminateProcess __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), UINT uExitCode __attribute__((in)));
__stdcall BOOL TerminateThread __attribute__((dllimport))(HANDLE hThread __attribute__((in)), DWORD dwExitCode __attribute__((in)));
__stdcall DWORD TlsAlloc __attribute__((dllimport))(void);
__stdcall BOOL TlsFree __attribute__((dllimport))(DWORD dwTlsIndex __attribute__((in)));
__stdcall LPVOID TlsGetValue __attribute__((dllimport))(DWORD dwTlsIndex __attribute__((in)));
__stdcall BOOL TlsSetValue __attribute__((dllimport))(DWORD dwTlsIndex __attribute__((in)), LPVOID lpTlsValue __attribute__((in)));
__stdcall BOOL TransmitCommChar __attribute__((dllimport))(HANDLE hFile __attribute__((in)), char cChar __attribute__((in)));
__stdcall BOOL UnlockFile __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwFileOffsetLow __attribute__((in)), DWORD dwFileOffsetHigh __attribute__((in)), DWORD nNumberOfBytesToUnlockLow __attribute__((in)), DWORD nNumberOfBytesToUnlockHigh __attribute__((in)));
__stdcall BOOL UnmapViewOfFile __attribute__((dllimport))(LPCVOID lpBaseAddress __attribute__((in)));
__stdcall BOOL UnrealizeObject __attribute__((dllimport))(HGDIOBJ h __attribute__((in)));
__stdcall BOOL UnregisterWait __attribute__((dllimport))(HANDLE WaitHandle __attribute__((in)));
__stdcall BOOL UnregisterWaitEx __attribute__((dllimport))(HANDLE WaitHandle __attribute__((in)), HANDLE CompletionEvent __attribute__((in)));
__stdcall ULONGLONG VerSetConditionMask __attribute__((dllimport))(ULONGLONG ConditionMask __attribute__((in)), DWORD TypeMask __attribute__((in)), BYTE Condition __attribute__((in)));
__stdcall SHORT VkKeyScanA __attribute__((dllimport))(CHAR ch __attribute__((in)));
typedef wchar_t WCHAR;
__stdcall DWORD WNetCloseEnum(HANDLE hEnum __attribute__((in)));
typedef UINT_PTR WPARAM;
__stdcall DWORD WaitForInputIdle __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), DWORD dwMilliseconds __attribute__((in)));
__stdcall DWORD WaitForMultipleObjects __attribute__((dllimport))(DWORD nCount __attribute__((in)), const HANDLE *lpHandles __attribute__((in)), BOOL bWaitAll __attribute__((in)), DWORD dwMilliseconds __attribute__((in)));
__stdcall DWORD WaitForMultipleObjectsEx __attribute__((dllimport))(DWORD nCount __attribute__((in)), const HANDLE *lpHandles __attribute__((in)), BOOL bWaitAll __attribute__((in)), DWORD dwMilliseconds __attribute__((in)), BOOL bAlertable __attribute__((in)));
__stdcall DWORD WaitForSingleObject __attribute__((dllimport))(HANDLE hHandle __attribute__((in)), DWORD dwMilliseconds __attribute__((in)));
__stdcall DWORD WaitForSingleObjectEx __attribute__((dllimport))(HANDLE hHandle __attribute__((in)), DWORD dwMilliseconds __attribute__((in)), BOOL bAlertable __attribute__((in)));
__stdcall BOOL WaitMessage __attribute__((dllimport))(void);
__stdcall DWORD WriteTapemark __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwTapemarkType __attribute__((in)), DWORD dwTapemarkCount __attribute__((in)), BOOL bImmediate __attribute__((in)));

struct _ABC {
	int abcA;
	UINT abcB;
	int abcC;
};

struct _ABCFLOAT {
	FLOAT abcfA;
	FLOAT abcfB;
	FLOAT abcfC;
};

struct _ACL {
	BYTE AclRevision;
	BYTE Sbz1;
	WORD AclSize;
	WORD AceCount;
	WORD Sbz2;
};

struct _BLENDFUNCTION {
	BYTE BlendOp;
	BYTE BlendFlags;
	BYTE SourceConstantAlpha;
	BYTE AlphaFormat;
};

struct _COMMTIMEOUTS {
	DWORD ReadIntervalTimeout;
	DWORD ReadTotalTimeoutMultiplier;
	DWORD ReadTotalTimeoutConstant;
	DWORD WriteTotalTimeoutMultiplier;
	DWORD WriteTotalTimeoutConstant;
};

struct _COMSTAT {
	DWORD fCtsHold:1;
	DWORD fDsrHold:1;
	DWORD fRlsdHold:1;
	DWORD fXoffHold:1;
	DWORD fXoffSent:1;
	DWORD fEof:1;
	DWORD fTxim:1;
	DWORD fReserved:25;
	DWORD cbInQue;
	DWORD cbOutQue;
};

struct _CONSOLE_CURSOR_INFO {
	DWORD dwSize;
	BOOL bVisible;
};

struct _CONSOLE_READCONSOLE_CONTROL {
	ULONG nLength;
	ULONG nInitialChars;
	ULONG dwCtrlWakeupMask;
	ULONG dwControlKeyState;
};

struct _COORD {
	SHORT X;
	SHORT Y;
};

struct _DCB {
	DWORD DCBlength;
	DWORD BaudRate;
	DWORD fBinary:1;
	DWORD fParity:1;
	DWORD fOutxCtsFlow:1;
	DWORD fOutxDsrFlow:1;
	DWORD fDtrControl:2;
	DWORD fDsrSensitivity:1;
	DWORD fTXContinueOnXoff:1;
	DWORD fOutX:1;
	DWORD fInX:1;
	DWORD fErrorChar:1;
	DWORD fNull:1;
	DWORD fRtsControl:2;
	DWORD fAbortOnError:1;
	DWORD fDummy2:17;
	WORD wReserved;
	WORD XonLim;
	WORD XoffLim;
	BYTE ByteSize;
	BYTE Parity;
	BYTE StopBits;
	char XonChar;
	char XoffChar;
	char ErrorChar;
	char EofChar;
	char EvtChar;
	WORD wReserved1;
};

struct _DISPLAY_DEVICEA {
	DWORD cb;
	CHAR DeviceName[32];
	CHAR DeviceString[128];
	DWORD StateFlags;
	CHAR DeviceID[128];
	CHAR DeviceKey[128];
};

struct _EXCEPTION_RECORD {
	DWORD ExceptionCode;
	DWORD ExceptionFlags;
	struct _EXCEPTION_RECORD *ExceptionRecord;
	PVOID ExceptionAddress;
	DWORD NumberParameters;
	ULONG_PTR ExceptionInformation[15];
} __attribute__((pack(8)));

struct _EXIT_PROCESS_DEBUG_INFO {
	DWORD dwExitCode;
};

struct _EXIT_THREAD_DEBUG_INFO {
	DWORD dwExitCode;
};

struct _FILETIME {
	DWORD dwLowDateTime;
	DWORD dwHighDateTime;
};

struct _FIXED {
	WORD fract;
	short value;
};

struct _FLOATING_SAVE_AREA {
	DWORD ControlWord;
	DWORD StatusWord;
	DWORD TagWord;
	DWORD ErrorOffset;
	DWORD ErrorSelector;
	DWORD DataOffset;
	DWORD DataSelector;
	BYTE RegisterArea[80];
	DWORD Cr0NpxState;
};

struct _FOCUS_EVENT_RECORD {
	BOOL bSetFocus;
};

union _LARGE_INTEGER {

	struct {
		DWORD LowPart;
		LONG HighPart;
	} s;

	struct {
		DWORD LowPart;
		LONG HighPart;
	} u;
	LONGLONG QuadPart;
};

struct _LDT_ENTRY {
	WORD LimitLow;
	WORD BaseLow;

	union {

		struct {
			BYTE BaseMid;
			BYTE Flags1;
			BYTE Flags2;
			BYTE BaseHi;
		} Bytes;

		struct {
			DWORD BaseMid:8;
			DWORD Type:5;
			DWORD Dpl:2;
			DWORD Pres:1;
			DWORD LimitHi:4;
			DWORD Sys:1;
			DWORD Reserved_0:1;
			DWORD Default_Big:1;
			DWORD Granularity:1;
			DWORD BaseHi:8;
		} Bits;
	} HighWord;
};

struct _LOAD_DLL_DEBUG_INFO {
	HANDLE hFile;
	LPVOID lpBaseOfDll;
	DWORD dwDebugInfoFileOffset;
	DWORD nDebugInfoSize;
	LPVOID lpImageName;
	WORD fUnicode;
};

struct _LUID {
	DWORD LowPart;
	LONG HighPart;
};

struct _MENU_EVENT_RECORD {
	UINT dwCommandId;
};

struct _NETINFOSTRUCT {
	DWORD cbStructure;
	DWORD dwProviderVersion;
	DWORD dwStatus;
	DWORD dwCharacteristics;
	ULONG_PTR dwHandle;
	WORD wNetType;
	DWORD dwPrinters;
	DWORD dwDrives;
};

struct _OFSTRUCT {
	BYTE cBytes;
	BYTE fFixedDisk;
	WORD nErrCode;
	WORD Reserved1;
	WORD Reserved2;
	CHAR szPathName[128];
};

struct _OSVERSIONINFOA {
	DWORD dwOSVersionInfoSize;
	DWORD dwMajorVersion;
	DWORD dwMinorVersion;
	DWORD dwBuildNumber;
	DWORD dwPlatformId;
	CHAR szCSDVersion[128];
};

struct _OSVERSIONINFOEXA {
	DWORD dwOSVersionInfoSize;
	DWORD dwMajorVersion;
	DWORD dwMinorVersion;
	DWORD dwBuildNumber;
	DWORD dwPlatformId;
	CHAR szCSDVersion[128];
	WORD wServicePackMajor;
	WORD wServicePackMinor;
	WORD wSuiteMask;
	BYTE wProductType;
	BYTE wReserved;
};

struct _OVERLAPPED {
	ULONG_PTR Internal;
	ULONG_PTR InternalHigh;

	union {

		struct {
			DWORD Offset;
			DWORD OffsetHigh;
		} s;
		PVOID Pointer;
	} u;
	HANDLE hEvent;
};

struct _POINTL {
	LONG x;
	LONG y;
};

struct _PROCESS_HEAP_ENTRY {
	PVOID lpData;
	DWORD cbData;
	BYTE cbOverhead;
	BYTE iRegionIndex;
	WORD wFlags;

	union {

		struct {
			HANDLE hMem;
			DWORD dwReserved[3];
		} Block;

		struct {
			DWORD dwCommittedSize;
			DWORD dwUnCommittedSize;
			LPVOID lpFirstBlock;
			LPVOID lpLastBlock;
		} Region;
	} u;
};

struct _PROCESS_INFORMATION {
	HANDLE hProcess;
	HANDLE hThread;
	DWORD dwProcessId;
	DWORD dwThreadId;
};

struct _RECTL {
	LONG left;
	LONG top;
	LONG right;
	LONG bottom;
};

struct _RIP_INFO {
	DWORD dwError;
	DWORD dwType;
};

struct _SECURITY_ATTRIBUTES {
	DWORD nLength;
	LPVOID lpSecurityDescriptor;
	BOOL bInheritHandle;
};

struct _SERVICE_STATUS {
	DWORD dwServiceType;
	DWORD dwCurrentState;
	DWORD dwControlsAccepted;
	DWORD dwWin32ExitCode;
	DWORD dwServiceSpecificExitCode;
	DWORD dwCheckPoint;
	DWORD dwWaitHint;
};

struct _SID_IDENTIFIER_AUTHORITY {
	BYTE Value[6];
};

struct _SMALL_RECT {
	SHORT Left;
	SHORT Top;
	SHORT Right;
	SHORT Bottom;
};

struct _SYSTEMTIME {
	WORD wYear;
	WORD wMonth;
	WORD wDayOfWeek;
	WORD wDay;
	WORD wHour;
	WORD wMinute;
	WORD wSecond;
	WORD wMilliseconds;
};

struct _SYSTEM_POWER_STATUS {
	BYTE ACLineStatus;
	BYTE BatteryFlag;
	BYTE BatteryLifePercent;
	BYTE Reserved1;
	DWORD BatteryLifeTime;
	DWORD BatteryFullLifeTime;
};

union _ULARGE_INTEGER {

	struct {
		DWORD LowPart;
		DWORD HighPart;
	} s;

	struct {
		DWORD LowPart;
		DWORD HighPart;
	} u;
	ULONGLONG QuadPart;
};

struct _UNLOAD_DLL_DEBUG_INFO {
	LPVOID lpBaseOfDll;
};

struct _cpinfo {
	UINT MaxCharSize;
	BYTE DefaultChar[2];
	BYTE LeadByte[12];
};
__stdcall long _hread __attribute__((dllimport))(HFILE hFile __attribute__((in)), LPVOID lpBuffer, long lBytes __attribute__((in)));
__stdcall HFILE _lclose __attribute__((dllimport))(HFILE hFile __attribute__((in)));
__stdcall LONG _llseek __attribute__((dllimport))(HFILE hFile __attribute__((in)), LONG lOffset __attribute__((in)), int iOrigin __attribute__((in)));
__stdcall UINT _lread __attribute__((dllimport))(HFILE hFile __attribute__((in)), LPVOID lpBuffer, UINT uBytes __attribute__((in)));
__cdecl void *_memccpy(void *_Dst, const void *_Src, int _Val, size_t _MaxCount);
__cdecl int _memicmp(const void *_Buf1, const void *_Buf2, size_t _Size);
__cdecl int _strncoll(const char *_Str1, const char *_Str2, size_t _MaxCount);
__cdecl int _strnicmp(const char *_Str1, const char *_Str2, size_t _MaxCount);
__cdecl int _strnicoll(const char *_Str1, const char *_Str2, size_t _MaxCount);
__cdecl wchar_t *_wcsdup(const wchar_t *_Str);
__cdecl int _wcsicmp(const wchar_t *_Str1, const wchar_t *_Str2);
__cdecl int _wcsicoll(const wchar_t *_Str1, const wchar_t *_Str2);
__cdecl wchar_t *_wcslwr __attribute__((deprecated))(wchar_t *_String);
__cdecl int _wcsnicmp(const wchar_t *_Str1, const wchar_t *_Str2, size_t _MaxCount);
__cdecl wchar_t *_wcsnset __attribute__((deprecated))(wchar_t *_Str, wchar_t _Val, size_t _MaxCount);
__cdecl wchar_t *_wcsrev(wchar_t *_Str);
__cdecl wchar_t *_wcsset __attribute__((deprecated))(wchar_t *_Str, wchar_t _Val);
__cdecl wchar_t *_wcsupr __attribute__((deprecated))(wchar_t *_String);
__cdecl int iswalnum(wint_t _C);
__cdecl int iswalpha(wint_t _C);
__cdecl int iswascii(wint_t _C);
__cdecl int iswcntrl(wint_t _C);
__cdecl int iswctype(wint_t _C, wctype_t _Type);
__cdecl int iswdigit(wint_t _C);
__cdecl int iswgraph(wint_t _C);
__cdecl int iswlower(wint_t _C);
__cdecl int iswprint(wint_t _C);
__cdecl int iswpunct(wint_t _C);
__cdecl int iswspace(wint_t _C);
__cdecl int iswupper(wint_t _C);
__cdecl int iswxdigit(wint_t _C);
__stdcall void keybd_event __attribute__((dllimport))(BYTE bVk __attribute__((in)), BYTE bScan __attribute__((in)), DWORD dwFlags __attribute__((in)), ULONG_PTR dwExtraInfo __attribute__((in)));
__cdecl void *memchr(const void *_Buf, int _Val, size_t _MaxCount);
__cdecl int memcmp(const void *_Buf1, const void *_Buf2, size_t _Size);
__cdecl void *memcpy(void *_Dst, const void *_Src, size_t _Size);
__cdecl void *memmove(void *_Dst, const void *_Src, size_t _Size);
__cdecl void *memset(void *_Dst, int _Val, size_t _Size);
__stdcall void mouse_event __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), DWORD dx __attribute__((in)), DWORD dy __attribute__((in)), DWORD dwData __attribute__((in)), ULONG_PTR dwExtraInfo __attribute__((in)));
__cdecl size_t strcspn(const char *_Str, const char *_Control);
__cdecl size_t strlen(const char *_Str);
__cdecl char *strncat __attribute__((deprecated))(char *_Dest, const char *_Source, size_t _Count);
__cdecl int strncmp(const char *_Str1, const char *_Str2, size_t _MaxCount);
__cdecl char *strncpy __attribute__((deprecated))(char *_Dest, const char *_Source, size_t _Count);
__cdecl size_t strspn(const char *_Str, const char *_Control);

struct tagACCEL {
	BYTE fVirt;
	WORD key;
	WORD cmd;
};

struct tagACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA {
	PVOID lpInformation;
	PVOID lpSectionBase;
	ULONG ulSectionLength;
	PVOID lpSectionGlobalDataBase;
	ULONG ulSectionGlobalDataLength;
};

struct tagBITMAP {
	LONG bmType;
	LONG bmWidth;
	LONG bmHeight;
	LONG bmWidthBytes;
	WORD bmPlanes;
	WORD bmBitsPixel;
	LPVOID bmBits;
};

struct tagBITMAPINFOHEADER {
	DWORD biSize;
	LONG biWidth;
	LONG biHeight;
	WORD biPlanes;
	WORD biBitCount;
	DWORD biCompression;
	DWORD biSizeImage;
	LONG biXPelsPerMeter;
	LONG biYPelsPerMeter;
	DWORD biClrUsed;
	DWORD biClrImportant;
};

struct tagCANDIDATELIST {
	DWORD dwSize;
	DWORD dwStyle;
	DWORD dwCount;
	DWORD dwSelection;
	DWORD dwPageStart;
	DWORD dwPageSize;
	DWORD dwOffset[1];
};

struct tagCIEXYZ {
	FXPT2DOT30 ciexyzX;
	FXPT2DOT30 ciexyzY;
	FXPT2DOT30 ciexyzZ;
};

struct tagCOLORADJUSTMENT {
	WORD caSize;
	WORD caFlags;
	WORD caIlluminantIndex;
	WORD caRedGamma;
	WORD caGreenGamma;
	WORD caBlueGamma;
	WORD caReferenceBlack;
	WORD caReferenceWhite;
	SHORT caContrast;
	SHORT caBrightness;
	SHORT caColorfulness;
	SHORT caRedGreenTint;
};

struct tagDRAWTEXTPARAMS {
	UINT cbSize;
	int iTabLength;
	int iLeftMargin;
	int iRightMargin;
	UINT uiLengthDrawn;
};

struct tagENHMETARECORD {
	DWORD iType;
	DWORD nSize;
	DWORD dParm[1];
};

struct tagFONTSIGNATURE {
	DWORD fsUsb[4];
	DWORD fsCsb[2];
};

struct tagHANDLETABLE {
	HGDIOBJ objectHandle[1];
};

struct tagHARDWAREINPUT {
	DWORD uMsg;
	WORD wParamL;
	WORD wParamH;
};

struct tagHW_PROFILE_INFOA {
	DWORD dwDockInfo;
	CHAR szHwProfileGuid[39];
	CHAR szHwProfileName[80];
};

struct tagKERNINGPAIR {
	WORD wFirst;
	WORD wSecond;
	int iKernAmount;
};

struct tagKEYBDINPUT {
	WORD wVk;
	WORD wScan;
	DWORD dwFlags;
	DWORD time;
	ULONG_PTR dwExtraInfo;
};

struct tagLASTINPUTINFO {
	UINT cbSize;
	DWORD dwTime;
};

struct tagLOGFONTA {
	LONG lfHeight;
	LONG lfWidth;
	LONG lfEscapement;
	LONG lfOrientation;
	LONG lfWeight;
	BYTE lfItalic;
	BYTE lfUnderline;
	BYTE lfStrikeOut;
	BYTE lfCharSet;
	BYTE lfOutPrecision;
	BYTE lfClipPrecision;
	BYTE lfQuality;
	BYTE lfPitchAndFamily;
	CHAR lfFaceName[32];
};

struct tagMETARECORD {
	DWORD rdSize;
	WORD rdFunction;
	WORD rdParm[1];
};

struct tagMOUSEINPUT {
	LONG dx;
	LONG dy;
	DWORD mouseData;
	DWORD dwFlags;
	DWORD time;
	ULONG_PTR dwExtraInfo;
};

struct tagPALETTEENTRY {
	BYTE peRed;
	BYTE peGreen;
	BYTE peBlue;
	BYTE peFlags;
};

struct tagPANOSE {
	BYTE bFamilyType;
	BYTE bSerifStyle;
	BYTE bWeight;
	BYTE bProportion;
	BYTE bContrast;
	BYTE bStrokeVariation;
	BYTE bArmStyle;
	BYTE bLetterform;
	BYTE bMidline;
	BYTE bXHeight;
};

struct tagPIXELFORMATDESCRIPTOR {
	WORD nSize;
	WORD nVersion;
	DWORD dwFlags;
	BYTE iPixelType;
	BYTE cColorBits;
	BYTE cRedBits;
	BYTE cRedShift;
	BYTE cGreenBits;
	BYTE cGreenShift;
	BYTE cBlueBits;
	BYTE cBlueShift;
	BYTE cAlphaBits;
	BYTE cAlphaShift;
	BYTE cAccumBits;
	BYTE cAccumRedBits;
	BYTE cAccumGreenBits;
	BYTE cAccumBlueBits;
	BYTE cAccumAlphaBits;
	BYTE cDepthBits;
	BYTE cStencilBits;
	BYTE cAuxBuffers;
	BYTE iLayerType;
	BYTE bReserved;
	DWORD dwLayerMask;
	DWORD dwVisibleMask;
	DWORD dwDamageMask;
};

struct tagPOINT {
	LONG x;
	LONG y;
};

struct tagRAWINPUTDEVICELIST {
	HANDLE hDevice;
	DWORD dwType;
};

struct tagRECT {
	LONG left;
	LONG top;
	LONG right;
	LONG bottom;
};

struct tagRGBQUAD {
	BYTE rgbBlue;
	BYTE rgbGreen;
	BYTE rgbRed;
	BYTE rgbReserved;
};

struct tagSCROLLINFO {
	UINT cbSize;
	UINT fMask;
	int nMin;
	int nMax;
	UINT nPage;
	int nPos;
	int nTrackPos;
};

struct tagSIZE {
	LONG cx;
	LONG cy;
};

struct tagTEXTMETRICA {
	LONG tmHeight;
	LONG tmAscent;
	LONG tmDescent;
	LONG tmInternalLeading;
	LONG tmExternalLeading;
	LONG tmAveCharWidth;
	LONG tmMaxCharWidth;
	LONG tmWeight;
	LONG tmOverhang;
	LONG tmDigitizedAspectX;
	LONG tmDigitizedAspectY;
	BYTE tmFirstChar;
	BYTE tmLastChar;
	BYTE tmDefaultChar;
	BYTE tmBreakChar;
	BYTE tmItalic;
	BYTE tmUnderlined;
	BYTE tmStruckOut;
	BYTE tmPitchAndFamily;
	BYTE tmCharSet;
} __attribute__((pack(4)));

struct tagXFORM {
	FLOAT eM11;
	FLOAT eM12;
	FLOAT eM21;
	FLOAT eM22;
	FLOAT eDx;
	FLOAT eDy;
};
__cdecl wint_t towlower(wint_t _C);
__cdecl wint_t towupper(wint_t _C);
__cdecl wchar_t *wcscat __attribute__((deprecated))(wchar_t *_Dest, const wchar_t *_Source);
__cdecl wchar_t *wcschr(const wchar_t *_Str, wchar_t _Ch);
__cdecl int wcscmp(const wchar_t *_Str1, const wchar_t *_Str2);
__cdecl int wcscoll(const wchar_t *_Str1, const wchar_t *_Str2);
__cdecl wchar_t *wcscpy __attribute__((deprecated))(wchar_t *_Dest, const wchar_t *_Source);
__cdecl size_t wcscspn(const wchar_t *_Str, const wchar_t *_Control);
__cdecl size_t wcslen(const wchar_t *_Str);
__cdecl wchar_t *wcsncat __attribute__((deprecated))(wchar_t *_Dest, const wchar_t *_Source, size_t _Count);
__cdecl int wcsncmp(const wchar_t *_Str1, const wchar_t *_Str2, size_t _MaxCount);
__cdecl wchar_t *wcsncpy __attribute__((deprecated))(wchar_t *_Dest, const wchar_t *_Source, size_t _Count);
__cdecl wchar_t *wcspbrk(const wchar_t *_Str, const wchar_t *_Control);
__cdecl wchar_t *wcsrchr(const wchar_t *_Str, wchar_t _Ch);
__cdecl size_t wcsspn(const wchar_t *_Str, const wchar_t *_Control);
__cdecl wchar_t *wcsstr(const wchar_t *_Str, const wchar_t *_SubStr);
__cdecl wchar_t *wcstok __attribute__((deprecated))(wchar_t *_Str, const wchar_t *_Delim);


typedef __stdcall BOOL (*ABORTPROC)(HDC __attribute__((in)), int __attribute__((in)));
typedef struct _ACL ACL;
typedef struct tagACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA;
__stdcall int AbortDoc __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL AbortPath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL AbortSystemShutdownA __attribute__((dllimport))(LPSTR lpMachineName __attribute__((in)));
__stdcall HKL ActivateKeyboardLayout __attribute__((dllimport))(HKL hkl __attribute__((in)), UINT Flags __attribute__((in)));
__stdcall ATOM AddAtomA __attribute__((dllimport))(LPCSTR lpString __attribute__((in)));
__stdcall int AddFontResourceA __attribute__((dllimport))(LPCSTR __attribute__((in)));
__stdcall int AddFontResourceExA __attribute__((dllimport))(LPCSTR name __attribute__((in)), DWORD fl __attribute__((in)), PVOID res);
__stdcall BOOL AngleArc __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), DWORD r __attribute__((in)), FLOAT StartAngle __attribute__((in)), FLOAT SweepAngle __attribute__((in)));
__stdcall BOOL AnimateWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), DWORD dwTime __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL AppendMenuA __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uFlags __attribute__((in)), UINT_PTR uIDNewItem __attribute__((in)), LPCSTR lpNewItem __attribute__((in)));
__stdcall BOOL Arc __attribute__((dllimport))(HDC hdc __attribute__((in)), int x1 __attribute__((in)), int y1 __attribute__((in)), int x2 __attribute__((in)), int y2 __attribute__((in)), int x3 __attribute__((in)), int y3 __attribute__((in)), int x4 __attribute__((in)), int y4 __attribute__((in)));
__stdcall BOOL ArcTo __attribute__((dllimport))(HDC hdc __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)), int xr1 __attribute__((in)), int yr1 __attribute__((in)), int xr2 __attribute__((in)), int yr2 __attribute__((in)));
__stdcall UINT ArrangeIconicWindows __attribute__((dllimport))(HWND hWnd __attribute__((in)));
typedef struct tagBITMAP BITMAP;
typedef struct tagBITMAPINFOHEADER BITMAPINFOHEADER;
typedef struct _BLENDFUNCTION BLENDFUNCTION;
__stdcall BOOL BackupEventLogA __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), LPCSTR lpBackupFileName __attribute__((in)));
__stdcall BOOL BackupRead __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPBYTE lpBuffer, DWORD nNumberOfBytesToRead __attribute__((in)), LPDWORD lpNumberOfBytesRead __attribute__((out)), BOOL bAbort __attribute__((in)), BOOL bProcessSecurity __attribute__((in)), LPVOID *lpContext);
__stdcall BOOL BackupSeek __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwLowBytesToSeek __attribute__((in)), DWORD dwHighBytesToSeek __attribute__((in)), LPDWORD lpdwLowByteSeeked __attribute__((out)), LPDWORD lpdwHighByteSeeked __attribute__((out)), LPVOID *lpContext);
__stdcall BOOL BackupWrite __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPBYTE lpBuffer __attribute__((in)), DWORD nNumberOfBytesToWrite __attribute__((in)), LPDWORD lpNumberOfBytesWritten __attribute__((out)), BOOL bAbort __attribute__((in)), BOOL bProcessSecurity __attribute__((in)), LPVOID *lpContext);
__stdcall HDWP BeginDeferWindowPos __attribute__((dllimport))(int nNumWindows __attribute__((in)));
__stdcall BOOL BeginPath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall HANDLE BeginUpdateResourceA __attribute__((dllimport))(LPCSTR pFileName __attribute__((in)), BOOL bDeleteExistingResources __attribute__((in)));
__stdcall BOOL BitBlt __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), HDC hdcSrc __attribute__((in)), int x1 __attribute__((in)), int y1 __attribute__((in)), DWORD rop __attribute__((in)));
__stdcall BOOL BringWindowToTop __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall long BroadcastSystemMessageA __attribute__((dllimport))(DWORD flags __attribute__((in)), LPDWORD lpInfo, UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall long BroadcastSystemMessageW __attribute__((dllimport))(DWORD flags __attribute__((in)), LPDWORD lpInfo, UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
typedef __stdcall BOOL (*CALINFO_ENUMPROCA)(LPSTR);
typedef struct tagCIEXYZ CIEXYZ;
typedef struct tagCOLORADJUSTMENT COLORADJUSTMENT;
typedef struct _CONSOLE_CURSOR_INFO CONSOLE_CURSOR_INFO;
typedef struct _COORD COORD;
__stdcall BOOL CallNamedPipeA __attribute__((dllimport))(LPCSTR lpNamedPipeName __attribute__((in)), LPVOID lpInBuffer __attribute__((in)), DWORD nInBufferSize __attribute__((in)), LPVOID lpOutBuffer, DWORD nOutBufferSize __attribute__((in)), LPDWORD lpBytesRead __attribute__((out)), DWORD nTimeOut __attribute__((in)));
__stdcall LRESULT CallNextHookEx __attribute__((dllimport))(HHOOK hhk __attribute__((in)), int nCode __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL CancelDC __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL ChangeClipboardChain __attribute__((dllimport))(HWND hWndRemove __attribute__((in)), HWND hWndNewNext __attribute__((in)));
__stdcall BOOL ChangeMenuA __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT cmd __attribute__((in)), LPCSTR lpszNewItem __attribute__((in)), UINT cmdInsert __attribute__((in)), UINT flags __attribute__((in)));
__stdcall BOOL ChangeServiceConfig2W __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwInfoLevel __attribute__((in)), LPVOID lpInfo __attribute__((in)));
__stdcall BOOL ChangeServiceConfigA __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwServiceType __attribute__((in)), DWORD dwStartType __attribute__((in)), DWORD dwErrorControl __attribute__((in)), LPCSTR lpBinaryPathName __attribute__((in)), LPCSTR lpLoadOrderGroup __attribute__((in)), LPDWORD lpdwTagId __attribute__((out)), LPCSTR lpDependencies __attribute__((in)), LPCSTR lpServiceStartName __attribute__((in)), LPCSTR lpPassword __attribute__((in)), LPCSTR lpDisplayName __attribute__((in)));
__stdcall LPSTR CharLowerA __attribute__((dllimport))(LPSTR lpsz);
__stdcall DWORD CharLowerBuffA __attribute__((dllimport))(LPSTR lpsz, DWORD cchLength __attribute__((in)));
__stdcall LPSTR CharNextA __attribute__((dllimport))(LPCSTR lpsz __attribute__((in)));
__stdcall LPSTR CharNextExA __attribute__((dllimport))(WORD CodePage __attribute__((in)), LPCSTR lpCurrentChar __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall LPSTR CharPrevA __attribute__((dllimport))(LPCSTR lpszStart __attribute__((in)), LPCSTR lpszCurrent __attribute__((in)));
__stdcall LPSTR CharPrevExA __attribute__((dllimport))(WORD CodePage __attribute__((in)), LPCSTR lpStart __attribute__((in)), LPCSTR lpCurrentChar __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL CharToOemA __attribute__((dllimport))(LPCSTR pSrc __attribute__((in)), LPSTR pDst);
__stdcall BOOL CharToOemBuffA __attribute__((dllimport))(LPCSTR lpszSrc __attribute__((in)), LPSTR lpszDst, DWORD cchDstLength __attribute__((in)));
__stdcall LPSTR CharUpperA __attribute__((dllimport))(LPSTR lpsz);
__stdcall DWORD CharUpperBuffA __attribute__((dllimport))(LPSTR lpsz, DWORD cchLength __attribute__((in)));
__stdcall BOOL CheckDlgButton __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDButton __attribute__((in)), UINT uCheck __attribute__((in)));
__stdcall DWORD CheckMenuItem __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uIDCheckItem __attribute__((in)), UINT uCheck __attribute__((in)));
__stdcall BOOL CheckMenuRadioItem __attribute__((dllimport))(HMENU hmenu __attribute__((in)), UINT first __attribute__((in)), UINT last __attribute__((in)), UINT check __attribute__((in)), UINT flags __attribute__((in)));
__stdcall BOOL CheckRadioButton __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDFirstButton __attribute__((in)), int nIDLastButton __attribute__((in)), int nIDCheckButton __attribute__((in)));
__stdcall BOOL CheckTokenMembership __attribute__((dllimport))(HANDLE TokenHandle __attribute__((in)), PSID SidToCheck __attribute__((in)), PBOOL IsMember __attribute__((out)));
__stdcall BOOL Chord __attribute__((dllimport))(HDC hdc __attribute__((in)), int x1 __attribute__((in)), int y1 __attribute__((in)), int x2 __attribute__((in)), int y2 __attribute__((in)), int x3 __attribute__((in)), int y3 __attribute__((in)), int x4 __attribute__((in)), int y4 __attribute__((in)));
__stdcall BOOL ClearEventLogA __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), LPCSTR lpBackupFileName __attribute__((in)));
__stdcall BOOL CloseDesktop __attribute__((dllimport))(HDESK hDesktop __attribute__((in)));
__stdcall HENHMETAFILE CloseEnhMetaFile __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL CloseFigure __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall HMETAFILE CloseMetaFile __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL CloseServiceHandle __attribute__((dllimport))(SC_HANDLE hSCObject __attribute__((in)));
__stdcall BOOL CloseWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL CloseWindowStation __attribute__((dllimport))(HWINSTA hWinSta __attribute__((in)));
__stdcall int CombineRgn __attribute__((dllimport))(HRGN hrgnDst __attribute__((in)), HRGN hrgnSrc1 __attribute__((in)), HRGN hrgnSrc2 __attribute__((in)), int iMode __attribute__((in)));
__stdcall int CompareStringA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwCmpFlags __attribute__((in)), PCNZCH lpString1 __attribute__((in)), int cchCount1 __attribute__((in)), PCNZCH lpString2 __attribute__((in)), int cchCount2 __attribute__((in)));
__stdcall LCID ConvertDefaultLocale __attribute__((dllimport))(LCID Locale __attribute__((in)));
__stdcall HENHMETAFILE CopyEnhMetaFileA __attribute__((dllimport))(HENHMETAFILE hEnh __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL CopyFileA __attribute__((dllimport))(LPCSTR lpExistingFileName __attribute__((in)), LPCSTR lpNewFileName __attribute__((in)), BOOL bFailIfExists __attribute__((in)));
__stdcall HICON CopyIcon __attribute__((dllimport))(HICON hIcon __attribute__((in)));
__stdcall HMETAFILE CopyMetaFileA __attribute__((dllimport))(HMETAFILE __attribute__((in)), LPCSTR __attribute__((in)));
__stdcall BOOL CopySid __attribute__((dllimport))(DWORD nDestinationSidLength __attribute__((in)), PSID pDestinationSid, PSID pSourceSid __attribute__((in)));
__stdcall HBITMAP CreateBitmap __attribute__((dllimport))(int nWidth __attribute__((in)), int nHeight __attribute__((in)), UINT nPlanes __attribute__((in)), UINT nBitCount __attribute__((in)), const void *lpBits __attribute__((in)));
__stdcall BOOL CreateCaret __attribute__((dllimport))(HWND hWnd __attribute__((in)), HBITMAP hBitmap __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)));
__stdcall HBITMAP CreateCompatibleBitmap __attribute__((dllimport))(HDC hdc __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)));
__stdcall HDC CreateCompatibleDC __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall HBRUSH CreateDIBPatternBrushPt __attribute__((dllimport))(const void *lpPackedDIB __attribute__((in)), UINT iUsage __attribute__((in)));
__stdcall HBITMAP CreateDiscardableBitmap __attribute__((dllimport))(HDC hdc __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)));
__stdcall HRGN CreateEllipticRgn __attribute__((dllimport))(int x1 __attribute__((in)), int y1 __attribute__((in)), int x2 __attribute__((in)), int y2 __attribute__((in)));
__stdcall HFONT CreateFontA __attribute__((dllimport))(int cHeight __attribute__((in)), int cWidth __attribute__((in)), int cEscapement __attribute__((in)), int cOrientation __attribute__((in)), int cWeight __attribute__((in)), DWORD bItalic __attribute__((in)), DWORD bUnderline __attribute__((in)), DWORD bStrikeOut __attribute__((in)), DWORD iCharSet __attribute__((in)), DWORD iOutPrecision __attribute__((in)), DWORD iClipPrecision __attribute__((in)), DWORD iQuality __attribute__((in)), DWORD iPitchAndFamily __attribute__((in)), LPCSTR pszFaceName __attribute__((in)));
__stdcall HPALETTE CreateHalftonePalette __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall HBRUSH CreateHatchBrush __attribute__((dllimport))(int iHatch __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall HICON CreateIcon __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)), BYTE cPlanes __attribute__((in)), BYTE cBitsPixel __attribute__((in)), const BYTE *lpbANDbits __attribute__((in)), const BYTE *lpbXORbits __attribute__((in)));
__stdcall HICON CreateIconFromResource __attribute__((dllimport))(PBYTE presbits __attribute__((in)), DWORD dwResSize __attribute__((in)), BOOL fIcon __attribute__((in)), DWORD dwVer __attribute__((in)));
__stdcall HICON CreateIconFromResourceEx __attribute__((dllimport))(PBYTE presbits __attribute__((in)), DWORD dwResSize __attribute__((in)), BOOL fIcon __attribute__((in)), DWORD dwVer __attribute__((in)), int cxDesired __attribute__((in)), int cyDesired __attribute__((in)), UINT Flags __attribute__((in)));
__stdcall HWND CreateMDIWindowA __attribute__((dllimport))(LPCSTR lpClassName __attribute__((in)), LPCSTR lpWindowName __attribute__((in)), DWORD dwStyle __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)), HWND hWndParent __attribute__((in)), HINSTANCE hInstance __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall HMENU CreateMenu __attribute__((dllimport))(void);
__stdcall HDC CreateMetaFileA __attribute__((dllimport))(LPCSTR pszFile __attribute__((in)));
__stdcall HBRUSH CreatePatternBrush __attribute__((dllimport))(HBITMAP hbm __attribute__((in)));
__stdcall HPEN CreatePen __attribute__((dllimport))(int iStyle __attribute__((in)), int cWidth __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall HMENU CreatePopupMenu __attribute__((dllimport))(void);
__stdcall HRGN CreateRectRgn __attribute__((dllimport))(int x1 __attribute__((in)), int y1 __attribute__((in)), int x2 __attribute__((in)), int y2 __attribute__((in)));
__stdcall HRGN CreateRoundRectRgn __attribute__((dllimport))(int x1 __attribute__((in)), int y1 __attribute__((in)), int x2 __attribute__((in)), int y2 __attribute__((in)), int w __attribute__((in)), int h __attribute__((in)));
__stdcall BOOL CreateScalableFontResourceA __attribute__((dllimport))(DWORD fdwHidden __attribute__((in)), LPCSTR lpszFont __attribute__((in)), LPCSTR lpszFile __attribute__((in)), LPCSTR lpszPath __attribute__((in)));
__stdcall SC_HANDLE CreateServiceA __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCSTR lpServiceName __attribute__((in)), LPCSTR lpDisplayName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)), DWORD dwServiceType __attribute__((in)), DWORD dwStartType __attribute__((in)), DWORD dwErrorControl __attribute__((in)), LPCSTR lpBinaryPathName __attribute__((in)), LPCSTR lpLoadOrderGroup __attribute__((in)), LPDWORD lpdwTagId __attribute__((out)), LPCSTR lpDependencies __attribute__((in)), LPCSTR lpServiceStartName __attribute__((in)), LPCSTR lpPassword __attribute__((in)));
__stdcall HBRUSH CreateSolidBrush __attribute__((dllimport))(COLORREF color __attribute__((in)));
__stdcall BOOL CreateWellKnownSid __attribute__((dllimport))(WELL_KNOWN_SID_TYPE WellKnownSidType __attribute__((in)), PSID DomainSid __attribute__((in)), PSID pSid, DWORD *cbSid);
__stdcall HWND CreateWindowExA __attribute__((dllimport))(DWORD dwExStyle __attribute__((in)), LPCSTR lpClassName __attribute__((in)), LPCSTR lpWindowName __attribute__((in)), DWORD dwStyle __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)), HWND hWndParent __attribute__((in)), HMENU hMenu __attribute__((in)), HINSTANCE hInstance __attribute__((in)), LPVOID lpParam __attribute__((in)));
typedef __stdcall BOOL (*DATEFMT_ENUMPROCA)(LPSTR);
typedef struct _DCB DCB;
typedef __stdcall INT_PTR (*DLGPROC)(HWND, UINT, WPARAM, LPARAM);
typedef __stdcall BOOL (*DRAWSTATEPROC)(HDC hdc, LPARAM lData, WPARAM wData, int cx, int cy);
__stdcall LRESULT DefDlgProcA __attribute__((dllimport))(HWND hDlg __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT DefDlgProcW __attribute__((dllimport))(HWND hDlg __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT DefFrameProcA __attribute__((dllimport))(HWND hWnd __attribute__((in)), HWND hWndMDIClient __attribute__((in)), UINT uMsg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT DefFrameProcW __attribute__((dllimport))(HWND hWnd __attribute__((in)), HWND hWndMDIClient __attribute__((in)), UINT uMsg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT DefMDIChildProcA __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT uMsg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT DefMDIChildProcW __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT uMsg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT DefWindowProcA __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT DefWindowProcW __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall HDWP DeferWindowPos __attribute__((dllimport))(HDWP hWinPosInfo __attribute__((in)), HWND hWnd __attribute__((in)), HWND hWndInsertAfter __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall BOOL DefineDosDeviceA __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), LPCSTR lpDeviceName __attribute__((in)), LPCSTR lpTargetPath __attribute__((in)));
__stdcall ATOM DeleteAtom __attribute__((dllimport))(ATOM nAtom __attribute__((in)));
__stdcall BOOL DeleteColorSpace __attribute__((dllimport))(HCOLORSPACE hcs __attribute__((in)));
__stdcall BOOL DeleteDC __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL DeleteEnhMetaFile __attribute__((dllimport))(HENHMETAFILE hmf __attribute__((in)));
__stdcall BOOL DeleteFileA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL DeleteMenu __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uPosition __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall BOOL DeleteMetaFile __attribute__((dllimport))(HMETAFILE hmf __attribute__((in)));
__stdcall BOOL DeleteService __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)));
__stdcall BOOL DeregisterShellHookWindow __attribute__((dllimport))(HWND hwnd __attribute__((in)));
__stdcall BOOL DestroyAcceleratorTable __attribute__((dllimport))(HACCEL hAccel __attribute__((in)));
__stdcall BOOL DestroyIcon __attribute__((dllimport))(HICON hIcon __attribute__((in)));
__stdcall BOOL DestroyMenu __attribute__((dllimport))(HMENU hMenu __attribute__((in)));
__stdcall BOOL DestroyPrivateObjectSecurity __attribute__((dllimport))(PSECURITY_DESCRIPTOR *ObjectDescriptor);
__stdcall BOOL DestroyWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall int DlgDirListA __attribute__((dllimport))(HWND hDlg __attribute__((in)), LPSTR lpPathSpec, int nIDListBox __attribute__((in)), int nIDStaticPath __attribute__((in)), UINT uFileType __attribute__((in)));
__stdcall int DlgDirListComboBoxA __attribute__((dllimport))(HWND hDlg __attribute__((in)), LPSTR lpPathSpec, int nIDComboBox __attribute__((in)), int nIDStaticPath __attribute__((in)), UINT uFiletype __attribute__((in)));
__stdcall BOOL DlgDirSelectComboBoxExA __attribute__((dllimport))(HWND hwndDlg __attribute__((in)), LPSTR lpString, int cchOut __attribute__((in)), int idComboBox __attribute__((in)));
__stdcall BOOL DlgDirSelectExA __attribute__((dllimport))(HWND hwndDlg __attribute__((in)), LPSTR lpString, int chCount __attribute__((in)), int idListBox __attribute__((in)));
__stdcall int DrawEscape __attribute__((dllimport))(HDC hdc __attribute__((in)), int iEscape __attribute__((in)), int cjIn __attribute__((in)), LPCSTR lpIn __attribute__((in)));
__stdcall BOOL DrawIcon __attribute__((dllimport))(HDC hDC __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), HICON hIcon __attribute__((in)));
__stdcall BOOL DrawIconEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int xLeft __attribute__((in)), int yTop __attribute__((in)), HICON hIcon __attribute__((in)), int cxWidth __attribute__((in)), int cyWidth __attribute__((in)), UINT istepIfAniCur __attribute__((in)), HBRUSH hbrFlickerFreeDraw __attribute__((in)), UINT diFlags __attribute__((in)));
__stdcall BOOL DrawMenuBar __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL DuplicateHandle __attribute__((dllimport))(HANDLE hSourceProcessHandle __attribute__((in)), HANDLE hSourceHandle __attribute__((in)), HANDLE hTargetProcessHandle __attribute__((in)), LPHANDLE lpTargetHandle, DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), DWORD dwOptions __attribute__((in)));
__stdcall BOOL DuplicateToken __attribute__((dllimport))(HANDLE ExistingTokenHandle __attribute__((in)), SECURITY_IMPERSONATION_LEVEL ImpersonationLevel __attribute__((in)), PHANDLE DuplicateTokenHandle);
typedef struct tagENHMETARECORD ENHMETARECORD;
typedef struct _EXCEPTION_RECORD EXCEPTION_RECORD;
typedef struct _EXIT_PROCESS_DEBUG_INFO EXIT_PROCESS_DEBUG_INFO;
typedef struct _EXIT_THREAD_DEBUG_INFO EXIT_THREAD_DEBUG_INFO;
__stdcall BOOL Ellipse __attribute__((dllimport))(HDC hdc __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)));
__stdcall BOOL EnableMenuItem __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uIDEnableItem __attribute__((in)), UINT uEnable __attribute__((in)));
__stdcall BOOL EnableScrollBar __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT wSBflags __attribute__((in)), UINT wArrows __attribute__((in)));
__stdcall BOOL EnableWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), BOOL bEnable __attribute__((in)));
__stdcall BOOL EndDeferWindowPos __attribute__((dllimport))(HDWP hWinPosInfo __attribute__((in)));
__stdcall BOOL EndDialog __attribute__((dllimport))(HWND hDlg __attribute__((in)), INT_PTR nResult __attribute__((in)));
__stdcall int EndDoc __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall int EndPage __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL EndPath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL EqualDomainSid __attribute__((dllimport))(PSID pSid1 __attribute__((in)), PSID pSid2 __attribute__((in)), BOOL *pfEqual __attribute__((out)));
__stdcall BOOL EqualPrefixSid __attribute__((dllimport))(PSID pSid1 __attribute__((in)), PSID pSid2 __attribute__((in)));
__stdcall BOOL EqualRgn __attribute__((dllimport))(HRGN hrgn1 __attribute__((in)), HRGN hrgn2 __attribute__((in)));
__stdcall BOOL EqualSid __attribute__((dllimport))(PSID pSid1 __attribute__((in)), PSID pSid2 __attribute__((in)));
__stdcall int Escape __attribute__((dllimport))(HDC hdc __attribute__((in)), int iEscape __attribute__((in)), int cjIn __attribute__((in)), LPCSTR pvIn __attribute__((in)), LPVOID pvOut __attribute__((out)));
__stdcall int ExcludeClipRect __attribute__((dllimport))(HDC hdc __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)));
__stdcall int ExcludeUpdateRgn __attribute__((dllimport))(HDC hDC __attribute__((in)), HWND hWnd __attribute__((in)));
__stdcall DWORD ExpandEnvironmentStringsA __attribute__((dllimport))(LPCSTR lpSrc __attribute__((in)), LPSTR lpDst, DWORD nSize __attribute__((in)));
__stdcall int ExtEscape __attribute__((dllimport))(HDC hdc __attribute__((in)), int iEscape __attribute__((in)), int cjInput __attribute__((in)), LPCSTR lpInData __attribute__((in)), int cjOutput __attribute__((in)), LPSTR lpOutData);
__stdcall BOOL ExtFloodFill __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), COLORREF color __attribute__((in)), UINT type __attribute__((in)));
__stdcall int ExtSelectClipRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)), int mode __attribute__((in)));
typedef struct _FILETIME FILETIME;
typedef struct _FIXED FIXED;
typedef struct _FLOATING_SAVE_AREA FLOATING_SAVE_AREA;
typedef struct _FOCUS_EVENT_RECORD FOCUS_EVENT_RECORD;
typedef struct tagFONTSIGNATURE FONTSIGNATURE;
__stdcall void FatalAppExitA __attribute__((dllimport))(UINT uAction __attribute__((in)), LPCSTR lpMessageText __attribute__((in)));
__stdcall BOOL FillPath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL FillRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)), HBRUSH hbr __attribute__((in)));
__stdcall ATOM FindAtomA __attribute__((dllimport))(LPCSTR lpString __attribute__((in)));
__stdcall HANDLE FindFirstChangeNotificationA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpPathName __attribute__((in)), BOOL bWatchSubtree __attribute__((in)), DWORD dwNotifyFilter __attribute__((in)));
__stdcall HANDLE FindFirstFileExA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpFileName __attribute__((in)), FINDEX_INFO_LEVELS fInfoLevelId __attribute__((in)), LPVOID lpFindFileData __attribute__((out)), FINDEX_SEARCH_OPS fSearchOp __attribute__((in)), LPVOID lpSearchFilter, DWORD dwAdditionalFlags __attribute__((in)));
__stdcall HWND FindWindowA __attribute__((dllimport))(LPCSTR lpClassName __attribute__((in)), LPCSTR lpWindowName __attribute__((in)));
__stdcall HWND FindWindowExA __attribute__((dllimport))(HWND hWndParent __attribute__((in)), HWND hWndChildAfter __attribute__((in)), LPCSTR lpszClass __attribute__((in)), LPCSTR lpszWindow __attribute__((in)));
__stdcall BOOL FlashWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), BOOL bInvert __attribute__((in)));
__stdcall BOOL FlattenPath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL FloodFill __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall BOOL FlushInstructionCache __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPCVOID lpBaseAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)));
__stdcall BOOL FlushViewOfFile __attribute__((dllimport))(LPCVOID lpBaseAddress __attribute__((in)), SIZE_T dwNumberOfBytesToFlush __attribute__((in)));
__stdcall DWORD FormatMessageA __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), LPCVOID lpSource __attribute__((in)), DWORD dwMessageId __attribute__((in)), DWORD dwLanguageId __attribute__((in)), LPSTR lpBuffer __attribute__((out)), DWORD nSize __attribute__((in)), va_list *Arguments __attribute__((in)));
__stdcall BOOL FrameRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)), HBRUSH hbr __attribute__((in)), int w __attribute__((in)), int h __attribute__((in)));
__stdcall BOOL FreeEnvironmentStringsA __attribute__((dllimport))(LPCH __attribute__((in)));
__stdcall BOOL FreeResource __attribute__((dllimport))(HGLOBAL hResData __attribute__((in)));
__stdcall PVOID FreeSid __attribute__((dllimport))(PSID pSid __attribute__((in)));
typedef __stdcall BOOL (*GEO_ENUMPROC)(GEOID);
typedef __stdcall int (*GOBJENUMPROC)(LPVOID, LPARAM);
typedef __stdcall BOOL (*GRAYSTRINGPROC)(HDC, LPARAM, int);
__stdcall BOOL GdiComment __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT nSize __attribute__((in)), const BYTE *lpData __attribute__((in)));
__stdcall BOOL GdiTransparentBlt __attribute__((dllimport))(HDC hdcDest __attribute__((in)), int xoriginDest __attribute__((in)), int yoriginDest __attribute__((in)), int wDest __attribute__((in)), int hDest __attribute__((in)), HDC hdcSrc __attribute__((in)), int xoriginSrc __attribute__((in)), int yoriginSrc __attribute__((in)), int wSrc __attribute__((in)), int hSrc __attribute__((in)), UINT crTransparent __attribute__((in)));
__stdcall HWND GetActiveWindow __attribute__((dllimport))(void);
__stdcall HWND GetAncestor __attribute__((dllimport))(HWND hwnd __attribute__((in)), UINT gaFlags __attribute__((in)));
__stdcall int GetArcDirection __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall UINT GetAtomNameA __attribute__((dllimport))(ATOM nAtom __attribute__((in)), LPSTR lpBuffer, int nSize __attribute__((in)));
__stdcall BOOL GetBinaryTypeA __attribute__((dllimport))(LPCSTR lpApplicationName __attribute__((in)), LPDWORD lpBinaryType __attribute__((out)));
__stdcall LONG GetBitmapBits __attribute__((dllimport))(HBITMAP hbit __attribute__((in)), LONG cb __attribute__((in)), LPVOID lpvBits);
__stdcall COLORREF GetBkColor __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall int GetBkMode __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall HWND GetCapture __attribute__((dllimport))(void);
__stdcall BOOL GetCharWidth32A __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iFirst __attribute__((in)), UINT iLast __attribute__((in)), LPINT lpBuffer);
__stdcall BOOL GetCharWidth32W __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iFirst __attribute__((in)), UINT iLast __attribute__((in)), LPINT lpBuffer);
__stdcall BOOL GetCharWidthA __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iFirst __attribute__((in)), UINT iLast __attribute__((in)), LPINT lpBuffer);
__stdcall BOOL GetCharWidthFloatA __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iFirst __attribute__((in)), UINT iLast __attribute__((in)), PFLOAT lpBuffer);
__stdcall BOOL GetCharWidthW __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iFirst __attribute__((in)), UINT iLast __attribute__((in)), LPINT lpBuffer);
__stdcall DWORD GetClassLongA __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)));
__stdcall DWORD GetClassLongW __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)));
__stdcall int GetClassNameA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPSTR lpClassName, int nMaxCount __attribute__((in)));
__stdcall WORD GetClassWord __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)));
__stdcall int GetClipRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)));
__stdcall int GetClipboardFormatNameA __attribute__((dllimport))(UINT format __attribute__((in)), LPSTR lpszFormatName, int cchMaxCount __attribute__((in)));
__stdcall HWND GetClipboardOwner __attribute__((dllimport))(void);
__stdcall HWND GetClipboardViewer __attribute__((dllimport))(void);
__stdcall BOOL GetCommMask __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPDWORD lpEvtMask __attribute__((out)));
__stdcall BOOL GetCommModemStatus __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPDWORD lpModemStat __attribute__((out)));
__stdcall LPSTR GetCommandLineA __attribute__((dllimport)) __attribute__((out))(void);
__stdcall DWORD GetCompressedFileSizeA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)), LPDWORD lpFileSizeHigh __attribute__((out)));
__stdcall BOOL GetComputerNameA __attribute__((dllimport))(LPSTR lpBuffer, LPDWORD nSize);
__stdcall BOOL GetComputerNameExA __attribute__((dllimport))(COMPUTER_NAME_FORMAT NameType __attribute__((in)), LPSTR lpBuffer, LPDWORD nSize);
__stdcall BOOL GetConsoleDisplayMode __attribute__((dllimport))(LPDWORD lpModeFlags __attribute__((out)));
__stdcall BOOL GetConsoleMode __attribute__((dllimport))(HANDLE hConsoleHandle __attribute__((in)), LPDWORD lpMode __attribute__((out)));
__stdcall DWORD GetConsoleTitleA __attribute__((dllimport))(LPSTR lpConsoleTitle, DWORD nSize __attribute__((in)));
__stdcall DWORD GetCurrentDirectoryA __attribute__((dllimport))(DWORD nBufferLength __attribute__((in)), LPSTR lpBuffer);
__stdcall HGDIOBJ GetCurrentObject __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT type __attribute__((in)));
__stdcall HDC GetDC __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall HDC GetDCEx __attribute__((dllimport))(HWND hWnd __attribute__((in)), HRGN hrgnClip __attribute__((in)), DWORD flags __attribute__((in)));
__stdcall HWND GetDesktopWindow __attribute__((dllimport))(void);
__stdcall int GetDeviceCaps __attribute__((dllimport))(HDC hdc __attribute__((in)), int index __attribute__((in)));
__stdcall BOOL GetDeviceGammaRamp __attribute__((dllimport))(HDC hdc __attribute__((in)), LPVOID lpRamp);
__stdcall BOOL GetDiskFreeSpaceA __attribute__((dllimport))(LPCSTR lpRootPathName __attribute__((in)), LPDWORD lpSectorsPerCluster __attribute__((out)), LPDWORD lpBytesPerSector __attribute__((out)), LPDWORD lpNumberOfFreeClusters __attribute__((out)), LPDWORD lpTotalNumberOfClusters __attribute__((out)));
__stdcall int GetDlgCtrlID __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall HWND GetDlgItem __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)));
__stdcall UINT GetDlgItemInt __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), BOOL *lpTranslated __attribute__((out)), BOOL bSigned __attribute__((in)));
__stdcall UINT GetDlgItemTextA __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), LPSTR lpString, int cchMax __attribute__((in)));
__stdcall UINT GetDriveTypeA __attribute__((dllimport))(LPCSTR lpRootPathName __attribute__((in)));
__stdcall HENHMETAFILE GetEnhMetaFileA __attribute__((dllimport))(LPCSTR lpName __attribute__((in)));
__stdcall UINT GetEnhMetaFileBits __attribute__((dllimport))(HENHMETAFILE hEMF __attribute__((in)), UINT nSize __attribute__((in)), LPBYTE lpData);
__stdcall UINT GetEnhMetaFileDescriptionA __attribute__((dllimport))(HENHMETAFILE hemf __attribute__((in)), UINT cchBuffer __attribute__((in)), LPSTR lpDescription);
__stdcall LPCH GetEnvironmentStrings __attribute__((dllimport)) __attribute__((out))(void);
__stdcall DWORD GetEnvironmentVariableA __attribute__((dllimport))(LPCSTR lpName __attribute__((in)), LPSTR lpBuffer, DWORD nSize __attribute__((in)));
__stdcall BOOL GetEventLogInformation __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), DWORD dwInfoLevel __attribute__((in)), LPVOID lpBuffer, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
__stdcall BOOL GetExitCodeProcess __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPDWORD lpExitCode __attribute__((out)));
__stdcall BOOL GetExitCodeThread __attribute__((dllimport))(HANDLE hThread __attribute__((in)), LPDWORD lpExitCode __attribute__((out)));
__stdcall DWORD GetFileAttributesA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL GetFileAttributesExA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)), GET_FILEEX_INFO_LEVELS fInfoLevelId __attribute__((in)), LPVOID lpFileInformation __attribute__((out)));
__stdcall BOOL GetFileSecurityA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)), SECURITY_INFORMATION RequestedInformation __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor, DWORD nLength __attribute__((in)), LPDWORD lpnLengthNeeded __attribute__((out)));
__stdcall DWORD GetFileSize __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPDWORD lpFileSizeHigh __attribute__((out)));
__stdcall BOOL GetFileVersionInfoA(LPCSTR lptstrFilename __attribute__((in)), DWORD dwHandle, DWORD dwLen __attribute__((in)), LPVOID lpData);
__stdcall DWORD GetFileVersionInfoSizeA(LPCSTR lptstrFilename __attribute__((in)), LPDWORD lpdwHandle __attribute__((out)));
__stdcall HWND GetFocus __attribute__((dllimport))(void);
__stdcall DWORD GetFontData __attribute__((dllimport))(HDC hdc __attribute__((in)), DWORD dwTable __attribute__((in)), DWORD dwOffset __attribute__((in)), PVOID pvBuffer, DWORD cjBuffer __attribute__((in)));
__stdcall DWORD GetFontLanguageInfo __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall HWND GetForegroundWindow __attribute__((dllimport))(void);
__stdcall DWORD GetFullPathNameA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)), DWORD nBufferLength __attribute__((in)), LPSTR lpBuffer, LPSTR *lpFilePart);
__stdcall int GetGraphicsMode __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL GetHandleInformation __attribute__((dllimport))(HANDLE hObject __attribute__((in)), LPDWORD lpdwFlags __attribute__((out)));
__stdcall BOOL GetICMProfileA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPDWORD pBufSize, LPSTR pszFilename);
__stdcall BOOL GetKernelObjectSecurity __attribute__((dllimport))(HANDLE Handle __attribute__((in)), SECURITY_INFORMATION RequestedInformation __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor, DWORD nLength __attribute__((in)), LPDWORD lpnLengthNeeded __attribute__((out)));
__stdcall int GetKeyNameTextA __attribute__((dllimport))(LONG lParam __attribute__((in)), LPSTR lpString, int cchSize __attribute__((in)));
__stdcall HKL GetKeyboardLayout __attribute__((dllimport))(DWORD idThread __attribute__((in)));
__stdcall int GetKeyboardLayoutList __attribute__((dllimport))(int nBuff __attribute__((in)), HKL *lpList);
__stdcall BOOL GetKeyboardLayoutNameA __attribute__((dllimport))(LPSTR pwszKLID);
__stdcall BOOL GetKeyboardState __attribute__((dllimport))(PBYTE lpKeyState);
__stdcall HWND GetLastActivePopup __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall DWORD GetLayout __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall DWORD GetLengthSid __attribute__((dllimport))(PSID pSid __attribute__((in)));
__stdcall int GetLocaleInfoA __attribute__((dllimport))(LCID Locale __attribute__((in)), LCTYPE LCType __attribute__((in)), LPSTR lpLCData, int cchData __attribute__((in)));
__stdcall DWORD GetLogicalDriveStringsA __attribute__((dllimport))(DWORD nBufferLength __attribute__((in)), LPSTR lpBuffer);
__stdcall DWORD GetLongPathNameA __attribute__((dllimport))(LPCSTR lpszShortPath __attribute__((in)), LPSTR lpszLongPath, DWORD cchBuffer __attribute__((in)));
__stdcall BOOL GetMailslotInfo __attribute__((dllimport))(HANDLE hMailslot __attribute__((in)), LPDWORD lpMaxMessageSize __attribute__((out)), LPDWORD lpNextSize __attribute__((out)), LPDWORD lpMessageCount __attribute__((out)), LPDWORD lpReadTimeout __attribute__((out)));
__stdcall int GetMapMode __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall HMENU GetMenu __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall DWORD GetMenuContextHelpId __attribute__((dllimport))(HMENU __attribute__((in)));
__stdcall UINT GetMenuDefaultItem __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT fByPos __attribute__((in)), UINT gmdiFlags __attribute__((in)));
__stdcall int GetMenuItemCount __attribute__((dllimport))(HMENU hMenu __attribute__((in)));
__stdcall UINT GetMenuItemID __attribute__((dllimport))(HMENU hMenu __attribute__((in)), int nPos __attribute__((in)));
__stdcall UINT GetMenuState __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uId __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall int GetMenuStringA __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uIDItem __attribute__((in)), LPSTR lpString, int cchMax __attribute__((in)), UINT flags __attribute__((in)));
__stdcall LPARAM GetMessageExtraInfo __attribute__((dllimport))(void);
__stdcall HMETAFILE GetMetaFileA __attribute__((dllimport))(LPCSTR lpName __attribute__((in)));
__stdcall UINT GetMetaFileBitsEx __attribute__((dllimport))(HMETAFILE hMF __attribute__((in)), UINT cbBuffer __attribute__((in)), LPVOID lpData);
__stdcall BOOL GetMiterLimit __attribute__((dllimport))(HDC hdc __attribute__((in)), PFLOAT plimit __attribute__((out)));
__stdcall BOOL GetNamedPipeHandleStateA __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)), LPDWORD lpState __attribute__((out)), LPDWORD lpCurInstances __attribute__((out)), LPDWORD lpMaxCollectionCount __attribute__((out)), LPDWORD lpCollectDataTimeout __attribute__((out)), LPSTR lpUserName, DWORD nMaxUserNameSize __attribute__((in)));
__stdcall BOOL GetNamedPipeInfo __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)), LPDWORD lpFlags __attribute__((out)), LPDWORD lpOutBufferSize __attribute__((out)), LPDWORD lpInBufferSize __attribute__((out)), LPDWORD lpMaxInstances __attribute__((out)));
__stdcall COLORREF GetNearestColor __attribute__((dllimport))(HDC hdc __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall UINT GetNearestPaletteIndex __attribute__((dllimport))(HPALETTE h __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall HWND GetNextDlgGroupItem __attribute__((dllimport))(HWND hDlg __attribute__((in)), HWND hCtl __attribute__((in)), BOOL bPrevious __attribute__((in)));
__stdcall HWND GetNextDlgTabItem __attribute__((dllimport))(HWND hDlg __attribute__((in)), HWND hCtl __attribute__((in)), BOOL bPrevious __attribute__((in)));
__stdcall BOOL GetNumberOfConsoleInputEvents __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), LPDWORD lpNumberOfEvents __attribute__((out)));
__stdcall BOOL GetNumberOfEventLogRecords __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), PDWORD NumberOfRecords __attribute__((out)));
__stdcall BOOL GetOldestEventLogRecord __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), PDWORD OldestRecord __attribute__((out)));
__stdcall HWND GetOpenClipboardWindow __attribute__((dllimport))(void);
__stdcall HWND GetParent __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall COLORREF GetPixel __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)));
__stdcall int GetPixelFormat __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall int GetPolyFillMode __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL GetPrivateObjectSecurity __attribute__((dllimport))(PSECURITY_DESCRIPTOR ObjectDescriptor __attribute__((in)), SECURITY_INFORMATION SecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR ResultantDescriptor, DWORD DescriptorLength __attribute__((in)), PDWORD ReturnLength __attribute__((out)));
__stdcall UINT GetPrivateProfileIntA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpKeyName __attribute__((in)), INT nDefault __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall DWORD GetPrivateProfileSectionA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPSTR lpReturnedString, DWORD nSize __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall DWORD GetPrivateProfileSectionNamesA __attribute__((dllimport))(LPSTR lpszReturnBuffer, DWORD nSize __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall DWORD GetPrivateProfileStringA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpKeyName __attribute__((in)), LPCSTR lpDefault __attribute__((in)), LPSTR lpReturnedString, DWORD nSize __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL GetPrivateProfileStructA __attribute__((dllimport))(LPCSTR lpszSection __attribute__((in)), LPCSTR lpszKey __attribute__((in)), LPVOID lpStruct, UINT uSizeStruct __attribute__((in)), LPCSTR szFile __attribute__((in)));
__stdcall BOOL GetProcessAffinityMask __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), PDWORD_PTR lpProcessAffinityMask __attribute__((out)), PDWORD_PTR lpSystemAffinityMask __attribute__((out)));
__stdcall BOOL GetProcessShutdownParameters __attribute__((dllimport))(LPDWORD lpdwLevel __attribute__((out)), LPDWORD lpdwFlags __attribute__((out)));
__stdcall HWINSTA GetProcessWindowStation __attribute__((dllimport))(void);
__stdcall BOOL GetProcessWorkingSetSize __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), PSIZE_T lpMinimumWorkingSetSize __attribute__((out)), PSIZE_T lpMaximumWorkingSetSize __attribute__((out)));
__stdcall UINT GetProfileIntA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpKeyName __attribute__((in)), INT nDefault __attribute__((in)));
__stdcall DWORD GetProfileSectionA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPSTR lpReturnedString, DWORD nSize __attribute__((in)));
__stdcall DWORD GetProfileStringA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpKeyName __attribute__((in)), LPCSTR lpDefault __attribute__((in)), LPSTR lpReturnedString, DWORD nSize __attribute__((in)));
__stdcall HANDLE GetPropA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCSTR lpString __attribute__((in)));
__stdcall int GetROP2 __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall int GetRandomRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)), INT i __attribute__((in)));
__stdcall BOOL GetRasterizerCaps __attribute__((dllimport))(LPRASTERIZER_STATUS lpraststat, UINT cjBytes __attribute__((in)));
__stdcall UINT GetRawInputData __attribute__((dllimport))(HRAWINPUT hRawInput __attribute__((in)), UINT uiCommand __attribute__((in)), LPVOID pData, PUINT pcbSize, UINT cbSizeHeader __attribute__((in)));
__stdcall int GetScrollPos __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nBar __attribute__((in)));
__stdcall BOOL GetScrollRange __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nBar __attribute__((in)), LPINT lpMinPos __attribute__((out)), LPINT lpMaxPos __attribute__((out)));
__stdcall BOOL GetSecurityDescriptorControl __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR_CONTROL pControl __attribute__((out)), LPDWORD lpdwRevision __attribute__((out)));
__stdcall BOOL GetSecurityDescriptorGroup __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), PSID *pGroup, LPBOOL lpbGroupDefaulted __attribute__((out)));
__stdcall DWORD GetSecurityDescriptorLength __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)));
__stdcall BOOL GetSecurityDescriptorOwner __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), PSID *pOwner, LPBOOL lpbOwnerDefaulted __attribute__((out)));
__stdcall BOOL GetServiceDisplayNameA __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCSTR lpServiceName __attribute__((in)), LPSTR lpDisplayName, LPDWORD lpcchBuffer);
__stdcall BOOL GetServiceKeyNameA __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCSTR lpDisplayName __attribute__((in)), LPSTR lpServiceName, LPDWORD lpcchBuffer);
__stdcall HWND GetShellWindow __attribute__((dllimport))(void);
__stdcall DWORD GetShortPathNameA __attribute__((dllimport))(LPCSTR lpszLongPath __attribute__((in)), LPSTR lpszShortPath, DWORD cchBuffer __attribute__((in)));
__stdcall PDWORD GetSidSubAuthority __attribute__((dllimport)) __attribute__((out))(PSID pSid __attribute__((in)), DWORD nSubAuthority __attribute__((in)));
__stdcall PUCHAR GetSidSubAuthorityCount __attribute__((dllimport)) __attribute__((out))(PSID pSid __attribute__((in)));
__stdcall int GetStretchBltMode __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL GetStringTypeA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwInfoType __attribute__((in)), LPCSTR lpSrcStr __attribute__((in)), int cchSrc __attribute__((in)), LPWORD lpCharType __attribute__((out)));
__stdcall BOOL GetStringTypeExA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwInfoType __attribute__((in)), LPCSTR lpSrcStr __attribute__((in)), int cchSrc __attribute__((in)), LPWORD lpCharType);
__stdcall HMENU GetSubMenu __attribute__((dllimport))(HMENU hMenu __attribute__((in)), int nPos __attribute__((in)));
__stdcall HBRUSH GetSysColorBrush __attribute__((dllimport))(int nIndex __attribute__((in)));
__stdcall LCID GetSystemDefaultLCID __attribute__((dllimport))(void);
__stdcall LANGID GetSystemDefaultLangID __attribute__((dllimport))(void);
__stdcall LANGID GetSystemDefaultUILanguage __attribute__((dllimport))(void);
__stdcall UINT GetSystemDirectoryA __attribute__((dllimport))(LPSTR lpBuffer, UINT uSize __attribute__((in)));
__stdcall HMENU GetSystemMenu __attribute__((dllimport))(HWND hWnd __attribute__((in)), BOOL bRevert __attribute__((in)));
__stdcall UINT GetSystemPaletteUse __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL GetSystemTimeAdjustment __attribute__((dllimport))(PDWORD lpTimeAdjustment __attribute__((out)), PDWORD lpTimeIncrement __attribute__((out)), PBOOL lpTimeAdjustmentDisabled __attribute__((out)));
__stdcall UINT GetSystemWindowsDirectoryA __attribute__((dllimport))(LPSTR lpBuffer, UINT uSize __attribute__((in)));
__stdcall DWORD GetTabbedTextExtentA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpString __attribute__((in)), int chCount __attribute__((in)), int nTabPositions __attribute__((in)), const INT *lpnTabStopPositions __attribute__((in)));
__stdcall DWORD GetTapeParameters __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwOperation __attribute__((in)), LPDWORD lpdwSize, LPVOID lpTapeInformation);
__stdcall DWORD GetTapePosition __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwPositionType __attribute__((in)), LPDWORD lpdwPartition __attribute__((out)), LPDWORD lpdwOffsetLow __attribute__((out)), LPDWORD lpdwOffsetHigh __attribute__((out)));
__stdcall UINT GetTempFileNameA __attribute__((dllimport))(LPCSTR lpPathName __attribute__((in)), LPCSTR lpPrefixString __attribute__((in)), UINT uUnique __attribute__((in)), LPSTR lpTempFileName);
__stdcall DWORD GetTempPathA __attribute__((dllimport))(DWORD nBufferLength __attribute__((in)), LPSTR lpBuffer);
__stdcall UINT GetTextAlign __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall int GetTextCharacterExtra __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall int GetTextCharset __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall COLORREF GetTextColor __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall int GetTextFaceA __attribute__((dllimport))(HDC hdc __attribute__((in)), int c __attribute__((in)), LPSTR lpName);
__stdcall HDESK GetThreadDesktop __attribute__((dllimport))(DWORD dwThreadId __attribute__((in)));
__stdcall LCID GetThreadLocale __attribute__((dllimport))(void);
__stdcall BOOL GetTokenInformation __attribute__((dllimport))(HANDLE TokenHandle __attribute__((in)), TOKEN_INFORMATION_CLASS TokenInformationClass __attribute__((in)), LPVOID TokenInformation, DWORD TokenInformationLength __attribute__((in)), PDWORD ReturnLength __attribute__((out)));
__stdcall HWND GetTopWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall int GetUpdateRgn __attribute__((dllimport))(HWND hWnd __attribute__((in)), HRGN hRgn __attribute__((in)), BOOL bErase __attribute__((in)));
__stdcall LCID GetUserDefaultLCID __attribute__((dllimport))(void);
__stdcall LANGID GetUserDefaultLangID __attribute__((dllimport))(void);
__stdcall LANGID GetUserDefaultUILanguage __attribute__((dllimport))(void);
__stdcall GEOID GetUserGeoID __attribute__((dllimport))(GEOCLASS GeoClass __attribute__((in)));
__stdcall BOOL GetUserNameA __attribute__((dllimport))(LPSTR lpBuffer, LPDWORD pcbBuffer);
__stdcall BOOL GetUserObjectInformationA __attribute__((dllimport))(HANDLE hObj __attribute__((in)), int nIndex __attribute__((in)), PVOID pvInfo, DWORD nLength __attribute__((in)), LPDWORD lpnLengthNeeded __attribute__((out)));
__stdcall BOOL GetUserObjectInformationW __attribute__((dllimport))(HANDLE hObj __attribute__((in)), int nIndex __attribute__((in)), PVOID pvInfo, DWORD nLength __attribute__((in)), LPDWORD lpnLengthNeeded __attribute__((out)));
__stdcall BOOL GetUserObjectSecurity __attribute__((dllimport))(HANDLE hObj __attribute__((in)), PSECURITY_INFORMATION pSIRequested __attribute__((in)), PSECURITY_DESCRIPTOR pSID, DWORD nLength __attribute__((in)), LPDWORD lpnLengthNeeded __attribute__((out)));
__stdcall BOOL GetVolumeInformationA __attribute__((dllimport))(LPCSTR lpRootPathName __attribute__((in)), LPSTR lpVolumeNameBuffer, DWORD nVolumeNameSize __attribute__((in)), LPDWORD lpVolumeSerialNumber __attribute__((out)), LPDWORD lpMaximumComponentLength __attribute__((out)), LPDWORD lpFileSystemFlags __attribute__((out)), LPSTR lpFileSystemNameBuffer, DWORD nFileSystemNameSize __attribute__((in)));
__stdcall BOOL GetVolumeNameForVolumeMountPointA __attribute__((dllimport))(LPCSTR lpszVolumeMountPoint __attribute__((in)), LPSTR lpszVolumeName, DWORD cchBufferLength __attribute__((in)));
__stdcall UINT GetWinMetaFileBits __attribute__((dllimport))(HENHMETAFILE hemf __attribute__((in)), UINT cbData16 __attribute__((in)), LPBYTE pData16, INT iMapMode __attribute__((in)), HDC hdcRef __attribute__((in)));
__stdcall HWND GetWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT uCmd __attribute__((in)));
__stdcall DWORD GetWindowContextHelpId __attribute__((dllimport))(HWND __attribute__((in)));
__stdcall HDC GetWindowDC __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall LONG GetWindowLongA __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)));
__stdcall LONG GetWindowLongW __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)));
__stdcall int GetWindowRgn __attribute__((dllimport))(HWND hWnd __attribute__((in)), HRGN hRgn __attribute__((in)));
__stdcall int GetWindowTextA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPSTR lpString, int nMaxCount __attribute__((in)));
__stdcall int GetWindowTextLengthA __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall int GetWindowTextLengthW __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall DWORD GetWindowThreadProcessId __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPDWORD lpdwProcessId __attribute__((out)));
__stdcall WORD GetWindowWord __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)));
__stdcall BOOL GetWindowsAccountDomainSid __attribute__((dllimport))(PSID pSid __attribute__((in)), PSID pDomainSid, DWORD *cbDomainSid);
__stdcall UINT GetWindowsDirectoryA __attribute__((dllimport))(LPSTR lpBuffer, UINT uSize __attribute__((in)));
__stdcall ATOM GlobalAddAtomA __attribute__((dllimport))(LPCSTR lpString __attribute__((in)));
__stdcall HGLOBAL GlobalAlloc __attribute__((dllimport)) __attribute__((out))(UINT uFlags __attribute__((in)), SIZE_T dwBytes __attribute__((in)));
__stdcall SIZE_T GlobalCompact __attribute__((dllimport))(DWORD dwMinFree __attribute__((in)));
__stdcall ATOM GlobalDeleteAtom __attribute__((dllimport))(ATOM nAtom __attribute__((in)));
__stdcall ATOM GlobalFindAtomA __attribute__((dllimport))(LPCSTR lpString __attribute__((in)));
__stdcall UINT GlobalFlags __attribute__((dllimport))(HGLOBAL hMem __attribute__((in)));
__stdcall HGLOBAL GlobalFree __attribute__((dllimport)) __attribute__((out))(HGLOBAL hMem);
__stdcall UINT GlobalGetAtomNameA __attribute__((dllimport))(ATOM nAtom __attribute__((in)), LPSTR lpBuffer, int nSize __attribute__((in)));
__stdcall HGLOBAL GlobalHandle __attribute__((dllimport)) __attribute__((out))(LPCVOID pMem __attribute__((in)));
__stdcall LPVOID GlobalLock __attribute__((dllimport)) __attribute__((out))(HGLOBAL hMem __attribute__((in)));
__stdcall HGLOBAL GlobalReAlloc __attribute__((dllimport)) __attribute__((out))(HGLOBAL hMem __attribute__((in)), SIZE_T dwBytes __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall SIZE_T GlobalSize __attribute__((dllimport))(HGLOBAL hMem __attribute__((in)));
__stdcall BOOL GlobalUnlock __attribute__((dllimport))(HGLOBAL hMem __attribute__((in)));
typedef struct tagHANDLETABLE HANDLETABLE;
typedef struct tagHARDWAREINPUT HARDWAREINPUT;
typedef HICON HCURSOR;
typedef HINSTANCE HMODULE;
typedef __stdcall LRESULT (*HOOKPROC)(int code, WPARAM wParam, LPARAM lParam);
__stdcall LPVOID HeapAlloc __attribute__((dllimport))(HANDLE hHeap __attribute__((in)), DWORD dwFlags __attribute__((in)), SIZE_T dwBytes __attribute__((in)));
__stdcall SIZE_T HeapCompact __attribute__((dllimport))(HANDLE hHeap __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall HANDLE HeapCreate __attribute__((dllimport)) __attribute__((out))(DWORD flOptions __attribute__((in)), SIZE_T dwInitialSize __attribute__((in)), SIZE_T dwMaximumSize __attribute__((in)));
__stdcall LPVOID HeapReAlloc __attribute__((dllimport))(HANDLE hHeap, DWORD dwFlags __attribute__((in)), LPVOID lpMem, SIZE_T dwBytes __attribute__((in)));
__stdcall BOOL HeapSetInformation __attribute__((dllimport))(HANDLE HeapHandle __attribute__((in)), HEAP_INFORMATION_CLASS HeapInformationClass __attribute__((in)), PVOID HeapInformation __attribute__((in)), SIZE_T HeapInformationLength __attribute__((in)));
__stdcall SIZE_T HeapSize __attribute__((dllimport))(HANDLE hHeap __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCVOID lpMem __attribute__((in)));
__stdcall BOOL HideCaret __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL HiliteMenuItem __attribute__((dllimport))(HWND hWnd __attribute__((in)), HMENU hMenu __attribute__((in)), UINT uIDHiliteItem __attribute__((in)), UINT uHilite __attribute__((in)));
typedef __stdcall int (*ICMENUMPROCA)(LPSTR, LPARAM);
__stdcall HIMC ImmAssociateContext(HWND __attribute__((in)), HIMC __attribute__((in)));
__stdcall BOOL ImmAssociateContextEx(HWND __attribute__((in)), HIMC __attribute__((in)), DWORD __attribute__((in)));
__stdcall BOOL ImmConfigureIMEW(HKL __attribute__((in)), HWND __attribute__((in)), DWORD __attribute__((in)), LPVOID __attribute__((in)));
__stdcall HIMC ImmCreateContext(void);
__stdcall BOOL ImmDestroyContext(HIMC __attribute__((in)));
__stdcall LRESULT ImmEscapeW(HKL __attribute__((in)), HIMC __attribute__((in)), UINT __attribute__((in)), LPVOID __attribute__((in)));
__stdcall LONG ImmGetCompositionStringW(HIMC __attribute__((in)), DWORD __attribute__((in)), LPVOID lpBuf, DWORD dwBufLen __attribute__((in)));
__stdcall HIMC ImmGetContext(HWND __attribute__((in)));
__stdcall BOOL ImmGetConversionStatus(HIMC __attribute__((in)), LPDWORD lpfdwConversion __attribute__((out)), LPDWORD lpfdwSentence __attribute__((out)));
__stdcall HWND ImmGetDefaultIMEWnd(HWND __attribute__((in)));
__stdcall UINT ImmGetIMEFileNameA(HKL __attribute__((in)), LPSTR lpszFileName, UINT uBufLen __attribute__((in)));
__stdcall BOOL ImmGetOpenStatus(HIMC __attribute__((in)));
__stdcall DWORD ImmGetProperty(HKL __attribute__((in)), DWORD __attribute__((in)));
__stdcall HKL ImmInstallIMEA(LPCSTR lpszIMEFileName __attribute__((in)), LPCSTR lpszLayoutText __attribute__((in)));
__stdcall BOOL ImmIsIME(HKL __attribute__((in)));
__stdcall BOOL ImmNotifyIME(HIMC __attribute__((in)), DWORD dwAction __attribute__((in)), DWORD dwIndex __attribute__((in)), DWORD dwValue __attribute__((in)));
__stdcall BOOL ImmReleaseContext(HWND __attribute__((in)), HIMC __attribute__((in)));
__stdcall BOOL ImmSetCompositionStringW(HIMC __attribute__((in)), DWORD dwIndex __attribute__((in)), LPVOID lpComp __attribute__((in)), DWORD dwCompLen __attribute__((in)), LPVOID lpRead __attribute__((in)), DWORD dwReadLen __attribute__((in)));
__stdcall BOOL ImmSetConversionStatus(HIMC __attribute__((in)), DWORD __attribute__((in)), DWORD __attribute__((in)));
__stdcall BOOL ImmSetOpenStatus(HIMC __attribute__((in)), BOOL __attribute__((in)));
__stdcall BOOL ImmSimulateHotKey(HWND __attribute__((in)), DWORD __attribute__((in)));
__stdcall BOOL ImpersonateSelf __attribute__((dllimport))(SECURITY_IMPERSONATION_LEVEL ImpersonationLevel __attribute__((in)));
__stdcall BOOL InitializeSecurityDescriptor __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((out)), DWORD dwRevision __attribute__((in)));
__stdcall BOOL InitiateSystemShutdownA __attribute__((dllimport))(LPSTR lpMachineName __attribute__((in)), LPSTR lpMessage __attribute__((in)), DWORD dwTimeout __attribute__((in)), BOOL bForceAppsClosed __attribute__((in)), BOOL bRebootAfterShutdown __attribute__((in)));
__stdcall BOOL InsertMenuA __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uPosition __attribute__((in)), UINT uFlags __attribute__((in)), UINT_PTR uIDNewItem __attribute__((in)), LPCSTR lpNewItem __attribute__((in)));
__stdcall int IntersectClipRect __attribute__((dllimport))(HDC hdc __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)));
__stdcall BOOL InvalidateRgn __attribute__((dllimport))(HWND hWnd __attribute__((in)), HRGN hRgn __attribute__((in)), BOOL bErase __attribute__((in)));
__stdcall BOOL InvertRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)));
__stdcall BOOL IsBadStringPtrA __attribute__((dllimport))(LPCSTR lpsz __attribute__((in)), UINT_PTR ucchMax __attribute__((in)));
__stdcall BOOL IsCharAlphaNumericW __attribute__((dllimport))(WCHAR ch __attribute__((in)));
__stdcall BOOL IsCharAlphaW __attribute__((dllimport))(WCHAR ch __attribute__((in)));
__stdcall BOOL IsCharLowerW __attribute__((dllimport))(WCHAR ch __attribute__((in)));
__stdcall BOOL IsCharUpperW __attribute__((dllimport))(WCHAR ch __attribute__((in)));
__stdcall BOOL IsChild __attribute__((dllimport))(HWND hWndParent __attribute__((in)), HWND hWnd __attribute__((in)));
__stdcall UINT IsDlgButtonChecked __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDButton __attribute__((in)));
__stdcall BOOL IsHungAppWindow __attribute__((dllimport))(HWND hwnd __attribute__((in)));
__stdcall BOOL IsIconic __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL IsMenu __attribute__((dllimport))(HMENU hMenu __attribute__((in)));
__stdcall BOOL IsValidLanguageGroup __attribute__((dllimport))(LGRPID LanguageGroup __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL IsValidLocale __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL IsValidSecurityDescriptor __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)));
__stdcall BOOL IsValidSid __attribute__((dllimport))(PSID pSid __attribute__((in)));
__stdcall BOOL IsWellKnownSid __attribute__((dllimport))(PSID pSid __attribute__((in)), WELL_KNOWN_SID_TYPE WellKnownSidType __attribute__((in)));
__stdcall BOOL IsWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL IsWindowEnabled __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL IsWindowUnicode __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL IsWindowVisible __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL IsWow64Process __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), PBOOL Wow64Process __attribute__((out)));
__stdcall BOOL IsZoomed __attribute__((dllimport))(HWND hWnd __attribute__((in)));
typedef struct tagKEYBDINPUT KEYBDINPUT;
__stdcall BOOL KillTimer __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT_PTR uIDEvent __attribute__((in)));
typedef union _LARGE_INTEGER LARGE_INTEGER;
__stdcall int LCMapStringA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwMapFlags __attribute__((in)), LPCSTR lpSrcStr __attribute__((in)), int cchSrc __attribute__((in)), LPSTR lpDestStr, int cchDest __attribute__((in)));
typedef __stdcall void (*LINEDDAPROC)(int, int, LPARAM);
typedef struct _LOAD_DLL_DEBUG_INFO LOAD_DLL_DEBUG_INFO;
typedef __stdcall BOOL (*LOCALE_ENUMPROCA)(LPSTR);
typedef struct tagLOGFONTA LOGFONTA;
typedef struct _ABC *LPABC;
typedef struct _ABCFLOAT *LPABCFLOAT;
typedef struct tagACCEL *LPACCEL;
typedef struct tagCANDIDATELIST *LPCANDIDATELIST;
typedef const DLGTEMPLATE *LPCDLGTEMPLATEA;
typedef const DLGTEMPLATE *LPCDLGTEMPLATEW;
typedef struct _COMMTIMEOUTS *LPCOMMTIMEOUTS;
typedef struct _COMSTAT *LPCOMSTAT;
typedef struct _cpinfo *LPCPINFO;
typedef const WCHAR *LPCWSTR;
typedef struct _DCB *LPDCB;
typedef struct tagDRAWTEXTPARAMS *LPDRAWTEXTPARAMS;
typedef PFIBER_START_ROUTINE LPFIBER_START_ROUTINE;
typedef struct _FILETIME *LPFILETIME;
typedef struct tagFONTSIGNATURE *LPFONTSIGNATURE;
typedef struct tagHANDLETABLE *LPHANDLETABLE;
typedef struct tagHW_PROFILE_INFOA *LPHW_PROFILE_INFOA;
typedef struct tagKERNINGPAIR *LPKERNINGPAIR;
typedef struct tagLOGFONTA *LPLOGFONTA;
typedef struct tagMETARECORD *LPMETARECORD;
typedef struct _NETINFOSTRUCT *LPNETINFOSTRUCT;
typedef struct _OFSTRUCT *LPOFSTRUCT;
typedef struct _OSVERSIONINFOA *LPOSVERSIONINFOA;
typedef struct _OSVERSIONINFOEXA *LPOSVERSIONINFOEXA;
typedef struct _OVERLAPPED *LPOVERLAPPED;
typedef struct tagPALETTEENTRY *LPPALETTEENTRY;
typedef struct tagPIXELFORMATDESCRIPTOR *LPPIXELFORMATDESCRIPTOR;
typedef struct tagPOINT *LPPOINT;
typedef struct _PROCESS_HEAP_ENTRY *LPPROCESS_HEAP_ENTRY;
typedef struct _PROCESS_INFORMATION *LPPROCESS_INFORMATION;
typedef struct tagRECT *LPRECT;
typedef struct tagSCROLLINFO *LPSCROLLINFO;
typedef struct _SECURITY_ATTRIBUTES *LPSECURITY_ATTRIBUTES;
typedef __stdcall void (*LPSERVICE_MAIN_FUNCTIONA)(DWORD dwNumServicesArgs, LPSTR *lpServiceArgVectors);
typedef struct _SERVICE_STATUS *LPSERVICE_STATUS;
typedef struct tagSIZE *LPSIZE;
typedef struct _SYSTEMTIME *LPSYSTEMTIME;
typedef struct _SYSTEM_POWER_STATUS *LPSYSTEM_POWER_STATUS;
typedef struct tagTEXTMETRICA *LPTEXTMETRICA;
typedef PTHREAD_START_ROUTINE LPTHREAD_START_ROUTINE;
typedef WCHAR *LPWCH;
typedef WCHAR *LPWSTR;
typedef struct tagXFORM *LPXFORM;
typedef struct _LUID LUID;
__stdcall BOOL LineTo __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)));
__stdcall HACCEL LoadAcceleratorsA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpTableName __attribute__((in)));
__stdcall HBITMAP LoadBitmapA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpBitmapName __attribute__((in)));
__stdcall HICON LoadIconA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpIconName __attribute__((in)));
__stdcall HANDLE LoadImageA __attribute__((dllimport))(HINSTANCE hInst __attribute__((in)), LPCSTR name __attribute__((in)), UINT type __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), UINT fuLoad __attribute__((in)));
__stdcall HKL LoadKeyboardLayoutA __attribute__((dllimport))(LPCSTR pwszKLID __attribute__((in)), UINT Flags __attribute__((in)));
__stdcall HMENU LoadMenuA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpMenuName __attribute__((in)));
__stdcall HMENU LoadMenuIndirectA __attribute__((dllimport))(const MENUTEMPLATEA *lpMenuTemplate __attribute__((in)));
__stdcall int LoadStringA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), UINT uID __attribute__((in)), LPSTR lpBuffer, int cchBufferMax __attribute__((in)));
__stdcall HLOCAL LocalAlloc __attribute__((dllimport))(UINT uFlags __attribute__((in)), SIZE_T uBytes __attribute__((in)));
__stdcall UINT LocalFlags __attribute__((dllimport))(HLOCAL hMem __attribute__((in)));
__stdcall HLOCAL LocalFree __attribute__((dllimport))(HLOCAL hMem);
__stdcall HLOCAL LocalHandle __attribute__((dllimport)) __attribute__((out))(LPCVOID pMem __attribute__((in)));
__stdcall LPVOID LocalLock __attribute__((dllimport)) __attribute__((out))(HLOCAL hMem __attribute__((in)));
__stdcall HLOCAL LocalReAlloc __attribute__((dllimport)) __attribute__((out))(HLOCAL hMem __attribute__((in)), SIZE_T uBytes __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall SIZE_T LocalSize __attribute__((dllimport))(HLOCAL hMem __attribute__((in)));
__stdcall BOOL LocalUnlock __attribute__((dllimport))(HLOCAL hMem __attribute__((in)));
__stdcall LPVOID LockResource __attribute__((dllimport))(HGLOBAL hResData __attribute__((in)));
__stdcall SC_LOCK LockServiceDatabase __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)));
__stdcall BOOL LockWindowUpdate __attribute__((dllimport))(HWND hWndLock __attribute__((in)));
__stdcall BOOL LogonUserA __attribute__((dllimport))(LPCSTR lpszUsername __attribute__((in)), LPCSTR lpszDomain __attribute__((in)), LPCSTR lpszPassword __attribute__((in)), DWORD dwLogonType __attribute__((in)), DWORD dwLogonProvider __attribute__((in)), PHANDLE phToken);
__stdcall BOOL LookupAccountNameA __attribute__((dllimport))(LPCSTR lpSystemName __attribute__((in)), LPCSTR lpAccountName __attribute__((in)), PSID Sid, LPDWORD cbSid, LPSTR ReferencedDomainName, LPDWORD cchReferencedDomainName, PSID_NAME_USE peUse __attribute__((out)));
__stdcall BOOL LookupAccountSidA __attribute__((dllimport))(LPCSTR lpSystemName __attribute__((in)), PSID Sid __attribute__((in)), LPSTR Name, LPDWORD cchName, LPSTR ReferencedDomainName, LPDWORD cchReferencedDomainName, PSID_NAME_USE peUse __attribute__((out)));
__stdcall int LookupIconIdFromDirectory __attribute__((dllimport))(PBYTE presbits __attribute__((in)), BOOL fIcon __attribute__((in)));
__stdcall int LookupIconIdFromDirectoryEx __attribute__((dllimport))(PBYTE presbits __attribute__((in)), BOOL fIcon __attribute__((in)), int cxDesired __attribute__((in)), int cyDesired __attribute__((in)), UINT Flags __attribute__((in)));
__stdcall BOOL LookupPrivilegeDisplayNameA __attribute__((dllimport))(LPCSTR lpSystemName __attribute__((in)), LPCSTR lpName __attribute__((in)), LPSTR lpDisplayName, LPDWORD cchDisplayName, LPDWORD lpLanguageId __attribute__((out)));
typedef struct _MENU_EVENT_RECORD MENU_EVENT_RECORD;
typedef struct tagMETARECORD METARECORD;
typedef struct tagMOUSEINPUT MOUSEINPUT;
__stdcall BOOL MakeSelfRelativeSD __attribute__((dllimport))(PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor, LPDWORD lpdwBufferLength);
__stdcall LPVOID MapViewOfFile __attribute__((dllimport)) __attribute__((out))(HANDLE hFileMappingObject __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)), DWORD dwFileOffsetHigh __attribute__((in)), DWORD dwFileOffsetLow __attribute__((in)), SIZE_T dwNumberOfBytesToMap __attribute__((in)));
__stdcall LPVOID MapViewOfFileEx __attribute__((dllimport)) __attribute__((out))(HANDLE hFileMappingObject __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)), DWORD dwFileOffsetHigh __attribute__((in)), DWORD dwFileOffsetLow __attribute__((in)), SIZE_T dwNumberOfBytesToMap __attribute__((in)), LPVOID lpBaseAddress __attribute__((in)));
__stdcall UINT MapVirtualKeyExA __attribute__((dllimport))(UINT uCode __attribute__((in)), UINT uMapType __attribute__((in)), HKL dwhkl __attribute__((in)));
__stdcall UINT MapVirtualKeyExW __attribute__((dllimport))(UINT uCode __attribute__((in)), UINT uMapType __attribute__((in)), HKL dwhkl __attribute__((in)));
__stdcall BOOL MaskBlt __attribute__((dllimport))(HDC hdcDest __attribute__((in)), int xDest __attribute__((in)), int yDest __attribute__((in)), int width __attribute__((in)), int height __attribute__((in)), HDC hdcSrc __attribute__((in)), int xSrc __attribute__((in)), int ySrc __attribute__((in)), HBITMAP hbmMask __attribute__((in)), int xMask __attribute__((in)), int yMask __attribute__((in)), DWORD rop __attribute__((in)));
__stdcall int MessageBoxA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCSTR lpText __attribute__((in)), LPCSTR lpCaption __attribute__((in)), UINT uType __attribute__((in)));
__stdcall int MessageBoxExA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCSTR lpText __attribute__((in)), LPCSTR lpCaption __attribute__((in)), UINT uType __attribute__((in)), WORD wLanguageId __attribute__((in)));
__stdcall BOOL ModifyMenuA __attribute__((dllimport))(HMENU hMnu __attribute__((in)), UINT uPosition __attribute__((in)), UINT uFlags __attribute__((in)), UINT_PTR uIDNewItem __attribute__((in)), LPCSTR lpNewItem __attribute__((in)));
__stdcall HMONITOR MonitorFromWindow __attribute__((dllimport))(HWND hwnd __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL MoveFileA __attribute__((dllimport))(LPCSTR lpExistingFileName __attribute__((in)), LPCSTR lpNewFileName __attribute__((in)));
__stdcall BOOL MoveFileExA __attribute__((dllimport))(LPCSTR lpExistingFileName __attribute__((in)), LPCSTR lpNewFileName __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL MoveWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)), BOOL bRepaint __attribute__((in)));
typedef __stdcall BOOL (*NAMEENUMPROCA)(LPSTR, LPARAM);
__stdcall void NotifyWinEvent __attribute__((dllimport))(DWORD event __attribute__((in)), HWND hwnd __attribute__((in)), LONG idObject __attribute__((in)), LONG idChild __attribute__((in)));
__stdcall NTSTATUS NtClose(HANDLE Handle __attribute__((in)));
__stdcall NTSTATUS NtQueryInformationProcess(HANDLE ProcessHandle __attribute__((in)), PROCESSINFOCLASS ProcessInformationClass __attribute__((in)), PVOID ProcessInformation __attribute__((out)), ULONG ProcessInformationLength __attribute__((in)), PULONG ReturnLength __attribute__((out)));
__stdcall NTSTATUS NtQueryInformationThread(HANDLE ThreadHandle __attribute__((in)), THREADINFOCLASS ThreadInformationClass __attribute__((in)), PVOID ThreadInformation __attribute__((out)), ULONG ThreadInformationLength __attribute__((in)), PULONG ReturnLength __attribute__((out)));
__stdcall NTSTATUS NtQueryObject __attribute__((dllimport))(HANDLE Handle __attribute__((in)), OBJECT_INFORMATION_CLASS ObjectInformationClass __attribute__((in)), PVOID ObjectInformation, ULONG ObjectInformationLength __attribute__((in)), PULONG ReturnLength __attribute__((out)));
__stdcall NTSTATUS NtQuerySystemInformation(SYSTEM_INFORMATION_CLASS SystemInformationClass __attribute__((in)), PVOID SystemInformation __attribute__((out)), ULONG SystemInformationLength __attribute__((in)), PULONG ReturnLength __attribute__((out)));
__stdcall BOOL ObjectCloseAuditAlarmA __attribute__((dllimport))(LPCSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), BOOL GenerateOnClose __attribute__((in)));
__stdcall BOOL OemToCharA __attribute__((dllimport))(LPCSTR pSrc __attribute__((in)), LPSTR pDst);
__stdcall BOOL OemToCharBuffA __attribute__((dllimport))(LPCSTR lpszSrc __attribute__((in)), LPSTR lpszDst, DWORD cchDstLength __attribute__((in)));
__stdcall int OffsetClipRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)));
__stdcall int OffsetRgn __attribute__((dllimport))(HRGN hrgn __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)));
__stdcall HANDLE OpenBackupEventLogA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpUNCServerName __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL OpenClipboard __attribute__((dllimport))(HWND hWndNewOwner __attribute__((in)));
__stdcall HDESK OpenDesktopA __attribute__((dllimport))(LPCSTR lpszDesktop __attribute__((in)), DWORD dwFlags __attribute__((in)), BOOL fInherit __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)));
__stdcall HANDLE OpenEventA __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall HANDLE OpenEventLogA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpUNCServerName __attribute__((in)), LPCSTR lpSourceName __attribute__((in)));
__stdcall HANDLE OpenFileMappingA __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall BOOL OpenIcon __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall HDESK OpenInputDesktop __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), BOOL fInherit __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)));
__stdcall HANDLE OpenMutexA __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall BOOL OpenProcessToken __attribute__((dllimport))(HANDLE ProcessHandle __attribute__((in)), DWORD DesiredAccess __attribute__((in)), PHANDLE TokenHandle);
__stdcall SC_HANDLE OpenSCManagerA __attribute__((dllimport))(LPCSTR lpMachineName __attribute__((in)), LPCSTR lpDatabaseName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)));
__stdcall HANDLE OpenSemaphoreA __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall SC_HANDLE OpenServiceA __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCSTR lpServiceName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)));
__stdcall BOOL OpenThreadToken __attribute__((dllimport))(HANDLE ThreadHandle __attribute__((in)), DWORD DesiredAccess __attribute__((in)), BOOL OpenAsSelf __attribute__((in)), PHANDLE TokenHandle);
__stdcall HWINSTA OpenWindowStationA __attribute__((dllimport))(LPCSTR lpszWinSta __attribute__((in)), BOOL fInherit __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)));
__stdcall void OutputDebugStringA __attribute__((dllimport))(LPCSTR lpOutputString __attribute__((in)));
typedef struct tagPALETTEENTRY PALETTEENTRY;
typedef struct tagPANOSE PANOSE;
typedef BOOLEAN *PBOOLEAN;
typedef const WCHAR *PCNZWCH;
typedef struct _CONSOLE_CURSOR_INFO *PCONSOLE_CURSOR_INFO;
typedef struct _CONSOLE_READCONSOLE_CONTROL *PCONSOLE_READCONSOLE_CONTROL;
typedef struct _COORD *PCOORD;
typedef const WCHAR *PCWSTR;
typedef struct _DISPLAY_DEVICEA *PDISPLAY_DEVICEA;
typedef __stdcall DWORD (*PFE_EXPORT_FUNC)(PBYTE pbData __attribute__((in)), PVOID pvCallbackContext __attribute__((in)), ULONG ulLength __attribute__((in)));
typedef __stdcall DWORD (*PFE_IMPORT_FUNC)(PBYTE pbData, PVOID pvCallbackContext __attribute__((in)), PULONG ulLength);
typedef struct _FILETIME *PFILETIME;
typedef
struct {
	UINT cbSize;
	HWND hwnd;
	DWORD dwFlags;
	UINT uCount;
	DWORD dwTimeout;
} *PFLASHWINFO;
typedef HKEY *PHKEY;
typedef struct tagLASTINPUTINFO *PLASTINPUTINFO;
typedef struct _LDT_ENTRY *PLDT_ENTRY;
typedef struct _LUID *PLUID;
typedef struct tagPOINT POINT;
typedef struct _POINTL POINTL;
typedef struct tagRAWINPUTDEVICELIST *PRAWINPUTDEVICELIST;
typedef __stdcall BOOL (*PROPENUMPROCA)(HWND, LPCSTR, HANDLE);
typedef __stdcall BOOL (*PROPENUMPROCEXA)(HWND, LPSTR, HANDLE, ULONG_PTR);
typedef struct _SID_IDENTIFIER_AUTHORITY *PSID_IDENTIFIER_AUTHORITY;
typedef struct _SMALL_RECT *PSMALL_RECT;
typedef WCHAR *PWCH;
typedef WCHAR *PWSTR;
__stdcall BOOL PaintDesktop __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL PaintRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)));
__stdcall BOOL PatBlt __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), int w __attribute__((in)), int h __attribute__((in)), DWORD rop __attribute__((in)));
__stdcall HRGN PathToRegion __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL PeekNamedPipe __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)), LPVOID lpBuffer, DWORD nBufferSize __attribute__((in)), LPDWORD lpBytesRead __attribute__((out)), LPDWORD lpTotalBytesAvail __attribute__((out)), LPDWORD lpBytesLeftThisMessage __attribute__((out)));
__stdcall BOOL Pie __attribute__((dllimport))(HDC hdc __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)), int xr1 __attribute__((in)), int yr1 __attribute__((in)), int xr2 __attribute__((in)), int yr2 __attribute__((in)));
__stdcall BOOL PlayMetaFile __attribute__((dllimport))(HDC hdc __attribute__((in)), HMETAFILE hmf __attribute__((in)));
__stdcall BOOL PostMessageA __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL PostMessageW __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL PostThreadMessageA __attribute__((dllimport))(DWORD idThread __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL PostThreadMessageW __attribute__((dllimport))(DWORD idThread __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL PrintWindow __attribute__((dllimport))(HWND hwnd __attribute__((in)), HDC hdcBlt __attribute__((in)), UINT nFlags __attribute__((in)));
__stdcall BOOL PtInRegion __attribute__((dllimport))(HRGN hrgn __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)));
__stdcall BOOL PtVisible __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)));
__stdcall BOOL QueryActCtxW __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), HANDLE hActCtx __attribute__((in)), PVOID pvSubInstance __attribute__((in)), ULONG ulInfoClass __attribute__((in)), PVOID pvBuffer, SIZE_T cbBuffer __attribute__((in)), SIZE_T *pcbWrittenOrRequired __attribute__((out)));
__stdcall DWORD QueryDosDeviceA __attribute__((dllimport))(LPCSTR lpDeviceName __attribute__((in)), LPSTR lpTargetPath, DWORD ucchMax __attribute__((in)));
__stdcall BOOL QueryInformationJobObject __attribute__((dllimport))(HANDLE hJob __attribute__((in)), JOBOBJECTINFOCLASS JobObjectInformationClass __attribute__((in)), LPVOID lpJobObjectInformation, DWORD cbJobObjectInformationLength __attribute__((in)), LPDWORD lpReturnLength __attribute__((out)));
__stdcall BOOL QueryServiceConfig2W __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwInfoLevel __attribute__((in)), LPBYTE lpBuffer, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
__stdcall BOOL QueryServiceObjectSecurity __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), SECURITY_INFORMATION dwSecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR lpSecurityDescriptor, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
__stdcall BOOL QueryServiceStatusEx __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), SC_STATUS_TYPE InfoLevel __attribute__((in)), LPBYTE lpBuffer, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
__stdcall DWORD QueueUserAPC __attribute__((dllimport))(PAPCFUNC pfnAPC __attribute__((in)), HANDLE hThread __attribute__((in)), ULONG_PTR dwData __attribute__((in)));
typedef struct tagRECT RECT;
typedef struct _RECTL RECTL;
typedef ACCESS_MASK REGSAM;
typedef struct tagRGBQUAD RGBQUAD;
typedef struct _RIP_INFO RIP_INFO;
__stdcall BOOL ReadProcessMemory __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPCVOID lpBaseAddress __attribute__((in)), LPVOID lpBuffer, SIZE_T nSize __attribute__((in)), SIZE_T *lpNumberOfBytesRead __attribute__((out)));
__stdcall UINT RealGetWindowClassA __attribute__((dllimport))(HWND hwnd __attribute__((in)), LPSTR ptszClassName, UINT cchClassNameMax __attribute__((in)));
__stdcall UINT RealizePalette __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL Rectangle __attribute__((dllimport))(HDC hdc __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)));
__stdcall LSTATUS RegCloseKey __attribute__((dllimport))(HKEY hKey __attribute__((in)));
__stdcall LSTATUS RegDeleteKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)));
__stdcall LSTATUS RegDeleteValueA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpValueName __attribute__((in)));
__stdcall LSTATUS RegDisablePredefinedCache __attribute__((dllimport))(void);
__stdcall LSTATUS RegEnumKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), DWORD dwIndex __attribute__((in)), LPSTR lpName, DWORD cchName __attribute__((in)));
__stdcall LSTATUS RegEnumValueA __attribute__((dllimport))(HKEY hKey __attribute__((in)), DWORD dwIndex __attribute__((in)), LPSTR lpValueName, LPDWORD lpcchValueName, LPDWORD lpReserved, LPDWORD lpType __attribute__((out)), LPBYTE lpData, LPDWORD lpcbData);
__stdcall LSTATUS RegFlushKey __attribute__((dllimport))(HKEY hKey __attribute__((in)));
__stdcall LSTATUS RegGetKeySecurity __attribute__((dllimport))(HKEY hKey __attribute__((in)), SECURITY_INFORMATION SecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor, LPDWORD lpcbSecurityDescriptor);
__stdcall LSTATUS RegLoadKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), LPCSTR lpFile __attribute__((in)));
__stdcall LSTATUS RegNotifyChangeKeyValue __attribute__((dllimport))(HKEY hKey __attribute__((in)), BOOL bWatchSubtree __attribute__((in)), DWORD dwNotifyFilter __attribute__((in)), HANDLE hEvent __attribute__((in)), BOOL fAsynchronous __attribute__((in)));
__stdcall LSTATUS RegOverridePredefKey __attribute__((dllimport))(HKEY hKey __attribute__((in)), HKEY hNewHKey __attribute__((in)));
__stdcall LSTATUS RegQueryValueA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), LPSTR lpData, PLONG lpcbData);
__stdcall LSTATUS RegQueryValueExA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpValueName __attribute__((in)), LPDWORD lpReserved, LPDWORD lpType __attribute__((out)), LPBYTE lpData, LPDWORD lpcbData);
__stdcall LSTATUS RegReplaceKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), LPCSTR lpNewFile __attribute__((in)), LPCSTR lpOldFile __attribute__((in)));
__stdcall LSTATUS RegRestoreKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpFile __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall LSTATUS RegSetKeySecurity __attribute__((dllimport))(HKEY hKey __attribute__((in)), SECURITY_INFORMATION SecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)));
__stdcall LSTATUS RegSetValueA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), DWORD dwType __attribute__((in)), LPCSTR lpData __attribute__((in)), DWORD cbData __attribute__((in)));
__stdcall LSTATUS RegSetValueExA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpValueName __attribute__((in)), DWORD Reserved, DWORD dwType __attribute__((in)), const BYTE *lpData __attribute__((in)), DWORD cbData __attribute__((in)));
__stdcall LSTATUS RegUnLoadKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)));
__stdcall UINT RegisterClipboardFormatA __attribute__((dllimport))(LPCSTR lpszFormat __attribute__((in)));
__stdcall HDEVNOTIFY RegisterDeviceNotificationA __attribute__((dllimport))(HANDLE hRecipient __attribute__((in)), LPVOID NotificationFilter __attribute__((in)), DWORD Flags __attribute__((in)));
__stdcall HDEVNOTIFY RegisterDeviceNotificationW __attribute__((dllimport))(HANDLE hRecipient __attribute__((in)), LPVOID NotificationFilter __attribute__((in)), DWORD Flags __attribute__((in)));
__stdcall HANDLE RegisterEventSourceA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpUNCServerName __attribute__((in)), LPCSTR lpSourceName __attribute__((in)));
__stdcall BOOL RegisterHotKey __attribute__((dllimport))(HWND hWnd __attribute__((in)), int id __attribute__((in)), UINT fsModifiers __attribute__((in)), UINT vk __attribute__((in)));
__stdcall SERVICE_STATUS_HANDLE RegisterServiceCtrlHandlerA __attribute__((dllimport))(LPCSTR lpServiceName __attribute__((in)), LPHANDLER_FUNCTION lpHandlerProc __attribute__((in)));
__stdcall SERVICE_STATUS_HANDLE RegisterServiceCtrlHandlerExA __attribute__((dllimport))(LPCSTR lpServiceName __attribute__((in)), LPHANDLER_FUNCTION_EX lpHandlerProc __attribute__((in)), LPVOID lpContext __attribute__((in)));
__stdcall BOOL RegisterShellHookWindow __attribute__((dllimport))(HWND hwnd __attribute__((in)));
__stdcall UINT RegisterWindowMessageA __attribute__((dllimport))(LPCSTR lpString __attribute__((in)));
__stdcall int ReleaseDC __attribute__((dllimport))(HWND hWnd __attribute__((in)), HDC hDC __attribute__((in)));
__stdcall BOOL RemoveDirectoryA __attribute__((dllimport))(LPCSTR lpPathName __attribute__((in)));
__stdcall BOOL RemoveFontResourceA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL RemoveMenu __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uPosition __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall HANDLE RemovePropA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCSTR lpString __attribute__((in)));
__stdcall BOOL ReplyMessage __attribute__((dllimport))(LRESULT lResult __attribute__((in)));
__stdcall BOOL ReportEventA __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), WORD wType __attribute__((in)), WORD wCategory __attribute__((in)), DWORD dwEventID __attribute__((in)), PSID lpUserSid __attribute__((in)), WORD wNumStrings __attribute__((in)), DWORD dwDataSize __attribute__((in)), LPCSTR *lpStrings __attribute__((in)), LPVOID lpRawData __attribute__((in)));
__stdcall BOOL ResizePalette __attribute__((dllimport))(HPALETTE hpal __attribute__((in)), UINT n __attribute__((in)));
__stdcall BOOL RestoreDC __attribute__((dllimport))(HDC hdc __attribute__((in)), int nSavedDC __attribute__((in)));
__stdcall BOOL RoundRect __attribute__((dllimport))(HDC hdc __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)), int width __attribute__((in)), int height __attribute__((in)));
__stdcall WORD RtlCaptureStackBackTrace __attribute__((dllimport))(DWORD FramesToSkip __attribute__((in)), DWORD FramesToCapture __attribute__((in)), PVOID *BackTrace, PDWORD BackTraceHash __attribute__((out)));
__stdcall NTSTATUS RtlCharToInteger(PCSZ String, ULONG Base, PULONG Value);
__stdcall SIZE_T RtlCompareMemory __attribute__((dllimport))(const void *Source1 __attribute__((in)), const void *Source2 __attribute__((in)), SIZE_T Length __attribute__((in)));
__stdcall ULONG RtlNtStatusToDosError(NTSTATUS Status);
__stdcall ULONG RtlUniform(PULONG Seed);
typedef struct tagSCROLLINFO SCROLLINFO;
typedef struct _SECURITY_ATTRIBUTES SECURITY_ATTRIBUTES;
typedef __stdcall void (*SENDASYNCPROC)(HWND, UINT, ULONG_PTR, LRESULT);
typedef struct _SERVICE_STATUS SERVICE_STATUS;
typedef struct tagSIZE SIZE;
typedef struct _SMALL_RECT SMALL_RECT;
typedef struct _SYSTEMTIME SYSTEMTIME;
__stdcall int SaveDC __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall DWORD SearchPathA __attribute__((dllimport))(LPCSTR lpPath __attribute__((in)), LPCSTR lpFileName __attribute__((in)), LPCSTR lpExtension __attribute__((in)), DWORD nBufferLength __attribute__((in)), LPSTR lpBuffer, LPSTR *lpFilePart __attribute__((out)));
__stdcall BOOL SelectClipPath __attribute__((dllimport))(HDC hdc __attribute__((in)), int mode __attribute__((in)));
__stdcall int SelectClipRgn __attribute__((dllimport))(HDC hdc __attribute__((in)), HRGN hrgn __attribute__((in)));
__stdcall HGDIOBJ SelectObject __attribute__((dllimport))(HDC hdc __attribute__((in)), HGDIOBJ h __attribute__((in)));
__stdcall HPALETTE SelectPalette __attribute__((dllimport))(HDC hdc __attribute__((in)), HPALETTE hPal __attribute__((in)), BOOL bForceBkgd __attribute__((in)));
__stdcall LRESULT SendDlgItemMessageA __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT SendDlgItemMessageW __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT SendMessageA __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT SendMessageTimeoutA __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)), UINT fuFlags __attribute__((in)), UINT uTimeout __attribute__((in)), PDWORD_PTR lpdwResult __attribute__((out)));
__stdcall LRESULT SendMessageTimeoutW __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)), UINT fuFlags __attribute__((in)), UINT uTimeout __attribute__((in)), PDWORD_PTR lpdwResult __attribute__((out)));
__stdcall LRESULT SendMessageW __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL SendNotifyMessageA __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL SendNotifyMessageW __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall HWND SetActiveWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall int SetArcDirection __attribute__((dllimport))(HDC hdc __attribute__((in)), int dir __attribute__((in)));
__stdcall LONG SetBitmapBits __attribute__((dllimport))(HBITMAP hbm __attribute__((in)), DWORD cb __attribute__((in)), const void *pvBits __attribute__((in)));
__stdcall COLORREF SetBkColor __attribute__((dllimport))(HDC hdc __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall int SetBkMode __attribute__((dllimport))(HDC hdc __attribute__((in)), int mode __attribute__((in)));
__stdcall HWND SetCapture __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall DWORD SetClassLongA __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)), LONG dwNewLong __attribute__((in)));
__stdcall DWORD SetClassLongW __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)), LONG dwNewLong __attribute__((in)));
__stdcall WORD SetClassWord __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)), WORD wNewWord __attribute__((in)));
__stdcall HWND SetClipboardViewer __attribute__((dllimport))(HWND hWndNewViewer __attribute__((in)));
__stdcall HCOLORSPACE SetColorSpace __attribute__((dllimport))(HDC hdc __attribute__((in)), HCOLORSPACE hcs __attribute__((in)));
__stdcall BOOL SetComputerNameA __attribute__((dllimport))(LPCSTR lpComputerName __attribute__((in)));
__stdcall BOOL SetConsoleCtrlHandler __attribute__((dllimport))(PHANDLER_ROUTINE HandlerRoutine __attribute__((in)), BOOL Add __attribute__((in)));
__stdcall BOOL SetConsoleTitleA __attribute__((dllimport))(LPCSTR lpConsoleTitle __attribute__((in)));
__stdcall BOOL SetCurrentDirectoryA __attribute__((dllimport))(LPCSTR lpPathName __attribute__((in)));
__stdcall COLORREF SetDCBrushColor __attribute__((dllimport))(HDC hdc __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall BOOL SetDlgItemInt __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), UINT uValue __attribute__((in)), BOOL bSigned __attribute__((in)));
__stdcall BOOL SetDlgItemTextA __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), LPCSTR lpString __attribute__((in)));
__stdcall HENHMETAFILE SetEnhMetaFileBits __attribute__((dllimport))(UINT nSize __attribute__((in)), const BYTE *pb __attribute__((in)));
__stdcall BOOL SetEnvironmentVariableA __attribute__((dllimport))(LPCSTR lpName __attribute__((in)), LPCSTR lpValue __attribute__((in)));
__stdcall BOOL SetFileAttributesA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)), DWORD dwFileAttributes __attribute__((in)));
__stdcall DWORD SetFilePointer __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LONG lDistanceToMove __attribute__((in)), PLONG lpDistanceToMoveHigh, DWORD dwMoveMethod __attribute__((in)));
__stdcall BOOL SetFileSecurityA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)), SECURITY_INFORMATION SecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)));
__stdcall HWND SetFocus __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL SetForegroundWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall int SetGraphicsMode __attribute__((dllimport))(HDC hdc __attribute__((in)), int iMode __attribute__((in)));
__stdcall int SetICMMode __attribute__((dllimport))(HDC hdc __attribute__((in)), int mode __attribute__((in)));
__stdcall BOOL SetICMProfileA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPSTR lpFileName __attribute__((in)));
__stdcall BOOL SetInformationJobObject __attribute__((dllimport))(HANDLE hJob __attribute__((in)), JOBOBJECTINFOCLASS JobObjectInformationClass __attribute__((in)), LPVOID lpJobObjectInformation __attribute__((in)), DWORD cbJobObjectInformationLength __attribute__((in)));
__stdcall BOOL SetKernelObjectSecurity __attribute__((dllimport))(HANDLE Handle __attribute__((in)), SECURITY_INFORMATION SecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR SecurityDescriptor __attribute__((in)));
__stdcall BOOL SetKeyboardState __attribute__((dllimport))(LPBYTE lpKeyState __attribute__((in)));
__stdcall BOOL SetLayeredWindowAttributes __attribute__((dllimport))(HWND hwnd __attribute__((in)), COLORREF crKey __attribute__((in)), BYTE bAlpha __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall DWORD SetLayout __attribute__((dllimport))(HDC hdc __attribute__((in)), DWORD l __attribute__((in)));
__stdcall BOOL SetLocaleInfoA __attribute__((dllimport))(LCID Locale __attribute__((in)), LCTYPE LCType __attribute__((in)), LPCSTR lpLCData __attribute__((in)));
__stdcall int SetMapMode __attribute__((dllimport))(HDC hdc __attribute__((in)), int iMode __attribute__((in)));
__stdcall DWORD SetMapperFlags __attribute__((dllimport))(HDC hdc __attribute__((in)), DWORD flags __attribute__((in)));
__stdcall BOOL SetMenu __attribute__((dllimport))(HWND hWnd __attribute__((in)), HMENU hMenu __attribute__((in)));
__stdcall BOOL SetMenuContextHelpId __attribute__((dllimport))(HMENU __attribute__((in)), DWORD __attribute__((in)));
__stdcall BOOL SetMenuDefaultItem __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uItem __attribute__((in)), UINT fByPos __attribute__((in)));
__stdcall BOOL SetMenuItemBitmaps __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uPosition __attribute__((in)), UINT uFlags __attribute__((in)), HBITMAP hBitmapUnchecked __attribute__((in)), HBITMAP hBitmapChecked __attribute__((in)));
__stdcall LPARAM SetMessageExtraInfo __attribute__((dllimport))(LPARAM lParam __attribute__((in)));
__stdcall HMETAFILE SetMetaFileBitsEx __attribute__((dllimport))(UINT cbBuffer __attribute__((in)), const BYTE *lpData __attribute__((in)));
__stdcall int SetMetaRgn __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL SetMiterLimit __attribute__((dllimport))(HDC hdc __attribute__((in)), FLOAT limit __attribute__((in)), PFLOAT old __attribute__((out)));
__stdcall BOOL SetNamedPipeHandleState __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)), LPDWORD lpMode __attribute__((in)), LPDWORD lpMaxCollectionCount __attribute__((in)), LPDWORD lpCollectDataTimeout __attribute__((in)));
__stdcall HWND SetParent __attribute__((dllimport))(HWND hWndChild __attribute__((in)), HWND hWndNewParent __attribute__((in)));
__stdcall COLORREF SetPixel __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall BOOL SetPixelV __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall int SetPolyFillMode __attribute__((dllimport))(HDC hdc __attribute__((in)), int mode __attribute__((in)));
__stdcall BOOL SetProcessAffinityMask __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), DWORD_PTR dwProcessAffinityMask __attribute__((in)));
__stdcall BOOL SetProcessWindowStation __attribute__((dllimport))(HWINSTA hWinSta __attribute__((in)));
__stdcall BOOL SetProcessWorkingSetSize __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), SIZE_T dwMinimumWorkingSetSize __attribute__((in)), SIZE_T dwMaximumWorkingSetSize __attribute__((in)));
__stdcall BOOL SetPropA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCSTR lpString __attribute__((in)), HANDLE hData __attribute__((in)));
__stdcall int SetROP2 __attribute__((dllimport))(HDC hdc __attribute__((in)), int rop2 __attribute__((in)));
__stdcall BOOL SetRectRgn __attribute__((dllimport))(HRGN hrgn __attribute__((in)), int left __attribute__((in)), int top __attribute__((in)), int right __attribute__((in)), int bottom __attribute__((in)));
__stdcall int SetScrollPos __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nBar __attribute__((in)), int nPos __attribute__((in)), BOOL bRedraw __attribute__((in)));
__stdcall BOOL SetScrollRange __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nBar __attribute__((in)), int nMinPos __attribute__((in)), int nMaxPos __attribute__((in)), BOOL bRedraw __attribute__((in)));
__stdcall BOOL SetSecurityDescriptorControl __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), SECURITY_DESCRIPTOR_CONTROL ControlBitsOfInterest __attribute__((in)), SECURITY_DESCRIPTOR_CONTROL ControlBitsToSet __attribute__((in)));
__stdcall BOOL SetSecurityDescriptorGroup __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor, PSID pGroup __attribute__((in)), BOOL bGroupDefaulted __attribute__((in)));
__stdcall BOOL SetSecurityDescriptorOwner __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor, PSID pOwner __attribute__((in)), BOOL bOwnerDefaulted __attribute__((in)));
__stdcall BOOL SetServiceObjectSecurity __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), SECURITY_INFORMATION dwSecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR lpSecurityDescriptor __attribute__((in)));
__stdcall int SetStretchBltMode __attribute__((dllimport))(HDC hdc __attribute__((in)), int mode __attribute__((in)));
__stdcall BOOL SetSysColors __attribute__((dllimport))(int cElements __attribute__((in)), const INT *lpaElements __attribute__((in)), const COLORREF *lpaRgbValues __attribute__((in)));
__stdcall UINT SetSystemPaletteUse __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT use __attribute__((in)));
__stdcall UINT SetTextAlign __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT align __attribute__((in)));
__stdcall int SetTextCharacterExtra __attribute__((dllimport))(HDC hdc __attribute__((in)), int extra __attribute__((in)));
__stdcall COLORREF SetTextColor __attribute__((dllimport))(HDC hdc __attribute__((in)), COLORREF color __attribute__((in)));
__stdcall BOOL SetTextJustification __attribute__((dllimport))(HDC hdc __attribute__((in)), int extra __attribute__((in)), int count __attribute__((in)));
__stdcall DWORD_PTR SetThreadAffinityMask __attribute__((dllimport))(HANDLE hThread __attribute__((in)), DWORD_PTR dwThreadAffinityMask __attribute__((in)));
__stdcall BOOL SetThreadDesktop __attribute__((dllimport))(HDESK hDesktop __attribute__((in)));
__stdcall EXECUTION_STATE SetThreadExecutionState __attribute__((dllimport))(EXECUTION_STATE esFlags __attribute__((in)));
__stdcall BOOL SetThreadLocale __attribute__((dllimport))(LCID Locale __attribute__((in)));
__stdcall BOOL SetThreadToken __attribute__((dllimport))(PHANDLE Thread __attribute__((in)), HANDLE Token __attribute__((in)));
__stdcall LANGID SetThreadUILanguage __attribute__((dllimport))(LANGID LangId __attribute__((in)));
__stdcall BOOL SetTokenInformation __attribute__((dllimport))(HANDLE TokenHandle __attribute__((in)), TOKEN_INFORMATION_CLASS TokenInformationClass __attribute__((in)), LPVOID TokenInformation __attribute__((in)), DWORD TokenInformationLength __attribute__((in)));
__stdcall BOOL SetUserGeoID __attribute__((dllimport))(GEOID GeoId __attribute__((in)));
__stdcall BOOL SetUserObjectSecurity __attribute__((dllimport))(HANDLE hObj __attribute__((in)), PSECURITY_INFORMATION pSIRequested __attribute__((in)), PSECURITY_DESCRIPTOR pSID __attribute__((in)));
__stdcall BOOL SetVolumeLabelA __attribute__((dllimport))(LPCSTR lpRootPathName __attribute__((in)), LPCSTR lpVolumeName __attribute__((in)));
__stdcall BOOL SetWindowContextHelpId __attribute__((dllimport))(HWND __attribute__((in)), DWORD __attribute__((in)));
__stdcall LONG SetWindowLongA __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)), LONG dwNewLong __attribute__((in)));
__stdcall LONG SetWindowLongW __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)), LONG dwNewLong __attribute__((in)));
__stdcall BOOL SetWindowPos __attribute__((dllimport))(HWND hWnd __attribute__((in)), HWND hWndInsertAfter __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall int SetWindowRgn __attribute__((dllimport))(HWND hWnd __attribute__((in)), HRGN hRgn __attribute__((in)), BOOL bRedraw __attribute__((in)));
__stdcall BOOL SetWindowTextA __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCSTR lpString __attribute__((in)));
__stdcall WORD SetWindowWord __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nIndex __attribute__((in)), WORD wNewWord __attribute__((in)));
__stdcall BOOL ShowCaret __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL ShowOwnedPopups __attribute__((dllimport))(HWND hWnd __attribute__((in)), BOOL fShow __attribute__((in)));
__stdcall BOOL ShowScrollBar __attribute__((dllimport))(HWND hWnd __attribute__((in)), int wBar __attribute__((in)), BOOL bShow __attribute__((in)));
__stdcall BOOL ShowWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nCmdShow __attribute__((in)));
__stdcall BOOL ShowWindowAsync __attribute__((dllimport))(HWND hWnd __attribute__((in)), int nCmdShow __attribute__((in)));
__stdcall int StartPage __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL StartServiceA __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwNumServiceArgs __attribute__((in)), LPCSTR *lpServiceArgVectors __attribute__((in)));
__stdcall BOOL StretchBlt __attribute__((dllimport))(HDC hdcDest __attribute__((in)), int xDest __attribute__((in)), int yDest __attribute__((in)), int wDest __attribute__((in)), int hDest __attribute__((in)), HDC hdcSrc __attribute__((in)), int xSrc __attribute__((in)), int ySrc __attribute__((in)), int wSrc __attribute__((in)), int hSrc __attribute__((in)), DWORD rop __attribute__((in)));
__stdcall BOOL StrokeAndFillPath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL StrokePath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL SwapBuffers __attribute__((dllimport))(HDC);
__stdcall BOOL SwitchDesktop __attribute__((dllimport))(HDESK hDesktop __attribute__((in)));
__stdcall void SwitchToThisWindow __attribute__((dllimport))(HWND hwnd __attribute__((in)), BOOL fUnknown __attribute__((in)));
typedef struct tagTEXTMETRICA TEXTMETRICA;
typedef __stdcall BOOL (*TIMEFMT_ENUMPROCA)(LPSTR);
typedef __stdcall void (*TIMERPROC)(HWND, UINT, UINT_PTR, DWORD);
__stdcall LONG TabbedTextOutA __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPCSTR lpString __attribute__((in)), int chCount __attribute__((in)), int nTabPositions __attribute__((in)), const INT *lpnTabStopPositions __attribute__((in)), int nTabOrigin __attribute__((in)));
__stdcall BOOL TextOutA __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPCSTR lpString __attribute__((in)), int c __attribute__((in)));
__stdcall int ToAscii __attribute__((dllimport))(UINT uVirtKey __attribute__((in)), UINT uScanCode __attribute__((in)), const BYTE *lpKeyState __attribute__((in)), LPWORD lpChar __attribute__((out)), UINT uFlags __attribute__((in)));
__stdcall int ToAsciiEx __attribute__((dllimport))(UINT uVirtKey __attribute__((in)), UINT uScanCode __attribute__((in)), const BYTE *lpKeyState __attribute__((in)), LPWORD lpChar __attribute__((out)), UINT uFlags __attribute__((in)), HKL dwhkl __attribute__((in)));
__stdcall BOOL TransparentBlt __attribute__((dllimport))(HDC hdcDest __attribute__((in)), int xoriginDest __attribute__((in)), int yoriginDest __attribute__((in)), int wDest __attribute__((in)), int hDest __attribute__((in)), HDC hdcSrc __attribute__((in)), int xoriginSrc __attribute__((in)), int yoriginSrc __attribute__((in)), int wSrc __attribute__((in)), int hSrc __attribute__((in)), UINT crTransparent __attribute__((in)));
typedef union _ULARGE_INTEGER ULARGE_INTEGER;
typedef struct _UNLOAD_DLL_DEBUG_INFO UNLOAD_DLL_DEBUG_INFO;
__stdcall BOOL UnhookWinEvent __attribute__((dllimport))(HWINEVENTHOOK hWinEventHook __attribute__((in)));
__stdcall BOOL UnhookWindowsHookEx __attribute__((dllimport))(HHOOK hhk __attribute__((in)));
__stdcall BOOL UnloadKeyboardLayout __attribute__((dllimport))(HKL hkl __attribute__((in)));
__stdcall BOOL UnlockServiceDatabase __attribute__((dllimport))(SC_LOCK ScLock __attribute__((in)));
__stdcall BOOL UnregisterClassA __attribute__((dllimport))(LPCSTR lpClassName __attribute__((in)), HINSTANCE hInstance __attribute__((in)));
__stdcall BOOL UnregisterDeviceNotification __attribute__((dllimport))(HDEVNOTIFY Handle __attribute__((in)));
__stdcall BOOL UnregisterHotKey __attribute__((dllimport))(HWND hWnd __attribute__((in)), int id __attribute__((in)));
__stdcall BOOL UpdateColors __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall BOOL UpdateResourceA __attribute__((dllimport))(HANDLE hUpdate __attribute__((in)), LPCSTR lpType __attribute__((in)), LPCSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)), LPVOID lpData __attribute__((in)), DWORD cb __attribute__((in)));
__stdcall BOOL UpdateWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)));
__stdcall BOOL ValidateRgn __attribute__((dllimport))(HWND hWnd __attribute__((in)), HRGN hRgn __attribute__((in)));
__stdcall DWORD VerLanguageNameA(DWORD wLang __attribute__((in)), LPSTR szLang, DWORD cchLang __attribute__((in)));
__stdcall BOOL VerQueryValueA(LPCVOID pBlock __attribute__((in)), LPCSTR lpSubBlock __attribute__((in)), LPVOID *lplpBuffer, PUINT puLen __attribute__((out)));
__stdcall LPVOID VirtualAlloc __attribute__((dllimport))(LPVOID lpAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)), DWORD flAllocationType __attribute__((in)), DWORD flProtect __attribute__((in)));
__stdcall LPVOID VirtualAllocEx __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPVOID lpAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)), DWORD flAllocationType __attribute__((in)), DWORD flProtect __attribute__((in)));
__stdcall BOOL VirtualFree __attribute__((dllimport))(LPVOID lpAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)), DWORD dwFreeType __attribute__((in)));
__stdcall BOOL VirtualFreeEx __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPVOID lpAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)), DWORD dwFreeType __attribute__((in)));
__stdcall BOOL VirtualLock __attribute__((dllimport))(LPVOID lpAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)));
__stdcall BOOL VirtualProtect __attribute__((dllimport))(LPVOID lpAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)), DWORD flNewProtect __attribute__((in)), PDWORD lpflOldProtect __attribute__((out)));
__stdcall BOOL VirtualUnlock __attribute__((dllimport))(LPVOID lpAddress __attribute__((in)), SIZE_T dwSize __attribute__((in)));
__stdcall SHORT VkKeyScanExA __attribute__((dllimport))(CHAR ch __attribute__((in)), HKL dwhkl __attribute__((in)));
__stdcall SHORT VkKeyScanW __attribute__((dllimport))(WCHAR ch __attribute__((in)));
typedef __stdcall void (*WAITORTIMERCALLBACKFUNC)(PVOID, BOOLEAN);
typedef __stdcall void (*WINEVENTPROC)(HWINEVENTHOOK hWinEventHook, DWORD event, HWND hwnd, LONG idObject, LONG idChild, DWORD idEventThread, DWORD dwmsEventTime);
typedef __stdcall BOOL (*WNDENUMPROC)(HWND, LPARAM);
typedef __stdcall LRESULT (*WNDPROC)(HWND, UINT, WPARAM, LPARAM);
__stdcall DWORD WNetAddConnectionA(LPCSTR lpRemoteName __attribute__((in)), LPCSTR lpPassword __attribute__((in)), LPCSTR lpLocalName __attribute__((in)));
__stdcall DWORD WNetCancelConnection2A(LPCSTR lpName __attribute__((in)), DWORD dwFlags __attribute__((in)), BOOL fForce __attribute__((in)));
__stdcall DWORD WNetConnectionDialog(HWND hwnd __attribute__((in)), DWORD dwType __attribute__((in)));
__stdcall DWORD WNetEnumResourceA(HANDLE hEnum __attribute__((in)), LPDWORD lpcCount, LPVOID lpBuffer, LPDWORD lpBufferSize);
__stdcall DWORD WNetEnumResourceW(HANDLE hEnum __attribute__((in)), LPDWORD lpcCount, LPVOID lpBuffer, LPDWORD lpBufferSize);
__stdcall DWORD WNetGetConnectionA(LPCSTR lpLocalName __attribute__((in)), LPSTR lpRemoteName, LPDWORD lpnLength);
__stdcall BOOL WaitNamedPipeA __attribute__((dllimport))(LPCSTR lpNamedPipeName __attribute__((in)), DWORD nTimeOut __attribute__((in)));
__stdcall BOOL WidenPath __attribute__((dllimport))(HDC hdc __attribute__((in)));
__stdcall UINT WinExec __attribute__((dllimport))(LPCSTR lpCmdLine __attribute__((in)), UINT uCmdShow __attribute__((in)));
__stdcall BOOL WinHelpA __attribute__((dllimport))(HWND hWndMain __attribute__((in)), LPCSTR lpszHelp __attribute__((in)), UINT uCommand __attribute__((in)), ULONG_PTR dwData __attribute__((in)));
__stdcall HWND WindowFromDC __attribute__((dllimport))(HDC hDC __attribute__((in)));
__stdcall BOOL WriteConsoleA __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const void *lpBuffer __attribute__((in)), DWORD nNumberOfCharsToWrite __attribute__((in)), LPDWORD lpNumberOfCharsWritten __attribute__((out)), LPVOID lpReserved);
__stdcall BOOL WriteConsoleW __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const void *lpBuffer __attribute__((in)), DWORD nNumberOfCharsToWrite __attribute__((in)), LPDWORD lpNumberOfCharsWritten __attribute__((out)), LPVOID lpReserved);
__stdcall BOOL WritePrivateProfileSectionA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpString __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL WritePrivateProfileStringA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpKeyName __attribute__((in)), LPCSTR lpString __attribute__((in)), LPCSTR lpFileName __attribute__((in)));
__stdcall BOOL WritePrivateProfileStructA __attribute__((dllimport))(LPCSTR lpszSection __attribute__((in)), LPCSTR lpszKey __attribute__((in)), LPVOID lpStruct __attribute__((in)), UINT uSizeStruct __attribute__((in)), LPCSTR szFile __attribute__((in)));
__stdcall BOOL WriteProcessMemory __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPVOID lpBaseAddress __attribute__((in)), LPCVOID lpBuffer __attribute__((in)), SIZE_T nSize __attribute__((in)), SIZE_T *lpNumberOfBytesWritten __attribute__((out)));
__stdcall BOOL WriteProfileSectionA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpString __attribute__((in)));
__stdcall BOOL WriteProfileStringA __attribute__((dllimport))(LPCSTR lpAppName __attribute__((in)), LPCSTR lpKeyName __attribute__((in)), LPCSTR lpString __attribute__((in)));
typedef struct tagXFORM XFORM;

struct _CHAR_INFO {

	union {
		WCHAR UnicodeChar;
		CHAR AsciiChar;
	} Char;
	WORD Attributes;
};

struct _COMMPROP {
	WORD wPacketLength;
	WORD wPacketVersion;
	DWORD dwServiceMask;
	DWORD dwReserved1;
	DWORD dwMaxTxQueue;
	DWORD dwMaxRxQueue;
	DWORD dwMaxBaud;
	DWORD dwProvSubType;
	DWORD dwProvCapabilities;
	DWORD dwSettableParams;
	DWORD dwSettableBaud;
	WORD wSettableData;
	WORD wSettableStopParity;
	DWORD dwCurrentTxQueue;
	DWORD dwCurrentRxQueue;
	DWORD dwProvSpec1;
	DWORD dwProvSpec2;
	WCHAR wcProvChar[1];
};

struct _DISPLAY_DEVICEW {
	DWORD cb;
	WCHAR DeviceName[32];
	WCHAR DeviceString[128];
	DWORD StateFlags;
	WCHAR DeviceID[128];
	WCHAR DeviceKey[128];
};

struct _DOCINFOA {
	int cbSize;
	LPCSTR lpszDocName;
	LPCSTR lpszOutput;
	LPCSTR lpszDatatype;
	DWORD fwType;
};

struct _GENERIC_MAPPING {
	ACCESS_MASK GenericRead;
	ACCESS_MASK GenericWrite;
	ACCESS_MASK GenericExecute;
	ACCESS_MASK GenericAll;
};

struct _ICONINFO {
	BOOL fIcon;
	DWORD xHotspot;
	DWORD yHotspot;
	HBITMAP hbmMask;
	HBITMAP hbmColor;
};

struct _IO_STATUS_BLOCK {

	union {
		NTSTATUS Status;
		PVOID Pointer;
	} u;
	ULONG_PTR Information;
};

struct _KEY_EVENT_RECORD {
	BOOL bKeyDown;
	WORD wRepeatCount;
	WORD wVirtualKeyCode;
	WORD wVirtualScanCode;

	union {
		WCHAR UnicodeChar;
		CHAR AsciiChar;
	} uChar;
	DWORD dwControlKeyState;
};

struct _MEMORYSTATUS {
	DWORD dwLength;
	DWORD dwMemoryLoad;
	SIZE_T dwTotalPhys;
	SIZE_T dwAvailPhys;
	SIZE_T dwTotalPageFile;
	SIZE_T dwAvailPageFile;
	SIZE_T dwTotalVirtual;
	SIZE_T dwAvailVirtual;
};

struct _MEMORYSTATUSEX {
	DWORD dwLength;
	DWORD dwMemoryLoad;
	DWORDLONG ullTotalPhys;
	DWORDLONG ullAvailPhys;
	DWORDLONG ullTotalPageFile;
	DWORDLONG ullAvailPageFile;
	DWORDLONG ullTotalVirtual;
	DWORDLONG ullAvailVirtual;
	DWORDLONG ullAvailExtendedVirtual;
};

struct _MEMORY_BASIC_INFORMATION {
	PVOID BaseAddress;
	PVOID AllocationBase;
	DWORD AllocationProtect;
	SIZE_T RegionSize;
	DWORD State;
	DWORD Protect;
	DWORD Type;
};

struct _NETRESOURCEA {
	DWORD dwScope;
	DWORD dwType;
	DWORD dwDisplayType;
	DWORD dwUsage;
	LPSTR lpLocalName;
	LPSTR lpRemoteName;
	LPSTR lpComment;
	LPSTR lpProvider;
};

struct _OBJECT_TYPE_LIST {
	WORD Level;
	WORD Sbz;
	GUID *ObjectType;
};

struct _OSVERSIONINFOEXW {
	DWORD dwOSVersionInfoSize;
	DWORD dwMajorVersion;
	DWORD dwMinorVersion;
	DWORD dwBuildNumber;
	DWORD dwPlatformId;
	WCHAR szCSDVersion[128];
	WORD wServicePackMajor;
	WORD wServicePackMinor;
	WORD wSuiteMask;
	BYTE wProductType;
	BYTE wReserved;
};

struct _OSVERSIONINFOW {
	DWORD dwOSVersionInfoSize;
	DWORD dwMajorVersion;
	DWORD dwMinorVersion;
	DWORD dwBuildNumber;
	DWORD dwPlatformId;
	WCHAR szCSDVersion[128];
};

struct _OUTPUT_DEBUG_STRING_INFO {
	LPSTR lpDebugStringData;
	WORD fUnicode;
	WORD nDebugStringLength;
};

struct _QUERY_SERVICE_CONFIGA {
	DWORD dwServiceType;
	DWORD dwStartType;
	DWORD dwErrorControl;
	LPSTR lpBinaryPathName;
	LPSTR lpLoadOrderGroup;
	DWORD dwTagId;
	LPSTR lpDependencies;
	LPSTR lpServiceStartName;
	LPSTR lpDisplayName;
};

struct _QUERY_SERVICE_LOCK_STATUSA {
	DWORD fIsLocked;
	LPSTR lpLockOwner;
	DWORD dwLockDuration;
};

struct _RTL_CRITICAL_SECTION_DEBUG {
	WORD Type;
	WORD CreatorBackTraceIndex;
	struct _RTL_CRITICAL_SECTION *CriticalSection;
	LIST_ENTRY ProcessLocksList;
	DWORD EntryCount;
	DWORD ContentionCount;
	DWORD Flags;
	WORD CreatorBackTraceIndexHigh;
	WORD SpareWORD;
};

struct _SID_AND_ATTRIBUTES {
	PSID Sid;
	DWORD Attributes;
};

union _SLIST_HEADER {
	ULONGLONG Alignment;

	struct {
		SINGLE_LIST_ENTRY Next;
		WORD Depth;
		WORD Sequence;
	} s;
};

struct _STARTUPINFOA {
	DWORD cb;
	LPSTR lpReserved;
	LPSTR lpDesktop;
	LPSTR lpTitle;
	DWORD dwX;
	DWORD dwY;
	DWORD dwXSize;
	DWORD dwYSize;
	DWORD dwXCountChars;
	DWORD dwYCountChars;
	DWORD dwFillAttribute;
	DWORD dwFlags;
	WORD wShowWindow;
	WORD cbReserved2;
	LPBYTE lpReserved2;
	HANDLE hStdInput;
	HANDLE hStdOutput;
	HANDLE hStdError;
};

struct _STRING {
	USHORT Length;
	USHORT MaximumLength;
	PCHAR Buffer;
};

struct _SYSTEM_INFO {

	union {
		DWORD dwOemId;

		struct {
			WORD wProcessorArchitecture;
			WORD wReserved;
		} s;
	} u;
	DWORD dwPageSize;
	LPVOID lpMinimumApplicationAddress;
	LPVOID lpMaximumApplicationAddress;
	DWORD_PTR dwActiveProcessorMask;
	DWORD dwNumberOfProcessors;
	DWORD dwProcessorType;
	DWORD dwAllocationGranularity;
	WORD wProcessorLevel;
	WORD wProcessorRevision;
};

struct _TRIVERTEX {
	LONG x;
	LONG y;
	COLOR16 Red;
	COLOR16 Green;
	COLOR16 Blue;
	COLOR16 Alpha;
};

struct _currencyfmtA {
	UINT NumDigits;
	UINT LeadingZero;
	UINT Grouping;
	LPSTR lpDecimalSep;
	LPSTR lpThousandSep;
	UINT NegativeOrder;
	UINT PositiveOrder;
	LPSTR lpCurrencySymbol;
};
__stdcall long _hwrite __attribute__((dllimport))(HFILE hFile __attribute__((in)), LPCCH lpBuffer __attribute__((in)), long lBytes __attribute__((in)));
__stdcall HFILE _lcreat __attribute__((dllimport))(LPCSTR lpPathName __attribute__((in)), int iAttribute __attribute__((in)));
__stdcall HFILE _lopen __attribute__((dllimport))(LPCSTR lpPathName __attribute__((in)), int iReadWrite __attribute__((in)));
__stdcall UINT _lwrite __attribute__((dllimport))(HFILE hFile __attribute__((in)), LPCCH lpBuffer __attribute__((in)), UINT uBytes __attribute__((in)));

struct _numberfmtA {
	UINT NumDigits;
	UINT LeadingZero;
	UINT Grouping;
	LPSTR lpDecimalSep;
	LPSTR lpThousandSep;
	UINT NegativeOrder;
};
__stdcall LPSTR lstrcatA __attribute__((dllimport)) __attribute__((out))(LPSTR lpString1, LPCSTR lpString2 __attribute__((in)));
__stdcall int lstrcmpA __attribute__((dllimport))(LPCSTR lpString1 __attribute__((in)), LPCSTR lpString2 __attribute__((in)));
__stdcall int lstrcmpiA __attribute__((dllimport))(LPCSTR lpString1 __attribute__((in)), LPCSTR lpString2 __attribute__((in)));
__stdcall LPSTR lstrcpyA __attribute__((dllimport)) __attribute__((out))(LPSTR lpString1, LPCSTR lpString2 __attribute__((in)));
__stdcall LPSTR lstrcpynA __attribute__((dllimport)) __attribute__((out))(LPSTR lpString1, LPCSTR lpString2 __attribute__((in)), int iMaxLength __attribute__((in)));
__stdcall int lstrlenA __attribute__((dllimport))(LPCSTR lpString __attribute__((in)));

struct tagHW_PROFILE_INFOW {
	DWORD dwDockInfo;
	WCHAR szHwProfileGuid[39];
	WCHAR szHwProfileName[80];
};

struct tagLOGBRUSH {
	UINT lbStyle;
	COLORREF lbColor;
	ULONG_PTR lbHatch;
};

struct tagLOGFONTW {
	LONG lfHeight;
	LONG lfWidth;
	LONG lfEscapement;
	LONG lfOrientation;
	LONG lfWeight;
	BYTE lfItalic;
	BYTE lfUnderline;
	BYTE lfStrikeOut;
	BYTE lfCharSet;
	BYTE lfOutPrecision;
	BYTE lfClipPrecision;
	BYTE lfQuality;
	BYTE lfPitchAndFamily;
	WCHAR lfFaceName[32];
};

struct tagMENUINFO {
	DWORD cbSize;
	DWORD fMask;
	DWORD dwStyle;
	UINT cyMax;
	HBRUSH hbrBack;
	DWORD dwContextHelpID;
	ULONG_PTR dwMenuData;
};

struct tagMENUITEMINFOA {
	UINT cbSize;
	UINT fMask;
	UINT fType;
	UINT fState;
	UINT wID;
	HMENU hSubMenu;
	HBITMAP hbmpChecked;
	HBITMAP hbmpUnchecked;
	ULONG_PTR dwItemData;
	LPSTR dwTypeData;
	UINT cch;
	HBITMAP hbmpItem;
};

struct tagMETAFILEPICT {
	LONG mm;
	LONG xExt;
	LONG yExt;
	HMETAFILE hMF;
};

struct tagRAWINPUTDEVICE {
	USHORT usUsagePage;
	USHORT usUsage;
	DWORD dwFlags;
	HWND hwndTarget;
};

struct tagTEXTMETRICW {
	LONG tmHeight;
	LONG tmAscent;
	LONG tmDescent;
	LONG tmInternalLeading;
	LONG tmExternalLeading;
	LONG tmAveCharWidth;
	LONG tmMaxCharWidth;
	LONG tmWeight;
	LONG tmOverhang;
	LONG tmDigitizedAspectX;
	LONG tmDigitizedAspectY;
	WCHAR tmFirstChar;
	WCHAR tmLastChar;
	WCHAR tmDefaultChar;
	WCHAR tmBreakChar;
	BYTE tmItalic;
	BYTE tmUnderlined;
	BYTE tmStruckOut;
	BYTE tmPitchAndFamily;
	BYTE tmCharSet;
} __attribute__((pack(4)));

struct tagTRACKMOUSEEVENT {
	DWORD cbSize;
	DWORD dwFlags;
	HWND hwndTrack;
	DWORD dwHoverTime;
};
__cdecl int wsprintfA __attribute__((dllimport))(LPSTR __attribute__((out)), LPCSTR __attribute__((in)), ...);
__stdcall int wvsprintfA __attribute__((dllimport))(LPSTR __attribute__((out)), LPCSTR __attribute__((in)), va_list arglist __attribute__((in)));


__stdcall BOOL AbortSystemShutdownW __attribute__((dllimport))(LPWSTR lpMachineName __attribute__((in)));
__stdcall ATOM AddAtomW __attribute__((dllimport))(LPCWSTR lpString __attribute__((in)));
__stdcall BOOL AddConsoleAliasW __attribute__((dllimport))(LPWSTR Source __attribute__((in)), LPWSTR Target __attribute__((in)), LPWSTR ExeName __attribute__((in)));
__stdcall int AddFontResourceExW __attribute__((dllimport))(LPCWSTR name __attribute__((in)), DWORD fl __attribute__((in)), PVOID res);
__stdcall int AddFontResourceW __attribute__((dllimport))(LPCWSTR __attribute__((in)));
__stdcall BOOL AdjustWindowRect __attribute__((dllimport))(LPRECT lpRect, DWORD dwStyle __attribute__((in)), BOOL bMenu __attribute__((in)));
__stdcall BOOL AdjustWindowRectEx __attribute__((dllimport))(LPRECT lpRect, DWORD dwStyle __attribute__((in)), BOOL bMenu __attribute__((in)), DWORD dwExStyle __attribute__((in)));
__stdcall BOOL AllocateAndInitializeSid __attribute__((dllimport))(PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority __attribute__((in)), BYTE nSubAuthorityCount __attribute__((in)), DWORD nSubAuthority0 __attribute__((in)), DWORD nSubAuthority1 __attribute__((in)), DWORD nSubAuthority2 __attribute__((in)), DWORD nSubAuthority3 __attribute__((in)), DWORD nSubAuthority4 __attribute__((in)), DWORD nSubAuthority5 __attribute__((in)), DWORD nSubAuthority6 __attribute__((in)), DWORD nSubAuthority7 __attribute__((in)), PSID *pSid);
__stdcall BOOL AllocateLocallyUniqueId __attribute__((dllimport))(PLUID Luid __attribute__((out)));
__stdcall BOOL AnimatePalette __attribute__((dllimport))(HPALETTE hPal __attribute__((in)), UINT iStartIndex __attribute__((in)), UINT cEntries __attribute__((in)), const PALETTEENTRY *ppe __attribute__((in)));
__stdcall BOOL AppendMenuW __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uFlags __attribute__((in)), UINT_PTR uIDNewItem __attribute__((in)), LPCWSTR lpNewItem __attribute__((in)));
__stdcall BOOL BackupEventLogW __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), LPCWSTR lpBackupFileName __attribute__((in)));
__stdcall HANDLE BeginUpdateResourceW __attribute__((dllimport))(LPCWSTR pFileName __attribute__((in)), BOOL bDeleteExistingResources __attribute__((in)));
__stdcall BOOL BuildCommDCBA __attribute__((dllimport))(LPCSTR lpDef __attribute__((in)), LPDCB lpDCB __attribute__((out)));
__stdcall BOOL BuildCommDCBAndTimeoutsA __attribute__((dllimport))(LPCSTR lpDef __attribute__((in)), LPDCB lpDCB __attribute__((out)), LPCOMMTIMEOUTS lpCommTimeouts __attribute__((out)));
__stdcall BOOL BuildCommDCBW __attribute__((dllimport))(LPCWSTR lpDef __attribute__((in)), LPDCB lpDCB __attribute__((out)));
typedef __stdcall BOOL (*CALINFO_ENUMPROCW)(LPWSTR);
typedef struct _CHAR_INFO CHAR_INFO;
typedef __stdcall BOOL (*CODEPAGE_ENUMPROCW)(LPWSTR);
typedef struct _currencyfmtA CURRENCYFMTA;
__stdcall BOOL CallNamedPipeW __attribute__((dllimport))(LPCWSTR lpNamedPipeName __attribute__((in)), LPVOID lpInBuffer __attribute__((in)), DWORD nInBufferSize __attribute__((in)), LPVOID lpOutBuffer, DWORD nOutBufferSize __attribute__((in)), LPDWORD lpBytesRead __attribute__((out)), DWORD nTimeOut __attribute__((in)));
__stdcall LRESULT CallWindowProcA __attribute__((dllimport))(WNDPROC lpPrevWndFunc __attribute__((in)), HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall LRESULT CallWindowProcW __attribute__((dllimport))(WNDPROC lpPrevWndFunc __attribute__((in)), HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall WORD CascadeWindows __attribute__((dllimport))(HWND hwndParent __attribute__((in)), UINT wHow __attribute__((in)), const RECT *lpRect __attribute__((in)), UINT cKids __attribute__((in)), const HWND *lpKids __attribute__((in)));
__stdcall BOOL ChangeMenuW __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT cmd __attribute__((in)), LPCWSTR lpszNewItem __attribute__((in)), UINT cmdInsert __attribute__((in)), UINT flags __attribute__((in)));
__stdcall BOOL ChangeServiceConfigW __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwServiceType __attribute__((in)), DWORD dwStartType __attribute__((in)), DWORD dwErrorControl __attribute__((in)), LPCWSTR lpBinaryPathName __attribute__((in)), LPCWSTR lpLoadOrderGroup __attribute__((in)), LPDWORD lpdwTagId __attribute__((out)), LPCWSTR lpDependencies __attribute__((in)), LPCWSTR lpServiceStartName __attribute__((in)), LPCWSTR lpPassword __attribute__((in)), LPCWSTR lpDisplayName __attribute__((in)));
__stdcall DWORD CharLowerBuffW __attribute__((dllimport))(LPWSTR lpsz, DWORD cchLength __attribute__((in)));
__stdcall LPWSTR CharLowerW __attribute__((dllimport))(LPWSTR lpsz);
__stdcall LPWSTR CharNextW __attribute__((dllimport))(LPCWSTR lpsz __attribute__((in)));
__stdcall LPWSTR CharPrevW __attribute__((dllimport))(LPCWSTR lpszStart __attribute__((in)), LPCWSTR lpszCurrent __attribute__((in)));
__stdcall BOOL CharToOemBuffW __attribute__((dllimport))(LPCWSTR lpszSrc __attribute__((in)), LPSTR lpszDst, DWORD cchDstLength __attribute__((in)));
__stdcall BOOL CharToOemW __attribute__((dllimport))(LPCWSTR pSrc __attribute__((in)), LPSTR pDst);
__stdcall DWORD CharUpperBuffW __attribute__((dllimport))(LPWSTR lpsz, DWORD cchLength __attribute__((in)));
__stdcall LPWSTR CharUpperW __attribute__((dllimport))(LPWSTR lpsz);
__stdcall HWND ChildWindowFromPoint __attribute__((dllimport))(HWND hWndParent __attribute__((in)), POINT Point __attribute__((in)));
__stdcall HWND ChildWindowFromPointEx __attribute__((dllimport))(HWND hwnd __attribute__((in)), POINT pt __attribute__((in)), UINT flags __attribute__((in)));
__stdcall BOOL ClearCommError __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPDWORD lpErrors __attribute__((out)), LPCOMSTAT lpStat __attribute__((out)));
__stdcall BOOL ClearEventLogW __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), LPCWSTR lpBackupFileName __attribute__((in)));
__stdcall BOOL ClientToScreen __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPPOINT lpPoint);
__stdcall BOOL ClipCursor __attribute__((dllimport))(const RECT *lpRect __attribute__((in)));
__stdcall BOOL CombineTransform __attribute__((dllimport))(LPXFORM lpxfOut __attribute__((out)), const XFORM *lpxf1 __attribute__((in)), const XFORM *lpxf2 __attribute__((in)));
__stdcall LONG CompareFileTime __attribute__((dllimport))(const FILETIME *lpFileTime1 __attribute__((in)), const FILETIME *lpFileTime2 __attribute__((in)));
__stdcall int CompareStringW __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwCmpFlags __attribute__((in)), PCNZWCH lpString1 __attribute__((in)), int cchCount1 __attribute__((in)), PCNZWCH lpString2 __attribute__((in)), int cchCount2 __attribute__((in)));
__stdcall BOOL ConnectNamedPipe __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)), LPOVERLAPPED lpOverlapped);
__stdcall BOOL ControlService __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwControl __attribute__((in)), LPSERVICE_STATUS lpServiceStatus __attribute__((out)));
__stdcall int CopyAcceleratorTableA __attribute__((dllimport))(HACCEL hAccelSrc __attribute__((in)), LPACCEL lpAccelDst, int cAccelEntries __attribute__((in)));
__stdcall int CopyAcceleratorTableW __attribute__((dllimport))(HACCEL hAccelSrc __attribute__((in)), LPACCEL lpAccelDst, int cAccelEntries __attribute__((in)));
__stdcall HENHMETAFILE CopyEnhMetaFileW __attribute__((dllimport))(HENHMETAFILE hEnh __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall BOOL CopyFileW __attribute__((dllimport))(LPCWSTR lpExistingFileName __attribute__((in)), LPCWSTR lpNewFileName __attribute__((in)), BOOL bFailIfExists __attribute__((in)));
__stdcall HMETAFILE CopyMetaFileW __attribute__((dllimport))(HMETAFILE __attribute__((in)), LPCWSTR __attribute__((in)));
__stdcall BOOL CopyRect __attribute__((dllimport))(LPRECT lprcDst __attribute__((out)), const RECT *lprcSrc __attribute__((in)));
__stdcall HACCEL CreateAcceleratorTableA __attribute__((dllimport))(LPACCEL paccel __attribute__((in)), int cAccel __attribute__((in)));
__stdcall HACCEL CreateAcceleratorTableW __attribute__((dllimport))(LPACCEL paccel __attribute__((in)), int cAccel __attribute__((in)));
__stdcall HBITMAP CreateBitmapIndirect __attribute__((dllimport))(const BITMAP *pbm __attribute__((in)));
__stdcall HANDLE CreateConsoleScreenBuffer __attribute__((dllimport))(DWORD dwDesiredAccess __attribute__((in)), DWORD dwShareMode __attribute__((in)), const SECURITY_ATTRIBUTES *lpSecurityAttributes __attribute__((in)), DWORD dwFlags __attribute__((in)), LPVOID lpScreenBufferData);
__stdcall HCURSOR CreateCursor __attribute__((dllimport))(HINSTANCE hInst __attribute__((in)), int xHotSpot __attribute__((in)), int yHotSpot __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)), const void *pvANDPlane __attribute__((in)), const void *pvXORPlane __attribute__((in)));
__stdcall HWND CreateDialogIndirectParamA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCDLGTEMPLATEA lpTemplate __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall HWND CreateDialogIndirectParamW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCDLGTEMPLATEW lpTemplate __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall HWND CreateDialogParamA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpTemplateName __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall HWND CreateDialogParamW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpTemplateName __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall BOOL CreateDirectoryA __attribute__((dllimport))(LPCSTR lpPathName __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall BOOL CreateDirectoryExA __attribute__((dllimport))(LPCSTR lpTemplateDirectory __attribute__((in)), LPCSTR lpNewDirectory __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall BOOL CreateDirectoryExW __attribute__((dllimport))(LPCWSTR lpTemplateDirectory __attribute__((in)), LPCWSTR lpNewDirectory __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall BOOL CreateDirectoryW __attribute__((dllimport))(LPCWSTR lpPathName __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall HRGN CreateEllipticRgnIndirect __attribute__((dllimport))(const RECT *lprect __attribute__((in)));
__stdcall HDC CreateEnhMetaFileA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpFilename __attribute__((in)), const RECT *lprc __attribute__((in)), LPCSTR lpDesc __attribute__((in)));
__stdcall HDC CreateEnhMetaFileW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpFilename __attribute__((in)), const RECT *lprc __attribute__((in)), LPCWSTR lpDesc __attribute__((in)));
__stdcall HANDLE CreateEventA __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpEventAttributes __attribute__((in)), BOOL bManualReset __attribute__((in)), BOOL bInitialState __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall HANDLE CreateEventW __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpEventAttributes __attribute__((in)), BOOL bManualReset __attribute__((in)), BOOL bInitialState __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall LPVOID CreateFiber __attribute__((dllimport)) __attribute__((out))(SIZE_T dwStackSize __attribute__((in)), LPFIBER_START_ROUTINE lpStartAddress __attribute__((in)), LPVOID lpParameter __attribute__((in)));
__stdcall HANDLE CreateFileA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpFileName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)), DWORD dwShareMode __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)), DWORD dwCreationDisposition __attribute__((in)), DWORD dwFlagsAndAttributes __attribute__((in)), HANDLE hTemplateFile __attribute__((in)));
__stdcall HANDLE CreateFileMappingA __attribute__((dllimport)) __attribute__((out))(HANDLE hFile __attribute__((in)), LPSECURITY_ATTRIBUTES lpFileMappingAttributes __attribute__((in)), DWORD flProtect __attribute__((in)), DWORD dwMaximumSizeHigh __attribute__((in)), DWORD dwMaximumSizeLow __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall HANDLE CreateFileMappingW __attribute__((dllimport)) __attribute__((out))(HANDLE hFile __attribute__((in)), LPSECURITY_ATTRIBUTES lpFileMappingAttributes __attribute__((in)), DWORD flProtect __attribute__((in)), DWORD dwMaximumSizeHigh __attribute__((in)), DWORD dwMaximumSizeLow __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall HANDLE CreateFileW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpFileName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)), DWORD dwShareMode __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)), DWORD dwCreationDisposition __attribute__((in)), DWORD dwFlagsAndAttributes __attribute__((in)), HANDLE hTemplateFile __attribute__((in)));
__stdcall HFONT CreateFontIndirectA __attribute__((dllimport))(const LOGFONTA *lplf __attribute__((in)));
__stdcall HFONT CreateFontW __attribute__((dllimport))(int cHeight __attribute__((in)), int cWidth __attribute__((in)), int cEscapement __attribute__((in)), int cOrientation __attribute__((in)), int cWeight __attribute__((in)), DWORD bItalic __attribute__((in)), DWORD bUnderline __attribute__((in)), DWORD bStrikeOut __attribute__((in)), DWORD iCharSet __attribute__((in)), DWORD iOutPrecision __attribute__((in)), DWORD iClipPrecision __attribute__((in)), DWORD iQuality __attribute__((in)), DWORD iPitchAndFamily __attribute__((in)), LPCWSTR pszFaceName __attribute__((in)));
__stdcall BOOL CreateHardLinkW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), LPCWSTR lpExistingFileName __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes);
__stdcall HANDLE CreateJobObjectA __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpJobAttributes __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall HANDLE CreateJobObjectW __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpJobAttributes __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall HANDLE CreateMailslotA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpName __attribute__((in)), DWORD nMaxMessageSize __attribute__((in)), DWORD lReadTimeout __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall HANDLE CreateMailslotW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpName __attribute__((in)), DWORD nMaxMessageSize __attribute__((in)), DWORD lReadTimeout __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall HDC CreateMetaFileW __attribute__((dllimport))(LPCWSTR pszFile __attribute__((in)));
__stdcall HANDLE CreateMutexA __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpMutexAttributes __attribute__((in)), BOOL bInitialOwner __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall HANDLE CreateMutexW __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpMutexAttributes __attribute__((in)), BOOL bInitialOwner __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall HANDLE CreateNamedPipeA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpName __attribute__((in)), DWORD dwOpenMode __attribute__((in)), DWORD dwPipeMode __attribute__((in)), DWORD nMaxInstances __attribute__((in)), DWORD nOutBufferSize __attribute__((in)), DWORD nInBufferSize __attribute__((in)), DWORD nDefaultTimeOut __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall HANDLE CreateNamedPipeW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpName __attribute__((in)), DWORD dwOpenMode __attribute__((in)), DWORD dwPipeMode __attribute__((in)), DWORD nMaxInstances __attribute__((in)), DWORD nOutBufferSize __attribute__((in)), DWORD nInBufferSize __attribute__((in)), DWORD nDefaultTimeOut __attribute__((in)), LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall BOOL CreatePipe __attribute__((dllimport))(PHANDLE hReadPipe, PHANDLE hWritePipe, LPSECURITY_ATTRIBUTES lpPipeAttributes __attribute__((in)), DWORD nSize __attribute__((in)));
__stdcall HRGN CreatePolyPolygonRgn __attribute__((dllimport))(const POINT *pptl __attribute__((in)), const INT *pc __attribute__((in)), int cPoly __attribute__((in)), int iMode __attribute__((in)));
__stdcall HRGN CreatePolygonRgn __attribute__((dllimport))(const POINT *pptl __attribute__((in)), int cPoint __attribute__((in)), int iMode __attribute__((in)));
__stdcall HRGN CreateRectRgnIndirect __attribute__((dllimport))(const RECT *lprect __attribute__((in)));
__stdcall HANDLE CreateRemoteThread __attribute__((dllimport)) __attribute__((out))(HANDLE hProcess __attribute__((in)), LPSECURITY_ATTRIBUTES lpThreadAttributes __attribute__((in)), SIZE_T dwStackSize __attribute__((in)), LPTHREAD_START_ROUTINE lpStartAddress __attribute__((in)), LPVOID lpParameter __attribute__((in)), DWORD dwCreationFlags __attribute__((in)), LPDWORD lpThreadId __attribute__((out)));
__stdcall HANDLE CreateSemaphoreA __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpSemaphoreAttributes __attribute__((in)), LONG lInitialCount __attribute__((in)), LONG lMaximumCount __attribute__((in)), LPCSTR lpName __attribute__((in)));
__stdcall HANDLE CreateSemaphoreW __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpSemaphoreAttributes __attribute__((in)), LONG lInitialCount __attribute__((in)), LONG lMaximumCount __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall SC_HANDLE CreateServiceW __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCWSTR lpServiceName __attribute__((in)), LPCWSTR lpDisplayName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)), DWORD dwServiceType __attribute__((in)), DWORD dwStartType __attribute__((in)), DWORD dwErrorControl __attribute__((in)), LPCWSTR lpBinaryPathName __attribute__((in)), LPCWSTR lpLoadOrderGroup __attribute__((in)), LPDWORD lpdwTagId __attribute__((out)), LPCWSTR lpDependencies __attribute__((in)), LPCWSTR lpServiceStartName __attribute__((in)), LPCWSTR lpPassword __attribute__((in)));
__stdcall HANDLE CreateThread __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpThreadAttributes __attribute__((in)), SIZE_T dwStackSize __attribute__((in)), LPTHREAD_START_ROUTINE lpStartAddress __attribute__((in)), LPVOID lpParameter __attribute__((in)), DWORD dwCreationFlags __attribute__((in)), LPDWORD lpThreadId __attribute__((out)));
__stdcall HANDLE CreateWaitableTimerA __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpTimerAttributes __attribute__((in)), BOOL bManualReset __attribute__((in)), LPCSTR lpTimerName __attribute__((in)));
__stdcall HANDLE CreateWaitableTimerW __attribute__((dllimport)) __attribute__((out))(LPSECURITY_ATTRIBUTES lpTimerAttributes __attribute__((in)), BOOL bManualReset __attribute__((in)), LPCWSTR lpTimerName __attribute__((in)));
__stdcall HWND CreateWindowExW __attribute__((dllimport))(DWORD dwExStyle __attribute__((in)), LPCWSTR lpClassName __attribute__((in)), LPCWSTR lpWindowName __attribute__((in)), DWORD dwStyle __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)), HWND hWndParent __attribute__((in)), HMENU hMenu __attribute__((in)), HINSTANCE hInstance __attribute__((in)), LPVOID lpParam __attribute__((in)));
__stdcall HWINSTA CreateWindowStationA __attribute__((dllimport))(LPCSTR lpwinsta __attribute__((in)), DWORD dwFlags __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)), LPSECURITY_ATTRIBUTES lpsa __attribute__((in)));
__stdcall HWINSTA CreateWindowStationW __attribute__((dllimport))(LPCWSTR lpwinsta __attribute__((in)), DWORD dwFlags __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)), LPSECURITY_ATTRIBUTES lpsa __attribute__((in)));
typedef __stdcall BOOL (*DATEFMT_ENUMPROCW)(LPWSTR);
typedef NAMEENUMPROCA DESKTOPENUMPROCA;
typedef struct _DOCINFOA DOCINFOA;
__stdcall BOOL DPtoLP __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT lppt, int c __attribute__((in)));
__stdcall BOOL DecryptFileW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), DWORD dwReserved);
__stdcall BOOL DefineDosDeviceW __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), LPCWSTR lpDeviceName __attribute__((in)), LPCWSTR lpTargetPath __attribute__((in)));
__stdcall BOOL DeleteFileW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)));
__stdcall BOOL DeleteVolumeMountPointW __attribute__((dllimport))(LPCWSTR lpszVolumeMountPoint __attribute__((in)));
__stdcall int DescribePixelFormat __attribute__((dllimport))(HDC hdc __attribute__((in)), int iPixelFormat __attribute__((in)), UINT nBytes __attribute__((in)), LPPIXELFORMATDESCRIPTOR ppfd);
__stdcall BOOL DestroyCursor __attribute__((dllimport))(HCURSOR hCursor __attribute__((in)));
__stdcall BOOL DeviceIoControl __attribute__((dllimport))(HANDLE hDevice __attribute__((in)), DWORD dwIoControlCode __attribute__((in)), LPVOID lpInBuffer __attribute__((in)), DWORD nInBufferSize __attribute__((in)), LPVOID lpOutBuffer, DWORD nOutBufferSize __attribute__((in)), LPDWORD lpBytesReturned __attribute__((out)), LPOVERLAPPED lpOverlapped);
__stdcall INT_PTR DialogBoxIndirectParamA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCDLGTEMPLATEA hDialogTemplate __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall INT_PTR DialogBoxIndirectParamW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCDLGTEMPLATEW hDialogTemplate __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall INT_PTR DialogBoxParamA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpTemplateName __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall INT_PTR DialogBoxParamW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpTemplateName __attribute__((in)), HWND hWndParent __attribute__((in)), DLGPROC lpDialogFunc __attribute__((in)), LPARAM dwInitParam __attribute__((in)));
__stdcall BOOL DisableThreadLibraryCalls __attribute__((dllimport))(HMODULE hLibModule __attribute__((in)));
__stdcall int DlgDirListComboBoxW __attribute__((dllimport))(HWND hDlg __attribute__((in)), LPWSTR lpPathSpec, int nIDComboBox __attribute__((in)), int nIDStaticPath __attribute__((in)), UINT uFiletype __attribute__((in)));
__stdcall int DlgDirListW __attribute__((dllimport))(HWND hDlg __attribute__((in)), LPWSTR lpPathSpec, int nIDListBox __attribute__((in)), int nIDStaticPath __attribute__((in)), UINT uFileType __attribute__((in)));
__stdcall BOOL DlgDirSelectComboBoxExW __attribute__((dllimport))(HWND hwndDlg __attribute__((in)), LPWSTR lpString, int cchOut __attribute__((in)), int idComboBox __attribute__((in)));
__stdcall BOOL DlgDirSelectExW __attribute__((dllimport))(HWND hwndDlg __attribute__((in)), LPWSTR lpString, int chCount __attribute__((in)), int idListBox __attribute__((in)));
__stdcall BOOL DnsHostnameToComputerNameW __attribute__((dllimport))(LPCWSTR Hostname __attribute__((in)), LPWSTR ComputerName, LPDWORD nSize);
__stdcall BOOL DosDateTimeToFileTime __attribute__((dllimport))(WORD wFatDate __attribute__((in)), WORD wFatTime __attribute__((in)), LPFILETIME lpFileTime __attribute__((out)));
__stdcall BOOL DragDetect __attribute__((dllimport))(HWND hwnd __attribute__((in)), POINT pt __attribute__((in)));
__stdcall DWORD DragObject __attribute__((dllimport))(HWND hwndParent __attribute__((in)), HWND hwndFrom __attribute__((in)), UINT fmt __attribute__((in)), ULONG_PTR data __attribute__((in)), HCURSOR hcur __attribute__((in)));
__stdcall BOOL DrawAnimatedRects __attribute__((dllimport))(HWND hwnd __attribute__((in)), int idAni __attribute__((in)), const RECT *lprcFrom __attribute__((in)), const RECT *lprcTo __attribute__((in)));
__stdcall BOOL DrawCaption __attribute__((dllimport))(HWND hwnd __attribute__((in)), HDC hdc __attribute__((in)), const RECT *lprect __attribute__((in)), UINT flags __attribute__((in)));
__stdcall BOOL DrawEdge __attribute__((dllimport))(HDC hdc __attribute__((in)), LPRECT qrc, UINT edge __attribute__((in)), UINT grfFlags __attribute__((in)));
__stdcall BOOL DrawFocusRect __attribute__((dllimport))(HDC hDC __attribute__((in)), const RECT *lprc __attribute__((in)));
__stdcall BOOL DrawFrameControl __attribute__((dllimport))(HDC __attribute__((in)), LPRECT, UINT __attribute__((in)), UINT __attribute__((in)));
__stdcall BOOL DrawStateA __attribute__((dllimport))(HDC hdc __attribute__((in)), HBRUSH hbrFore __attribute__((in)), DRAWSTATEPROC qfnCallBack __attribute__((in)), LPARAM lData __attribute__((in)), WPARAM wData __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall BOOL DrawStateW __attribute__((dllimport))(HDC hdc __attribute__((in)), HBRUSH hbrFore __attribute__((in)), DRAWSTATEPROC qfnCallBack __attribute__((in)), LPARAM lData __attribute__((in)), WPARAM wData __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), UINT uFlags __attribute__((in)));
__stdcall int DrawTextA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpchText, int cchText __attribute__((in)), LPRECT lprc, UINT format __attribute__((in)));
__stdcall int DrawTextExA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPSTR lpchText, int cchText __attribute__((in)), LPRECT lprc, UINT format __attribute__((in)), LPDRAWTEXTPARAMS lpdtp __attribute__((in)));
__stdcall int DrawTextExW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPWSTR lpchText, int cchText __attribute__((in)), LPRECT lprc, UINT format __attribute__((in)), LPDRAWTEXTPARAMS lpdtp __attribute__((in)));
__stdcall int DrawTextW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpchText, int cchText __attribute__((in)), LPRECT lprc, UINT format __attribute__((in)));
__stdcall BOOL DuplicateTokenEx __attribute__((dllimport))(HANDLE hExistingToken __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)), LPSECURITY_ATTRIBUTES lpTokenAttributes __attribute__((in)), SECURITY_IMPERSONATION_LEVEL ImpersonationLevel __attribute__((in)), TOKEN_TYPE TokenType __attribute__((in)), PHANDLE phNewToken);
typedef __stdcall int (*ENHMFENUMPROC)(HDC hdc __attribute__((in)), HANDLETABLE *lpht __attribute__((in)), const ENHMETARECORD *lpmr __attribute__((in)), int nHandles __attribute__((in)), LPARAM data __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESLANGPROCA)(HMODULE hModule __attribute__((in)), LPCSTR lpType __attribute__((in)), LPCSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESLANGPROCW)(HMODULE hModule __attribute__((in)), LPCWSTR lpType __attribute__((in)), LPCWSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESNAMEPROCA)(HMODULE hModule __attribute__((in)), LPCSTR lpType __attribute__((in)), LPSTR lpName __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESNAMEPROCW)(HMODULE hModule __attribute__((in)), LPCWSTR lpType __attribute__((in)), LPWSTR lpName __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESTYPEPROCA)(HMODULE hModule __attribute__((in)), LPSTR lpType __attribute__((in)), LONG_PTR lParam __attribute__((in)));
__stdcall BOOL EncryptFileW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)));
__stdcall BOOL EnumCalendarInfoA __attribute__((dllimport))(CALINFO_ENUMPROCA lpCalInfoEnumProc __attribute__((in)), LCID Locale __attribute__((in)), CALID Calendar __attribute__((in)), CALTYPE CalType __attribute__((in)));
__stdcall BOOL EnumChildWindows __attribute__((dllimport))(HWND hWndParent __attribute__((in)), WNDENUMPROC lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumDateFormatsA __attribute__((dllimport))(DATEFMT_ENUMPROCA lpDateFmtEnumProc __attribute__((in)), LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumDesktopWindows __attribute__((dllimport))(HDESK hDesktop __attribute__((in)), WNDENUMPROC lpfn __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumDisplayDevicesA __attribute__((dllimport))(LPCSTR lpDevice __attribute__((in)), DWORD iDevNum __attribute__((in)), PDISPLAY_DEVICEA lpDisplayDevice, DWORD dwFlags __attribute__((in)));
__stdcall int EnumICMProfilesA __attribute__((dllimport))(HDC hdc __attribute__((in)), ICMENUMPROCA proc __attribute__((in)), LPARAM param __attribute__((in)));
__stdcall int EnumObjects __attribute__((dllimport))(HDC hdc __attribute__((in)), int nType __attribute__((in)), GOBJENUMPROC lpFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall int EnumPropsA __attribute__((dllimport))(HWND hWnd __attribute__((in)), PROPENUMPROCA lpEnumFunc __attribute__((in)));
__stdcall int EnumPropsExA __attribute__((dllimport))(HWND hWnd __attribute__((in)), PROPENUMPROCEXA lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumServicesStatusExW __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), SC_ENUM_TYPE InfoLevel __attribute__((in)), DWORD dwServiceType __attribute__((in)), DWORD dwServiceState __attribute__((in)), LPBYTE lpServices, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)), LPDWORD lpServicesReturned __attribute__((out)), LPDWORD lpResumeHandle, LPCWSTR pszGroupName __attribute__((in)));
__stdcall BOOL EnumSystemGeoID __attribute__((dllimport))(GEOCLASS GeoClass __attribute__((in)), GEOID ParentGeoId __attribute__((in)), GEO_ENUMPROC lpGeoEnumProc __attribute__((in)));
__stdcall BOOL EnumSystemLocalesA __attribute__((dllimport))(LOCALE_ENUMPROCA lpLocaleEnumProc __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumThreadWindows __attribute__((dllimport))(DWORD dwThreadId __attribute__((in)), WNDENUMPROC lpfn __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumTimeFormatsA __attribute__((dllimport))(TIMEFMT_ENUMPROCA lpTimeFmtEnumProc __attribute__((in)), LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumWindows __attribute__((dllimport))(WNDENUMPROC lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EqualRect __attribute__((dllimport))(const RECT *lprc1 __attribute__((in)), const RECT *lprc2 __attribute__((in)));
__stdcall DWORD ExpandEnvironmentStringsW __attribute__((dllimport))(LPCWSTR lpSrc __attribute__((in)), LPWSTR lpDst, DWORD nSize __attribute__((in)));
__stdcall BOOL ExtTextOutA __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), UINT options __attribute__((in)), const RECT *lprect __attribute__((in)), LPCSTR lpString __attribute__((in)), UINT c __attribute__((in)), const INT *lpDx __attribute__((in)));
__stdcall BOOL ExtTextOutW __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), UINT options __attribute__((in)), const RECT *lprect __attribute__((in)), LPCWSTR lpString __attribute__((in)), UINT c __attribute__((in)), const INT *lpDx __attribute__((in)));
__stdcall void FatalAppExitW __attribute__((dllimport))(UINT uAction __attribute__((in)), LPCWSTR lpMessageText __attribute__((in)));
__stdcall BOOL FileEncryptionStatusW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), LPDWORD lpStatus __attribute__((out)));
__stdcall BOOL FileTimeToDosDateTime __attribute__((dllimport))(const FILETIME *lpFileTime __attribute__((in)), LPWORD lpFatDate __attribute__((out)), LPWORD lpFatTime __attribute__((out)));
__stdcall BOOL FileTimeToLocalFileTime __attribute__((dllimport))(const FILETIME *lpFileTime __attribute__((in)), LPFILETIME lpLocalFileTime __attribute__((out)));
__stdcall BOOL FileTimeToSystemTime __attribute__((dllimport))(const FILETIME *lpFileTime __attribute__((in)), LPSYSTEMTIME lpSystemTime __attribute__((out)));
__stdcall BOOL FillConsoleOutputAttribute __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), WORD wAttribute __attribute__((in)), DWORD nLength __attribute__((in)), COORD dwWriteCoord __attribute__((in)), LPDWORD lpNumberOfAttrsWritten __attribute__((out)));
__stdcall BOOL FillConsoleOutputCharacterA __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), CHAR cCharacter __attribute__((in)), DWORD nLength __attribute__((in)), COORD dwWriteCoord __attribute__((in)), LPDWORD lpNumberOfCharsWritten __attribute__((out)));
__stdcall BOOL FillConsoleOutputCharacterW __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), WCHAR cCharacter __attribute__((in)), DWORD nLength __attribute__((in)), COORD dwWriteCoord __attribute__((in)), LPDWORD lpNumberOfCharsWritten __attribute__((out)));
__stdcall int FillRect __attribute__((dllimport))(HDC hDC __attribute__((in)), const RECT *lprc __attribute__((in)), HBRUSH hbr __attribute__((in)));
__stdcall ATOM FindAtomW __attribute__((dllimport))(LPCWSTR lpString __attribute__((in)));
__stdcall HANDLE FindFirstChangeNotificationW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpPathName __attribute__((in)), BOOL bWatchSubtree __attribute__((in)), DWORD dwNotifyFilter __attribute__((in)));
__stdcall HANDLE FindFirstFileExW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpFileName __attribute__((in)), FINDEX_INFO_LEVELS fInfoLevelId __attribute__((in)), LPVOID lpFindFileData __attribute__((out)), FINDEX_SEARCH_OPS fSearchOp __attribute__((in)), LPVOID lpSearchFilter, DWORD dwAdditionalFlags __attribute__((in)));
__stdcall HANDLE FindFirstVolumeMountPointW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpszRootPathName __attribute__((in)), LPWSTR lpszVolumeMountPoint, DWORD cchBufferLength __attribute__((in)));
__stdcall HANDLE FindFirstVolumeW __attribute__((dllimport)) __attribute__((out))(LPWSTR lpszVolumeName, DWORD cchBufferLength __attribute__((in)));
__stdcall BOOL FindNextVolumeMountPointW __attribute__((dllimport))(HANDLE hFindVolumeMountPoint __attribute__((in)), LPWSTR lpszVolumeMountPoint, DWORD cchBufferLength __attribute__((in)));
__stdcall BOOL FindNextVolumeW __attribute__((dllimport))(HANDLE hFindVolume, LPWSTR lpszVolumeName, DWORD cchBufferLength __attribute__((in)));
__stdcall HRSRC FindResourceA __attribute__((dllimport)) __attribute__((out))(HMODULE hModule __attribute__((in)), LPCSTR lpName __attribute__((in)), LPCSTR lpType __attribute__((in)));
__stdcall HRSRC FindResourceExA __attribute__((dllimport)) __attribute__((out))(HMODULE hModule __attribute__((in)), LPCSTR lpType __attribute__((in)), LPCSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)));
__stdcall HRSRC FindResourceExW __attribute__((dllimport)) __attribute__((out))(HMODULE hModule __attribute__((in)), LPCWSTR lpType __attribute__((in)), LPCWSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)));
__stdcall HRSRC FindResourceW __attribute__((dllimport)) __attribute__((out))(HMODULE hModule __attribute__((in)), LPCWSTR lpName __attribute__((in)), LPCWSTR lpType __attribute__((in)));
__stdcall HWND FindWindowExW __attribute__((dllimport))(HWND hWndParent __attribute__((in)), HWND hWndChildAfter __attribute__((in)), LPCWSTR lpszClass __attribute__((in)), LPCWSTR lpszWindow __attribute__((in)));
__stdcall HWND FindWindowW __attribute__((dllimport))(LPCWSTR lpClassName __attribute__((in)), LPCWSTR lpWindowName __attribute__((in)));
__stdcall BOOL FlashWindowEx __attribute__((dllimport))(PFLASHWINFO pfwi __attribute__((in)));
__stdcall int FoldStringW __attribute__((dllimport))(DWORD dwMapFlags __attribute__((in)), LPCWSTR lpSrcStr __attribute__((in)), int cchSrc __attribute__((in)), LPWSTR lpDestStr, int cchDest __attribute__((in)));
__stdcall DWORD FormatMessageW __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), LPCVOID lpSource __attribute__((in)), DWORD dwMessageId __attribute__((in)), DWORD dwLanguageId __attribute__((in)), LPWSTR lpBuffer __attribute__((out)), DWORD nSize __attribute__((in)), va_list *Arguments __attribute__((in)));
__stdcall int FrameRect __attribute__((dllimport))(HDC hDC __attribute__((in)), const RECT *lprc __attribute__((in)), HBRUSH hbr __attribute__((in)));
__stdcall BOOL FreeEnvironmentStringsW __attribute__((dllimport))(LPWCH __attribute__((in)));
__stdcall BOOL FreeLibrary __attribute__((dllimport))(HMODULE hLibModule __attribute__((in)));
__noreturn __stdcall void FreeLibraryAndExitThread __attribute__((dllimport))(HMODULE hLibModule __attribute__((in)), DWORD dwExitCode __attribute__((in)));
typedef struct _GENERIC_MAPPING GENERIC_MAPPING;
__stdcall BOOL GdiAlphaBlend __attribute__((dllimport))(HDC hdcDest __attribute__((in)), int xoriginDest __attribute__((in)), int yoriginDest __attribute__((in)), int wDest __attribute__((in)), int hDest __attribute__((in)), HDC hdcSrc __attribute__((in)), int xoriginSrc __attribute__((in)), int yoriginSrc __attribute__((in)), int wSrc __attribute__((in)), int hSrc __attribute__((in)), BLENDFUNCTION ftn __attribute__((in)));
__stdcall BOOL GetAspectRatioFilterEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPSIZE lpsize __attribute__((out)));
__stdcall UINT GetAtomNameW __attribute__((dllimport))(ATOM nAtom __attribute__((in)), LPWSTR lpBuffer, int nSize __attribute__((in)));
__stdcall BOOL GetBinaryTypeW __attribute__((dllimport))(LPCWSTR lpApplicationName __attribute__((in)), LPDWORD lpBinaryType __attribute__((out)));
__stdcall BOOL GetBitmapDimensionEx __attribute__((dllimport))(HBITMAP hbit __attribute__((in)), LPSIZE lpsize __attribute__((out)));
__stdcall UINT GetBoundsRect __attribute__((dllimport))(HDC hdc __attribute__((in)), LPRECT lprect __attribute__((out)), UINT flags __attribute__((in)));
__stdcall BOOL GetBrushOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall BOOL GetCPInfo __attribute__((dllimport))(UINT CodePage __attribute__((in)), LPCPINFO lpCPInfo __attribute__((out)));
__stdcall int GetCalendarInfoW __attribute__((dllimport))(LCID Locale __attribute__((in)), CALID Calendar __attribute__((in)), CALTYPE CalType __attribute__((in)), LPWSTR lpCalData, int cchData __attribute__((in)), LPDWORD lpValue __attribute__((out)));
__stdcall BOOL GetCaretPos __attribute__((dllimport))(LPPOINT lpPoint __attribute__((out)));
__stdcall BOOL GetCharABCWidthsA __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT wFirst __attribute__((in)), UINT wLast __attribute__((in)), LPABC lpABC);
__stdcall BOOL GetCharABCWidthsFloatA __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iFirst __attribute__((in)), UINT iLast __attribute__((in)), LPABCFLOAT lpABC);
__stdcall BOOL GetCharABCWidthsW __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT wFirst __attribute__((in)), UINT wLast __attribute__((in)), LPABC lpABC);
__stdcall int GetClassNameW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPWSTR lpClassName, int nMaxCount __attribute__((in)));
__stdcall BOOL GetClientRect __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPRECT lpRect __attribute__((out)));
__stdcall int GetClipBox __attribute__((dllimport))(HDC hdc __attribute__((in)), LPRECT lprect __attribute__((out)));
__stdcall BOOL GetClipCursor __attribute__((dllimport))(LPRECT lpRect __attribute__((out)));
__stdcall int GetClipboardFormatNameW __attribute__((dllimport))(UINT format __attribute__((in)), LPWSTR lpszFormatName, int cchMaxCount __attribute__((in)));
__stdcall BOOL GetCommState __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPDCB lpDCB __attribute__((out)));
__stdcall BOOL GetCommTimeouts __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPCOMMTIMEOUTS lpCommTimeouts __attribute__((out)));
__stdcall LPWSTR GetCommandLineW __attribute__((dllimport)) __attribute__((out))(void);
__stdcall DWORD GetCompressedFileSizeW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), LPDWORD lpFileSizeHigh __attribute__((out)));
__stdcall BOOL GetComputerNameExW __attribute__((dllimport))(COMPUTER_NAME_FORMAT NameType __attribute__((in)), LPWSTR lpBuffer, LPDWORD nSize);
__stdcall BOOL GetComputerNameW __attribute__((dllimport))(LPWSTR lpBuffer, LPDWORD nSize);
__stdcall DWORD GetConsoleAliasExesW __attribute__((dllimport))(LPWSTR ExeNameBuffer, DWORD ExeNameBufferLength __attribute__((in)));
__stdcall DWORD GetConsoleAliasesLengthW __attribute__((dllimport))(LPWSTR ExeName __attribute__((in)));
__stdcall DWORD GetConsoleAliasesW __attribute__((dllimport))(LPWSTR AliasBuffer, DWORD AliasBufferLength __attribute__((in)), LPWSTR ExeName __attribute__((in)));
__stdcall BOOL GetConsoleCursorInfo __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), PCONSOLE_CURSOR_INFO lpConsoleCursorInfo __attribute__((out)));
__stdcall COORD GetConsoleFontSize __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), DWORD nFont __attribute__((in)));
__stdcall DWORD GetConsoleTitleW __attribute__((dllimport))(LPWSTR lpConsoleTitle, DWORD nSize __attribute__((in)));
__stdcall DWORD GetCurrentDirectoryW __attribute__((dllimport))(DWORD nBufferLength __attribute__((in)), LPWSTR lpBuffer);
__stdcall BOOL GetCurrentHwProfileA __attribute__((dllimport))(LPHW_PROFILE_INFOA lpHwProfileInfo __attribute__((out)));
__stdcall BOOL GetCurrentPositionEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall HCURSOR GetCursor __attribute__((dllimport))(void);
__stdcall BOOL GetCursorPos __attribute__((dllimport))(LPPOINT lpPoint __attribute__((out)));
__stdcall BOOL GetDCOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall UINT GetDIBColorTable __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iStart __attribute__((in)), UINT cEntries __attribute__((in)), RGBQUAD *prgbq);
__stdcall int GetDateFormatA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), const SYSTEMTIME *lpDate __attribute__((in)), LPCSTR lpFormat __attribute__((in)), LPSTR lpDateStr, int cchDate __attribute__((in)));
__stdcall int GetDateFormatW __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), const SYSTEMTIME *lpDate __attribute__((in)), LPCWSTR lpFormat __attribute__((in)), LPWSTR lpDateStr, int cchDate __attribute__((in)));
__stdcall BOOL GetDiskFreeSpaceW __attribute__((dllimport))(LPCWSTR lpRootPathName __attribute__((in)), LPDWORD lpSectorsPerCluster __attribute__((out)), LPDWORD lpBytesPerSector __attribute__((out)), LPDWORD lpNumberOfFreeClusters __attribute__((out)), LPDWORD lpTotalNumberOfClusters __attribute__((out)));
__stdcall UINT GetDlgItemTextW __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), LPWSTR lpString, int cchMax __attribute__((in)));
__stdcall UINT GetDriveTypeW __attribute__((dllimport))(LPCWSTR lpRootPathName __attribute__((in)));
__stdcall UINT GetEnhMetaFileDescriptionW __attribute__((dllimport))(HENHMETAFILE hemf __attribute__((in)), UINT cchBuffer __attribute__((in)), LPWSTR lpDescription);
__stdcall UINT GetEnhMetaFilePaletteEntries __attribute__((dllimport))(HENHMETAFILE hemf __attribute__((in)), UINT nNumEntries __attribute__((in)), LPPALETTEENTRY lpPaletteEntries);
__stdcall HENHMETAFILE GetEnhMetaFileW __attribute__((dllimport))(LPCWSTR lpName __attribute__((in)));
__stdcall LPWCH GetEnvironmentStringsW __attribute__((dllimport)) __attribute__((out))(void);
__stdcall DWORD GetEnvironmentVariableW __attribute__((dllimport))(LPCWSTR lpName __attribute__((in)), LPWSTR lpBuffer, DWORD nSize __attribute__((in)));
__stdcall BOOL GetFileAttributesExW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), GET_FILEEX_INFO_LEVELS fInfoLevelId __attribute__((in)), LPVOID lpFileInformation __attribute__((out)));
__stdcall DWORD GetFileAttributesW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)));
__stdcall BOOL GetFileSecurityW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), SECURITY_INFORMATION RequestedInformation __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor, DWORD nLength __attribute__((in)), LPDWORD lpnLengthNeeded __attribute__((out)));
__stdcall BOOL GetFileTime __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPFILETIME lpCreationTime __attribute__((out)), LPFILETIME lpLastAccessTime __attribute__((out)), LPFILETIME lpLastWriteTime __attribute__((out)));
__stdcall DWORD GetFileVersionInfoSizeW(LPCWSTR lptstrFilename __attribute__((in)), LPDWORD lpdwHandle __attribute__((out)));
__stdcall BOOL GetFileVersionInfoW(LPCWSTR lptstrFilename __attribute__((in)), DWORD dwHandle, DWORD dwLen __attribute__((in)), LPVOID lpData);
__stdcall DWORD GetFullPathNameW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), DWORD nBufferLength __attribute__((in)), LPWSTR lpBuffer, LPWSTR *lpFilePart);
__stdcall int GetGeoInfoW __attribute__((dllimport))(GEOID Location __attribute__((in)), GEOTYPE GeoType __attribute__((in)), LPWSTR lpGeoData, int cchData __attribute__((in)), LANGID LangId __attribute__((in)));
__stdcall DWORD GetGlyphIndicesW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpstr __attribute__((in)), int c __attribute__((in)), LPWORD pgi, DWORD fl __attribute__((in)));
__stdcall DWORD GetKerningPairsA __attribute__((dllimport))(HDC hdc __attribute__((in)), DWORD nPairs __attribute__((in)), LPKERNINGPAIR lpKernPair);
__stdcall DWORD GetKerningPairsW __attribute__((dllimport))(HDC hdc __attribute__((in)), DWORD nPairs __attribute__((in)), LPKERNINGPAIR lpKernPair);
__stdcall int GetKeyNameTextW __attribute__((dllimport))(LONG lParam __attribute__((in)), LPWSTR lpString, int cchSize __attribute__((in)));
__stdcall BOOL GetKeyboardLayoutNameW __attribute__((dllimport))(LPWSTR pwszKLID);
__stdcall COORD GetLargestConsoleWindowSize __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)));
__stdcall BOOL GetLastInputInfo __attribute__((dllimport))(PLASTINPUTINFO plii __attribute__((out)));
__stdcall void GetLocalTime __attribute__((dllimport))(LPSYSTEMTIME lpSystemTime __attribute__((out)));
__stdcall int GetLocaleInfoW __attribute__((dllimport))(LCID Locale __attribute__((in)), LCTYPE LCType __attribute__((in)), LPWSTR lpLCData, int cchData __attribute__((in)));
__stdcall DWORD GetLogicalDriveStringsW __attribute__((dllimport))(DWORD nBufferLength __attribute__((in)), LPWSTR lpBuffer);
__stdcall DWORD GetLongPathNameW __attribute__((dllimport))(LPCWSTR lpszShortPath __attribute__((in)), LPWSTR lpszLongPath, DWORD cchBuffer __attribute__((in)));
__stdcall BOOL GetMenuItemRect __attribute__((dllimport))(HWND hWnd __attribute__((in)), HMENU hMenu __attribute__((in)), UINT uItem __attribute__((in)), LPRECT lprcItem __attribute__((out)));
__stdcall int GetMenuStringW __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uIDItem __attribute__((in)), LPWSTR lpString, int cchMax __attribute__((in)), UINT flags __attribute__((in)));
__stdcall HMETAFILE GetMetaFileW __attribute__((dllimport))(LPCWSTR lpName __attribute__((in)));
__stdcall DWORD GetModuleFileNameA __attribute__((dllimport))(HMODULE hModule __attribute__((in)), LPSTR lpFilename, DWORD nSize __attribute__((in)));
__stdcall DWORD GetModuleFileNameW __attribute__((dllimport))(HMODULE hModule __attribute__((in)), LPWSTR lpFilename, DWORD nSize __attribute__((in)));
__stdcall HMODULE GetModuleHandleA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpModuleName __attribute__((in)));
__stdcall BOOL GetModuleHandleExW __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), LPCWSTR lpModuleName __attribute__((in)), HMODULE *phModule __attribute__((out)));
__stdcall HMODULE GetModuleHandleW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpModuleName __attribute__((in)));
__stdcall BOOL GetOverlappedResult __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPOVERLAPPED lpOverlapped __attribute__((in)), LPDWORD lpNumberOfBytesTransferred __attribute__((out)), BOOL bWait __attribute__((in)));
__stdcall UINT GetPaletteEntries __attribute__((dllimport))(HPALETTE hpal __attribute__((in)), UINT iStart __attribute__((in)), UINT cEntries __attribute__((in)), LPPALETTEENTRY pPalEntries);
__stdcall int GetPath __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT apt, LPBYTE aj, int cpt);
__stdcall UINT GetPrivateProfileIntW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPCWSTR lpKeyName __attribute__((in)), INT nDefault __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall DWORD GetPrivateProfileSectionNamesW __attribute__((dllimport))(LPWSTR lpszReturnBuffer, DWORD nSize __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall DWORD GetPrivateProfileSectionW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPWSTR lpReturnedString, DWORD nSize __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall DWORD GetPrivateProfileStringW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPCWSTR lpKeyName __attribute__((in)), LPCWSTR lpDefault __attribute__((in)), LPWSTR lpReturnedString, DWORD nSize __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall BOOL GetPrivateProfileStructW __attribute__((dllimport))(LPCWSTR lpszSection __attribute__((in)), LPCWSTR lpszKey __attribute__((in)), LPVOID lpStruct, UINT uSizeStruct __attribute__((in)), LPCWSTR szFile __attribute__((in)));
__stdcall FARPROC GetProcAddress __attribute__((dllimport))(HMODULE hModule __attribute__((in)), LPCSTR lpProcName __attribute__((in)));
__stdcall BOOL GetProcessTimes __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPFILETIME lpCreationTime __attribute__((out)), LPFILETIME lpExitTime __attribute__((out)), LPFILETIME lpKernelTime __attribute__((out)), LPFILETIME lpUserTime __attribute__((out)));
__stdcall UINT GetProfileIntW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPCWSTR lpKeyName __attribute__((in)), INT nDefault __attribute__((in)));
__stdcall DWORD GetProfileSectionW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPWSTR lpReturnedString, DWORD nSize __attribute__((in)));
__stdcall DWORD GetProfileStringW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPCWSTR lpKeyName __attribute__((in)), LPCWSTR lpDefault __attribute__((in)), LPWSTR lpReturnedString, DWORD nSize __attribute__((in)));
__stdcall HANDLE GetPropW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCWSTR lpString __attribute__((in)));
__stdcall BOOL GetQueuedCompletionStatus __attribute__((dllimport))(HANDLE CompletionPort __attribute__((in)), LPDWORD lpNumberOfBytesTransferred __attribute__((out)), PULONG_PTR lpCompletionKey __attribute__((out)), LPOVERLAPPED *lpOverlapped __attribute__((out)), DWORD dwMilliseconds __attribute__((in)));
__stdcall UINT GetRawInputDeviceList __attribute__((dllimport))(PRAWINPUTDEVICELIST pRawInputDeviceList, PUINT puiNumDevices, UINT cbSize __attribute__((in)));
__stdcall int GetRgnBox __attribute__((dllimport))(HRGN hrgn __attribute__((in)), LPRECT lprc __attribute__((out)));
__stdcall BOOL GetScrollInfo __attribute__((dllimport))(HWND hwnd __attribute__((in)), int nBar __attribute__((in)), LPSCROLLINFO lpsi);
__stdcall BOOL GetServiceDisplayNameW __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCWSTR lpServiceName __attribute__((in)), LPWSTR lpDisplayName, LPDWORD lpcchBuffer);
__stdcall BOOL GetServiceKeyNameW __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCWSTR lpDisplayName __attribute__((in)), LPWSTR lpServiceName, LPDWORD lpcchBuffer);
__stdcall DWORD GetShortPathNameW __attribute__((dllimport))(LPCWSTR lpszLongPath __attribute__((in)), LPWSTR lpszShortPath, DWORD cchBuffer __attribute__((in)));
__stdcall PSID_IDENTIFIER_AUTHORITY GetSidIdentifierAuthority __attribute__((dllimport)) __attribute__((out))(PSID pSid __attribute__((in)));
__stdcall BOOL GetStringTypeExW __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwInfoType __attribute__((in)), LPCWSTR lpSrcStr __attribute__((in)), int cchSrc __attribute__((in)), LPWORD lpCharType);
__stdcall BOOL GetStringTypeW __attribute__((dllimport))(DWORD dwInfoType __attribute__((in)), LPCWSTR lpSrcStr __attribute__((in)), int cchSrc __attribute__((in)), LPWORD lpCharType __attribute__((out)));
__stdcall UINT GetSystemDirectoryW __attribute__((dllimport))(LPWSTR lpBuffer, UINT uSize __attribute__((in)));
__stdcall UINT GetSystemPaletteEntries __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iStart __attribute__((in)), UINT cEntries __attribute__((in)), LPPALETTEENTRY pPalEntries);
__stdcall BOOL GetSystemPowerStatus __attribute__((dllimport))(LPSYSTEM_POWER_STATUS lpSystemPowerStatus __attribute__((out)));
__stdcall void GetSystemTime __attribute__((dllimport))(LPSYSTEMTIME lpSystemTime __attribute__((out)));
__stdcall void GetSystemTimeAsFileTime __attribute__((dllimport))(LPFILETIME lpSystemTimeAsFileTime __attribute__((out)));
__stdcall UINT GetSystemWindowsDirectoryW __attribute__((dllimport))(LPWSTR lpBuffer, UINT uSize __attribute__((in)));
__stdcall UINT GetSystemWow64DirectoryW __attribute__((dllimport))(LPWSTR lpBuffer, UINT uSize __attribute__((in)));
__stdcall DWORD GetTabbedTextExtentW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpString __attribute__((in)), int chCount __attribute__((in)), int nTabPositions __attribute__((in)), const INT *lpnTabStopPositions __attribute__((in)));
__stdcall UINT GetTempFileNameW __attribute__((dllimport))(LPCWSTR lpPathName __attribute__((in)), LPCWSTR lpPrefixString __attribute__((in)), UINT uUnique __attribute__((in)), LPWSTR lpTempFileName);
__stdcall DWORD GetTempPathW __attribute__((dllimport))(DWORD nBufferLength __attribute__((in)), LPWSTR lpBuffer);
__stdcall int GetTextCharsetInfo __attribute__((dllimport))(HDC hdc __attribute__((in)), LPFONTSIGNATURE lpSig __attribute__((out)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL GetTextExtentExPointA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpszString __attribute__((in)), int cchString __attribute__((in)), int nMaxExtent __attribute__((in)), LPINT lpnFit __attribute__((out)), LPINT lpnDx, LPSIZE lpSize __attribute__((out)));
__stdcall BOOL GetTextExtentExPointW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpszString __attribute__((in)), int cchString __attribute__((in)), int nMaxExtent __attribute__((in)), LPINT lpnFit __attribute__((out)), LPINT lpnDx, LPSIZE lpSize __attribute__((out)));
__stdcall BOOL GetTextExtentPoint32A __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpString __attribute__((in)), int c __attribute__((in)), LPSIZE psizl __attribute__((out)));
__stdcall BOOL GetTextExtentPoint32W __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpString __attribute__((in)), int c __attribute__((in)), LPSIZE psizl __attribute__((out)));
__stdcall BOOL GetTextExtentPointA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpString __attribute__((in)), int c __attribute__((in)), LPSIZE lpsz __attribute__((out)));
__stdcall BOOL GetTextExtentPointW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpString __attribute__((in)), int c __attribute__((in)), LPSIZE lpsz __attribute__((out)));
__stdcall int GetTextFaceW __attribute__((dllimport))(HDC hdc __attribute__((in)), int c __attribute__((in)), LPWSTR lpName);
__stdcall BOOL GetTextMetricsA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPTEXTMETRICA lptm __attribute__((out)));
__stdcall BOOL GetThreadTimes __attribute__((dllimport))(HANDLE hThread __attribute__((in)), LPFILETIME lpCreationTime __attribute__((out)), LPFILETIME lpExitTime __attribute__((out)), LPFILETIME lpKernelTime __attribute__((out)), LPFILETIME lpUserTime __attribute__((out)));
__stdcall int GetTimeFormatA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), const SYSTEMTIME *lpTime __attribute__((in)), LPCSTR lpFormat __attribute__((in)), LPSTR lpTimeStr, int cchTime __attribute__((in)));
__stdcall int GetTimeFormatW __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), const SYSTEMTIME *lpTime __attribute__((in)), LPCWSTR lpFormat __attribute__((in)), LPWSTR lpTimeStr, int cchTime __attribute__((in)));
__stdcall BOOL GetUpdateRect __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPRECT lpRect __attribute__((out)), BOOL bErase __attribute__((in)));
__stdcall BOOL GetUserNameW __attribute__((dllimport))(LPWSTR lpBuffer, LPDWORD pcbBuffer);
__stdcall BOOL GetVersionExA __attribute__((dllimport))(LPOSVERSIONINFOA lpVersionInformation);
__stdcall BOOL GetViewportExtEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPSIZE lpsize __attribute__((out)));
__stdcall BOOL GetViewportOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT lppoint __attribute__((out)));
__stdcall BOOL GetVolumeInformationW __attribute__((dllimport))(LPCWSTR lpRootPathName __attribute__((in)), LPWSTR lpVolumeNameBuffer, DWORD nVolumeNameSize __attribute__((in)), LPDWORD lpVolumeSerialNumber __attribute__((out)), LPDWORD lpMaximumComponentLength __attribute__((out)), LPDWORD lpFileSystemFlags __attribute__((out)), LPWSTR lpFileSystemNameBuffer, DWORD nFileSystemNameSize __attribute__((in)));
__stdcall BOOL GetVolumeNameForVolumeMountPointW __attribute__((dllimport))(LPCWSTR lpszVolumeMountPoint __attribute__((in)), LPWSTR lpszVolumeName, DWORD cchBufferLength __attribute__((in)));
__stdcall BOOL GetVolumePathNameW __attribute__((dllimport))(LPCWSTR lpszFileName __attribute__((in)), LPWSTR lpszVolumePathName, DWORD cchBufferLength __attribute__((in)));
__stdcall BOOL GetVolumePathNamesForVolumeNameW __attribute__((dllimport))(LPCWSTR lpszVolumeName __attribute__((in)), LPWCH lpszVolumePathNames, DWORD cchBufferLength __attribute__((in)), PDWORD lpcchReturnLength __attribute__((out)));
__stdcall BOOL GetWindowExtEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPSIZE lpsize __attribute__((out)));
__stdcall UINT GetWindowModuleFileNameW __attribute__((dllimport))(HWND hwnd __attribute__((in)), LPWSTR pszFileName, UINT cchFileNameMax __attribute__((in)));
__stdcall BOOL GetWindowOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT lppoint __attribute__((out)));
__stdcall BOOL GetWindowRect __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPRECT lpRect __attribute__((out)));
__stdcall int GetWindowRgnBox __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPRECT lprc __attribute__((out)));
__stdcall int GetWindowTextW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPWSTR lpString, int nMaxCount __attribute__((in)));
__stdcall UINT GetWindowsDirectoryW __attribute__((dllimport))(LPWSTR lpBuffer, UINT uSize __attribute__((in)));
__stdcall BOOL GetWorldTransform __attribute__((dllimport))(HDC hdc __attribute__((in)), LPXFORM lpxf __attribute__((out)));
__stdcall ATOM GlobalAddAtomW __attribute__((dllimport))(LPCWSTR lpString __attribute__((in)));
__stdcall ATOM GlobalFindAtomW __attribute__((dllimport))(LPCWSTR lpString __attribute__((in)));
__stdcall UINT GlobalGetAtomNameW __attribute__((dllimport))(ATOM nAtom __attribute__((in)), LPWSTR lpBuffer, int nSize __attribute__((in)));
__stdcall BOOL GrayStringA __attribute__((dllimport))(HDC hDC __attribute__((in)), HBRUSH hBrush __attribute__((in)), GRAYSTRINGPROC lpOutputFunc __attribute__((in)), LPARAM lpData __attribute__((in)), int nCount __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)));
__stdcall BOOL GrayStringW __attribute__((dllimport))(HDC hDC __attribute__((in)), HBRUSH hBrush __attribute__((in)), GRAYSTRINGPROC lpOutputFunc __attribute__((in)), LPARAM lpData __attribute__((in)), int nCount __attribute__((in)), int X __attribute__((in)), int Y __attribute__((in)), int nWidth __attribute__((in)), int nHeight __attribute__((in)));
__stdcall BOOL HeapWalk __attribute__((dllimport))(HANDLE hHeap __attribute__((in)), LPPROCESS_HEAP_ENTRY lpEntry);
typedef struct _ICONINFO ICONINFO;
__stdcall DWORD ImmGetCandidateListW(HIMC __attribute__((in)), DWORD deIndex __attribute__((in)), LPCANDIDATELIST lpCandList, DWORD dwBufLen __attribute__((in)));
__stdcall DWORD ImmGetConversionListW(HKL __attribute__((in)), HIMC __attribute__((in)), LPCWSTR lpSrc __attribute__((in)), LPCANDIDATELIST lpDst, DWORD dwBufLen __attribute__((in)), UINT uFlag __attribute__((in)));
__stdcall DWORD ImmGetGuideLineW(HIMC __attribute__((in)), DWORD dwIndex __attribute__((in)), LPWSTR lpBuf, DWORD dwBufLen __attribute__((in)));
__stdcall UINT ImmGetIMEFileNameW(HKL __attribute__((in)), LPWSTR lpszFileName, UINT uBufLen __attribute__((in)));
__stdcall HKL ImmInstallIMEW(LPCWSTR lpszIMEFileName __attribute__((in)), LPCWSTR lpszLayoutText __attribute__((in)));
__stdcall BOOL ImmRegisterWordW(HKL __attribute__((in)), LPCWSTR lpszReading __attribute__((in)), DWORD __attribute__((in)), LPCWSTR lpszRegister __attribute__((in)));
__stdcall BOOL InflateRect __attribute__((dllimport))(LPRECT lprc, int dx __attribute__((in)), int dy __attribute__((in)));
__stdcall BOOL InitializeSid __attribute__((dllimport))(PSID Sid __attribute__((out)), PSID_IDENTIFIER_AUTHORITY pIdentifierAuthority __attribute__((in)), BYTE nSubAuthorityCount __attribute__((in)));
__stdcall BOOL InitiateSystemShutdownExW __attribute__((dllimport))(LPWSTR lpMachineName __attribute__((in)), LPWSTR lpMessage __attribute__((in)), DWORD dwTimeout __attribute__((in)), BOOL bForceAppsClosed __attribute__((in)), BOOL bRebootAfterShutdown __attribute__((in)), DWORD dwReason __attribute__((in)));
__stdcall BOOL InitiateSystemShutdownW __attribute__((dllimport))(LPWSTR lpMachineName __attribute__((in)), LPWSTR lpMessage __attribute__((in)), DWORD dwTimeout __attribute__((in)), BOOL bForceAppsClosed __attribute__((in)), BOOL bRebootAfterShutdown __attribute__((in)));
__stdcall BOOL InsertMenuW __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uPosition __attribute__((in)), UINT uFlags __attribute__((in)), UINT_PTR uIDNewItem __attribute__((in)), LPCWSTR lpNewItem __attribute__((in)));
__stdcall int InternalGetWindowText __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPWSTR pString, int cchMaxCount __attribute__((in)));
__stdcall BOOL IntersectRect __attribute__((dllimport))(LPRECT lprcDst __attribute__((out)), const RECT *lprcSrc1 __attribute__((in)), const RECT *lprcSrc2 __attribute__((in)));
__stdcall BOOL InvalidateRect __attribute__((dllimport))(HWND hWnd __attribute__((in)), const RECT *lpRect __attribute__((in)), BOOL bErase __attribute__((in)));
__stdcall BOOL InvertRect __attribute__((dllimport))(HDC hDC __attribute__((in)), const RECT *lprc __attribute__((in)));
__stdcall BOOL IsBadStringPtrW __attribute__((dllimport))(LPCWSTR lpsz __attribute__((in)), UINT_PTR ucchMax __attribute__((in)));
__stdcall BOOL IsRectEmpty __attribute__((dllimport))(const RECT *lprc __attribute__((in)));
typedef struct _KEY_EVENT_RECORD KEY_EVENT_RECORD;
__stdcall int LCMapStringW __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwMapFlags __attribute__((in)), LPCWSTR lpSrcStr __attribute__((in)), int cchSrc __attribute__((in)), LPWSTR lpDestStr, int cchDest __attribute__((in)));
typedef __stdcall BOOL (*LOCALE_ENUMPROCW)(LPWSTR);
typedef struct tagLOGBRUSH LOGBRUSH;
typedef struct tagLOGFONTW LOGFONTW;
typedef struct _COMMPROP *LPCOMMPROP;
typedef const RECT *LPCRECT;
typedef const SCROLLINFO *LPCSCROLLINFO;
typedef struct tagHW_PROFILE_INFOW *LPHW_PROFILE_INFOW;
typedef PLDT_ENTRY LPLDT_ENTRY;
typedef struct tagLOGFONTW *LPLOGFONTW;
typedef struct _MEMORYSTATUS *LPMEMORYSTATUS;
typedef struct _MEMORYSTATUSEX *LPMEMORYSTATUSEX;
typedef struct tagMENUITEMINFOA *LPMENUITEMINFOA;
typedef struct _NETRESOURCEA *LPNETRESOURCEA;
typedef struct _OSVERSIONINFOEXW *LPOSVERSIONINFOEXW;
typedef struct _OSVERSIONINFOW *LPOSVERSIONINFOW;
typedef __stdcall void (*LPOVERLAPPED_COMPLETION_ROUTINE)(DWORD dwErrorCode __attribute__((in)), DWORD dwNumberOfBytesTransfered __attribute__((in)), LPOVERLAPPED lpOverlapped);
typedef __stdcall DWORD (*LPPROGRESS_ROUTINE)(LARGE_INTEGER TotalFileSize __attribute__((in)), LARGE_INTEGER TotalBytesTransferred __attribute__((in)), LARGE_INTEGER StreamSize __attribute__((in)), LARGE_INTEGER StreamBytesTransferred __attribute__((in)), DWORD dwStreamNumber __attribute__((in)), DWORD dwCallbackReason __attribute__((in)), HANDLE hSourceFile __attribute__((in)), HANDLE hDestinationFile __attribute__((in)), LPVOID lpData __attribute__((in)));
typedef struct _QUERY_SERVICE_CONFIGA *LPQUERY_SERVICE_CONFIGA;
typedef struct _QUERY_SERVICE_LOCK_STATUSA *LPQUERY_SERVICE_LOCK_STATUSA;
typedef __stdcall void (*LPSERVICE_MAIN_FUNCTIONW)(DWORD dwNumServicesArgs, LPWSTR *lpServiceArgVectors);
typedef struct _STARTUPINFOA *LPSTARTUPINFOA;
typedef struct _SYSTEM_INFO *LPSYSTEM_INFO;
typedef struct tagTEXTMETRICW *LPTEXTMETRICW;
typedef struct tagTRACKMOUSEEVENT *LPTRACKMOUSEEVENT;
__stdcall BOOL LPtoDP __attribute__((dllimport))(HDC hdc __attribute__((in)), LPPOINT lppt, int c __attribute__((in)));
__stdcall BOOL LineDDA __attribute__((dllimport))(int xStart __attribute__((in)), int yStart __attribute__((in)), int xEnd __attribute__((in)), int yEnd __attribute__((in)), LINEDDAPROC lpProc __attribute__((in)), LPARAM data __attribute__((in)));
__stdcall HACCEL LoadAcceleratorsW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpTableName __attribute__((in)));
__stdcall HBITMAP LoadBitmapW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpBitmapName __attribute__((in)));
__stdcall HCURSOR LoadCursorA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpCursorName __attribute__((in)));
__stdcall HCURSOR LoadCursorFromFileA __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)));
__stdcall HCURSOR LoadCursorW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpCursorName __attribute__((in)));
__stdcall HICON LoadIconW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpIconName __attribute__((in)));
__stdcall HANDLE LoadImageW __attribute__((dllimport))(HINSTANCE hInst __attribute__((in)), LPCWSTR name __attribute__((in)), UINT type __attribute__((in)), int cx __attribute__((in)), int cy __attribute__((in)), UINT fuLoad __attribute__((in)));
__stdcall HKL LoadKeyboardLayoutW __attribute__((dllimport))(LPCWSTR pwszKLID __attribute__((in)), UINT Flags __attribute__((in)));
__stdcall HMODULE LoadLibraryA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpLibFileName __attribute__((in)));
__stdcall HMODULE LoadLibraryExA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpLibFileName __attribute__((in)), HANDLE hFile, DWORD dwFlags __attribute__((in)));
__stdcall HMODULE LoadLibraryExW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpLibFileName __attribute__((in)), HANDLE hFile, DWORD dwFlags __attribute__((in)));
__stdcall HMODULE LoadLibraryW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpLibFileName __attribute__((in)));
__stdcall HMENU LoadMenuW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpMenuName __attribute__((in)));
__stdcall HGLOBAL LoadResource __attribute__((dllimport)) __attribute__((out))(HMODULE hModule __attribute__((in)), HRSRC hResInfo __attribute__((in)));
__stdcall int LoadStringW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), UINT uID __attribute__((in)), LPWSTR lpBuffer, int cchBufferMax __attribute__((in)));
__stdcall BOOL LocalFileTimeToFileTime __attribute__((dllimport))(const FILETIME *lpLocalFileTime __attribute__((in)), LPFILETIME lpFileTime __attribute__((out)));
__stdcall BOOL LockFileEx __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwFlags __attribute__((in)), DWORD dwReserved, DWORD nNumberOfBytesToLockLow __attribute__((in)), DWORD nNumberOfBytesToLockHigh __attribute__((in)), LPOVERLAPPED lpOverlapped);
__stdcall BOOL LogonUserW __attribute__((dllimport))(LPCWSTR lpszUsername __attribute__((in)), LPCWSTR lpszDomain __attribute__((in)), LPCWSTR lpszPassword __attribute__((in)), DWORD dwLogonType __attribute__((in)), DWORD dwLogonProvider __attribute__((in)), PHANDLE phToken);
__stdcall BOOL LookupAccountNameW __attribute__((dllimport))(LPCWSTR lpSystemName __attribute__((in)), LPCWSTR lpAccountName __attribute__((in)), PSID Sid, LPDWORD cbSid, LPWSTR ReferencedDomainName, LPDWORD cchReferencedDomainName, PSID_NAME_USE peUse __attribute__((out)));
__stdcall BOOL LookupAccountSidW __attribute__((dllimport))(LPCWSTR lpSystemName __attribute__((in)), PSID Sid __attribute__((in)), LPWSTR Name, LPDWORD cchName, LPWSTR ReferencedDomainName, LPDWORD cchReferencedDomainName, PSID_NAME_USE peUse __attribute__((out)));
__stdcall BOOL LookupPrivilegeDisplayNameW __attribute__((dllimport))(LPCWSTR lpSystemName __attribute__((in)), LPCWSTR lpName __attribute__((in)), LPWSTR lpDisplayName, LPDWORD cchDisplayName, LPDWORD lpLanguageId __attribute__((out)));
__stdcall BOOL LookupPrivilegeNameA __attribute__((dllimport))(LPCSTR lpSystemName __attribute__((in)), PLUID lpLuid __attribute__((in)), LPSTR lpName, LPDWORD cchName);
__stdcall BOOL LookupPrivilegeNameW __attribute__((dllimport))(LPCWSTR lpSystemName __attribute__((in)), PLUID lpLuid __attribute__((in)), LPWSTR lpName, LPDWORD cchName);
__stdcall BOOL LookupPrivilegeValueA __attribute__((dllimport))(LPCSTR lpSystemName __attribute__((in)), LPCSTR lpName __attribute__((in)), PLUID lpLuid __attribute__((out)));
__stdcall BOOL LookupPrivilegeValueW __attribute__((dllimport))(LPCWSTR lpSystemName __attribute__((in)), LPCWSTR lpName __attribute__((in)), PLUID lpLuid __attribute__((out)));
typedef struct tagMENUINFO MENUINFO;
typedef struct tagMENUITEMINFOA MENUITEMINFOA;
typedef struct tagMETAFILEPICT METAFILEPICT;
typedef __stdcall int (*MFENUMPROC)(HDC hdc __attribute__((in)), HANDLETABLE *lpht __attribute__((in)), METARECORD *lpMR __attribute__((in)), int nObj __attribute__((in)), LPARAM param __attribute__((in)));
typedef __stdcall BOOL (*MONITORENUMPROC)(HMONITOR, HDC, LPRECT, LPARAM);
__stdcall BOOL MapDialogRect __attribute__((dllimport))(HWND hDlg __attribute__((in)), LPRECT lpRect);
__stdcall int MapWindowPoints __attribute__((dllimport))(HWND hWndFrom __attribute__((in)), HWND hWndTo __attribute__((in)), LPPOINT lpPoints, UINT cPoints __attribute__((in)));
__stdcall int MenuItemFromPoint __attribute__((dllimport))(HWND hWnd __attribute__((in)), HMENU hMenu __attribute__((in)), POINT ptScreen __attribute__((in)));
__stdcall int MessageBoxExW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCWSTR lpText __attribute__((in)), LPCWSTR lpCaption __attribute__((in)), UINT uType __attribute__((in)), WORD wLanguageId __attribute__((in)));
__stdcall int MessageBoxW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCWSTR lpText __attribute__((in)), LPCWSTR lpCaption __attribute__((in)), UINT uType __attribute__((in)));
__stdcall BOOL ModifyMenuW __attribute__((dllimport))(HMENU hMnu __attribute__((in)), UINT uPosition __attribute__((in)), UINT uFlags __attribute__((in)), UINT_PTR uIDNewItem __attribute__((in)), LPCWSTR lpNewItem __attribute__((in)));
__stdcall BOOL ModifyWorldTransform __attribute__((dllimport))(HDC hdc __attribute__((in)), const XFORM *lpxf __attribute__((in)), DWORD mode __attribute__((in)));
__stdcall HMONITOR MonitorFromPoint __attribute__((dllimport))(POINT pt __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL MoveFileExW __attribute__((dllimport))(LPCWSTR lpExistingFileName __attribute__((in)), LPCWSTR lpNewFileName __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL MoveFileW __attribute__((dllimport))(LPCWSTR lpExistingFileName __attribute__((in)), LPCWSTR lpNewFileName __attribute__((in)));
__stdcall BOOL MoveToEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall int MultiByteToWideChar __attribute__((dllimport))(UINT CodePage __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCSTR lpMultiByteStr __attribute__((in)), int cbMultiByte __attribute__((in)), LPWSTR lpWideCharStr, int cchWideChar __attribute__((in)));
typedef __stdcall BOOL (*NAMEENUMPROCW)(LPWSTR, LPARAM);
typedef struct _numberfmtA NUMBERFMTA;
typedef __stdcall int (*OLDFONTENUMPROCA)(const LOGFONTA*, const TEXTMETRICA*, DWORD, LPARAM);
typedef struct _OUTPUT_DEBUG_STRING_INFO OUTPUT_DEBUG_STRING_INFO;
__stdcall BOOL ObjectCloseAuditAlarmW __attribute__((dllimport))(LPCWSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), BOOL GenerateOnClose __attribute__((in)));
__stdcall BOOL ObjectDeleteAuditAlarmW __attribute__((dllimport))(LPCWSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), BOOL GenerateOnClose __attribute__((in)));
__stdcall BOOL OemToCharBuffW __attribute__((dllimport))(LPCSTR lpszSrc __attribute__((in)), LPWSTR lpszDst, DWORD cchDstLength __attribute__((in)));
__stdcall BOOL OemToCharW __attribute__((dllimport))(LPCSTR pSrc __attribute__((in)), LPWSTR pDst);
__stdcall BOOL OffsetRect __attribute__((dllimport))(LPRECT lprc, int dx __attribute__((in)), int dy __attribute__((in)));
__stdcall BOOL OffsetViewportOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall BOOL OffsetWindowOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall HANDLE OpenBackupEventLogW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpUNCServerName __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall HDESK OpenDesktopW __attribute__((dllimport))(LPCWSTR lpszDesktop __attribute__((in)), DWORD dwFlags __attribute__((in)), BOOL fInherit __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)));
__stdcall DWORD OpenEncryptedFileRawW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), ULONG ulFlags __attribute__((in)), PVOID *pvContext);
__stdcall HANDLE OpenEventLogW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpUNCServerName __attribute__((in)), LPCWSTR lpSourceName __attribute__((in)));
__stdcall HANDLE OpenEventW __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall HFILE OpenFile __attribute__((dllimport))(LPCSTR lpFileName __attribute__((in)), LPOFSTRUCT lpReOpenBuff, UINT uStyle __attribute__((in)));
__stdcall HANDLE OpenFileMappingW __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall HANDLE OpenJobObjectW __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall HANDLE OpenMutexW __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall SC_HANDLE OpenSCManagerW __attribute__((dllimport))(LPCWSTR lpMachineName __attribute__((in)), LPCWSTR lpDatabaseName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)));
__stdcall HANDLE OpenSemaphoreW __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCWSTR lpName __attribute__((in)));
__stdcall SC_HANDLE OpenServiceW __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPCWSTR lpServiceName __attribute__((in)), DWORD dwDesiredAccess __attribute__((in)));
__stdcall HANDLE OpenWaitableTimerW __attribute__((dllimport)) __attribute__((out))(DWORD dwDesiredAccess __attribute__((in)), BOOL bInheritHandle __attribute__((in)), LPCWSTR lpTimerName __attribute__((in)));
__stdcall HWINSTA OpenWindowStationW __attribute__((dllimport))(LPCWSTR lpszWinSta __attribute__((in)), BOOL fInherit __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)));
__stdcall void OutputDebugStringW __attribute__((dllimport))(LPCWSTR lpOutputString __attribute__((in)));
typedef ACL *PACL;
typedef
struct {
	UINT cbSize;
	HDESK hdesk;
	HWND hwnd;
	LUID luid;
} *PBSMINFO;
typedef struct _CHAR_INFO *PCHAR_INFO;
typedef struct _DISPLAY_DEVICEW *PDISPLAY_DEVICEW;
typedef EXCEPTION_RECORD *PEXCEPTION_RECORD;
typedef struct _IO_STATUS_BLOCK *PIO_STATUS_BLOCK;
typedef LARGE_INTEGER *PLARGE_INTEGER;
typedef struct _MEMORY_BASIC_INFORMATION *PMEMORY_BASIC_INFORMATION;
typedef struct _OBJECT_TYPE_LIST *POBJECT_TYPE_LIST;
typedef __stdcall BOOL (*PROPENUMPROCEXW)(HWND, LPWSTR, HANDLE, ULONG_PTR);
typedef struct _RTL_CRITICAL_SECTION_DEBUG *PRTL_CRITICAL_SECTION_DEBUG;
typedef struct _SID_AND_ATTRIBUTES *PSID_AND_ATTRIBUTES;
typedef union _SLIST_HEADER *PSLIST_HEADER;
typedef struct _TRIVERTEX *PTRIVERTEX;
typedef ULARGE_INTEGER *PULARGE_INTEGER;
__stdcall BOOL PlayEnhMetaFile __attribute__((dllimport))(HDC hdc __attribute__((in)), HENHMETAFILE hmf __attribute__((in)), const RECT *lprect __attribute__((in)));
__stdcall BOOL PlayEnhMetaFileRecord __attribute__((dllimport))(HDC hdc __attribute__((in)), LPHANDLETABLE pht __attribute__((in)), const ENHMETARECORD *pmr __attribute__((in)), UINT cht __attribute__((in)));
__stdcall BOOL PlayMetaFileRecord __attribute__((dllimport))(HDC hdc __attribute__((in)), LPHANDLETABLE lpHandleTable __attribute__((in)), LPMETARECORD lpMR __attribute__((in)), UINT noObjs __attribute__((in)));
__stdcall BOOL PlgBlt __attribute__((dllimport))(HDC hdcDest __attribute__((in)), const POINT *lpPoint __attribute__((in)), HDC hdcSrc __attribute__((in)), int xSrc __attribute__((in)), int ySrc __attribute__((in)), int width __attribute__((in)), int height __attribute__((in)), HBITMAP hbmMask __attribute__((in)), int xMask __attribute__((in)), int yMask __attribute__((in)));
__stdcall BOOL PolyBezier __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), DWORD cpt __attribute__((in)));
__stdcall BOOL PolyBezierTo __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), DWORD cpt __attribute__((in)));
__stdcall BOOL PolyDraw __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), const BYTE *aj __attribute__((in)), int cpt __attribute__((in)));
__stdcall BOOL PolyPolygon __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), const INT *asz __attribute__((in)), int csz __attribute__((in)));
__stdcall BOOL PolyPolyline __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), const DWORD *asz __attribute__((in)), DWORD csz __attribute__((in)));
__stdcall BOOL Polygon __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), int cpt __attribute__((in)));
__stdcall BOOL Polyline __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), int cpt __attribute__((in)));
__stdcall BOOL PolylineTo __attribute__((dllimport))(HDC hdc __attribute__((in)), const POINT *apt __attribute__((in)), DWORD cpt __attribute__((in)));
__stdcall BOOL PostQueuedCompletionStatus __attribute__((dllimport))(HANDLE CompletionPort __attribute__((in)), DWORD dwNumberOfBytesTransferred __attribute__((in)), ULONG_PTR dwCompletionKey __attribute__((in)), LPOVERLAPPED lpOverlapped __attribute__((in)));
__stdcall UINT PrivateExtractIconsW __attribute__((dllimport))(LPCWSTR szFileName __attribute__((in)), int nIconIndex __attribute__((in)), int cxIcon __attribute__((in)), int cyIcon __attribute__((in)), HICON *phicon, UINT *piconid, UINT nIcons __attribute__((in)), UINT flags __attribute__((in)));
__stdcall BOOL PtInRect __attribute__((dllimport))(const RECT *lprc __attribute__((in)), POINT pt __attribute__((in)));
__stdcall DWORD QueryDosDeviceW __attribute__((dllimport))(LPCWSTR lpDeviceName __attribute__((in)), LPWSTR lpTargetPath, DWORD ucchMax __attribute__((in)));
__stdcall BOOL QueryPerformanceCounter __attribute__((dllimport))(LARGE_INTEGER *lpPerformanceCount __attribute__((out)));
__stdcall BOOL QueryPerformanceFrequency __attribute__((dllimport))(LARGE_INTEGER *lpFrequency __attribute__((out)));
__stdcall BOOL QueryServiceStatus __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), LPSERVICE_STATUS lpServiceStatus __attribute__((out)));
__stdcall BOOL QueueUserWorkItem __attribute__((dllimport))(LPTHREAD_START_ROUTINE Function __attribute__((in)), PVOID Context __attribute__((in)), ULONG Flags __attribute__((in)));
typedef struct tagRAWINPUTDEVICE RAWINPUTDEVICE;
typedef __stdcall int (*REGISTERWORDENUMPROCW)(LPCWSTR lpszReading __attribute__((in)), DWORD, LPCWSTR lpszString __attribute__((in)), LPVOID);
__stdcall BOOL ReadConsoleA __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), LPVOID lpBuffer, DWORD nNumberOfCharsToRead __attribute__((in)), LPDWORD lpNumberOfCharsRead __attribute__((out)), PCONSOLE_READCONSOLE_CONTROL pInputControl __attribute__((in)));
__stdcall BOOL ReadConsoleOutputAttribute __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), LPWORD lpAttribute, DWORD nLength __attribute__((in)), COORD dwReadCoord __attribute__((in)), LPDWORD lpNumberOfAttrsRead __attribute__((out)));
__stdcall BOOL ReadConsoleW __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), LPVOID lpBuffer, DWORD nNumberOfCharsToRead __attribute__((in)), LPDWORD lpNumberOfCharsRead __attribute__((out)), PCONSOLE_READCONSOLE_CONTROL pInputControl __attribute__((in)));
__stdcall DWORD ReadEncryptedFileRaw __attribute__((dllimport))(PFE_EXPORT_FUNC pfExportCallback __attribute__((in)), PVOID pvCallbackContext __attribute__((in)), PVOID pvContext __attribute__((in)));
__stdcall BOOL ReadFile __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPVOID lpBuffer, DWORD nNumberOfBytesToRead __attribute__((in)), LPDWORD lpNumberOfBytesRead __attribute__((out)), LPOVERLAPPED lpOverlapped);
__stdcall BOOL RectInRegion __attribute__((dllimport))(HRGN hrgn __attribute__((in)), const RECT *lprect __attribute__((in)));
__stdcall BOOL RectVisible __attribute__((dllimport))(HDC hdc __attribute__((in)), const RECT *lprect __attribute__((in)));
__stdcall BOOL RedrawWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), const RECT *lprcUpdate __attribute__((in)), HRGN hrgnUpdate __attribute__((in)), UINT flags __attribute__((in)));
__stdcall LSTATUS RegConnectRegistryA __attribute__((dllimport))(LPCSTR lpMachineName __attribute__((in)), HKEY hKey __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegConnectRegistryW __attribute__((dllimport))(LPCWSTR lpMachineName __attribute__((in)), HKEY hKey __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegCreateKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegCreateKeyExA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), DWORD Reserved, LPSTR lpClass __attribute__((in)), DWORD dwOptions __attribute__((in)), REGSAM samDesired __attribute__((in)), const LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)), PHKEY phkResult __attribute__((out)), LPDWORD lpdwDisposition __attribute__((out)));
__stdcall LSTATUS RegCreateKeyExW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), DWORD Reserved, LPWSTR lpClass __attribute__((in)), DWORD dwOptions __attribute__((in)), REGSAM samDesired __attribute__((in)), const LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)), PHKEY phkResult __attribute__((out)), LPDWORD lpdwDisposition __attribute__((out)));
__stdcall LSTATUS RegCreateKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegDeleteKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)));
__stdcall LSTATUS RegDeleteValueW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpValueName __attribute__((in)));
__stdcall LSTATUS RegEnumKeyExA __attribute__((dllimport))(HKEY hKey __attribute__((in)), DWORD dwIndex __attribute__((in)), LPSTR lpName, LPDWORD lpcchName, LPDWORD lpReserved, LPSTR lpClass, LPDWORD lpcchClass, PFILETIME lpftLastWriteTime __attribute__((out)));
__stdcall LSTATUS RegEnumKeyExW __attribute__((dllimport))(HKEY hKey __attribute__((in)), DWORD dwIndex __attribute__((in)), LPWSTR lpName, LPDWORD lpcchName, LPDWORD lpReserved, LPWSTR lpClass, LPDWORD lpcchClass, PFILETIME lpftLastWriteTime __attribute__((out)));
__stdcall LSTATUS RegEnumKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), DWORD dwIndex __attribute__((in)), LPWSTR lpName, DWORD cchName __attribute__((in)));
__stdcall LSTATUS RegEnumValueW __attribute__((dllimport))(HKEY hKey __attribute__((in)), DWORD dwIndex __attribute__((in)), LPWSTR lpValueName, LPDWORD lpcchValueName, LPDWORD lpReserved, LPDWORD lpType __attribute__((out)), LPBYTE lpData, LPDWORD lpcbData);
__stdcall LSTATUS RegLoadKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), LPCWSTR lpFile __attribute__((in)));
__stdcall LSTATUS RegOpenCurrentUser __attribute__((dllimport))(REGSAM samDesired __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegOpenKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegOpenKeyExA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpSubKey __attribute__((in)), DWORD ulOptions __attribute__((in)), REGSAM samDesired __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegOpenKeyExW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), DWORD ulOptions __attribute__((in)), REGSAM samDesired __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegOpenKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegOpenUserClassesRoot __attribute__((dllimport))(HANDLE hToken __attribute__((in)), DWORD dwOptions, REGSAM samDesired __attribute__((in)), PHKEY phkResult __attribute__((out)));
__stdcall LSTATUS RegQueryInfoKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPSTR lpClass, LPDWORD lpcchClass, LPDWORD lpReserved, LPDWORD lpcSubKeys __attribute__((out)), LPDWORD lpcbMaxSubKeyLen __attribute__((out)), LPDWORD lpcbMaxClassLen __attribute__((out)), LPDWORD lpcValues __attribute__((out)), LPDWORD lpcbMaxValueNameLen __attribute__((out)), LPDWORD lpcbMaxValueLen __attribute__((out)), LPDWORD lpcbSecurityDescriptor __attribute__((out)), PFILETIME lpftLastWriteTime __attribute__((out)));
__stdcall LSTATUS RegQueryInfoKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPWSTR lpClass, LPDWORD lpcchClass, LPDWORD lpReserved, LPDWORD lpcSubKeys __attribute__((out)), LPDWORD lpcbMaxSubKeyLen __attribute__((out)), LPDWORD lpcbMaxClassLen __attribute__((out)), LPDWORD lpcValues __attribute__((out)), LPDWORD lpcbMaxValueNameLen __attribute__((out)), LPDWORD lpcbMaxValueLen __attribute__((out)), LPDWORD lpcbSecurityDescriptor __attribute__((out)), PFILETIME lpftLastWriteTime __attribute__((out)));
__stdcall LSTATUS RegQueryValueExW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpValueName __attribute__((in)), LPDWORD lpReserved, LPDWORD lpType __attribute__((out)), LPBYTE lpData, LPDWORD lpcbData);
__stdcall LSTATUS RegQueryValueW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), LPWSTR lpData, PLONG lpcbData);
__stdcall LSTATUS RegReplaceKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), LPCWSTR lpNewFile __attribute__((in)), LPCWSTR lpOldFile __attribute__((in)));
__stdcall LSTATUS RegRestoreKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpFile __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall LSTATUS RegSaveKeyA __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCSTR lpFile __attribute__((in)), const LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall LSTATUS RegSaveKeyExW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpFile __attribute__((in)), const LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)), DWORD Flags __attribute__((in)));
__stdcall LSTATUS RegSaveKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpFile __attribute__((in)), const LPSECURITY_ATTRIBUTES lpSecurityAttributes __attribute__((in)));
__stdcall LSTATUS RegSetValueExW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpValueName __attribute__((in)), DWORD Reserved, DWORD dwType __attribute__((in)), const BYTE *lpData __attribute__((in)), DWORD cbData __attribute__((in)));
__stdcall LSTATUS RegSetValueW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)), DWORD dwType __attribute__((in)), LPCWSTR lpData __attribute__((in)), DWORD cbData __attribute__((in)));
__stdcall LSTATUS RegUnLoadKeyW __attribute__((dllimport))(HKEY hKey __attribute__((in)), LPCWSTR lpSubKey __attribute__((in)));
__stdcall UINT RegisterClipboardFormatW __attribute__((dllimport))(LPCWSTR lpszFormat __attribute__((in)));
__stdcall HANDLE RegisterEventSourceW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpUNCServerName __attribute__((in)), LPCWSTR lpSourceName __attribute__((in)));
__stdcall SERVICE_STATUS_HANDLE RegisterServiceCtrlHandlerExW __attribute__((dllimport))(LPCWSTR lpServiceName __attribute__((in)), LPHANDLER_FUNCTION_EX lpHandlerProc __attribute__((in)), LPVOID lpContext __attribute__((in)));
__stdcall SERVICE_STATUS_HANDLE RegisterServiceCtrlHandlerW __attribute__((dllimport))(LPCWSTR lpServiceName __attribute__((in)), LPHANDLER_FUNCTION lpHandlerProc __attribute__((in)));
__stdcall UINT RegisterWindowMessageW __attribute__((dllimport))(LPCWSTR lpString __attribute__((in)));
__stdcall BOOL RemoveDirectoryW __attribute__((dllimport))(LPCWSTR lpPathName __attribute__((in)));
__stdcall BOOL RemoveFontResourceExW __attribute__((dllimport))(LPCWSTR name __attribute__((in)), DWORD fl __attribute__((in)), PVOID pdv);
__stdcall BOOL RemoveFontResourceW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)));
__stdcall HANDLE RemovePropW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCWSTR lpString __attribute__((in)));
__stdcall BOOL ReplaceFileW __attribute__((dllimport))(LPCWSTR lpReplacedFileName __attribute__((in)), LPCWSTR lpReplacementFileName __attribute__((in)), LPCWSTR lpBackupFileName __attribute__((in)), DWORD dwReplaceFlags __attribute__((in)), LPVOID lpExclude, LPVOID lpReserved);
__stdcall BOOL ReportEventW __attribute__((dllimport))(HANDLE hEventLog __attribute__((in)), WORD wType __attribute__((in)), WORD wCategory __attribute__((in)), DWORD dwEventID __attribute__((in)), PSID lpUserSid __attribute__((in)), WORD wNumStrings __attribute__((in)), DWORD dwDataSize __attribute__((in)), LPCWSTR *lpStrings __attribute__((in)), LPVOID lpRawData __attribute__((in)));
__stdcall NTSTATUS RtlUnicodeToMultiByteSize(PULONG BytesInMultiByteString __attribute__((out)), PWCH UnicodeString __attribute__((in)), ULONG BytesInUnicodeString __attribute__((in)));
typedef SIZE SIZEL;
typedef union _SLIST_HEADER SLIST_HEADER;
typedef struct _STRING STRING;
__stdcall BOOL ScaleViewportExtEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int xn __attribute__((in)), int dx __attribute__((in)), int yn __attribute__((in)), int yd __attribute__((in)), LPSIZE lpsz __attribute__((out)));
__stdcall BOOL ScaleWindowExtEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int xn __attribute__((in)), int xd __attribute__((in)), int yn __attribute__((in)), int yd __attribute__((in)), LPSIZE lpsz __attribute__((out)));
__stdcall BOOL ScreenToClient __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPPOINT lpPoint);
__stdcall BOOL ScrollDC __attribute__((dllimport))(HDC hDC __attribute__((in)), int dx __attribute__((in)), int dy __attribute__((in)), const RECT *lprcScroll __attribute__((in)), const RECT *lprcClip __attribute__((in)), HRGN hrgnUpdate __attribute__((in)), LPRECT lprcUpdate __attribute__((out)));
__stdcall BOOL ScrollWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), int XAmount __attribute__((in)), int YAmount __attribute__((in)), const RECT *lpRect __attribute__((in)), const RECT *lpClipRect __attribute__((in)));
__stdcall int ScrollWindowEx __attribute__((dllimport))(HWND hWnd __attribute__((in)), int dx __attribute__((in)), int dy __attribute__((in)), const RECT *prcScroll __attribute__((in)), const RECT *prcClip __attribute__((in)), HRGN hrgnUpdate __attribute__((in)), LPRECT prcUpdate __attribute__((out)), UINT flags __attribute__((in)));
__stdcall DWORD SearchPathW __attribute__((dllimport))(LPCWSTR lpPath __attribute__((in)), LPCWSTR lpFileName __attribute__((in)), LPCWSTR lpExtension __attribute__((in)), DWORD nBufferLength __attribute__((in)), LPWSTR lpBuffer, LPWSTR *lpFilePart __attribute__((out)));
__stdcall BOOL SendMessageCallbackA __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)), SENDASYNCPROC lpResultCallBack __attribute__((in)), ULONG_PTR dwData __attribute__((in)));
__stdcall BOOL SendMessageCallbackW __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)), SENDASYNCPROC lpResultCallBack __attribute__((in)), ULONG_PTR dwData __attribute__((in)));
__stdcall int SetAbortProc __attribute__((dllimport))(HDC hdc __attribute__((in)), ABORTPROC proc __attribute__((in)));
__stdcall BOOL SetBitmapDimensionEx __attribute__((dllimport))(HBITMAP hbm __attribute__((in)), int w __attribute__((in)), int h __attribute__((in)), LPSIZE lpsz __attribute__((out)));
__stdcall UINT SetBoundsRect __attribute__((dllimport))(HDC hdc __attribute__((in)), const RECT *lprect __attribute__((in)), UINT flags __attribute__((in)));
__stdcall BOOL SetBrushOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall BOOL SetColorAdjustment __attribute__((dllimport))(HDC hdc __attribute__((in)), const COLORADJUSTMENT *lpca __attribute__((in)));
__stdcall BOOL SetCommState __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPDCB lpDCB __attribute__((in)));
__stdcall BOOL SetCommTimeouts __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPCOMMTIMEOUTS lpCommTimeouts __attribute__((in)));
__stdcall BOOL SetComputerNameExW __attribute__((dllimport))(COMPUTER_NAME_FORMAT NameType __attribute__((in)), LPCWSTR lpBuffer __attribute__((in)));
__stdcall BOOL SetComputerNameW __attribute__((dllimport))(LPCWSTR lpComputerName __attribute__((in)));
__stdcall BOOL SetConsoleCursorInfo __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const CONSOLE_CURSOR_INFO *lpConsoleCursorInfo __attribute__((in)));
__stdcall BOOL SetConsoleCursorPosition __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), COORD dwCursorPosition __attribute__((in)));
__stdcall BOOL SetConsoleDisplayMode(HANDLE hConsoleOutput __attribute__((in)), DWORD dwFlags __attribute__((in)), PCOORD lpNewScreenBufferDimensions __attribute__((out)));
__stdcall BOOL SetConsoleScreenBufferSize __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), COORD dwSize __attribute__((in)));
__stdcall BOOL SetConsoleTitleW __attribute__((dllimport))(LPCWSTR lpConsoleTitle __attribute__((in)));
__stdcall BOOL SetConsoleWindowInfo __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), BOOL bAbsolute __attribute__((in)), const SMALL_RECT *lpConsoleWindow __attribute__((in)));
__stdcall BOOL SetCurrentDirectoryW __attribute__((dllimport))(LPCWSTR lpPathName __attribute__((in)));
__stdcall HCURSOR SetCursor __attribute__((dllimport))(HCURSOR hCursor __attribute__((in)));
__stdcall UINT SetDIBColorTable __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT iStart __attribute__((in)), UINT cEntries __attribute__((in)), const RGBQUAD *prgbq __attribute__((in)));
__stdcall BOOL SetDlgItemTextW __attribute__((dllimport))(HWND hDlg __attribute__((in)), int nIDDlgItem __attribute__((in)), LPCWSTR lpString __attribute__((in)));
__stdcall BOOL SetEnvironmentVariableW __attribute__((dllimport))(LPCWSTR lpName __attribute__((in)), LPCWSTR lpValue __attribute__((in)));
__stdcall BOOL SetFileAttributesW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), DWORD dwFileAttributes __attribute__((in)));
__stdcall BOOL SetFileSecurityW __attribute__((dllimport))(LPCWSTR lpFileName __attribute__((in)), SECURITY_INFORMATION SecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)));
__stdcall BOOL SetFileShortNameW __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPCWSTR lpShortName __attribute__((in)));
__stdcall BOOL SetFileTime __attribute__((dllimport))(HANDLE hFile __attribute__((in)), const FILETIME *lpCreationTime __attribute__((in)), const FILETIME *lpLastAccessTime __attribute__((in)), const FILETIME *lpLastWriteTime __attribute__((in)));
__stdcall BOOL SetLocalTime __attribute__((dllimport))(const SYSTEMTIME *lpSystemTime __attribute__((in)));
__stdcall UINT SetPaletteEntries __attribute__((dllimport))(HPALETTE hpal __attribute__((in)), UINT iStart __attribute__((in)), UINT cEntries __attribute__((in)), const PALETTEENTRY *pPalEntries __attribute__((in)));
__stdcall BOOL SetPropW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCWSTR lpString __attribute__((in)), HANDLE hData __attribute__((in)));
__stdcall BOOL SetRect __attribute__((dllimport))(LPRECT lprc __attribute__((out)), int xLeft __attribute__((in)), int yTop __attribute__((in)), int xRight __attribute__((in)), int yBottom __attribute__((in)));
__stdcall BOOL SetRectEmpty __attribute__((dllimport))(LPRECT lprc __attribute__((out)));
__stdcall BOOL SetServiceStatus __attribute__((dllimport))(SERVICE_STATUS_HANDLE hServiceStatus __attribute__((in)), LPSERVICE_STATUS lpServiceStatus __attribute__((in)));
__stdcall BOOL SetSystemCursor __attribute__((dllimport))(HCURSOR hcur __attribute__((in)), DWORD id __attribute__((in)));
__stdcall BOOL SetSystemTime __attribute__((dllimport))(const SYSTEMTIME *lpSystemTime __attribute__((in)));
__stdcall UINT_PTR SetTimer __attribute__((dllimport))(HWND hWnd __attribute__((in)), UINT_PTR nIDEvent __attribute__((in)), UINT uElapse __attribute__((in)), TIMERPROC lpTimerFunc __attribute__((in)));
__stdcall BOOL SetViewportExtEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPSIZE lpsz __attribute__((out)));
__stdcall BOOL SetViewportOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall BOOL SetVolumeLabelW __attribute__((dllimport))(LPCWSTR lpRootPathName __attribute__((in)), LPCWSTR lpVolumeName __attribute__((in)));
__stdcall BOOL SetVolumeMountPointW __attribute__((dllimport))(LPCWSTR lpszVolumeMountPoint __attribute__((in)), LPCWSTR lpszVolumeName __attribute__((in)));
__stdcall BOOL SetWaitableTimer __attribute__((dllimport))(HANDLE hTimer __attribute__((in)), const LARGE_INTEGER *lpDueTime __attribute__((in)), LONG lPeriod __attribute__((in)), PTIMERAPCROUTINE pfnCompletionRoutine __attribute__((in)), LPVOID lpArgToCompletionRoutine __attribute__((in)), BOOL fResume __attribute__((in)));
__stdcall HWINEVENTHOOK SetWinEventHook __attribute__((dllimport))(DWORD eventMin __attribute__((in)), DWORD eventMax __attribute__((in)), HMODULE hmodWinEventProc __attribute__((in)), WINEVENTPROC pfnWinEventProc __attribute__((in)), DWORD idProcess __attribute__((in)), DWORD idThread __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL SetWindowExtEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPSIZE lpsz __attribute__((out)));
__stdcall BOOL SetWindowOrgEx __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPPOINT lppt __attribute__((out)));
__stdcall BOOL SetWindowTextW __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPCWSTR lpString __attribute__((in)));
__stdcall HHOOK SetWindowsHookA __attribute__((dllimport))(int nFilterType __attribute__((in)), HOOKPROC pfnFilterProc __attribute__((in)));
__stdcall HHOOK SetWindowsHookExA __attribute__((dllimport))(int idHook __attribute__((in)), HOOKPROC lpfn __attribute__((in)), HINSTANCE hmod __attribute__((in)), DWORD dwThreadId __attribute__((in)));
__stdcall HHOOK SetWindowsHookExW __attribute__((dllimport))(int idHook __attribute__((in)), HOOKPROC lpfn __attribute__((in)), HINSTANCE hmod __attribute__((in)), DWORD dwThreadId __attribute__((in)));
__stdcall HHOOK SetWindowsHookW __attribute__((dllimport))(int nFilterType __attribute__((in)), HOOKPROC pfnFilterProc __attribute__((in)));
__stdcall BOOL SetWorldTransform __attribute__((dllimport))(HDC hdc __attribute__((in)), const XFORM *lpxf __attribute__((in)));
__stdcall DWORD SizeofResource __attribute__((dllimport))(HMODULE hModule __attribute__((in)), HRSRC hResInfo __attribute__((in)));
__stdcall BOOL StartServiceW __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwNumServiceArgs __attribute__((in)), LPCWSTR *lpServiceArgVectors __attribute__((in)));
__stdcall BOOL SubtractRect __attribute__((dllimport))(LPRECT lprcDst __attribute__((out)), const RECT *lprcSrc1 __attribute__((in)), const RECT *lprcSrc2 __attribute__((in)));
__stdcall BOOL SystemTimeToFileTime __attribute__((dllimport))(const SYSTEMTIME *lpSystemTime __attribute__((in)), LPFILETIME lpFileTime __attribute__((out)));
typedef struct tagTEXTMETRICW TEXTMETRICW;
typedef __stdcall BOOL (*TIMEFMT_ENUMPROCW)(LPWSTR);
__stdcall LONG TabbedTextOutW __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPCWSTR lpString __attribute__((in)), int chCount __attribute__((in)), int nTabPositions __attribute__((in)), const INT *lpnTabStopPositions __attribute__((in)), int nTabOrigin __attribute__((in)));
__stdcall BOOL TextOutW __attribute__((dllimport))(HDC hdc __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), LPCWSTR lpString __attribute__((in)), int c __attribute__((in)));
__stdcall WORD TileWindows __attribute__((dllimport))(HWND hwndParent __attribute__((in)), UINT wHow __attribute__((in)), const RECT *lpRect __attribute__((in)), UINT cKids __attribute__((in)), const HWND *lpKids __attribute__((in)));
__stdcall int ToUnicode __attribute__((dllimport))(UINT wVirtKey __attribute__((in)), UINT wScanCode __attribute__((in)), const BYTE *lpKeyState __attribute__((in)), LPWSTR pwszBuff, int cchBuff __attribute__((in)), UINT wFlags __attribute__((in)));
__stdcall int ToUnicodeEx __attribute__((dllimport))(UINT wVirtKey __attribute__((in)), UINT wScanCode __attribute__((in)), const BYTE *lpKeyState __attribute__((in)), LPWSTR pwszBuff, int cchBuff __attribute__((in)), UINT wFlags __attribute__((in)), HKL dwhkl __attribute__((in)));
__stdcall BOOL TrackPopupMenu __attribute__((dllimport))(HMENU hMenu __attribute__((in)), UINT uFlags __attribute__((in)), int x __attribute__((in)), int y __attribute__((in)), int nReserved __attribute__((in)), HWND hWnd __attribute__((in)), const RECT *prcRect __attribute__((in)));
__stdcall BOOL TransactNamedPipe __attribute__((dllimport))(HANDLE hNamedPipe __attribute__((in)), LPVOID lpInBuffer __attribute__((in)), DWORD nInBufferSize __attribute__((in)), LPVOID lpOutBuffer, DWORD nOutBufferSize __attribute__((in)), LPDWORD lpBytesRead __attribute__((out)), LPOVERLAPPED lpOverlapped);
typedef __stdcall BOOL (*UILANGUAGE_ENUMPROCW)(LPWSTR, LONG_PTR);
__stdcall BOOL UnhookWindowsHook __attribute__((dllimport))(int nCode __attribute__((in)), HOOKPROC pfnFilterProc __attribute__((in)));
__stdcall BOOL UnionRect __attribute__((dllimport))(LPRECT lprcDst __attribute__((out)), const RECT *lprcSrc1 __attribute__((in)), const RECT *lprcSrc2 __attribute__((in)));
__stdcall BOOL UnlockFileEx __attribute__((dllimport))(HANDLE hFile __attribute__((in)), DWORD dwReserved, DWORD nNumberOfBytesToUnlockLow __attribute__((in)), DWORD nNumberOfBytesToUnlockHigh __attribute__((in)), LPOVERLAPPED lpOverlapped);
__stdcall BOOL UnregisterClassW __attribute__((dllimport))(LPCWSTR lpClassName __attribute__((in)), HINSTANCE hInstance __attribute__((in)));
__stdcall BOOL UpdateLayeredWindow __attribute__((dllimport))(HWND hWnd __attribute__((in)), HDC hdcDst __attribute__((in)), POINT *pptDst __attribute__((in)), SIZE *psize __attribute__((in)), HDC hdcSrc __attribute__((in)), POINT *pptSrc __attribute__((in)), COLORREF crKey __attribute__((in)), BLENDFUNCTION *pblend __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL UpdateResourceW __attribute__((dllimport))(HANDLE hUpdate __attribute__((in)), LPCWSTR lpType __attribute__((in)), LPCWSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)), LPVOID lpData __attribute__((in)), DWORD cb __attribute__((in)));
__stdcall BOOL ValidateRect __attribute__((dllimport))(HWND hWnd __attribute__((in)), const RECT *lpRect __attribute__((in)));
__stdcall DWORD VerFindFileW(DWORD uFlags __attribute__((in)), LPCWSTR szFileName __attribute__((in)), LPCWSTR szWinDir __attribute__((in)), LPCWSTR szAppDir __attribute__((in)), LPWSTR szCurDir, PUINT lpuCurDirLen, LPWSTR szDestDir, PUINT lpuDestDirLen);
__stdcall DWORD VerLanguageNameW(DWORD wLang __attribute__((in)), LPWSTR szLang, DWORD cchLang __attribute__((in)));
__stdcall BOOL VerQueryValueW(LPCVOID pBlock __attribute__((in)), LPCWSTR lpSubBlock __attribute__((in)), LPVOID *lplpBuffer, PUINT puLen __attribute__((out)));
__stdcall BOOL VerifyVersionInfoA __attribute__((dllimport))(LPOSVERSIONINFOEXA lpVersionInformation, DWORD dwTypeMask __attribute__((in)), DWORDLONG dwlConditionMask __attribute__((in)));
typedef WAITORTIMERCALLBACKFUNC WAITORTIMERCALLBACK;
typedef NAMEENUMPROCA WINSTAENUMPROCA;
__stdcall DWORD WNetCancelConnection2W(LPCWSTR lpName __attribute__((in)), DWORD dwFlags __attribute__((in)), BOOL fForce __attribute__((in)));
__stdcall DWORD WNetCancelConnectionW(LPCWSTR lpName __attribute__((in)), BOOL fForce __attribute__((in)));
__stdcall DWORD WNetGetConnectionW(LPCWSTR lpLocalName __attribute__((in)), LPWSTR lpRemoteName, LPDWORD lpnLength);
__stdcall DWORD WNetGetLastErrorW(LPDWORD lpError __attribute__((out)), LPWSTR lpErrorBuf, DWORD nErrorBufSize __attribute__((in)), LPWSTR lpNameBuf, DWORD nNameBufSize __attribute__((in)));
__stdcall DWORD WNetGetNetworkInformationW(LPCWSTR lpProvider __attribute__((in)), LPNETINFOSTRUCT lpNetInfoStruct __attribute__((out)));
__stdcall DWORD WNetGetProviderNameW(DWORD dwNetType __attribute__((in)), LPWSTR lpProviderName, LPDWORD lpBufferSize);
__stdcall DWORD WNetGetUniversalNameW(LPCWSTR lpLocalPath __attribute__((in)), DWORD dwInfoLevel __attribute__((in)), LPVOID lpBuffer, LPDWORD lpBufferSize);
__stdcall DWORD WNetGetUserW(LPCWSTR lpName __attribute__((in)), LPWSTR lpUserName, LPDWORD lpnLength);
__stdcall BOOL WaitCommEvent __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPDWORD lpEvtMask, LPOVERLAPPED lpOverlapped);
__stdcall BOOL WaitNamedPipeW __attribute__((dllimport))(LPCWSTR lpNamedPipeName __attribute__((in)), DWORD nTimeOut __attribute__((in)));
__stdcall int WideCharToMultiByte __attribute__((dllimport))(UINT CodePage __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCWSTR lpWideCharStr __attribute__((in)), int cchWideChar __attribute__((in)), LPSTR lpMultiByteStr, int cbMultiByte __attribute__((in)), LPCSTR lpDefaultChar __attribute__((in)), LPBOOL lpUsedDefaultChar __attribute__((out)));
__stdcall BOOL WinHelpW __attribute__((dllimport))(HWND hWndMain __attribute__((in)), LPCWSTR lpszHelp __attribute__((in)), UINT uCommand __attribute__((in)), ULONG_PTR dwData __attribute__((in)));
__stdcall HWND WindowFromPoint __attribute__((dllimport))(POINT Point __attribute__((in)));
__stdcall BOOL WriteConsoleOutputAttribute __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const WORD *lpAttribute __attribute__((in)), DWORD nLength __attribute__((in)), COORD dwWriteCoord __attribute__((in)), LPDWORD lpNumberOfAttrsWritten __attribute__((out)));
__stdcall BOOL WriteConsoleOutputCharacterA __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), LPCSTR lpCharacter __attribute__((in)), DWORD nLength __attribute__((in)), COORD dwWriteCoord __attribute__((in)), LPDWORD lpNumberOfCharsWritten __attribute__((out)));
__stdcall DWORD WriteEncryptedFileRaw __attribute__((dllimport))(PFE_IMPORT_FUNC pfImportCallback __attribute__((in)), PVOID pvCallbackContext __attribute__((in)), PVOID pvContext __attribute__((in)));
__stdcall BOOL WriteFile __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPCVOID lpBuffer __attribute__((in)), DWORD nNumberOfBytesToWrite __attribute__((in)), LPDWORD lpNumberOfBytesWritten __attribute__((out)), LPOVERLAPPED lpOverlapped);
__stdcall BOOL WritePrivateProfileSectionW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPCWSTR lpString __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall BOOL WritePrivateProfileStringW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPCWSTR lpKeyName __attribute__((in)), LPCWSTR lpString __attribute__((in)), LPCWSTR lpFileName __attribute__((in)));
__stdcall BOOL WritePrivateProfileStructW __attribute__((dllimport))(LPCWSTR lpszSection __attribute__((in)), LPCWSTR lpszKey __attribute__((in)), LPVOID lpStruct __attribute__((in)), UINT uSizeStruct __attribute__((in)), LPCWSTR szFile __attribute__((in)));
__stdcall BOOL WriteProfileStringW __attribute__((dllimport))(LPCWSTR lpAppName __attribute__((in)), LPCWSTR lpKeyName __attribute__((in)), LPCWSTR lpString __attribute__((in)));

struct _BY_HANDLE_FILE_INFORMATION {
	DWORD dwFileAttributes;
	FILETIME ftCreationTime;
	FILETIME ftLastAccessTime;
	FILETIME ftLastWriteTime;
	DWORD dwVolumeSerialNumber;
	DWORD nFileSizeHigh;
	DWORD nFileSizeLow;
	DWORD nNumberOfLinks;
	DWORD nFileIndexHigh;
	DWORD nFileIndexLow;
};

struct _COMMCONFIG {
	DWORD dwSize;
	WORD wVersion;
	WORD wReserved;
	DCB dcb;
	DWORD dwProviderSubType;
	DWORD dwProviderOffset;
	DWORD dwProviderSize;
	WCHAR wcProviderData[1];
};

struct _CONSOLE_FONT_INFO {
	DWORD nFont;
	COORD dwFontSize;
};

struct _CONSOLE_SCREEN_BUFFER_INFO {
	COORD dwSize;
	COORD dwCursorPosition;
	WORD wAttributes;
	SMALL_RECT srWindow;
	COORD dwMaximumWindowSize;
};

struct _CONTEXT {
	DWORD ContextFlags;
	DWORD Dr0;
	DWORD Dr1;
	DWORD Dr2;
	DWORD Dr3;
	DWORD Dr6;
	DWORD Dr7;
	FLOATING_SAVE_AREA FloatSave;
	DWORD SegGs;
	DWORD SegFs;
	DWORD SegEs;
	DWORD SegDs;
	DWORD Edi;
	DWORD Esi;
	DWORD Ebx;
	DWORD Edx;
	DWORD Ecx;
	DWORD Eax;
	DWORD Ebp;
	DWORD Eip;
	DWORD SegCs;
	DWORD EFlags;
	DWORD Esp;
	DWORD SegSs;
	BYTE ExtendedRegisters[512];
} __attribute__((pack(8)));

struct _CREATE_PROCESS_DEBUG_INFO {
	HANDLE hFile;
	HANDLE hProcess;
	HANDLE hThread;
	LPVOID lpBaseOfImage;
	DWORD dwDebugInfoFileOffset;
	DWORD nDebugInfoSize;
	LPVOID lpThreadLocalBase;
	LPTHREAD_START_ROUTINE lpStartAddress;
	LPVOID lpImageName;
	WORD fUnicode;
};

struct _CREATE_THREAD_DEBUG_INFO {
	HANDLE hThread;
	LPVOID lpThreadLocalBase;
	LPTHREAD_START_ROUTINE lpStartAddress;
};

struct _DOCINFOW {
	int cbSize;
	LPCWSTR lpszDocName;
	LPCWSTR lpszOutput;
	LPCWSTR lpszDatatype;
	DWORD fwType;
};

struct _ENUM_SERVICE_STATUSA {
	LPSTR lpServiceName;
	LPSTR lpDisplayName;
	SERVICE_STATUS ServiceStatus;
};

struct _ENUM_SERVICE_STATUSW {
	LPWSTR lpServiceName;
	LPWSTR lpDisplayName;
	SERVICE_STATUS ServiceStatus;
};

struct _EXCEPTION_DEBUG_INFO {
	EXCEPTION_RECORD ExceptionRecord;
	DWORD dwFirstChance;
};

struct _GLYPHMETRICS {
	UINT gmBlackBoxX;
	UINT gmBlackBoxY;
	POINT gmptGlyphOrigin;
	short gmCellIncX;
	short gmCellIncY;
};

struct _LUID_AND_ATTRIBUTES {
	LUID Luid;
	DWORD Attributes;
} __attribute__((pack(4)));

struct _MAT2 {
	FIXED eM11;
	FIXED eM12;
	FIXED eM21;
	FIXED eM22;
};

struct _MOUSE_EVENT_RECORD {
	COORD dwMousePosition;
	DWORD dwButtonState;
	DWORD dwControlKeyState;
	DWORD dwEventFlags;
};

struct _NETRESOURCEW {
	DWORD dwScope;
	DWORD dwType;
	DWORD dwDisplayType;
	DWORD dwUsage;
	LPWSTR lpLocalName;
	LPWSTR lpRemoteName;
	LPWSTR lpComment;
	LPWSTR lpProvider;
};

struct _OUTLINETEXTMETRICA {
	UINT otmSize;
	TEXTMETRICA otmTextMetrics;
	BYTE otmFiller;
	PANOSE otmPanoseNumber;
	UINT otmfsSelection;
	UINT otmfsType;
	int otmsCharSlopeRise;
	int otmsCharSlopeRun;
	int otmItalicAngle;
	UINT otmEMSquare;
	int otmAscent;
	int otmDescent;
	UINT otmLineGap;
	UINT otmsCapEmHeight;
	UINT otmsXHeight;
	RECT otmrcFontBox;
	int otmMacAscent;
	int otmMacDescent;
	UINT otmMacLineGap;
	UINT otmusMinimumPPEM;
	POINT otmptSubscriptSize;
	POINT otmptSubscriptOffset;
	POINT otmptSuperscriptSize;
	POINT otmptSuperscriptOffset;
	UINT otmsStrikeoutSize;
	int otmsStrikeoutPosition;
	int otmsUnderscoreSize;
	int otmsUnderscorePosition;
	PSTR otmpFamilyName;
	PSTR otmpFaceName;
	PSTR otmpStyleName;
	PSTR otmpFullName;
};

struct _QUERY_SERVICE_CONFIGW {
	DWORD dwServiceType;
	DWORD dwStartType;
	DWORD dwErrorControl;
	LPWSTR lpBinaryPathName;
	LPWSTR lpLoadOrderGroup;
	DWORD dwTagId;
	LPWSTR lpDependencies;
	LPWSTR lpServiceStartName;
	LPWSTR lpDisplayName;
};

struct _QUERY_SERVICE_LOCK_STATUSW {
	DWORD fIsLocked;
	LPWSTR lpLockOwner;
	DWORD dwLockDuration;
};

struct _QUOTA_LIMITS {
	SIZE_T PagedPoolLimit;
	SIZE_T NonPagedPoolLimit;
	SIZE_T MinimumWorkingSetSize;
	SIZE_T MaximumWorkingSetSize;
	SIZE_T PagefileLimit;
	LARGE_INTEGER TimeLimit;
};

struct _RGNDATAHEADER {
	DWORD dwSize;
	DWORD iType;
	DWORD nCount;
	DWORD nRgnSize;
	RECT rcBound;
};

struct _SERVICE_TABLE_ENTRYA {
	LPSTR lpServiceName;
	LPSERVICE_MAIN_FUNCTIONA lpServiceProc;
};

struct _STARTUPINFOW {
	DWORD cb;
	LPWSTR lpReserved;
	LPWSTR lpDesktop;
	LPWSTR lpTitle;
	DWORD dwX;
	DWORD dwY;
	DWORD dwXSize;
	DWORD dwYSize;
	DWORD dwXCountChars;
	DWORD dwYCountChars;
	DWORD dwFillAttribute;
	DWORD dwFlags;
	WORD wShowWindow;
	WORD cbReserved2;
	LPBYTE lpReserved2;
	HANDLE hStdInput;
	HANDLE hStdOutput;
	HANDLE hStdError;
};

struct _TIME_ZONE_INFORMATION {
	LONG Bias;
	WCHAR StandardName[32];
	SYSTEMTIME StandardDate;
	LONG StandardBias;
	WCHAR DaylightName[32];
	SYSTEMTIME DaylightDate;
	LONG DaylightBias;
};

struct _UNICODE_STRING {
	USHORT Length;
	USHORT MaximumLength;
	PWSTR Buffer;
};

struct _WIN32_FIND_DATAA {
	DWORD dwFileAttributes;
	FILETIME ftCreationTime;
	FILETIME ftLastAccessTime;
	FILETIME ftLastWriteTime;
	DWORD nFileSizeHigh;
	DWORD nFileSizeLow;
	DWORD dwReserved0;
	DWORD dwReserved1;
	CHAR cFileName[260];
	CHAR cAlternateFileName[14];
};

struct _WIN32_FIND_DATAW {
	DWORD dwFileAttributes;
	FILETIME ftCreationTime;
	FILETIME ftLastAccessTime;
	FILETIME ftLastWriteTime;
	DWORD nFileSizeHigh;
	DWORD nFileSizeLow;
	DWORD dwReserved0;
	DWORD dwReserved1;
	WCHAR cFileName[260];
	WCHAR cAlternateFileName[14];
};

struct _WINDOW_BUFFER_SIZE_RECORD {
	COORD dwSize;
};

struct _currencyfmtW {
	UINT NumDigits;
	UINT LeadingZero;
	UINT Grouping;
	LPWSTR lpDecimalSep;
	LPWSTR lpThousandSep;
	UINT NegativeOrder;
	UINT PositiveOrder;
	LPWSTR lpCurrencySymbol;
};

struct _devicemodeA {
	BYTE dmDeviceName[32];
	WORD dmSpecVersion;
	WORD dmDriverVersion;
	WORD dmSize;
	WORD dmDriverExtra;
	DWORD dmFields;

	union {

		struct {
			short dmOrientation;
			short dmPaperSize;
			short dmPaperLength;
			short dmPaperWidth;
			short dmScale;
			short dmCopies;
			short dmDefaultSource;
			short dmPrintQuality;
		};

		struct {
			POINTL dmPosition;
			DWORD dmDisplayOrientation;
			DWORD dmDisplayFixedOutput;
		};
	};
	short dmColor;
	short dmDuplex;
	short dmYResolution;
	short dmTTOption;
	short dmCollate;
	BYTE dmFormName[32];
	WORD dmLogPixels;
	DWORD dmBitsPerPel;
	DWORD dmPelsWidth;
	DWORD dmPelsHeight;

	union {
		DWORD dmDisplayFlags;
		DWORD dmNup;
	};
	DWORD dmDisplayFrequency;
	DWORD dmICMMethod;
	DWORD dmICMIntent;
	DWORD dmMediaType;
	DWORD dmDitherType;
	DWORD dmReserved1;
	DWORD dmReserved2;
	DWORD dmPanningWidth;
	DWORD dmPanningHeight;
};

struct _devicemodeW {
	WCHAR dmDeviceName[32];
	WORD dmSpecVersion;
	WORD dmDriverVersion;
	WORD dmSize;
	WORD dmDriverExtra;
	DWORD dmFields;

	union {

		struct {
			short dmOrientation;
			short dmPaperSize;
			short dmPaperLength;
			short dmPaperWidth;
			short dmScale;
			short dmCopies;
			short dmDefaultSource;
			short dmPrintQuality;
		};

		struct {
			POINTL dmPosition;
			DWORD dmDisplayOrientation;
			DWORD dmDisplayFixedOutput;
		};
	};
	short dmColor;
	short dmDuplex;
	short dmYResolution;
	short dmTTOption;
	short dmCollate;
	WCHAR dmFormName[32];
	WORD dmLogPixels;
	DWORD dmBitsPerPel;
	DWORD dmPelsWidth;
	DWORD dmPelsHeight;

	union {
		DWORD dmDisplayFlags;
		DWORD dmNup;
	};
	DWORD dmDisplayFrequency;
	DWORD dmICMMethod;
	DWORD dmICMIntent;
	DWORD dmMediaType;
	DWORD dmDitherType;
	DWORD dmReserved1;
	DWORD dmReserved2;
	DWORD dmPanningWidth;
	DWORD dmPanningHeight;
};

struct _numberfmtW {
	UINT NumDigits;
	UINT LeadingZero;
	UINT Grouping;
	LPWSTR lpDecimalSep;
	LPWSTR lpThousandSep;
	UINT NegativeOrder;
};
__stdcall LPWSTR lstrcatW __attribute__((dllimport)) __attribute__((out))(LPWSTR lpString1, LPCWSTR lpString2 __attribute__((in)));
__stdcall int lstrcmpW __attribute__((dllimport))(LPCWSTR lpString1 __attribute__((in)), LPCWSTR lpString2 __attribute__((in)));
__stdcall int lstrcmpiW __attribute__((dllimport))(LPCWSTR lpString1 __attribute__((in)), LPCWSTR lpString2 __attribute__((in)));
__stdcall LPWSTR lstrcpyW __attribute__((dllimport)) __attribute__((out))(LPWSTR lpString1, LPCWSTR lpString2 __attribute__((in)));
__stdcall LPWSTR lstrcpynW __attribute__((dllimport)) __attribute__((out))(LPWSTR lpString1, LPCWSTR lpString2 __attribute__((in)), int iMaxLength __attribute__((in)));
__stdcall int lstrlenW __attribute__((dllimport))(LPCWSTR lpString __attribute__((in)));

struct tagACTCTXW {
	ULONG cbSize;
	DWORD dwFlags;
	LPCWSTR lpSource;
	USHORT wProcessorArchitecture;
	LANGID wLangId;
	LPCWSTR lpAssemblyDirectory;
	LPCWSTR lpResourceName;
	LPCWSTR lpApplicationName;
	HMODULE hModule;
};

struct tagACTCTX_SECTION_KEYED_DATA {
	ULONG cbSize;
	ULONG ulDataFormatVersion;
	PVOID lpData;
	ULONG ulLength;
	PVOID lpSectionGlobalData;
	ULONG ulSectionGlobalDataLength;
	PVOID lpSectionBase;
	ULONG ulSectionTotalLength;
	HANDLE hActCtx;
	ULONG ulAssemblyRosterIndex;
	ULONG ulFlags;
	ACTCTX_SECTION_KEYED_DATA_ASSEMBLY_METADATA AssemblyMetadata;
};

struct tagBITMAPINFO {
	BITMAPINFOHEADER bmiHeader;
	RGBQUAD bmiColors[1];
};

struct tagCHARSETINFO {
	UINT ciCharset;
	UINT ciACP;
	FONTSIGNATURE fs;
};

struct tagCOMBOBOXINFO {
	DWORD cbSize;
	RECT rcItem;
	RECT rcButton;
	DWORD stateButton;
	HWND hwndCombo;
	HWND hwndItem;
	HWND hwndList;
};

struct tagCOMPOSITIONFORM {
	DWORD dwStyle;
	POINT ptCurrentPos;
	RECT rcArea;
};

struct tagCURSORINFO {
	DWORD cbSize;
	DWORD flags;
	HCURSOR hCursor;
	POINT ptScreenPos;
};

struct tagGCP_RESULTSA {
	DWORD lStructSize;
	LPSTR lpOutString;
	UINT *lpOrder;
	int *lpDx;
	int *lpCaretPos;
	LPSTR lpClass;
	LPWSTR lpGlyphs;
	UINT nGlyphs;
	int nMaxFit;
};

struct tagGCP_RESULTSW {
	DWORD lStructSize;
	LPWSTR lpOutString;
	UINT *lpOrder;
	int *lpDx;
	int *lpCaretPos;
	LPSTR lpClass;
	LPWSTR lpGlyphs;
	UINT nGlyphs;
	int nMaxFit;
};

struct tagGUITHREADINFO {
	DWORD cbSize;
	DWORD flags;
	HWND hwndActive;
	HWND hwndFocus;
	HWND hwndCapture;
	HWND hwndMenuOwner;
	HWND hwndMoveSize;
	HWND hwndCaret;
	RECT rcCaret;
};

struct tagHELPINFO {
	UINT cbSize;
	int iContextType;
	int iCtrlId;
	HANDLE hItemHandle;
	DWORD_PTR dwContextId;
	POINT MousePos;
};

struct tagICEXYZTRIPLE {
	CIEXYZ ciexyzRed;
	CIEXYZ ciexyzGreen;
	CIEXYZ ciexyzBlue;
};

struct tagINPUT {
	DWORD type;

	union {
		MOUSEINPUT mi;
		KEYBDINPUT ki;
		HARDWAREINPUT hi;
	};
};

struct tagLOGPALETTE {
	WORD palVersion;
	WORD palNumEntries;
	PALETTEENTRY palPalEntry[1];
};

struct tagLOGPEN {
	UINT lopnStyle;
	POINT lopnWidth;
	COLORREF lopnColor;
};

struct tagMENUBARINFO {
	DWORD cbSize;
	RECT rcBar;
	HMENU hMenu;
	HWND hwndMenu;
	BOOL fBarFocused:1;
	BOOL fFocused:1;
};

struct tagMENUITEMINFOW {
	UINT cbSize;
	UINT fMask;
	UINT fType;
	UINT fState;
	UINT wID;
	HMENU hSubMenu;
	HBITMAP hbmpChecked;
	HBITMAP hbmpUnchecked;
	ULONG_PTR dwItemData;
	LPWSTR dwTypeData;
	UINT cch;
	HBITMAP hbmpItem;
};

struct tagMONITORINFO {
	DWORD cbSize;
	RECT rcMonitor;
	RECT rcWork;
	DWORD dwFlags;
};

struct tagMSG {
	HWND hwnd;
	UINT message;
	WPARAM wParam;
	LPARAM lParam;
	DWORD time;
	POINT pt;
};

struct tagPAINTSTRUCT {
	HDC hdc;
	BOOL fErase;
	RECT rcPaint;
	BOOL fRestore;
	BOOL fIncUpdate;
	BYTE rgbReserved[32];
};

struct tagPOLYTEXTA {
	int x;
	int y;
	UINT n;
	LPCSTR lpstr;
	UINT uiFlags;
	RECT rcl;
	int *pdx;
};

struct tagSCROLLBARINFO {
	DWORD cbSize;
	RECT rcScrollBar;
	int dxyLineButton;
	int xyThumbTop;
	int xyThumbBottom;
	int reserved;
	DWORD rgstate[6];
};

struct tagTITLEBARINFO {
	DWORD cbSize;
	RECT rcTitleBar;
	DWORD rgstate[6];
};

struct tagTPMPARAMS {
	UINT cbSize;
	RECT rcExclude;
};

struct tagWINDOWINFO {
	DWORD cbSize;
	RECT rcWindow;
	RECT rcClient;
	DWORD dwStyle;
	DWORD dwExStyle;
	DWORD dwWindowStatus;
	UINT cxWindowBorders;
	UINT cyWindowBorders;
	ATOM atomWindowType;
	WORD wCreatorVersion;
};

struct tagWINDOWPLACEMENT {
	UINT length;
	UINT flags;
	UINT showCmd;
	POINT ptMinPosition;
	POINT ptMaxPosition;
	RECT rcNormalPosition;
};

struct tagWNDCLASSA {
	UINT style;
	WNDPROC lpfnWndProc;
	int cbClsExtra;
	int cbWndExtra;
	HINSTANCE hInstance;
	HICON hIcon;
	HCURSOR hCursor;
	HBRUSH hbrBackground;
	LPCSTR lpszMenuName;
	LPCSTR lpszClassName;
};

struct tagWNDCLASSEXA {
	UINT cbSize;
	UINT style;
	WNDPROC lpfnWndProc;
	int cbClsExtra;
	int cbWndExtra;
	HINSTANCE hInstance;
	HICON hIcon;
	HCURSOR hCursor;
	HBRUSH hbrBackground;
	LPCSTR lpszMenuName;
	LPCSTR lpszClassName;
	HICON hIconSm;
};

struct tagWNDCLASSEXW {
	UINT cbSize;
	UINT style;
	WNDPROC lpfnWndProc;
	int cbClsExtra;
	int cbWndExtra;
	HINSTANCE hInstance;
	HICON hIcon;
	HCURSOR hCursor;
	HBRUSH hbrBackground;
	LPCWSTR lpszMenuName;
	LPCWSTR lpszClassName;
	HICON hIconSm;
};

struct tagWNDCLASSW {
	UINT style;
	WNDPROC lpfnWndProc;
	int cbClsExtra;
	int cbWndExtra;
	HINSTANCE hInstance;
	HICON hIcon;
	HCURSOR hCursor;
	HBRUSH hbrBackground;
	LPCWSTR lpszMenuName;
	LPCWSTR lpszClassName;
};
__cdecl int wsprintfW __attribute__((dllimport))(LPWSTR __attribute__((out)), LPCWSTR __attribute__((in)), ...);
__stdcall int wvsprintfW __attribute__((dllimport))(LPWSTR __attribute__((out)), LPCWSTR __attribute__((in)), va_list arglist __attribute__((in)));


typedef struct tagACTCTXW ACTCTXW;
__stdcall BOOL AddAccessAllowedAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AccessMask __attribute__((in)), PSID pSid __attribute__((in)));
__stdcall BOOL AddAccessAllowedAceEx __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AceFlags __attribute__((in)), DWORD AccessMask __attribute__((in)), PSID pSid __attribute__((in)));
__stdcall BOOL AddAccessAllowedObjectAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AceFlags __attribute__((in)), DWORD AccessMask __attribute__((in)), GUID *ObjectTypeGuid __attribute__((in)), GUID *InheritedObjectTypeGuid __attribute__((in)), PSID pSid __attribute__((in)));
__stdcall BOOL AddAccessDeniedAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AccessMask __attribute__((in)), PSID pSid __attribute__((in)));
__stdcall BOOL AddAccessDeniedAceEx __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AceFlags __attribute__((in)), DWORD AccessMask __attribute__((in)), PSID pSid __attribute__((in)));
__stdcall BOOL AddAccessDeniedObjectAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AceFlags __attribute__((in)), DWORD AccessMask __attribute__((in)), GUID *ObjectTypeGuid __attribute__((in)), GUID *InheritedObjectTypeGuid __attribute__((in)), PSID pSid __attribute__((in)));
__stdcall BOOL AddAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD dwStartingAceIndex __attribute__((in)), LPVOID pAceList __attribute__((in)), DWORD nAceListLength __attribute__((in)));
__stdcall BOOL AddAuditAccessAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD dwAccessMask __attribute__((in)), PSID pSid __attribute__((in)), BOOL bAuditSuccess __attribute__((in)), BOOL bAuditFailure __attribute__((in)));
__stdcall BOOL AddAuditAccessAceEx __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AceFlags __attribute__((in)), DWORD dwAccessMask __attribute__((in)), PSID pSid __attribute__((in)), BOOL bAuditSuccess __attribute__((in)), BOOL bAuditFailure __attribute__((in)));
__stdcall BOOL AddAuditAccessObjectAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceRevision __attribute__((in)), DWORD AceFlags __attribute__((in)), DWORD AccessMask __attribute__((in)), GUID *ObjectTypeGuid __attribute__((in)), GUID *InheritedObjectTypeGuid __attribute__((in)), PSID pSid __attribute__((in)), BOOL bAuditSuccess __attribute__((in)), BOOL bAuditFailure __attribute__((in)));
typedef struct tagBITMAPINFO BITMAPINFO;
__stdcall BOOL BindIoCompletionCallback __attribute__((dllimport))(HANDLE FileHandle __attribute__((in)), LPOVERLAPPED_COMPLETION_ROUTINE Function __attribute__((in)), ULONG Flags __attribute__((in)));
__stdcall long BroadcastSystemMessageExW __attribute__((dllimport))(DWORD flags __attribute__((in)), LPDWORD lpInfo, UINT Msg __attribute__((in)), WPARAM wParam __attribute__((in)), LPARAM lParam __attribute__((in)), PBSMINFO pbsmInfo __attribute__((out)));
typedef struct tagICEXYZTRIPLE CIEXYZTRIPLE;
typedef struct _CONTEXT CONTEXT;
typedef struct _CREATE_PROCESS_DEBUG_INFO CREATE_PROCESS_DEBUG_INFO;
typedef struct _CREATE_THREAD_DEBUG_INFO CREATE_THREAD_DEBUG_INFO;
typedef struct _currencyfmtW CURRENCYFMTW;
__stdcall BOOL CopyFileExA __attribute__((dllimport))(LPCSTR lpExistingFileName __attribute__((in)), LPCSTR lpNewFileName __attribute__((in)), LPPROGRESS_ROUTINE lpProgressRoutine __attribute__((in)), LPVOID lpData __attribute__((in)), LPBOOL pbCancel __attribute__((in)), DWORD dwCopyFlags __attribute__((in)));
__stdcall BOOL CopyFileExW __attribute__((dllimport))(LPCWSTR lpExistingFileName __attribute__((in)), LPCWSTR lpNewFileName __attribute__((in)), LPPROGRESS_ROUTINE lpProgressRoutine __attribute__((in)), LPVOID lpData __attribute__((in)), LPBOOL pbCancel __attribute__((in)), DWORD dwCopyFlags __attribute__((in)));
__stdcall HBRUSH CreateBrushIndirect __attribute__((dllimport))(const LOGBRUSH *plbrush __attribute__((in)));
__stdcall HFONT CreateFontIndirectW __attribute__((dllimport))(const LOGFONTW *lplf __attribute__((in)));
__stdcall BOOL CreateProcessA __attribute__((dllimport))(LPCSTR lpApplicationName __attribute__((in)), LPSTR lpCommandLine, LPSECURITY_ATTRIBUTES lpProcessAttributes __attribute__((in)), LPSECURITY_ATTRIBUTES lpThreadAttributes __attribute__((in)), BOOL bInheritHandles __attribute__((in)), DWORD dwCreationFlags __attribute__((in)), LPVOID lpEnvironment __attribute__((in)), LPCSTR lpCurrentDirectory __attribute__((in)), LPSTARTUPINFOA lpStartupInfo __attribute__((in)), LPPROCESS_INFORMATION lpProcessInformation __attribute__((out)));
__stdcall BOOL CreateProcessAsUserA __attribute__((dllimport))(HANDLE hToken __attribute__((in)), LPCSTR lpApplicationName __attribute__((in)), LPSTR lpCommandLine, LPSECURITY_ATTRIBUTES lpProcessAttributes __attribute__((in)), LPSECURITY_ATTRIBUTES lpThreadAttributes __attribute__((in)), BOOL bInheritHandles __attribute__((in)), DWORD dwCreationFlags __attribute__((in)), LPVOID lpEnvironment __attribute__((in)), LPCSTR lpCurrentDirectory __attribute__((in)), LPSTARTUPINFOA lpStartupInfo __attribute__((in)), LPPROCESS_INFORMATION lpProcessInformation __attribute__((out)));
__stdcall BOOL CreateTimerQueueTimer __attribute__((dllimport))(PHANDLE phNewTimer, HANDLE TimerQueue __attribute__((in)), WAITORTIMERCALLBACK Callback __attribute__((in)), PVOID Parameter __attribute__((in)), DWORD DueTime __attribute__((in)), DWORD Period __attribute__((in)), ULONG Flags __attribute__((in)));
typedef NAMEENUMPROCW DESKTOPENUMPROCW;
typedef struct _devicemodeA DEVMODEA;
typedef struct _devicemodeW DEVMODEW;
typedef struct _DOCINFOW DOCINFOW;
__stdcall BOOL DeleteAce __attribute__((dllimport))(PACL pAcl, DWORD dwAceIndex __attribute__((in)));
typedef struct _EXCEPTION_DEBUG_INFO EXCEPTION_DEBUG_INFO;
__stdcall BOOL EnumCalendarInfoW __attribute__((dllimport))(CALINFO_ENUMPROCW lpCalInfoEnumProc __attribute__((in)), LCID Locale __attribute__((in)), CALID Calendar __attribute__((in)), CALTYPE CalType __attribute__((in)));
__stdcall BOOL EnumDateFormatsW __attribute__((dllimport))(DATEFMT_ENUMPROCW lpDateFmtEnumProc __attribute__((in)), LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumDesktopsA __attribute__((dllimport))(HWINSTA hwinsta __attribute__((in)), DESKTOPENUMPROCA lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumDisplayDevicesW __attribute__((dllimport))(LPCWSTR lpDevice __attribute__((in)), DWORD iDevNum __attribute__((in)), PDISPLAY_DEVICEW lpDisplayDevice, DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumDisplayMonitors __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCRECT lprcClip __attribute__((in)), MONITORENUMPROC lpfnEnum __attribute__((in)), LPARAM dwData __attribute__((in)));
__stdcall BOOL EnumEnhMetaFile __attribute__((dllimport))(HDC hdc __attribute__((in)), HENHMETAFILE hmf __attribute__((in)), ENHMFENUMPROC proc __attribute__((in)), LPVOID param __attribute__((in)), const RECT *lpRect __attribute__((in)));
__stdcall BOOL EnumMetaFile __attribute__((dllimport))(HDC hdc __attribute__((in)), HMETAFILE hmf __attribute__((in)), MFENUMPROC proc __attribute__((in)), LPARAM param __attribute__((in)));
__stdcall int EnumPropsExW __attribute__((dllimport))(HWND hWnd __attribute__((in)), PROPENUMPROCEXW lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumResourceLanguagesA __attribute__((dllimport))(HMODULE hModule __attribute__((in)), LPCSTR lpType __attribute__((in)), LPCSTR lpName __attribute__((in)), ENUMRESLANGPROCA lpEnumFunc __attribute__((in)), LONG_PTR lParam __attribute__((in)));
__stdcall BOOL EnumResourceLanguagesW __attribute__((dllimport))(HMODULE hModule __attribute__((in)), LPCWSTR lpType __attribute__((in)), LPCWSTR lpName __attribute__((in)), ENUMRESLANGPROCW lpEnumFunc __attribute__((in)), LONG_PTR lParam __attribute__((in)));
__stdcall BOOL EnumResourceNamesA __attribute__((dllimport))(HMODULE hModule __attribute__((in)), LPCSTR lpType __attribute__((in)), ENUMRESNAMEPROCA lpEnumFunc __attribute__((in)), LONG_PTR lParam __attribute__((in)));
__stdcall BOOL EnumResourceNamesW __attribute__((dllimport))(HMODULE hModule __attribute__((in)), LPCWSTR lpType __attribute__((in)), ENUMRESNAMEPROCW lpEnumFunc __attribute__((in)), LONG_PTR lParam __attribute__((in)));
__stdcall BOOL EnumResourceTypesA __attribute__((dllimport))(HMODULE hModule __attribute__((in)), ENUMRESTYPEPROCA lpEnumFunc __attribute__((in)), LONG_PTR lParam __attribute__((in)));
__stdcall BOOL EnumSystemCodePagesW __attribute__((dllimport))(CODEPAGE_ENUMPROCW lpCodePageEnumProc __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumSystemLocalesW __attribute__((dllimport))(LOCALE_ENUMPROCW lpLocaleEnumProc __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumTimeFormatsW __attribute__((dllimport))(TIMEFMT_ENUMPROCW lpTimeFmtEnumProc __attribute__((in)), LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumUILanguagesW __attribute__((dllimport))(UILANGUAGE_ENUMPROCW lpUILanguageEnumProc __attribute__((in)), DWORD dwFlags __attribute__((in)), LONG_PTR lParam __attribute__((in)));
__stdcall BOOL EnumWindowStationsA __attribute__((dllimport))(WINSTAENUMPROCA lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall HPEN ExtCreatePen __attribute__((dllimport))(DWORD iPenStyle __attribute__((in)), DWORD cWidth __attribute__((in)), const LOGBRUSH *plbrush __attribute__((in)), DWORD cStyle __attribute__((in)), const DWORD *pstyle __attribute__((in)));
typedef OLDFONTENUMPROCA FONTENUMPROCA;
__stdcall BOOL FindFirstFreeAce __attribute__((dllimport))(PACL pAcl __attribute__((in)), LPVOID *pAce);
__stdcall BOOL GdiGradientFill __attribute__((dllimport))(HDC hdc __attribute__((in)), PTRIVERTEX pVertex __attribute__((in)), ULONG nVertex __attribute__((in)), PVOID pMesh __attribute__((in)), ULONG nCount __attribute__((in)), ULONG ulMode __attribute__((in)));
__stdcall BOOL GetAce __attribute__((dllimport))(PACL pAcl __attribute__((in)), DWORD dwAceIndex __attribute__((in)), LPVOID *pAce);
__stdcall BOOL GetAclInformation __attribute__((dllimport))(PACL pAcl __attribute__((in)), LPVOID pAclInformation, DWORD nAclInformationLength __attribute__((in)), ACL_INFORMATION_CLASS dwAclInformationClass __attribute__((in)));
__stdcall BOOL GetCommProperties __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPCOMMPROP lpCommProp);
__stdcall int GetCurrencyFormatA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCSTR lpValue __attribute__((in)), const CURRENCYFMTA *lpFormat __attribute__((in)), LPSTR lpCurrencyStr, int cchCurrency __attribute__((in)));
__stdcall BOOL GetCurrentHwProfileW __attribute__((dllimport))(LPHW_PROFILE_INFOW lpHwProfileInfo __attribute__((out)));
__stdcall BOOL GetDiskFreeSpaceExA __attribute__((dllimport))(LPCSTR lpDirectoryName __attribute__((in)), PULARGE_INTEGER lpFreeBytesAvailableToCaller __attribute__((out)), PULARGE_INTEGER lpTotalNumberOfBytes __attribute__((out)), PULARGE_INTEGER lpTotalNumberOfFreeBytes __attribute__((out)));
__stdcall BOOL GetDiskFreeSpaceExW __attribute__((dllimport))(LPCWSTR lpDirectoryName __attribute__((in)), PULARGE_INTEGER lpFreeBytesAvailableToCaller __attribute__((out)), PULARGE_INTEGER lpTotalNumberOfBytes __attribute__((out)), PULARGE_INTEGER lpTotalNumberOfFreeBytes __attribute__((out)));
__stdcall BOOL GetFileSizeEx __attribute__((dllimport))(HANDLE hFile __attribute__((in)), PLARGE_INTEGER lpFileSize __attribute__((out)));
__stdcall BOOL GetMenuItemInfoA __attribute__((dllimport))(HMENU hmenu __attribute__((in)), UINT item __attribute__((in)), BOOL fByPosition __attribute__((in)), LPMENUITEMINFOA lpmii);
__stdcall void GetNativeSystemInfo __attribute__((dllimport))(LPSYSTEM_INFO lpSystemInfo __attribute__((out)));
__stdcall int GetNumberFormatA __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCSTR lpValue __attribute__((in)), const NUMBERFMTA *lpFormat __attribute__((in)), LPSTR lpNumberStr, int cchNumber __attribute__((in)));
__stdcall BOOL GetSecurityDescriptorDacl __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), LPBOOL lpbDaclPresent __attribute__((out)), PACL *pDacl, LPBOOL lpbDaclDefaulted __attribute__((out)));
__stdcall BOOL GetSecurityDescriptorSacl __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), LPBOOL lpbSaclPresent __attribute__((out)), PACL *pSacl, LPBOOL lpbSaclDefaulted __attribute__((out)));
__stdcall void GetStartupInfoA __attribute__((dllimport))(LPSTARTUPINFOA lpStartupInfo __attribute__((out)));
__stdcall void GetSystemInfo __attribute__((dllimport))(LPSYSTEM_INFO lpSystemInfo __attribute__((out)));
__stdcall BOOL GetTextMetricsW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPTEXTMETRICW lptm __attribute__((out)));
__stdcall BOOL GetThreadSelectorEntry __attribute__((dllimport))(HANDLE hThread __attribute__((in)), DWORD dwSelector __attribute__((in)), LPLDT_ENTRY lpSelectorEntry __attribute__((out)));
__stdcall BOOL GetVersionExW __attribute__((dllimport))(LPOSVERSIONINFOW lpVersionInformation);
__stdcall void GlobalMemoryStatus __attribute__((dllimport))(LPMEMORYSTATUS lpBuffer __attribute__((out)));
__stdcall BOOL GlobalMemoryStatusEx __attribute__((dllimport))(LPMEMORYSTATUSEX lpBuffer __attribute__((out)));
__stdcall UINT ImmEnumRegisterWordW(HKL __attribute__((in)), REGISTERWORDENUMPROCW __attribute__((in)), LPCWSTR lpszReading __attribute__((in)), DWORD __attribute__((in)), LPCWSTR lpszRegister __attribute__((in)), LPVOID __attribute__((in)));
__stdcall BOOL ImmSetCompositionFontW(HIMC __attribute__((in)), LPLOGFONTW lplf __attribute__((in)));
__stdcall BOOL InitializeAcl __attribute__((dllimport))(PACL pAcl, DWORD nAclLength __attribute__((in)), DWORD dwAclRevision __attribute__((in)));
__stdcall void InitializeSListHead __attribute__((dllimport))(PSLIST_HEADER ListHead);
__stdcall PSINGLE_LIST_ENTRY InterlockedFlushSList __attribute__((dllimport))(PSLIST_HEADER ListHead);
__stdcall PSINGLE_LIST_ENTRY InterlockedPopEntrySList __attribute__((dllimport))(PSLIST_HEADER ListHead);
__stdcall PSINGLE_LIST_ENTRY InterlockedPushEntrySList __attribute__((dllimport))(PSLIST_HEADER ListHead, PSINGLE_LIST_ENTRY ListEntry);
__stdcall BOOL IsValidAcl __attribute__((dllimport))(PACL pAcl __attribute__((in)));
typedef struct tagLOGPALETTE LOGPALETTE;
typedef struct tagLOGPEN LOGPEN;
typedef struct tagBITMAPINFO *LPBITMAPINFO;
typedef struct _BY_HANDLE_FILE_INFORMATION *LPBY_HANDLE_FILE_INFORMATION;
typedef struct tagCHARSETINFO *LPCHARSETINFO;
typedef const MENUINFO *LPCMENUINFO;
typedef const MENUITEMINFOA *LPCMENUITEMINFOA;
typedef struct _COMMCONFIG *LPCOMMCONFIG;
typedef struct tagCOMPOSITIONFORM *LPCOMPOSITIONFORM;
typedef struct _ENUM_SERVICE_STATUSA *LPENUM_SERVICE_STATUSA;
typedef struct _ENUM_SERVICE_STATUSW *LPENUM_SERVICE_STATUSW;
typedef struct tagGCP_RESULTSA *LPGCP_RESULTSA;
typedef struct tagGCP_RESULTSW *LPGCP_RESULTSW;
typedef struct _GLYPHMETRICS *LPGLYPHMETRICS;
typedef struct tagHELPINFO *LPHELPINFO;
typedef struct tagINPUT *LPINPUT;
typedef struct tagMENUITEMINFOW *LPMENUITEMINFOW;
typedef struct tagMONITORINFO *LPMONITORINFO;
typedef struct tagMSG *LPMSG;
typedef struct _NETRESOURCEW *LPNETRESOURCEW;
typedef struct _OUTLINETEXTMETRICA *LPOUTLINETEXTMETRICA;
typedef struct tagPAINTSTRUCT *LPPAINTSTRUCT;
typedef struct _QUERY_SERVICE_CONFIGW *LPQUERY_SERVICE_CONFIGW;
typedef struct _QUERY_SERVICE_LOCK_STATUSW *LPQUERY_SERVICE_LOCK_STATUSW;
typedef struct _STARTUPINFOW *LPSTARTUPINFOW;
typedef struct _TIME_ZONE_INFORMATION *LPTIME_ZONE_INFORMATION;
typedef struct _WIN32_FIND_DATAA *LPWIN32_FIND_DATAA;
typedef struct _WIN32_FIND_DATAW *LPWIN32_FIND_DATAW;
typedef struct tagWNDCLASSA *LPWNDCLASSA;
typedef struct tagWNDCLASSEXA *LPWNDCLASSEXA;
typedef struct tagWNDCLASSEXW *LPWNDCLASSEXW;
typedef struct tagWNDCLASSW *LPWNDCLASSW;
typedef struct _LUID_AND_ATTRIBUTES LUID_AND_ATTRIBUTES;
typedef struct _MAT2 MAT2;
typedef struct tagMENUITEMINFOW MENUITEMINFOW;
typedef struct _MOUSE_EVENT_RECORD MOUSE_EVENT_RECORD;
typedef struct tagMSG MSG;
__stdcall BOOL MakeAbsoluteSD __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSelfRelativeSecurityDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR pAbsoluteSecurityDescriptor, LPDWORD lpdwAbsoluteSecurityDescriptorSize, PACL pDacl, LPDWORD lpdwDaclSize, PACL pSacl, LPDWORD lpdwSaclSize, PSID pOwner, LPDWORD lpdwOwnerSize, PSID pPrimaryGroup, LPDWORD lpdwPrimaryGroupSize);
__stdcall HMONITOR MonitorFromRect __attribute__((dllimport))(LPCRECT lprc __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL MoveFileWithProgressW __attribute__((dllimport))(LPCWSTR lpExistingFileName __attribute__((in)), LPCWSTR lpNewFileName __attribute__((in)), LPPROGRESS_ROUTINE lpProgressRoutine __attribute__((in)), LPVOID lpData __attribute__((in)), DWORD dwFlags __attribute__((in)));
typedef struct _numberfmtW NUMBERFMTW;
__stdcall NTSTATUS NtQuerySystemTime(PLARGE_INTEGER SystemTime __attribute__((out)));
__stdcall NTSTATUS NtWaitForSingleObject(HANDLE Handle __attribute__((in)), BOOLEAN Alertable __attribute__((in)), PLARGE_INTEGER Timeout __attribute__((in)));
typedef __stdcall int (*OLDFONTENUMPROCW)(const LOGFONTW*, const TEXTMETRICW*, DWORD, LPARAM);
typedef struct tagACTCTX_SECTION_KEYED_DATA *PACTCTX_SECTION_KEYED_DATA;
typedef struct tagPAINTSTRUCT PAINTSTRUCT;
typedef struct tagCOMBOBOXINFO *PCOMBOBOXINFO;
typedef struct _CONSOLE_FONT_INFO *PCONSOLE_FONT_INFO;
typedef struct _CONSOLE_SCREEN_BUFFER_INFO *PCONSOLE_SCREEN_BUFFER_INFO;
typedef const RAWINPUTDEVICE *PCRAWINPUTDEVICE;
typedef struct tagCURSORINFO *PCURSORINFO;
typedef GENERIC_MAPPING *PGENERIC_MAPPING;
typedef struct tagGUITHREADINFO *PGUITHREADINFO;
typedef ICONINFO *PICONINFO;
typedef __stdcall void (*PIO_APC_ROUTINE)(PVOID ApcContext __attribute__((in)), PIO_STATUS_BLOCK IoStatusBlock __attribute__((in)), ULONG Reserved __attribute__((in)));
typedef struct _LUID_AND_ATTRIBUTES *PLUID_AND_ATTRIBUTES;
typedef struct tagMENUBARINFO *PMENUBARINFO;
typedef struct tagPOLYTEXTA POLYTEXTA;
typedef struct _QUOTA_LIMITS *PQUOTA_LIMITS;
typedef struct tagSCROLLBARINFO *PSCROLLBARINFO;
typedef STRING *PSTRING;
typedef struct tagTITLEBARINFO *PTITLEBARINFO;
typedef struct tagWINDOWINFO *PWINDOWINFO;
__stdcall USHORT QueryDepthSList __attribute__((dllimport))(PSLIST_HEADER ListHead __attribute__((in)));
__stdcall BOOL QueryServiceConfigA __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), LPQUERY_SERVICE_CONFIGA lpServiceConfig, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
__stdcall BOOL QueryServiceLockStatusA __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPQUERY_SERVICE_LOCK_STATUSA lpLockStatus, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
typedef struct _RGNDATAHEADER RGNDATAHEADER;
__stdcall BOOL ReadConsoleOutputA __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), PCHAR_INFO lpBuffer, COORD dwBufferSize __attribute__((in)), COORD dwBufferCoord __attribute__((in)), PSMALL_RECT lpReadRegion);
__stdcall BOOL ReadConsoleOutputW __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), PCHAR_INFO lpBuffer, COORD dwBufferSize __attribute__((in)), COORD dwBufferCoord __attribute__((in)), PSMALL_RECT lpReadRegion);
__stdcall BOOL ReadDirectoryChangesW __attribute__((dllimport))(HANDLE hDirectory __attribute__((in)), LPVOID lpBuffer, DWORD nBufferLength __attribute__((in)), BOOL bWatchSubtree __attribute__((in)), DWORD dwNotifyFilter __attribute__((in)), LPDWORD lpBytesReturned __attribute__((out)), LPOVERLAPPED lpOverlapped, LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine __attribute__((in)));
__stdcall BOOL ReadFileEx __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPVOID lpBuffer, DWORD nNumberOfBytesToRead __attribute__((in)), LPOVERLAPPED lpOverlapped, LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine __attribute__((in)));
__stdcall BOOL RegisterWaitForSingleObject __attribute__((dllimport))(PHANDLE phNewWaitObject, HANDLE hObject __attribute__((in)), WAITORTIMERCALLBACK Callback __attribute__((in)), PVOID Context __attribute__((in)), ULONG dwMilliseconds __attribute__((in)), ULONG dwFlags __attribute__((in)));
__stdcall HANDLE RegisterWaitForSingleObjectEx __attribute__((dllimport))(HANDLE hObject __attribute__((in)), WAITORTIMERCALLBACK Callback __attribute__((in)), PVOID Context __attribute__((in)), ULONG dwMilliseconds __attribute__((in)), ULONG dwFlags __attribute__((in)));
__stdcall PSINGLE_LIST_ENTRY RtlFirstEntrySList __attribute__((dllimport))(const SLIST_HEADER *ListHead __attribute__((in)));
__stdcall void RtlInitializeSListHead __attribute__((dllimport))(PSLIST_HEADER ListHead __attribute__((out)));
__stdcall PSINGLE_LIST_ENTRY RtlInterlockedPopEntrySList __attribute__((dllimport))(PSLIST_HEADER ListHead);
__stdcall PSINGLE_LIST_ENTRY RtlInterlockedPushEntrySList __attribute__((dllimport))(PSLIST_HEADER ListHead, PSINGLE_LIST_ENTRY ListEntry);
__stdcall NTSTATUS RtlLocalTimeToSystemTime(PLARGE_INTEGER LocalTime __attribute__((in)), PLARGE_INTEGER SystemTime __attribute__((out)));
__stdcall BOOLEAN RtlTimeToSecondsSince1970(PLARGE_INTEGER Time, PULONG ElapsedSeconds);
__stdcall void RtlUnwind __attribute__((dllimport))(PVOID TargetFrame __attribute__((in)), PVOID TargetIp __attribute__((in)), PEXCEPTION_RECORD ExceptionRecord __attribute__((in)), PVOID ReturnValue __attribute__((in)));
typedef struct _SERVICE_TABLE_ENTRYA SERVICE_TABLE_ENTRYA;
__stdcall BOOL ScrollConsoleScreenBufferA __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const SMALL_RECT *lpScrollRectangle __attribute__((in)), const SMALL_RECT *lpClipRectangle __attribute__((in)), COORD dwDestinationOrigin __attribute__((in)), const CHAR_INFO *lpFill __attribute__((in)));
__stdcall BOOL ScrollConsoleScreenBufferW __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const SMALL_RECT *lpScrollRectangle __attribute__((in)), const SMALL_RECT *lpClipRectangle __attribute__((in)), COORD dwDestinationOrigin __attribute__((in)), const CHAR_INFO *lpFill __attribute__((in)));
__stdcall BOOL SetFilePointerEx __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LARGE_INTEGER liDistanceToMove __attribute__((in)), PLARGE_INTEGER lpNewFilePointer __attribute__((out)), DWORD dwMoveMethod __attribute__((in)));
__stdcall int SetScrollInfo __attribute__((dllimport))(HWND hwnd __attribute__((in)), int nBar __attribute__((in)), LPCSCROLLINFO lpsi __attribute__((in)), BOOL redraw __attribute__((in)));
__stdcall BOOL SetSecurityDescriptorDacl __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor, BOOL bDaclPresent __attribute__((in)), PACL pDacl __attribute__((in)), BOOL bDaclDefaulted __attribute__((in)));
__stdcall BOOL SetSecurityDescriptorSacl __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor, BOOL bSaclPresent __attribute__((in)), PACL pSacl __attribute__((in)), BOOL bSaclDefaulted __attribute__((in)));
__stdcall HANDLE SetTimerQueueTimer __attribute__((dllimport))(HANDLE TimerQueue __attribute__((in)), WAITORTIMERCALLBACK Callback __attribute__((in)), PVOID Parameter __attribute__((in)), DWORD DueTime __attribute__((in)), DWORD Period __attribute__((in)), BOOL PreferIo __attribute__((in)));
__stdcall HENHMETAFILE SetWinMetaFileBits __attribute__((dllimport))(UINT nSize __attribute__((in)), const BYTE *lpMeta16Data __attribute__((in)), HDC hdcRef __attribute__((in)), const METAFILEPICT *lpMFP __attribute__((in)));
__stdcall int StartDocA __attribute__((dllimport))(HDC hdc __attribute__((in)), const DOCINFOA *lpdi __attribute__((in)));
typedef struct _TIME_ZONE_INFORMATION TIME_ZONE_INFORMATION;
typedef struct tagTPMPARAMS TPMPARAMS;
__stdcall BOOL TrackMouseEvent __attribute__((dllimport))(LPTRACKMOUSEEVENT lpEventTrack);
typedef struct _UNICODE_STRING UNICODE_STRING;
__stdcall BOOL VerifyVersionInfoW __attribute__((dllimport))(LPOSVERSIONINFOEXW lpVersionInformation, DWORD dwTypeMask __attribute__((in)), DWORDLONG dwlConditionMask __attribute__((in)));
__stdcall SIZE_T VirtualQuery __attribute__((dllimport))(LPCVOID lpAddress __attribute__((in)), PMEMORY_BASIC_INFORMATION lpBuffer, SIZE_T dwLength __attribute__((in)));
__stdcall SIZE_T VirtualQueryEx __attribute__((dllimport))(HANDLE hProcess __attribute__((in)), LPCVOID lpAddress __attribute__((in)), PMEMORY_BASIC_INFORMATION lpBuffer, SIZE_T dwLength __attribute__((in)));
typedef struct tagWINDOWPLACEMENT WINDOWPLACEMENT;
typedef struct _WINDOW_BUFFER_SIZE_RECORD WINDOW_BUFFER_SIZE_RECORD;
typedef NAMEENUMPROCW WINSTAENUMPROCW;
typedef struct tagWNDCLASSA WNDCLASSA;
typedef struct tagWNDCLASSEXA WNDCLASSEXA;
typedef struct tagWNDCLASSEXW WNDCLASSEXW;
typedef struct tagWNDCLASSW WNDCLASSW;
__stdcall DWORD WNetAddConnection2A(LPNETRESOURCEA lpNetResource __attribute__((in)), LPCSTR lpPassword __attribute__((in)), LPCSTR lpUserName __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL WriteConsoleOutputA __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const CHAR_INFO *lpBuffer __attribute__((in)), COORD dwBufferSize __attribute__((in)), COORD dwBufferCoord __attribute__((in)), PSMALL_RECT lpWriteRegion);
__stdcall BOOL WriteConsoleOutputW __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), const CHAR_INFO *lpBuffer __attribute__((in)), COORD dwBufferSize __attribute__((in)), COORD dwBufferCoord __attribute__((in)), PSMALL_RECT lpWriteRegion);
__stdcall BOOL WriteFileEx __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPCVOID lpBuffer __attribute__((in)), DWORD nNumberOfBytesToWrite __attribute__((in)), LPOVERLAPPED lpOverlapped, LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine __attribute__((in)));

struct _OUTLINETEXTMETRICW {
	UINT otmSize;
	TEXTMETRICW otmTextMetrics;
	BYTE otmFiller;
	PANOSE otmPanoseNumber;
	UINT otmfsSelection;
	UINT otmfsType;
	int otmsCharSlopeRise;
	int otmsCharSlopeRun;
	int otmItalicAngle;
	UINT otmEMSquare;
	int otmAscent;
	int otmDescent;
	UINT otmLineGap;
	UINT otmsCapEmHeight;
	UINT otmsXHeight;
	RECT otmrcFontBox;
	int otmMacAscent;
	int otmMacDescent;
	UINT otmMacLineGap;
	UINT otmusMinimumPPEM;
	POINT otmptSubscriptSize;
	POINT otmptSubscriptOffset;
	POINT otmptSuperscriptSize;
	POINT otmptSuperscriptOffset;
	UINT otmsStrikeoutSize;
	int otmsStrikeoutPosition;
	int otmsUnderscoreSize;
	int otmsUnderscorePosition;
	PSTR otmpFamilyName;
	PSTR otmpFaceName;
	PSTR otmpStyleName;
	PSTR otmpFullName;
};

struct _RTL_CRITICAL_SECTION {
	PRTL_CRITICAL_SECTION_DEBUG DebugInfo;
	LONG LockCount;
	LONG RecursionCount;
	HANDLE OwningThread;
	HANDLE LockSemaphore;
	ULONG_PTR SpinCount;
};

struct _SERVICE_TABLE_ENTRYW {
	LPWSTR lpServiceName;
	LPSERVICE_MAIN_FUNCTIONW lpServiceProc;
};

struct tagENHMETAHEADER {
	DWORD iType;
	DWORD nSize;
	RECTL rclBounds;
	RECTL rclFrame;
	DWORD dSignature;
	DWORD nVersion;
	DWORD nBytes;
	DWORD nRecords;
	WORD nHandles;
	WORD sReserved;
	DWORD nDescription;
	DWORD offDescription;
	DWORD nPalEntries;
	SIZEL szlDevice;
	SIZEL szlMillimeters;
	DWORD cbPixelFormat;
	DWORD offPixelFormat;
	DWORD bOpenGL;
	SIZEL szlMicrometers;
};


__stdcall BOOL AccessCheckAndAuditAlarmA __attribute__((dllimport))(LPCSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), LPSTR ObjectTypeName __attribute__((in)), LPSTR ObjectName __attribute__((in)), PSECURITY_DESCRIPTOR SecurityDescriptor __attribute__((in)), DWORD DesiredAccess __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)), BOOL ObjectCreation __attribute__((in)), LPDWORD GrantedAccess __attribute__((out)), LPBOOL AccessStatus __attribute__((out)), LPBOOL pfGenerateOnClose __attribute__((out)));
__stdcall BOOL AccessCheckAndAuditAlarmW __attribute__((dllimport))(LPCWSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), LPWSTR ObjectTypeName __attribute__((in)), LPWSTR ObjectName __attribute__((in)), PSECURITY_DESCRIPTOR SecurityDescriptor __attribute__((in)), DWORD DesiredAccess __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)), BOOL ObjectCreation __attribute__((in)), LPDWORD GrantedAccess __attribute__((out)), LPBOOL AccessStatus __attribute__((out)), LPBOOL pfGenerateOnClose __attribute__((out)));
__stdcall HDC BeginPaint __attribute__((dllimport))(HWND hWnd __attribute__((in)), LPPAINTSTRUCT lpPaint __attribute__((out)));
__stdcall BOOL CallMsgFilterA __attribute__((dllimport))(LPMSG lpMsg __attribute__((in)), int nCode __attribute__((in)));
__stdcall BOOL CallMsgFilterW __attribute__((dllimport))(LPMSG lpMsg __attribute__((in)), int nCode __attribute__((in)));
__stdcall LONG ChangeDisplaySettingsA __attribute__((dllimport))(DEVMODEA *lpDevMode __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall LONG ChangeDisplaySettingsExA __attribute__((dllimport))(LPCSTR lpszDeviceName __attribute__((in)), DEVMODEA *lpDevMode __attribute__((in)), HWND hwnd, DWORD dwflags __attribute__((in)), LPVOID lParam __attribute__((in)));
__stdcall LONG ChangeDisplaySettingsExW __attribute__((dllimport))(LPCWSTR lpszDeviceName __attribute__((in)), DEVMODEW *lpDevMode __attribute__((in)), HWND hwnd, DWORD dwflags __attribute__((in)), LPVOID lParam __attribute__((in)));
__stdcall LONG ChangeDisplaySettingsW __attribute__((dllimport))(DEVMODEW *lpDevMode __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL CommConfigDialogA __attribute__((dllimport))(LPCSTR lpszName __attribute__((in)), HWND hWnd __attribute__((in)), LPCOMMCONFIG lpCC);
__stdcall BOOL CommConfigDialogW __attribute__((dllimport))(LPCWSTR lpszName __attribute__((in)), HWND hWnd __attribute__((in)), LPCOMMCONFIG lpCC);
__stdcall BOOL ConvertToAutoInheritPrivateObjectSecurity __attribute__((dllimport))(PSECURITY_DESCRIPTOR ParentDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR CurrentSecurityDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR *NewSecurityDescriptor, GUID *ObjectType __attribute__((in)), BOOLEAN IsDirectoryObject __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)));
__stdcall HDC CreateDCA __attribute__((dllimport))(LPCSTR pwszDriver __attribute__((in)), LPCSTR pwszDevice __attribute__((in)), LPCSTR pszPort __attribute__((in)), const DEVMODEA *pdm __attribute__((in)));
__stdcall HDC CreateDCW __attribute__((dllimport))(LPCWSTR pwszDriver __attribute__((in)), LPCWSTR pwszDevice __attribute__((in)), LPCWSTR pszPort __attribute__((in)), const DEVMODEW *pdm __attribute__((in)));
__stdcall HBITMAP CreateDIBSection __attribute__((dllimport))(HDC hdc __attribute__((in)), const BITMAPINFO *lpbmi __attribute__((in)), UINT usage __attribute__((in)), void **ppvBits, HANDLE hSection __attribute__((in)), DWORD offset __attribute__((in)));
__stdcall HBITMAP CreateDIBitmap __attribute__((dllimport))(HDC hdc __attribute__((in)), const BITMAPINFOHEADER *pbmih __attribute__((in)), DWORD flInit __attribute__((in)), const void *pjBits __attribute__((in)), const BITMAPINFO *pbmi __attribute__((in)), UINT iUsage __attribute__((in)));
__stdcall HDESK CreateDesktopA __attribute__((dllimport))(LPCSTR lpszDesktop __attribute__((in)), LPCSTR lpszDevice, DEVMODEA *pDevmode, DWORD dwFlags __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)), LPSECURITY_ATTRIBUTES lpsa __attribute__((in)));
__stdcall HDESK CreateDesktopW __attribute__((dllimport))(LPCWSTR lpszDesktop __attribute__((in)), LPCWSTR lpszDevice, DEVMODEW *pDevmode, DWORD dwFlags __attribute__((in)), ACCESS_MASK dwDesiredAccess __attribute__((in)), LPSECURITY_ATTRIBUTES lpsa __attribute__((in)));
__stdcall HDC CreateICA __attribute__((dllimport))(LPCSTR pszDriver __attribute__((in)), LPCSTR pszDevice __attribute__((in)), LPCSTR pszPort __attribute__((in)), const DEVMODEA *pdm __attribute__((in)));
__stdcall HDC CreateICW __attribute__((dllimport))(LPCWSTR pszDriver __attribute__((in)), LPCWSTR pszDevice __attribute__((in)), LPCWSTR pszPort __attribute__((in)), const DEVMODEW *pdm __attribute__((in)));
__stdcall HICON CreateIconIndirect __attribute__((dllimport))(PICONINFO piconinfo __attribute__((in)));
__stdcall HPALETTE CreatePalette __attribute__((dllimport))(const LOGPALETTE *plpal __attribute__((in)));
__stdcall HPEN CreatePenIndirect __attribute__((dllimport))(const LOGPEN *plpen __attribute__((in)));
__stdcall BOOL CreatePrivateObjectSecurity __attribute__((dllimport))(PSECURITY_DESCRIPTOR ParentDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR CreatorDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR *NewDescriptor, BOOL IsDirectoryObject __attribute__((in)), HANDLE Token __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)));
__stdcall BOOL CreatePrivateObjectSecurityEx __attribute__((dllimport))(PSECURITY_DESCRIPTOR ParentDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR CreatorDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR *NewDescriptor, GUID *ObjectType __attribute__((in)), BOOL IsContainerObject __attribute__((in)), ULONG AutoInheritFlags __attribute__((in)), HANDLE Token __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)));
__stdcall BOOL CreatePrivateObjectSecurityWithMultipleInheritance __attribute__((dllimport))(PSECURITY_DESCRIPTOR ParentDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR CreatorDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR *NewDescriptor, GUID **ObjectTypes __attribute__((in)), ULONG GuidCount __attribute__((in)), BOOL IsContainerObject __attribute__((in)), ULONG AutoInheritFlags __attribute__((in)), HANDLE Token __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)));
__stdcall BOOL CreateProcessAsUserW __attribute__((dllimport))(HANDLE hToken __attribute__((in)), LPCWSTR lpApplicationName __attribute__((in)), LPWSTR lpCommandLine, LPSECURITY_ATTRIBUTES lpProcessAttributes __attribute__((in)), LPSECURITY_ATTRIBUTES lpThreadAttributes __attribute__((in)), BOOL bInheritHandles __attribute__((in)), DWORD dwCreationFlags __attribute__((in)), LPVOID lpEnvironment __attribute__((in)), LPCWSTR lpCurrentDirectory __attribute__((in)), LPSTARTUPINFOW lpStartupInfo __attribute__((in)), LPPROCESS_INFORMATION lpProcessInformation __attribute__((out)));
__stdcall BOOL CreateProcessW __attribute__((dllimport))(LPCWSTR lpApplicationName __attribute__((in)), LPWSTR lpCommandLine, LPSECURITY_ATTRIBUTES lpProcessAttributes __attribute__((in)), LPSECURITY_ATTRIBUTES lpThreadAttributes __attribute__((in)), BOOL bInheritHandles __attribute__((in)), DWORD dwCreationFlags __attribute__((in)), LPVOID lpEnvironment __attribute__((in)), LPCWSTR lpCurrentDirectory __attribute__((in)), LPSTARTUPINFOW lpStartupInfo __attribute__((in)), LPPROCESS_INFORMATION lpProcessInformation __attribute__((out)));
__stdcall BOOL CreateProcessWithLogonW __attribute__((dllimport))(LPCWSTR lpUsername __attribute__((in)), LPCWSTR lpDomain __attribute__((in)), LPCWSTR lpPassword __attribute__((in)), DWORD dwLogonFlags __attribute__((in)), LPCWSTR lpApplicationName __attribute__((in)), LPWSTR lpCommandLine, DWORD dwCreationFlags __attribute__((in)), LPVOID lpEnvironment __attribute__((in)), LPCWSTR lpCurrentDirectory __attribute__((in)), LPSTARTUPINFOW lpStartupInfo __attribute__((in)), LPPROCESS_INFORMATION lpProcessInformation __attribute__((out)));
__stdcall BOOL CreateRestrictedToken __attribute__((dllimport))(HANDLE ExistingTokenHandle __attribute__((in)), DWORD Flags __attribute__((in)), DWORD DisableSidCount __attribute__((in)), PSID_AND_ATTRIBUTES SidsToDisable __attribute__((in)), DWORD DeletePrivilegeCount __attribute__((in)), PLUID_AND_ATTRIBUTES PrivilegesToDelete __attribute__((in)), DWORD RestrictedSidCount __attribute__((in)), PSID_AND_ATTRIBUTES SidsToRestrict __attribute__((in)), PHANDLE NewTokenHandle);
__stdcall LRESULT DispatchMessageA __attribute__((dllimport))(const MSG *lpMsg __attribute__((in)));
__stdcall LRESULT DispatchMessageW __attribute__((dllimport))(const MSG *lpMsg __attribute__((in)));
__stdcall BOOL EndPaint __attribute__((dllimport))(HWND hWnd __attribute__((in)), const PAINTSTRUCT *lpPaint __attribute__((in)));
__stdcall BOOL EnumDependentServicesA __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwServiceState __attribute__((in)), LPENUM_SERVICE_STATUSA lpServices, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)), LPDWORD lpServicesReturned __attribute__((out)));
__stdcall BOOL EnumDependentServicesW __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), DWORD dwServiceState __attribute__((in)), LPENUM_SERVICE_STATUSW lpServices, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)), LPDWORD lpServicesReturned __attribute__((out)));
__stdcall BOOL EnumDesktopsW __attribute__((dllimport))(HWINSTA hwinsta __attribute__((in)), DESKTOPENUMPROCW lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumDisplaySettingsA __attribute__((dllimport))(LPCSTR lpszDeviceName __attribute__((in)), DWORD iModeNum __attribute__((in)), DEVMODEA *lpDevMode);
__stdcall BOOL EnumDisplaySettingsExW __attribute__((dllimport))(LPCWSTR lpszDeviceName __attribute__((in)), DWORD iModeNum __attribute__((in)), DEVMODEW *lpDevMode, DWORD dwFlags __attribute__((in)));
__stdcall BOOL EnumDisplaySettingsW __attribute__((dllimport))(LPCWSTR lpszDeviceName __attribute__((in)), DWORD iModeNum __attribute__((in)), DEVMODEW *lpDevMode);
__stdcall int EnumFontFamiliesA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpLogfont __attribute__((in)), FONTENUMPROCA lpProc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall int EnumFontFamiliesExA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPLOGFONTA lpLogfont __attribute__((in)), FONTENUMPROCA lpProc __attribute__((in)), LPARAM lParam __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall int EnumFontsA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpLogfont __attribute__((in)), FONTENUMPROCA lpProc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall BOOL EnumServicesStatusA __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), DWORD dwServiceType __attribute__((in)), DWORD dwServiceState __attribute__((in)), LPENUM_SERVICE_STATUSA lpServices, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)), LPDWORD lpServicesReturned __attribute__((out)), LPDWORD lpResumeHandle);
__stdcall BOOL EnumServicesStatusW __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), DWORD dwServiceType __attribute__((in)), DWORD dwServiceState __attribute__((in)), LPENUM_SERVICE_STATUSW lpServices, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)), LPDWORD lpServicesReturned __attribute__((out)), LPDWORD lpResumeHandle);
__stdcall BOOL EnumWindowStationsW __attribute__((dllimport))(WINSTAENUMPROCW lpEnumFunc __attribute__((in)), LPARAM lParam __attribute__((in)));
typedef OLDFONTENUMPROCW FONTENUMPROCW;
__stdcall BOOL FindActCtxSectionGuid __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), const GUID *lpExtensionGuid, ULONG ulSectionId __attribute__((in)), const GUID *lpGuidToFind __attribute__((in)), PACTCTX_SECTION_KEYED_DATA ReturnedData __attribute__((out)));
__stdcall BOOL FindActCtxSectionStringW __attribute__((dllimport))(DWORD dwFlags __attribute__((in)), const GUID *lpExtensionGuid, ULONG ulSectionId __attribute__((in)), LPCWSTR lpStringToFind __attribute__((in)), PACTCTX_SECTION_KEYED_DATA ReturnedData __attribute__((out)));
__stdcall HANDLE FindFirstFileA __attribute__((dllimport)) __attribute__((out))(LPCSTR lpFileName __attribute__((in)), LPWIN32_FIND_DATAA lpFindFileData __attribute__((out)));
__stdcall HANDLE FindFirstFileW __attribute__((dllimport)) __attribute__((out))(LPCWSTR lpFileName __attribute__((in)), LPWIN32_FIND_DATAW lpFindFileData __attribute__((out)));
__stdcall BOOL FindNextFileA __attribute__((dllimport))(HANDLE hFindFile __attribute__((in)), LPWIN32_FIND_DATAA lpFindFileData __attribute__((out)));
__stdcall BOOL FindNextFileW __attribute__((dllimport))(HANDLE hFindFile __attribute__((in)), LPWIN32_FIND_DATAW lpFindFileData __attribute__((out)));
__stdcall DWORD GetCharacterPlacementA __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCSTR lpString __attribute__((in)), int nCount __attribute__((in)), int nMexExtent __attribute__((in)), LPGCP_RESULTSA lpResults, DWORD dwFlags __attribute__((in)));
__stdcall DWORD GetCharacterPlacementW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpString __attribute__((in)), int nCount __attribute__((in)), int nMexExtent __attribute__((in)), LPGCP_RESULTSW lpResults, DWORD dwFlags __attribute__((in)));
__stdcall BOOL GetClassInfoA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpClassName __attribute__((in)), LPWNDCLASSA lpWndClass __attribute__((out)));
__stdcall BOOL GetClassInfoExA __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCSTR lpszClass __attribute__((in)), LPWNDCLASSEXA lpwcx __attribute__((out)));
__stdcall BOOL GetClassInfoExW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpszClass __attribute__((in)), LPWNDCLASSEXW lpwcx __attribute__((out)));
__stdcall BOOL GetClassInfoW __attribute__((dllimport))(HINSTANCE hInstance __attribute__((in)), LPCWSTR lpClassName __attribute__((in)), LPWNDCLASSW lpWndClass __attribute__((out)));
__stdcall BOOL GetComboBoxInfo __attribute__((dllimport))(HWND hwndCombo __attribute__((in)), PCOMBOBOXINFO pcbi);
__stdcall BOOL GetCommConfig __attribute__((dllimport))(HANDLE hCommDev __attribute__((in)), LPCOMMCONFIG lpCC, LPDWORD lpdwSize);
__stdcall BOOL GetConsoleScreenBufferInfo __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo __attribute__((out)));
__stdcall int GetCurrencyFormatW __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCWSTR lpValue __attribute__((in)), const CURRENCYFMTW *lpFormat __attribute__((in)), LPWSTR lpCurrencyStr, int cchCurrency __attribute__((in)));
__stdcall BOOL GetCurrentConsoleFont __attribute__((dllimport))(HANDLE hConsoleOutput __attribute__((in)), BOOL bMaximumWindow __attribute__((in)), PCONSOLE_FONT_INFO lpConsoleCurrentFont __attribute__((out)));
__stdcall BOOL GetCursorInfo __attribute__((dllimport))(PCURSORINFO pci);
__stdcall int GetDIBits __attribute__((dllimport))(HDC hdc __attribute__((in)), HBITMAP hbm __attribute__((in)), UINT start __attribute__((in)), UINT cLines __attribute__((in)), LPVOID lpvBits __attribute__((out)), LPBITMAPINFO lpbmi, UINT usage __attribute__((in)));
__stdcall BOOL GetDefaultCommConfigA __attribute__((dllimport))(LPCSTR lpszName __attribute__((in)), LPCOMMCONFIG lpCC, LPDWORD lpdwSize);
__stdcall BOOL GetDefaultCommConfigW __attribute__((dllimport))(LPCWSTR lpszName __attribute__((in)), LPCOMMCONFIG lpCC, LPDWORD lpdwSize);
__stdcall BOOL GetFileInformationByHandle __attribute__((dllimport))(HANDLE hFile __attribute__((in)), LPBY_HANDLE_FILE_INFORMATION lpFileInformation __attribute__((out)));
__stdcall BOOL GetGUIThreadInfo __attribute__((dllimport))(DWORD idThread __attribute__((in)), PGUITHREADINFO pgui);
__stdcall DWORD GetGlyphOutlineA __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT uChar __attribute__((in)), UINT fuFormat __attribute__((in)), LPGLYPHMETRICS lpgm __attribute__((out)), DWORD cjBuffer __attribute__((in)), LPVOID pvBuffer, const MAT2 *lpmat2 __attribute__((in)));
__stdcall DWORD GetGlyphOutlineW __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT uChar __attribute__((in)), UINT fuFormat __attribute__((in)), LPGLYPHMETRICS lpgm __attribute__((out)), DWORD cjBuffer __attribute__((in)), LPVOID pvBuffer, const MAT2 *lpmat2 __attribute__((in)));
__stdcall BOOL GetIconInfo __attribute__((dllimport))(HICON hIcon __attribute__((in)), PICONINFO piconinfo __attribute__((out)));
__stdcall BOOL GetMenuBarInfo __attribute__((dllimport))(HWND hwnd __attribute__((in)), LONG idObject __attribute__((in)), LONG idItem __attribute__((in)), PMENUBARINFO pmbi);
__stdcall BOOL GetMenuItemInfoW __attribute__((dllimport))(HMENU hmenu __attribute__((in)), UINT item __attribute__((in)), BOOL fByPosition __attribute__((in)), LPMENUITEMINFOW lpmii);
__stdcall BOOL GetMessageA __attribute__((dllimport))(LPMSG lpMsg __attribute__((out)), HWND hWnd __attribute__((in)), UINT wMsgFilterMin __attribute__((in)), UINT wMsgFilterMax __attribute__((in)));
__stdcall BOOL GetMessageW __attribute__((dllimport))(LPMSG lpMsg __attribute__((out)), HWND hWnd __attribute__((in)), UINT wMsgFilterMin __attribute__((in)), UINT wMsgFilterMax __attribute__((in)));
__stdcall BOOL GetMonitorInfoA __attribute__((dllimport))(HMONITOR hMonitor __attribute__((in)), LPMONITORINFO lpmi);
__stdcall BOOL GetMonitorInfoW __attribute__((dllimport))(HMONITOR hMonitor __attribute__((in)), LPMONITORINFO lpmi);
__stdcall int GetNumberFormatW __attribute__((dllimport))(LCID Locale __attribute__((in)), DWORD dwFlags __attribute__((in)), LPCWSTR lpValue __attribute__((in)), const NUMBERFMTW *lpFormat __attribute__((in)), LPWSTR lpNumberStr, int cchNumber __attribute__((in)));
__stdcall UINT GetOutlineTextMetricsA __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT cjCopy __attribute__((in)), LPOUTLINETEXTMETRICA potm);
__stdcall BOOL GetScrollBarInfo __attribute__((dllimport))(HWND hwnd __attribute__((in)), LONG idObject __attribute__((in)), PSCROLLBARINFO psbi);
__stdcall void GetStartupInfoW __attribute__((dllimport))(LPSTARTUPINFOW lpStartupInfo __attribute__((out)));
__stdcall DWORD GetTimeZoneInformation __attribute__((dllimport))(LPTIME_ZONE_INFORMATION lpTimeZoneInformation __attribute__((out)));
__stdcall BOOL GetTitleBarInfo __attribute__((dllimport))(HWND hwnd __attribute__((in)), PTITLEBARINFO pti);
__stdcall BOOL GetWindowInfo __attribute__((dllimport))(HWND hwnd __attribute__((in)), PWINDOWINFO pwi);
__stdcall BOOL GetWindowPlacement __attribute__((dllimport))(HWND hWnd __attribute__((in)), WINDOWPLACEMENT *lpwndpl);
__stdcall BOOL ImmGetCompositionWindow(HIMC __attribute__((in)), LPCOMPOSITIONFORM lpCompForm __attribute__((out)));
__stdcall BOOL ImmSetCompositionWindow(HIMC __attribute__((in)), LPCOMPOSITIONFORM lpCompForm __attribute__((in)));
__stdcall BOOL InsertMenuItemA __attribute__((dllimport))(HMENU hmenu __attribute__((in)), UINT item __attribute__((in)), BOOL fByPosition __attribute__((in)), LPCMENUITEMINFOA lpmi __attribute__((in)));
__stdcall BOOL IsDialogMessageA __attribute__((dllimport))(HWND hDlg __attribute__((in)), LPMSG lpMsg __attribute__((in)));
__stdcall BOOL IsDialogMessageW __attribute__((dllimport))(HWND hDlg __attribute__((in)), LPMSG lpMsg __attribute__((in)));
typedef const MENUITEMINFOW *LPCMENUITEMINFOW;
typedef struct tagENHMETAHEADER *LPENHMETAHEADER;
typedef struct _OUTLINETEXTMETRICW *LPOUTLINETEXTMETRICW;
typedef TPMPARAMS *LPTPMPARAMS;
__stdcall BOOL LogonUserExW __attribute__((dllimport))(LPCWSTR lpszUsername __attribute__((in)), LPCWSTR lpszDomain __attribute__((in)), LPCWSTR lpszPassword __attribute__((in)), DWORD dwLogonType __attribute__((in)), DWORD dwLogonProvider __attribute__((in)), PHANDLE phToken, PSID *ppLogonSid, PVOID *ppProfileBuffer, LPDWORD pdwProfileLength __attribute__((out)), PQUOTA_LIMITS pQuotaLimits __attribute__((out)));
typedef __stdcall void (*MSGBOXCALLBACK)(LPHELPINFO lpHelpInfo);
__stdcall void MapGenericMask __attribute__((dllimport))(PDWORD AccessMask, PGENERIC_MAPPING GenericMapping __attribute__((in)));
__stdcall NTSTATUS NtDeviceIoControlFile(HANDLE FileHandle __attribute__((in)), HANDLE Event __attribute__((in)), PIO_APC_ROUTINE ApcRoutine __attribute__((in)), PVOID ApcContext __attribute__((in)), PIO_STATUS_BLOCK IoStatusBlock __attribute__((out)), ULONG IoControlCode __attribute__((in)), PVOID InputBuffer __attribute__((in)), ULONG InputBufferLength __attribute__((in)), PVOID OutputBuffer __attribute__((out)), ULONG OutputBufferLength __attribute__((in)));
typedef PSTRING PANSI_STRING;
typedef const ACTCTXW *PCACTCTXW;
typedef PSTRING PCANSI_STRING;
typedef CONTEXT *PCONTEXT;
typedef const UNICODE_STRING *PCUNICODE_STRING;
typedef PSTRING POEM_STRING;
typedef struct _RTL_CRITICAL_SECTION *PRTL_CRITICAL_SECTION;
typedef UNICODE_STRING *PUNICODE_STRING;
__stdcall BOOL PeekMessageA __attribute__((dllimport))(LPMSG lpMsg __attribute__((out)), HWND hWnd __attribute__((in)), UINT wMsgFilterMin __attribute__((in)), UINT wMsgFilterMax __attribute__((in)), UINT wRemoveMsg __attribute__((in)));
__stdcall BOOL PeekMessageW __attribute__((dllimport))(LPMSG lpMsg __attribute__((out)), HWND hWnd __attribute__((in)), UINT wMsgFilterMin __attribute__((in)), UINT wMsgFilterMax __attribute__((in)), UINT wRemoveMsg __attribute__((in)));
__stdcall BOOL PolyTextOutA __attribute__((dllimport))(HDC hdc __attribute__((in)), const POLYTEXTA *ppt __attribute__((in)), int nstrings __attribute__((in)));
__stdcall BOOL QueryServiceConfigW __attribute__((dllimport))(SC_HANDLE hService __attribute__((in)), LPQUERY_SERVICE_CONFIGW lpServiceConfig, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
__stdcall BOOL QueryServiceLockStatusW __attribute__((dllimport))(SC_HANDLE hSCManager __attribute__((in)), LPQUERY_SERVICE_LOCK_STATUSW lpLockStatus, DWORD cbBufSize __attribute__((in)), LPDWORD pcbBytesNeeded __attribute__((out)));
__stdcall ATOM RegisterClassA __attribute__((dllimport))(const WNDCLASSA *lpWndClass __attribute__((in)));
__stdcall ATOM RegisterClassExA __attribute__((dllimport))(const WNDCLASSEXA* __attribute__((in)));
__stdcall ATOM RegisterClassExW __attribute__((dllimport))(const WNDCLASSEXW* __attribute__((in)));
__stdcall ATOM RegisterClassW __attribute__((dllimport))(const WNDCLASSW *lpWndClass __attribute__((in)));
__stdcall BOOL RegisterRawInputDevices __attribute__((dllimport))(PCRAWINPUTDEVICE pRawInputDevices __attribute__((in)), UINT uiNumDevices __attribute__((in)), UINT cbSize __attribute__((in)));
__stdcall HDC ResetDCA __attribute__((dllimport))(HDC hdc __attribute__((in)), const DEVMODEA *lpdm __attribute__((in)));
__stdcall HDC ResetDCW __attribute__((dllimport))(HDC hdc __attribute__((in)), const DEVMODEW *lpdm __attribute__((in)));
__stdcall void RtlInitString(PSTRING DestinationString, PCSZ SourceString);
typedef struct _SERVICE_TABLE_ENTRYW SERVICE_TABLE_ENTRYW;
__stdcall UINT SendInput __attribute__((dllimport))(UINT cInputs __attribute__((in)), LPINPUT pInputs __attribute__((in)), int cbSize __attribute__((in)));
__stdcall BOOL SetCommConfig __attribute__((dllimport))(HANDLE hCommDev __attribute__((in)), LPCOMMCONFIG lpCC __attribute__((in)), DWORD dwSize __attribute__((in)));
__stdcall int SetDIBits __attribute__((dllimport))(HDC hdc __attribute__((in)), HBITMAP hbm __attribute__((in)), UINT start __attribute__((in)), UINT cLines __attribute__((in)), const void *lpBits __attribute__((in)), const BITMAPINFO *lpbmi __attribute__((in)), UINT ColorUse __attribute__((in)));
__stdcall int SetDIBitsToDevice __attribute__((dllimport))(HDC hdc __attribute__((in)), int xDest __attribute__((in)), int yDest __attribute__((in)), DWORD w __attribute__((in)), DWORD h __attribute__((in)), int xSrc __attribute__((in)), int ySrc __attribute__((in)), UINT StartScan __attribute__((in)), UINT cLines __attribute__((in)), const void *lpvBits __attribute__((in)), const BITMAPINFO *lpbmi __attribute__((in)), UINT ColorUse __attribute__((in)));
__stdcall BOOL SetDefaultCommConfigA __attribute__((dllimport))(LPCSTR lpszName __attribute__((in)), LPCOMMCONFIG lpCC __attribute__((in)), DWORD dwSize __attribute__((in)));
__stdcall BOOL SetDefaultCommConfigW __attribute__((dllimport))(LPCWSTR lpszName __attribute__((in)), LPCOMMCONFIG lpCC __attribute__((in)), DWORD dwSize __attribute__((in)));
__stdcall BOOL SetMenuInfo __attribute__((dllimport))(HMENU __attribute__((in)), LPCMENUINFO __attribute__((in)));
__stdcall BOOL SetMenuItemInfoA __attribute__((dllimport))(HMENU hmenu __attribute__((in)), UINT item __attribute__((in)), BOOL fByPositon __attribute__((in)), LPCMENUITEMINFOA lpmii __attribute__((in)));
__stdcall BOOL SetPrivateObjectSecurity __attribute__((dllimport))(SECURITY_INFORMATION SecurityInformation __attribute__((in)), PSECURITY_DESCRIPTOR ModificationDescriptor __attribute__((in)), PSECURITY_DESCRIPTOR *ObjectsSecurityDescriptor, PGENERIC_MAPPING GenericMapping __attribute__((in)), HANDLE Token __attribute__((in)));
__stdcall BOOL SetThreadContext __attribute__((dllimport))(HANDLE hThread __attribute__((in)), const CONTEXT *lpContext __attribute__((in)));
__stdcall BOOL SetTimeZoneInformation __attribute__((dllimport))(const TIME_ZONE_INFORMATION *lpTimeZoneInformation __attribute__((in)));
__stdcall BOOL SetWindowPlacement __attribute__((dllimport))(HWND hWnd __attribute__((in)), const WINDOWPLACEMENT *lpwndpl __attribute__((in)));
__stdcall int StartDocW __attribute__((dllimport))(HDC hdc __attribute__((in)), const DOCINFOW *lpdi __attribute__((in)));
__stdcall BOOL StartServiceCtrlDispatcherA __attribute__((dllimport))(const SERVICE_TABLE_ENTRYA *lpServiceStartTable __attribute__((in)));
__stdcall int StretchDIBits __attribute__((dllimport))(HDC hdc __attribute__((in)), int xDest __attribute__((in)), int yDest __attribute__((in)), int DestWidth __attribute__((in)), int DestHeight __attribute__((in)), int xSrc __attribute__((in)), int ySrc __attribute__((in)), int SrcWidth __attribute__((in)), int SrcHeight __attribute__((in)), const void *lpBits __attribute__((in)), const BITMAPINFO *lpbmi __attribute__((in)), UINT iUsage __attribute__((in)), DWORD rop __attribute__((in)));
__stdcall BOOL SystemTimeToTzSpecificLocalTime __attribute__((dllimport))(const TIME_ZONE_INFORMATION *lpTimeZoneInformation __attribute__((in)), const SYSTEMTIME *lpUniversalTime __attribute__((in)), LPSYSTEMTIME lpLocalTime __attribute__((out)));
__stdcall int TranslateAcceleratorA __attribute__((dllimport))(HWND hWnd __attribute__((in)), HACCEL hAccTable __attribute__((in)), LPMSG lpMsg __attribute__((in)));
__stdcall int TranslateAcceleratorW __attribute__((dllimport))(HWND hWnd __attribute__((in)), HACCEL hAccTable __attribute__((in)), LPMSG lpMsg __attribute__((in)));
__stdcall BOOL TranslateCharsetInfo __attribute__((dllimport))(DWORD *lpSrc, LPCHARSETINFO lpCs __attribute__((out)), DWORD dwFlags __attribute__((in)));
__stdcall BOOL TranslateMDISysAccel __attribute__((dllimport))(HWND hWndClient __attribute__((in)), LPMSG lpMsg __attribute__((in)));
__stdcall BOOL TranslateMessage __attribute__((dllimport))(const MSG *lpMsg __attribute__((in)));
__stdcall BOOL TzSpecificLocalTimeToSystemTime __attribute__((dllimport))(const TIME_ZONE_INFORMATION *lpTimeZoneInformation __attribute__((in)), const SYSTEMTIME *lpLocalTime __attribute__((in)), LPSYSTEMTIME lpUniversalTime __attribute__((out)));
__stdcall DWORD WNetAddConnection2W(LPNETRESOURCEW lpNetResource __attribute__((in)), LPCWSTR lpPassword __attribute__((in)), LPCWSTR lpUserName __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall DWORD WNetAddConnection3W(HWND hwndOwner __attribute__((in)), LPNETRESOURCEW lpNetResource __attribute__((in)), LPCWSTR lpPassword __attribute__((in)), LPCWSTR lpUserName __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall DWORD WNetGetResourceInformationW(LPNETRESOURCEW lpNetResource __attribute__((in)), LPVOID lpBuffer, LPDWORD lpcbBuffer, LPWSTR *lplpSystem);
__stdcall DWORD WNetOpenEnumW(DWORD dwScope __attribute__((in)), DWORD dwType __attribute__((in)), DWORD dwUsage __attribute__((in)), LPNETRESOURCEW lpNetResource __attribute__((in)), LPHANDLE lphEnum __attribute__((out)));
__stdcall DWORD WNetUseConnectionW(HWND hwndOwner __attribute__((in)), LPNETRESOURCEW lpNetResource __attribute__((in)), LPCWSTR lpPassword __attribute__((in)), LPCWSTR lpUserId __attribute__((in)), DWORD dwFlags __attribute__((in)), LPWSTR lpAccessName, LPDWORD lpBufferSize, LPDWORD lpResult __attribute__((out)));

struct _CONNECTDLGSTRUCTW {
	DWORD cbStructure;
	HWND hwndOwner;
	LPNETRESOURCEW lpConnRes;
	DWORD dwFlags;
	DWORD dwDevNum;
};

struct _DEBUG_EVENT {
	DWORD dwDebugEventCode;
	DWORD dwProcessId;
	DWORD dwThreadId;

	union {
		EXCEPTION_DEBUG_INFO Exception;
		CREATE_THREAD_DEBUG_INFO CreateThread;
		CREATE_PROCESS_DEBUG_INFO CreateProcessInfo;
		EXIT_THREAD_DEBUG_INFO ExitThread;
		EXIT_PROCESS_DEBUG_INFO ExitProcess;
		LOAD_DLL_DEBUG_INFO LoadDll;
		UNLOAD_DLL_DEBUG_INFO UnloadDll;
		OUTPUT_DEBUG_STRING_INFO DebugString;
		RIP_INFO RipInfo;
	} u;
};

struct _INPUT_RECORD {
	WORD EventType;

	union {
		KEY_EVENT_RECORD KeyEvent;
		MOUSE_EVENT_RECORD MouseEvent;
		WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
		MENU_EVENT_RECORD MenuEvent;
		FOCUS_EVENT_RECORD FocusEvent;
	} Event;
};

struct _PRIVILEGE_SET {
	DWORD PrivilegeCount;
	DWORD Control;
	LUID_AND_ATTRIBUTES Privilege[1];
};

struct _RGNDATA {
	RGNDATAHEADER rdh;
	char Buffer[1];
};

struct _TOKEN_PRIVILEGES {
	DWORD PrivilegeCount;
	LUID_AND_ATTRIBUTES Privileges[1];
};

struct tagLOGCOLORSPACEA {
	DWORD lcsSignature;
	DWORD lcsVersion;
	DWORD lcsSize;
	LCSCSTYPE lcsCSType;
	LCSGAMUTMATCH lcsIntent;
	CIEXYZTRIPLE lcsEndpoints;
	DWORD lcsGammaRed;
	DWORD lcsGammaGreen;
	DWORD lcsGammaBlue;
	CHAR lcsFilename[260];
};

struct tagLOGCOLORSPACEW {
	DWORD lcsSignature;
	DWORD lcsVersion;
	DWORD lcsSize;
	LCSCSTYPE lcsCSType;
	LCSGAMUTMATCH lcsIntent;
	CIEXYZTRIPLE lcsEndpoints;
	DWORD lcsGammaRed;
	DWORD lcsGammaGreen;
	DWORD lcsGammaBlue;
	WCHAR lcsFilename[260];
};


__stdcall HANDLE CreateActCtxW __attribute__((dllimport)) __attribute__((out))(PCACTCTXW pActCtx __attribute__((in)));
__stdcall int EnumFontFamiliesExW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPLOGFONTW lpLogfont __attribute__((in)), FONTENUMPROCW lpProc __attribute__((in)), LPARAM lParam __attribute__((in)), DWORD dwFlags __attribute__((in)));
__stdcall int EnumFontFamiliesW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpLogfont __attribute__((in)), FONTENUMPROCW lpProc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall int EnumFontsW __attribute__((dllimport))(HDC hdc __attribute__((in)), LPCWSTR lpLogfont __attribute__((in)), FONTENUMPROCW lpProc __attribute__((in)), LPARAM lParam __attribute__((in)));
__stdcall UINT GetEnhMetaFileHeader __attribute__((dllimport))(HENHMETAFILE hemf __attribute__((in)), UINT nSize __attribute__((in)), LPENHMETAHEADER lpEnhMetaHeader);
__stdcall UINT GetOutlineTextMetricsW __attribute__((dllimport))(HDC hdc __attribute__((in)), UINT cjCopy __attribute__((in)), LPOUTLINETEXTMETRICW potm);
typedef struct _INPUT_RECORD INPUT_RECORD;
__stdcall BOOL InsertMenuItemW __attribute__((dllimport))(HMENU hmenu __attribute__((in)), UINT item __attribute__((in)), BOOL fByPosition __attribute__((in)), LPCMENUITEMINFOW lpmi __attribute__((in)));
typedef struct _CONNECTDLGSTRUCTW *LPCONNECTDLGSTRUCTW;
typedef PCONTEXT LPCONTEXT;
typedef PRTL_CRITICAL_SECTION LPCRITICAL_SECTION;
typedef struct _DEBUG_EVENT *LPDEBUG_EVENT;
typedef struct tagLOGCOLORSPACEA *LPLOGCOLORSPACEA;
typedef struct tagLOGCOLORSPACEW *LPLOGCOLORSPACEW;
typedef struct _RGNDATA *LPRGNDATA;
typedef struct _INPUT_RECORD *PINPUT_RECORD;
typedef struct _PRIVILEGE_SET *PPRIVILEGE_SET;
typedef struct _TOKEN_PRIVILEGES *PTOKEN_PRIVILEGES;
typedef struct _RGNDATA RGNDATA;
__stdcall NTSTATUS RtlAnsiStringToUnicodeString(PUNICODE_STRING DestinationString, PCANSI_STRING SourceString, BOOLEAN AllocateDestinationString);
__stdcall void RtlCaptureContext __attribute__((dllimport))(PCONTEXT ContextRecord __attribute__((out)));
__stdcall NTSTATUS RtlConvertSidToUnicodeString(PUNICODE_STRING UnicodeString, PSID Sid, BOOLEAN AllocateDestinationString);
__stdcall void RtlFreeAnsiString(PANSI_STRING AnsiString);
__stdcall void RtlFreeOemString(POEM_STRING OemString);
__stdcall void RtlFreeUnicodeString(PUNICODE_STRING UnicodeString);
__stdcall void RtlInitAnsiString(PANSI_STRING DestinationString, PCSZ SourceString);
__stdcall void RtlInitUnicodeString(PUNICODE_STRING DestinationString, PCWSTR SourceString);
__stdcall BOOLEAN RtlIsNameLegalDOS8Dot3(PUNICODE_STRING Name __attribute__((in)), POEM_STRING OemName __attribute__((in)) __attribute__((out)), PBOOLEAN NameContainsSpaces __attribute__((in)) __attribute__((out)));
__stdcall NTSTATUS RtlUnicodeStringToAnsiString(PANSI_STRING DestinationString, PCUNICODE_STRING SourceString, BOOLEAN AllocateDestinationString);
__stdcall NTSTATUS RtlUnicodeStringToOemString(POEM_STRING DestinationString, PCUNICODE_STRING SourceString, BOOLEAN AllocateDestinationString);
__stdcall BOOL SetMenuItemInfoW __attribute__((dllimport))(HMENU hmenu __attribute__((in)), UINT item __attribute__((in)), BOOL fByPositon __attribute__((in)), LPCMENUITEMINFOW lpmii __attribute__((in)));
__stdcall BOOL StartServiceCtrlDispatcherW __attribute__((dllimport))(const SERVICE_TABLE_ENTRYW *lpServiceStartTable __attribute__((in)));
__stdcall BOOL TrackPopupMenuEx __attribute__((dllimport))(HMENU __attribute__((in)), UINT __attribute__((in)), int __attribute__((in)), int __attribute__((in)), HWND __attribute__((in)), LPTPMPARAMS __attribute__((in)));

struct _EXCEPTION_POINTERS {
	PEXCEPTION_RECORD ExceptionRecord;
	PCONTEXT ContextRecord;
};

struct _OBJECT_ATTRIBUTES {
	ULONG Length;
	HANDLE RootDirectory;
	PUNICODE_STRING ObjectName;
	ULONG Attributes;
	PVOID SecurityDescriptor;
	PVOID SecurityQualityOfService;
};

struct tagMSGBOXPARAMSA {
	UINT cbSize;
	HWND hwndOwner;
	HINSTANCE hInstance;
	LPCSTR lpszText;
	LPCSTR lpszCaption;
	DWORD dwStyle;
	LPCSTR lpszIcon;
	DWORD_PTR dwContextHelpId;
	MSGBOXCALLBACK lpfnMsgBoxCallback;
	DWORD dwLanguageId;
};

struct tagMSGBOXPARAMSW {
	UINT cbSize;
	HWND hwndOwner;
	HINSTANCE hInstance;
	LPCWSTR lpszText;
	LPCWSTR lpszCaption;
	DWORD dwStyle;
	LPCWSTR lpszIcon;
	DWORD_PTR dwContextHelpId;
	MSGBOXCALLBACK lpfnMsgBoxCallback;
	DWORD dwLanguageId;
};


__stdcall BOOL AccessCheck __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), HANDLE ClientToken __attribute__((in)), DWORD DesiredAccess __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)), PPRIVILEGE_SET PrivilegeSet, LPDWORD PrivilegeSetLength, LPDWORD GrantedAccess __attribute__((out)), LPBOOL AccessStatus __attribute__((out)));
__stdcall BOOL AccessCheckByType __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), PSID PrincipalSelfSid __attribute__((in)), HANDLE ClientToken __attribute__((in)), DWORD DesiredAccess __attribute__((in)), POBJECT_TYPE_LIST ObjectTypeList, DWORD ObjectTypeListLength __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)), PPRIVILEGE_SET PrivilegeSet, LPDWORD PrivilegeSetLength, LPDWORD GrantedAccess __attribute__((out)), LPBOOL AccessStatus __attribute__((out)));
__stdcall BOOL AccessCheckByTypeResultList __attribute__((dllimport))(PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), PSID PrincipalSelfSid __attribute__((in)), HANDLE ClientToken __attribute__((in)), DWORD DesiredAccess __attribute__((in)), POBJECT_TYPE_LIST ObjectTypeList, DWORD ObjectTypeListLength __attribute__((in)), PGENERIC_MAPPING GenericMapping __attribute__((in)), PPRIVILEGE_SET PrivilegeSet, LPDWORD PrivilegeSetLength, LPDWORD GrantedAccessList __attribute__((out)), LPDWORD AccessStatusList __attribute__((out)));
__stdcall BOOL AdjustTokenPrivileges __attribute__((dllimport))(HANDLE TokenHandle __attribute__((in)), BOOL DisableAllPrivileges __attribute__((in)), PTOKEN_PRIVILEGES NewState __attribute__((in)), DWORD BufferLength __attribute__((in)), PTOKEN_PRIVILEGES PreviousState, PDWORD ReturnLength __attribute__((out)));
__stdcall HCOLORSPACE CreateColorSpaceA __attribute__((dllimport))(LPLOGCOLORSPACEA lplcs __attribute__((in)));
__stdcall HCOLORSPACE CreateColorSpaceW __attribute__((dllimport))(LPLOGCOLORSPACEW lplcs __attribute__((in)));
__stdcall void DeleteCriticalSection __attribute__((dllimport))(LPCRITICAL_SECTION lpCriticalSection);
__stdcall void EnterCriticalSection __attribute__((dllimport))(LPCRITICAL_SECTION lpCriticalSection);
__stdcall HRGN ExtCreateRegion __attribute__((dllimport))(const XFORM *lpx __attribute__((in)), DWORD nCount __attribute__((in)), const RGNDATA *lpData __attribute__((in)));
__stdcall BOOL GetLogColorSpaceA __attribute__((dllimport))(HCOLORSPACE hColorSpace __attribute__((in)), LPLOGCOLORSPACEA lpBuffer, DWORD nSize __attribute__((in)));
__stdcall DWORD GetRegionData __attribute__((dllimport))(HRGN hrgn __attribute__((in)), DWORD nCount __attribute__((in)), LPRGNDATA lpRgnData);
__stdcall BOOL GetThreadContext __attribute__((dllimport))(HANDLE hThread __attribute__((in)), LPCONTEXT lpContext);
__stdcall void InitializeCriticalSection __attribute__((dllimport))(LPCRITICAL_SECTION lpCriticalSection __attribute__((out)));
__stdcall BOOL InitializeCriticalSectionAndSpinCount __attribute__((dllimport))(LPCRITICAL_SECTION lpCriticalSection __attribute__((out)), DWORD dwSpinCount __attribute__((in)));
__stdcall void LeaveCriticalSection __attribute__((dllimport))(LPCRITICAL_SECTION lpCriticalSection);
typedef struct tagMSGBOXPARAMSA MSGBOXPARAMSA;
typedef struct tagMSGBOXPARAMSW MSGBOXPARAMSW;
typedef struct _OBJECT_ATTRIBUTES OBJECT_ATTRIBUTES;
__stdcall BOOL ObjectOpenAuditAlarmA __attribute__((dllimport))(LPCSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), LPSTR ObjectTypeName __attribute__((in)), LPSTR ObjectName __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), HANDLE ClientToken __attribute__((in)), DWORD DesiredAccess __attribute__((in)), DWORD GrantedAccess __attribute__((in)), PPRIVILEGE_SET Privileges __attribute__((in)), BOOL ObjectCreation __attribute__((in)), BOOL AccessGranted __attribute__((in)), LPBOOL GenerateOnClose __attribute__((out)));
__stdcall BOOL ObjectOpenAuditAlarmW __attribute__((dllimport))(LPCWSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), LPWSTR ObjectTypeName __attribute__((in)), LPWSTR ObjectName __attribute__((in)), PSECURITY_DESCRIPTOR pSecurityDescriptor __attribute__((in)), HANDLE ClientToken __attribute__((in)), DWORD DesiredAccess __attribute__((in)), DWORD GrantedAccess __attribute__((in)), PPRIVILEGE_SET Privileges __attribute__((in)), BOOL ObjectCreation __attribute__((in)), BOOL AccessGranted __attribute__((in)), LPBOOL GenerateOnClose __attribute__((out)));
__stdcall BOOL ObjectPrivilegeAuditAlarmA __attribute__((dllimport))(LPCSTR SubsystemName __attribute__((in)), LPVOID HandleId __attribute__((in)), HANDLE ClientToken __attribute__((in)), DWORD DesiredAccess __attribute__((in)), PPRIVILEGE_SET Privileges __attribute__((in)), BOOL AccessGranted __attribute__((in)));
typedef __stdcall LONG (*PTOP_LEVEL_EXCEPTION_FILTER)(struct _EXCEPTION_POINTERS *ExceptionInfo __attribute__((in)));
__stdcall BOOL PeekConsoleInputA __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), PINPUT_RECORD lpBuffer, DWORD nLength __attribute__((in)), LPDWORD lpNumberOfEventsRead __attribute__((out)));
__stdcall BOOL PeekConsoleInputW __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), PINPUT_RECORD lpBuffer, DWORD nLength __attribute__((in)), LPDWORD lpNumberOfEventsRead __attribute__((out)));
__stdcall BOOL PrivilegeCheck __attribute__((dllimport))(HANDLE ClientToken __attribute__((in)), PPRIVILEGE_SET RequiredPrivileges, LPBOOL pfResult __attribute__((out)));
__stdcall BOOL PrivilegedServiceAuditAlarmA __attribute__((dllimport))(LPCSTR SubsystemName __attribute__((in)), LPCSTR ServiceName __attribute__((in)), HANDLE ClientToken __attribute__((in)), PPRIVILEGE_SET Privileges __attribute__((in)), BOOL AccessGranted __attribute__((in)));
__stdcall BOOL ReadConsoleInputA __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), PINPUT_RECORD lpBuffer, DWORD nLength __attribute__((in)), LPDWORD lpNumberOfEventsRead __attribute__((out)));
__stdcall BOOL ReadConsoleInputW __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), PINPUT_RECORD lpBuffer, DWORD nLength __attribute__((in)), LPDWORD lpNumberOfEventsRead __attribute__((out)));
__stdcall DWORD SetCriticalSectionSpinCount __attribute__((dllimport))(LPCRITICAL_SECTION lpCriticalSection, DWORD dwSpinCount __attribute__((in)));
__stdcall BOOL TryEnterCriticalSection __attribute__((dllimport))(LPCRITICAL_SECTION lpCriticalSection);
__stdcall LONG UnhandledExceptionFilter __attribute__((dllimport))(struct _EXCEPTION_POINTERS *ExceptionInfo __attribute__((in)));
__stdcall DWORD WNetConnectionDialog1W(LPCONNECTDLGSTRUCTW lpConnDlgStruct);
__stdcall BOOL WaitForDebugEvent __attribute__((dllimport))(LPDEBUG_EVENT lpDebugEvent __attribute__((in)), DWORD dwMilliseconds __attribute__((in)));
__stdcall BOOL WriteConsoleInputA __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), const INPUT_RECORD *lpBuffer __attribute__((in)), DWORD nLength __attribute__((in)), LPDWORD lpNumberOfEventsWritten __attribute__((out)));
__stdcall BOOL WriteConsoleInputW __attribute__((dllimport))(HANDLE hConsoleInput __attribute__((in)), const INPUT_RECORD *lpBuffer __attribute__((in)), DWORD nLength __attribute__((in)), LPDWORD lpNumberOfEventsWritten __attribute__((out)));


typedef PTOP_LEVEL_EXCEPTION_FILTER LPTOP_LEVEL_EXCEPTION_FILTER;
__stdcall int MessageBoxIndirectA __attribute__((dllimport))(const MSGBOXPARAMSA *lpmbp __attribute__((in)));
__stdcall int MessageBoxIndirectW __attribute__((dllimport))(const MSGBOXPARAMSW *lpmbp __attribute__((in)));
typedef OBJECT_ATTRIBUTES *POBJECT_ATTRIBUTES;


__stdcall NTSTATUS NtCreateFile(PHANDLE FileHandle __attribute__((out)), ACCESS_MASK DesiredAccess __attribute__((in)), POBJECT_ATTRIBUTES ObjectAttributes __attribute__((in)), PIO_STATUS_BLOCK IoStatusBlock __attribute__((out)), PLARGE_INTEGER AllocationSize __attribute__((in)), ULONG FileAttributes __attribute__((in)), ULONG ShareAccess __attribute__((in)), ULONG CreateDisposition __attribute__((in)), ULONG CreateOptions __attribute__((in)), PVOID EaBuffer __attribute__((in)), ULONG EaLength __attribute__((in)));
__stdcall NTSTATUS NtOpenFile(PHANDLE FileHandle __attribute__((out)), ACCESS_MASK DesiredAccess __attribute__((in)), POBJECT_ATTRIBUTES ObjectAttributes __attribute__((in)), PIO_STATUS_BLOCK IoStatusBlock __attribute__((out)), ULONG ShareAccess __attribute__((in)), ULONG OpenOptions __attribute__((in)));
__stdcall LPTOP_LEVEL_EXCEPTION_FILTER SetUnhandledExceptionFilter __attribute__((dllimport))(LPTOP_LEVEL_EXCEPTION_FILTER lpTopLevelExceptionFilter __attribute__((in)));

