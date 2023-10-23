#define NULL 0
struct _RTL_CRITICAL_SECTION;
typedef int BOOL;
typedef unsigned char BYTE;
typedef char CHAR;
typedef unsigned long DWORD;
typedef __stdcall int (*FARPROC)();
typedef float FLOAT;
typedef long FXPT2DOT30;

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
typedef const char *PCSZ;
typedef unsigned int *PUINT;
typedef unsigned long *PULONG_PTR;
typedef void *PVOID;

struct SC_HANDLE__ {
	int unused;
};

struct SERVICE_STATUS_HANDLE__ {
	int unused;
};
typedef short SHORT;
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
typedef BYTE BOOLEAN;
typedef DWORD CALID;
typedef DWORD CALTYPE;
typedef USHORT COLOR16;
typedef DWORD COLORREF;
typedef enum _COMPUTER_NAME_FORMAT COMPUTER_NAME_FORMAT;
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
typedef DWORD EXECUTION_STATE;
typedef enum _FINDEX_INFO_LEVELS FINDEX_INFO_LEVELS;
typedef enum _FINDEX_SEARCH_OPS FINDEX_SEARCH_OPS;
typedef DWORD GEOCLASS;
typedef LONG GEOID;
typedef DWORD GEOTYPE;
typedef enum _GET_FILEEX_INFO_LEVELS GET_FILEEX_INFO_LEVELS;
typedef struct _GUID GUID;
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
__stdcall BOOL ImmDisableIME(DWORD __attribute__((in)));
__stdcall BOOL ImmDisableTextFrameService(DWORD idThread);
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
typedef LONG NTSTATUS;
typedef enum _OBJECT_INFORMATION_CLASS OBJECT_INFORMATION_CLASS;
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
typedef enum _THREADINFOCLASS THREADINFOCLASS;
typedef enum _TOKEN_INFORMATION_CLASS TOKEN_INFORMATION_CLASS;
typedef enum _TOKEN_TYPE TOKEN_TYPE;
typedef wchar_t WCHAR;
__stdcall DWORD WNetCloseEnum(HANDLE hEnum __attribute__((in)));
typedef UINT_PTR WPARAM;

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
__cdecl void *memchr(const void *_Buf, int _Val, size_t _MaxCount);
__cdecl int memcmp(const void *_Buf1, const void *_Buf2, size_t _Size);
__cdecl void *memcpy(void *_Dst, const void *_Src, size_t _Size);
__cdecl void *memmove(void *_Dst, const void *_Src, size_t _Size);
__cdecl void *memset(void *_Dst, int _Val, size_t _Size);
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
typedef struct tagBITMAP BITMAP;
typedef struct tagBITMAPINFOHEADER BITMAPINFOHEADER;
typedef struct _BLENDFUNCTION BLENDFUNCTION;
typedef __stdcall BOOL (*CALINFO_ENUMPROCA)(LPSTR);
typedef struct tagCIEXYZ CIEXYZ;
typedef struct tagCOLORADJUSTMENT COLORADJUSTMENT;
typedef struct _CONSOLE_CURSOR_INFO CONSOLE_CURSOR_INFO;
typedef struct _COORD COORD;
typedef __stdcall BOOL (*DATEFMT_ENUMPROCA)(LPSTR);
typedef struct _DCB DCB;
typedef __stdcall INT_PTR (*DLGPROC)(HWND, UINT, WPARAM, LPARAM);
typedef __stdcall BOOL (*DRAWSTATEPROC)(HDC hdc, LPARAM lData, WPARAM wData, int cx, int cy);
typedef struct tagENHMETARECORD ENHMETARECORD;
typedef struct _EXCEPTION_RECORD EXCEPTION_RECORD;
typedef struct _EXIT_PROCESS_DEBUG_INFO EXIT_PROCESS_DEBUG_INFO;
typedef struct _EXIT_THREAD_DEBUG_INFO EXIT_THREAD_DEBUG_INFO;
typedef struct _FILETIME FILETIME;
typedef struct _FIXED FIXED;
typedef struct _FLOATING_SAVE_AREA FLOATING_SAVE_AREA;
typedef struct _FOCUS_EVENT_RECORD FOCUS_EVENT_RECORD;
typedef struct tagFONTSIGNATURE FONTSIGNATURE;
typedef __stdcall BOOL (*GEO_ENUMPROC)(GEOID);
typedef __stdcall int (*GOBJENUMPROC)(LPVOID, LPARAM);
typedef __stdcall BOOL (*GRAYSTRINGPROC)(HDC, LPARAM, int);
__stdcall BOOL GetFileVersionInfoA(LPCSTR lptstrFilename __attribute__((in)), DWORD dwHandle, DWORD dwLen __attribute__((in)), LPVOID lpData);
__stdcall DWORD GetFileVersionInfoSizeA(LPCSTR lptstrFilename __attribute__((in)), LPDWORD lpdwHandle __attribute__((out)));
typedef struct tagHANDLETABLE HANDLETABLE;
typedef struct tagHARDWAREINPUT HARDWAREINPUT;
typedef HICON HCURSOR;
typedef HINSTANCE HMODULE;
typedef __stdcall LRESULT (*HOOKPROC)(int code, WPARAM wParam, LPARAM lParam);
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
typedef struct tagKEYBDINPUT KEYBDINPUT;
typedef union _LARGE_INTEGER LARGE_INTEGER;
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
typedef struct _MENU_EVENT_RECORD MENU_EVENT_RECORD;
typedef struct tagMETARECORD METARECORD;
typedef struct tagMOUSEINPUT MOUSEINPUT;
typedef __stdcall BOOL (*NAMEENUMPROCA)(LPSTR, LPARAM);
__stdcall NTSTATUS NtClose(HANDLE Handle __attribute__((in)));
__stdcall NTSTATUS NtQueryInformationProcess(HANDLE ProcessHandle __attribute__((in)), PROCESSINFOCLASS ProcessInformationClass __attribute__((in)), PVOID ProcessInformation __attribute__((out)), ULONG ProcessInformationLength __attribute__((in)), PULONG ReturnLength __attribute__((out)));
__stdcall NTSTATUS NtQueryInformationThread(HANDLE ThreadHandle __attribute__((in)), THREADINFOCLASS ThreadInformationClass __attribute__((in)), PVOID ThreadInformation __attribute__((out)), ULONG ThreadInformationLength __attribute__((in)), PULONG ReturnLength __attribute__((out)));
__stdcall NTSTATUS NtQuerySystemInformation(SYSTEM_INFORMATION_CLASS SystemInformationClass __attribute__((in)), PVOID SystemInformation __attribute__((out)), ULONG SystemInformationLength __attribute__((in)), PULONG ReturnLength __attribute__((out)));
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
typedef struct tagRECT RECT;
typedef struct _RECTL RECTL;
typedef ACCESS_MASK REGSAM;
typedef struct tagRGBQUAD RGBQUAD;
typedef struct _RIP_INFO RIP_INFO;
__stdcall NTSTATUS RtlCharToInteger(PCSZ String, ULONG Base, PULONG Value);
__stdcall ULONG RtlNtStatusToDosError(NTSTATUS Status);
__stdcall ULONG RtlUniform(PULONG Seed);
typedef struct tagSCROLLINFO SCROLLINFO;
typedef struct _SECURITY_ATTRIBUTES SECURITY_ATTRIBUTES;
typedef __stdcall void (*SENDASYNCPROC)(HWND, UINT, ULONG_PTR, LRESULT);
typedef struct _SERVICE_STATUS SERVICE_STATUS;
typedef struct tagSIZE SIZE;
typedef struct _SMALL_RECT SMALL_RECT;
typedef struct _SYSTEMTIME SYSTEMTIME;
typedef struct tagTEXTMETRICA TEXTMETRICA;
typedef __stdcall BOOL (*TIMEFMT_ENUMPROCA)(LPSTR);
typedef __stdcall void (*TIMERPROC)(HWND, UINT, UINT_PTR, DWORD);
typedef union _ULARGE_INTEGER ULARGE_INTEGER;
typedef struct _UNLOAD_DLL_DEBUG_INFO UNLOAD_DLL_DEBUG_INFO;
__stdcall DWORD VerLanguageNameA(DWORD wLang __attribute__((in)), LPSTR szLang, DWORD cchLang __attribute__((in)));
__stdcall BOOL VerQueryValueA(LPCVOID pBlock __attribute__((in)), LPCSTR lpSubBlock __attribute__((in)), LPVOID *lplpBuffer, PUINT puLen __attribute__((out)));
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

struct _numberfmtA {
	UINT NumDigits;
	UINT LeadingZero;
	UINT Grouping;
	LPSTR lpDecimalSep;
	LPSTR lpThousandSep;
	UINT NegativeOrder;
};

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


typedef __stdcall BOOL (*CALINFO_ENUMPROCW)(LPWSTR);
typedef struct _CHAR_INFO CHAR_INFO;
typedef __stdcall BOOL (*CODEPAGE_ENUMPROCW)(LPWSTR);
typedef struct _currencyfmtA CURRENCYFMTA;
typedef __stdcall BOOL (*DATEFMT_ENUMPROCW)(LPWSTR);
typedef NAMEENUMPROCA DESKTOPENUMPROCA;
typedef struct _DOCINFOA DOCINFOA;
typedef __stdcall int (*ENHMFENUMPROC)(HDC hdc __attribute__((in)), HANDLETABLE *lpht __attribute__((in)), const ENHMETARECORD *lpmr __attribute__((in)), int nHandles __attribute__((in)), LPARAM data __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESLANGPROCA)(HMODULE hModule __attribute__((in)), LPCSTR lpType __attribute__((in)), LPCSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESLANGPROCW)(HMODULE hModule __attribute__((in)), LPCWSTR lpType __attribute__((in)), LPCWSTR lpName __attribute__((in)), WORD wLanguage __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESNAMEPROCA)(HMODULE hModule __attribute__((in)), LPCSTR lpType __attribute__((in)), LPSTR lpName __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESNAMEPROCW)(HMODULE hModule __attribute__((in)), LPCWSTR lpType __attribute__((in)), LPWSTR lpName __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef __stdcall BOOL (*ENUMRESTYPEPROCA)(HMODULE hModule __attribute__((in)), LPSTR lpType __attribute__((in)), LONG_PTR lParam __attribute__((in)));
typedef struct _GENERIC_MAPPING GENERIC_MAPPING;
__stdcall DWORD GetFileVersionInfoSizeW(LPCWSTR lptstrFilename __attribute__((in)), LPDWORD lpdwHandle __attribute__((out)));
__stdcall BOOL GetFileVersionInfoW(LPCWSTR lptstrFilename __attribute__((in)), DWORD dwHandle, DWORD dwLen __attribute__((in)), LPVOID lpData);
typedef struct _ICONINFO ICONINFO;
__stdcall DWORD ImmGetCandidateListW(HIMC __attribute__((in)), DWORD deIndex __attribute__((in)), LPCANDIDATELIST lpCandList, DWORD dwBufLen __attribute__((in)));
__stdcall DWORD ImmGetConversionListW(HKL __attribute__((in)), HIMC __attribute__((in)), LPCWSTR lpSrc __attribute__((in)), LPCANDIDATELIST lpDst, DWORD dwBufLen __attribute__((in)), UINT uFlag __attribute__((in)));
__stdcall DWORD ImmGetGuideLineW(HIMC __attribute__((in)), DWORD dwIndex __attribute__((in)), LPWSTR lpBuf, DWORD dwBufLen __attribute__((in)));
__stdcall UINT ImmGetIMEFileNameW(HKL __attribute__((in)), LPWSTR lpszFileName, UINT uBufLen __attribute__((in)));
__stdcall HKL ImmInstallIMEW(LPCWSTR lpszIMEFileName __attribute__((in)), LPCWSTR lpszLayoutText __attribute__((in)));
__stdcall BOOL ImmRegisterWordW(HKL __attribute__((in)), LPCWSTR lpszReading __attribute__((in)), DWORD __attribute__((in)), LPCWSTR lpszRegister __attribute__((in)));
typedef struct _KEY_EVENT_RECORD KEY_EVENT_RECORD;
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
typedef struct tagMENUINFO MENUINFO;
typedef struct tagMENUITEMINFOA MENUITEMINFOA;
typedef struct tagMETAFILEPICT METAFILEPICT;
typedef __stdcall int (*MFENUMPROC)(HDC hdc __attribute__((in)), HANDLETABLE *lpht __attribute__((in)), METARECORD *lpMR __attribute__((in)), int nObj __attribute__((in)), LPARAM param __attribute__((in)));
typedef __stdcall BOOL (*MONITORENUMPROC)(HMONITOR, HDC, LPRECT, LPARAM);
typedef __stdcall BOOL (*NAMEENUMPROCW)(LPWSTR, LPARAM);
typedef struct _numberfmtA NUMBERFMTA;
typedef __stdcall int (*OLDFONTENUMPROCA)(const LOGFONTA*, const TEXTMETRICA*, DWORD, LPARAM);
typedef struct _OUTPUT_DEBUG_STRING_INFO OUTPUT_DEBUG_STRING_INFO;
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
typedef struct tagRAWINPUTDEVICE RAWINPUTDEVICE;
typedef __stdcall int (*REGISTERWORDENUMPROCW)(LPCWSTR lpszReading __attribute__((in)), DWORD, LPCWSTR lpszString __attribute__((in)), LPVOID);
__stdcall NTSTATUS RtlUnicodeToMultiByteSize(PULONG BytesInMultiByteString __attribute__((out)), PWCH UnicodeString __attribute__((in)), ULONG BytesInUnicodeString __attribute__((in)));
typedef SIZE SIZEL;
typedef union _SLIST_HEADER SLIST_HEADER;
typedef struct _STRING STRING;
__stdcall BOOL SetConsoleDisplayMode(HANDLE hConsoleOutput __attribute__((in)), DWORD dwFlags __attribute__((in)), PCOORD lpNewScreenBufferDimensions __attribute__((out)));
typedef struct tagTEXTMETRICW TEXTMETRICW;
typedef __stdcall BOOL (*TIMEFMT_ENUMPROCW)(LPWSTR);
typedef __stdcall BOOL (*UILANGUAGE_ENUMPROCW)(LPWSTR, LONG_PTR);
__stdcall DWORD VerFindFileW(DWORD uFlags __attribute__((in)), LPCWSTR szFileName __attribute__((in)), LPCWSTR szWinDir __attribute__((in)), LPCWSTR szAppDir __attribute__((in)), LPWSTR szCurDir, PUINT lpuCurDirLen, LPWSTR szDestDir, PUINT lpuDestDirLen);
__stdcall DWORD VerLanguageNameW(DWORD wLang __attribute__((in)), LPWSTR szLang, DWORD cchLang __attribute__((in)));
__stdcall BOOL VerQueryValueW(LPCVOID pBlock __attribute__((in)), LPCWSTR lpSubBlock __attribute__((in)), LPVOID *lplpBuffer, PUINT puLen __attribute__((out)));
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


typedef struct tagACTCTXW ACTCTXW;
typedef struct tagBITMAPINFO BITMAPINFO;
typedef struct tagICEXYZTRIPLE CIEXYZTRIPLE;
typedef struct _CONTEXT CONTEXT;
typedef struct _CREATE_PROCESS_DEBUG_INFO CREATE_PROCESS_DEBUG_INFO;
typedef struct _CREATE_THREAD_DEBUG_INFO CREATE_THREAD_DEBUG_INFO;
typedef struct _currencyfmtW CURRENCYFMTW;
typedef NAMEENUMPROCW DESKTOPENUMPROCW;
typedef struct _devicemodeA DEVMODEA;
typedef struct _devicemodeW DEVMODEW;
typedef struct _DOCINFOW DOCINFOW;
typedef struct _EXCEPTION_DEBUG_INFO EXCEPTION_DEBUG_INFO;
typedef OLDFONTENUMPROCA FONTENUMPROCA;
__stdcall UINT ImmEnumRegisterWordW(HKL __attribute__((in)), REGISTERWORDENUMPROCW __attribute__((in)), LPCWSTR lpszReading __attribute__((in)), DWORD __attribute__((in)), LPCWSTR lpszRegister __attribute__((in)), LPVOID __attribute__((in)));
__stdcall BOOL ImmSetCompositionFontW(HIMC __attribute__((in)), LPLOGFONTW lplf __attribute__((in)));
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
typedef struct _RGNDATAHEADER RGNDATAHEADER;
__stdcall NTSTATUS RtlLocalTimeToSystemTime(PLARGE_INTEGER LocalTime __attribute__((in)), PLARGE_INTEGER SystemTime __attribute__((out)));
__stdcall BOOLEAN RtlTimeToSecondsSince1970(PLARGE_INTEGER Time, PULONG ElapsedSeconds);
typedef struct _SERVICE_TABLE_ENTRYA SERVICE_TABLE_ENTRYA;
typedef struct _TIME_ZONE_INFORMATION TIME_ZONE_INFORMATION;
typedef struct tagTPMPARAMS TPMPARAMS;
typedef struct _UNICODE_STRING UNICODE_STRING;
typedef struct tagWINDOWPLACEMENT WINDOWPLACEMENT;
typedef struct _WINDOW_BUFFER_SIZE_RECORD WINDOW_BUFFER_SIZE_RECORD;
typedef NAMEENUMPROCW WINSTAENUMPROCW;
typedef struct tagWNDCLASSA WNDCLASSA;
typedef struct tagWNDCLASSEXA WNDCLASSEXA;
typedef struct tagWNDCLASSEXW WNDCLASSEXW;
typedef struct tagWNDCLASSW WNDCLASSW;
__stdcall DWORD WNetAddConnection2A(LPNETRESOURCEA lpNetResource __attribute__((in)), LPCSTR lpPassword __attribute__((in)), LPCSTR lpUserName __attribute__((in)), DWORD dwFlags __attribute__((in)));

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


typedef OLDFONTENUMPROCW FONTENUMPROCW;
__stdcall BOOL ImmGetCompositionWindow(HIMC __attribute__((in)), LPCOMPOSITIONFORM lpCompForm __attribute__((out)));
__stdcall BOOL ImmSetCompositionWindow(HIMC __attribute__((in)), LPCOMPOSITIONFORM lpCompForm __attribute__((in)));
typedef const MENUITEMINFOW *LPCMENUITEMINFOW;
typedef struct tagENHMETAHEADER *LPENHMETAHEADER;
typedef struct _OUTLINETEXTMETRICW *LPOUTLINETEXTMETRICW;
typedef TPMPARAMS *LPTPMPARAMS;
typedef __stdcall void (*MSGBOXCALLBACK)(LPHELPINFO lpHelpInfo);
__stdcall NTSTATUS NtDeviceIoControlFile(HANDLE FileHandle __attribute__((in)), HANDLE Event __attribute__((in)), PIO_APC_ROUTINE ApcRoutine __attribute__((in)), PVOID ApcContext __attribute__((in)), PIO_STATUS_BLOCK IoStatusBlock __attribute__((out)), ULONG IoControlCode __attribute__((in)), PVOID InputBuffer __attribute__((in)), ULONG InputBufferLength __attribute__((in)), PVOID OutputBuffer __attribute__((out)), ULONG OutputBufferLength __attribute__((in)));
typedef PSTRING PANSI_STRING;
typedef const ACTCTXW *PCACTCTXW;
typedef PSTRING PCANSI_STRING;
typedef CONTEXT *PCONTEXT;
typedef const UNICODE_STRING *PCUNICODE_STRING;
typedef PSTRING POEM_STRING;
typedef struct _RTL_CRITICAL_SECTION *PRTL_CRITICAL_SECTION;
typedef UNICODE_STRING *PUNICODE_STRING;
__stdcall void RtlInitString(PSTRING DestinationString, PCSZ SourceString);
typedef struct _SERVICE_TABLE_ENTRYW SERVICE_TABLE_ENTRYW;
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


typedef struct _INPUT_RECORD INPUT_RECORD;
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
__stdcall NTSTATUS RtlConvertSidToUnicodeString(PUNICODE_STRING UnicodeString, PSID Sid, BOOLEAN AllocateDestinationString);
__stdcall void RtlFreeAnsiString(PANSI_STRING AnsiString);
__stdcall void RtlFreeOemString(POEM_STRING OemString);
__stdcall void RtlFreeUnicodeString(PUNICODE_STRING UnicodeString);
__stdcall void RtlInitAnsiString(PANSI_STRING DestinationString, PCSZ SourceString);
__stdcall void RtlInitUnicodeString(PUNICODE_STRING DestinationString, PCWSTR SourceString);
__stdcall BOOLEAN RtlIsNameLegalDOS8Dot3(PUNICODE_STRING Name __attribute__((in)), POEM_STRING OemName __attribute__((in)) __attribute__((out)), PBOOLEAN NameContainsSpaces __attribute__((in)) __attribute__((out)));
__stdcall NTSTATUS RtlUnicodeStringToAnsiString(PANSI_STRING DestinationString, PCUNICODE_STRING SourceString, BOOLEAN AllocateDestinationString);
__stdcall NTSTATUS RtlUnicodeStringToOemString(POEM_STRING DestinationString, PCUNICODE_STRING SourceString, BOOLEAN AllocateDestinationString);

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


typedef struct tagMSGBOXPARAMSA MSGBOXPARAMSA;
typedef struct tagMSGBOXPARAMSW MSGBOXPARAMSW;
typedef struct _OBJECT_ATTRIBUTES OBJECT_ATTRIBUTES;
typedef __stdcall LONG (*PTOP_LEVEL_EXCEPTION_FILTER)(struct _EXCEPTION_POINTERS *ExceptionInfo __attribute__((in)));
__stdcall DWORD WNetConnectionDialog1W(LPCONNECTDLGSTRUCTW lpConnDlgStruct);


typedef PTOP_LEVEL_EXCEPTION_FILTER LPTOP_LEVEL_EXCEPTION_FILTER;
typedef OBJECT_ATTRIBUTES *POBJECT_ATTRIBUTES;


__stdcall NTSTATUS NtCreateFile(PHANDLE FileHandle __attribute__((out)), ACCESS_MASK DesiredAccess __attribute__((in)), POBJECT_ATTRIBUTES ObjectAttributes __attribute__((in)), PIO_STATUS_BLOCK IoStatusBlock __attribute__((out)), PLARGE_INTEGER AllocationSize __attribute__((in)), ULONG FileAttributes __attribute__((in)), ULONG ShareAccess __attribute__((in)), ULONG CreateDisposition __attribute__((in)), ULONG CreateOptions __attribute__((in)), PVOID EaBuffer __attribute__((in)), ULONG EaLength __attribute__((in)));
__stdcall NTSTATUS NtOpenFile(PHANDLE FileHandle __attribute__((out)), ACCESS_MASK DesiredAccess __attribute__((in)), POBJECT_ATTRIBUTES ObjectAttributes __attribute__((in)), PIO_STATUS_BLOCK IoStatusBlock __attribute__((out)), ULONG ShareAccess __attribute__((in)), ULONG OpenOptions __attribute__((in)));

