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

__stdcall void * CountClipboardFormats __attribute__((dllimport))(void * var1 );
__stdcall void * DebugBreak __attribute__((dllimport))(void * var2 );
__stdcall void * GetDialogBaseUnits __attribute__((dllimport))(void * var3 );
__stdcall void * GetKeyboardType __attribute__((dllimport))(void * var4 );
__stdcall void * GetSystemMetrics __attribute__((dllimport))(void * var5 );
__stdcall void * MulDiv __attribute__((dllimport))(void * var6 , void * var7 , void * var8 );
__stdcall void * PostQuitMessage __attribute__((dllimport))(void * var9 );
__stdcall void * SetFileApisToANSI __attribute__((dllimport))(void * var10 );
__stdcall void * SetFileApisToOEM __attribute__((dllimport))(void * var11 );
__stdcall void * ActivateActCtx __attribute__((dllimport))(void * var12 , void * var13 );
__stdcall void * AddRefActCtx __attribute__((dllimport))(void * var14 );
__stdcall void * AllocConsole __attribute__((dllimport))(void * var15 );
__stdcall void * AllowSetForegroundWindow __attribute__((dllimport))(void * var16 );
__stdcall void * AnyPopup __attribute__((dllimport))(void * var17 );
__stdcall void * AreAllAccessesGranted __attribute__((dllimport))(void * var18 , void * var19 );
__stdcall void * AreAnyAccessesGranted __attribute__((dllimport))(void * var20 , void * var21 );
__stdcall void * AreFileApisANSI __attribute__((dllimport))(void * var22 );
__stdcall void * AssignProcessToJobObject __attribute__((dllimport))(void * var23 , void * var24 );
__stdcall void * AttachThreadInput __attribute__((dllimport))(void * var25 , void * var26 , void * var27 );
__stdcall void * Beep __attribute__((dllimport))(void * var28 , void * var29 );
__stdcall void * CancelIo __attribute__((dllimport))(void * var30 );
__stdcall void * CancelWaitableTimer __attribute__((dllimport))(void * var31 );
__stdcall void * ChangeTimerQueueTimer __attribute__((dllimport))(void * var32 , void * var33 , void * var34 , void * var35 );
__stdcall void * ClearCommBreak __attribute__((dllimport))(void * var36 );
__stdcall void * CloseClipboard __attribute__((dllimport))(void * var37 );
__stdcall void * CloseEncryptedFileRaw __attribute__((dllimport))(void * var38 );
__stdcall void * CloseEventLog __attribute__((dllimport))(void * var39 );
__stdcall void * CloseHandle __attribute__((dllimport))(void * var40 );
__stdcall void * ContinueDebugEvent __attribute__((dllimport))(void * var41 , void * var42 , void * var43 );
__stdcall void * ConvertFiberToThread __attribute__((dllimport))(void * var44 );
__stdcall void * ConvertThreadToFiber __attribute__((dllimport))(void * var45 );
__stdcall void * CopyImage __attribute__((dllimport))(void * var46 , void * var47 , void * var48 , void * var49 , void * var50 );
__stdcall void * CreateIoCompletionPort __attribute__((dllimport))(void * var51 , void * var52 , void * var53 , void * var54 );
__stdcall void * CreateTimerQueue __attribute__((dllimport))(void * var55 );
__stdcall void * DeactivateActCtx __attribute__((dllimport))(void * var56 , void * var57 );
__stdcall void * DebugActiveProcess __attribute__((dllimport))(void * var58 );
__stdcall void * DeleteFiber __attribute__((dllimport))(void * var59 );
__stdcall void * DeleteObject __attribute__((dllimport))(void * var60 );
__stdcall void * DeleteTimerQueue __attribute__((dllimport))(void * var61 );
__stdcall void * DeleteTimerQueueEx __attribute__((dllimport))(void * var62 , void * var63 );
__stdcall void * DeleteTimerQueueTimer __attribute__((dllimport))(void * var64 , void * var65 , void * var66 );
__stdcall void * DeregisterEventSource __attribute__((dllimport))(void * var67 );
__stdcall void * DestroyCaret __attribute__((dllimport))(void * var68 );
__stdcall void * DisconnectNamedPipe __attribute__((dllimport))(void * var69 );
__stdcall void * EmptyClipboard __attribute__((dllimport))(void * var70 );
__stdcall void * EndMenu __attribute__((dllimport))(void * var71 );
__stdcall void * EndUpdateResourceA __attribute__((dllimport))(void * var72 , void * var73 );
__stdcall void * EnumClipboardFormats __attribute__((dllimport))(void * var74 );
__stdcall void * EraseTape __attribute__((dllimport))(void * var75 , void * var76 , void * var77 );
__stdcall void * EscapeCommFunction __attribute__((dllimport))(void * var78 , void * var79 );
__stdcall void * ExitProcess __attribute__((dllimport))(void * var80 );
__stdcall void * ExitThread __attribute__((dllimport))(void * var81 );
__stdcall void * ExitWindowsEx __attribute__((dllimport))(void * var82 , void * var83 );
__stdcall void * FindClose __attribute__((dllimport))(void * var84 );
__stdcall void * FindCloseChangeNotification __attribute__((dllimport))(void * var85 );
__stdcall void * FindNextChangeNotification __attribute__((dllimport))(void * var86 );
__stdcall void * FindVolumeClose __attribute__((dllimport))(void * var87 );
__stdcall void * FindVolumeMountPointClose __attribute__((dllimport))(void * var88 );
__stdcall void * FlushConsoleInputBuffer __attribute__((dllimport))(void * var89 );
__stdcall void * FlushFileBuffers __attribute__((dllimport))(void * var90 );
__stdcall void * FreeConsole __attribute__((dllimport))(void * var91 );
__stdcall void * GdiFlush __attribute__((dllimport))(void * var92 );
__stdcall void * GdiSetBatchLimit __attribute__((dllimport))(void * var93 );
__stdcall void * GenerateConsoleCtrlEvent __attribute__((dllimport))(void * var94 , void * var95 );
__stdcall void * GetACP __attribute__((dllimport))(void * var96 );
__stdcall void * GetAsyncKeyState __attribute__((dllimport))(void * var97 );
__stdcall void * GetCaretBlinkTime __attribute__((dllimport))(void * var98 );
__stdcall void * GetClipboardData __attribute__((dllimport))(void * var99 );
__stdcall void * GetClipboardSequenceNumber __attribute__((dllimport))(void * var100 );
__stdcall void * GetConsoleAliasExesLengthW __attribute__((dllimport))(void * var101 );
__stdcall void * GetConsoleCP __attribute__((dllimport))(void * var102 );
__stdcall void * GetConsoleOutputCP __attribute__((dllimport))(void * var103 );
__stdcall void * GetCurrentActCtx __attribute__((dllimport))(void * var104 );
__stdcall void * GetCurrentProcess __attribute__((dllimport))(void * var105 );
__stdcall void * GetCurrentProcessId __attribute__((dllimport))(void * var106 );
__stdcall void * GetCurrentThread __attribute__((dllimport))(void * var107 );
__stdcall void * GetCurrentThreadId __attribute__((dllimport))(void * var108 );
__stdcall void * GetDoubleClickTime __attribute__((dllimport))(void * var109 );
__stdcall void * GetFileType __attribute__((dllimport))(void * var110 );
__stdcall void * GetGuiResources __attribute__((dllimport))(void * var111 , void * var112 );
__stdcall void * GetInputState __attribute__((dllimport))(void * var113 );
__stdcall void * GetKBCodePage __attribute__((dllimport))(void * var114 );
__stdcall void * GetKeyState __attribute__((dllimport))(void * var115 );
__stdcall void * GetLastError __attribute__((dllimport))(void * var116 );
__stdcall void * GetLogicalDrives __attribute__((dllimport))(void * var117 );
__stdcall void * GetMenuCheckMarkDimensions __attribute__((dllimport))(void * var118 );
__stdcall void * GetMessagePos __attribute__((dllimport))(void * var119 );
__stdcall void * GetMessageTime __attribute__((dllimport))(void * var120 );
__stdcall void * GetOEMCP __attribute__((dllimport))(void * var121 );
__stdcall void * GetObjectA __attribute__((dllimport))(void * var122 , void * var123 , void * var124 );
__stdcall void * GetObjectType __attribute__((dllimport))(void * var125 );
__stdcall void * GetObjectW __attribute__((dllimport))(void * var126 , void * var127 , void * var128 );
__stdcall void * GetPriorityClass __attribute__((dllimport))(void * var129 );
__stdcall void * GetPriorityClipboardFormat __attribute__((dllimport))(void * var130 , void * var131 );
__stdcall void * GetProcessDefaultLayout __attribute__((dllimport))(void * var132 );
__stdcall void * GetProcessHeap __attribute__((dllimport))(void * var133 );
__stdcall void * GetProcessId __attribute__((dllimport))(void * var134 );
__stdcall void * GetProcessVersion __attribute__((dllimport))(void * var135 );
__stdcall void * GetQueueStatus __attribute__((dllimport))(void * var136 );
__stdcall void * GetRawInputDeviceInfoW __attribute__((dllimport))(void * var137 , void * var138 , void * var139 , void * var140 );
__stdcall void * GetSidLengthRequired __attribute__((dllimport))(void * var141 );
__stdcall void * GetStdHandle __attribute__((dllimport))(void * var142 );
__stdcall void * GetStockObject __attribute__((dllimport))(void * var143 );
__stdcall void * GetSysColor __attribute__((dllimport))(void * var144 );
__stdcall void * GetTapeStatus __attribute__((dllimport))(void * var145 );
__stdcall void * GetThreadPriority __attribute__((dllimport))(void * var146 );
__stdcall void * GetTickCount __attribute__((dllimport))(void * var147 );
__stdcall void * GetVersion __attribute__((dllimport))(void * var148 );
__stdcall void * HeapDestroy __attribute__((dllimport))(void * var149 );
__stdcall void * HeapFree __attribute__((dllimport))(void * var150 , void * var151 , void * var152 );
__stdcall void * HeapLock __attribute__((dllimport))(void * var153 );
__stdcall void * HeapUnlock __attribute__((dllimport))(void * var154 );
__stdcall void * HeapValidate __attribute__((dllimport))(void * var155 , void * var156 , void * var157 );
__stdcall void * ImpersonateAnonymousToken __attribute__((dllimport))(void * var158 );
__stdcall void * ImpersonateLoggedOnUser __attribute__((dllimport))(void * var159 );
__stdcall void * ImpersonateNamedPipeClient __attribute__((dllimport))(void * var160 );
__stdcall void * InSendMessage __attribute__((dllimport))(void * var161 );
__stdcall void * InSendMessageEx __attribute__((dllimport))(void * var162 );
__stdcall void * InitAtomTable __attribute__((dllimport))(void * var163 );
__stdcall void * InterlockedCompareExchange __attribute__((dllimport))(void * var164 , void * var165 , void * var166 );
__stdcall void * InterlockedDecrement __attribute__((dllimport))(void * var167 );
__stdcall void * InterlockedExchange __attribute__((dllimport))(void * var168 , void * var169 );
__stdcall void * InterlockedExchangeAdd __attribute__((dllimport))(void * var170 , void * var171 );
__stdcall void * InterlockedIncrement __attribute__((dllimport))(void * var172 );
__stdcall void * IsBadCodePtr __attribute__((dllimport))(void * var173 );
__stdcall void * IsBadHugeReadPtr __attribute__((dllimport))(void * var174 , void * var175 );
__stdcall void * IsBadHugeWritePtr __attribute__((dllimport))(void * var176 , void * var177 );
__stdcall void * IsBadReadPtr __attribute__((dllimport))(void * var178 , void * var179 );
__stdcall void * IsBadWritePtr __attribute__((dllimport))(void * var180 , void * var181 );
__stdcall void * IsCharAlphaA __attribute__((dllimport))(void * var182 );
__stdcall void * IsCharAlphaNumericA __attribute__((dllimport))(void * var183 );
__stdcall void * IsCharLowerA __attribute__((dllimport))(void * var184 );
__stdcall void * IsCharUpperA __attribute__((dllimport))(void * var185 );
__stdcall void * IsClipboardFormatAvailable __attribute__((dllimport))(void * var186 );
__stdcall void * IsDBCSLeadByte __attribute__((dllimport))(void * var187 );
__stdcall void * IsDBCSLeadByteEx __attribute__((dllimport))(void * var188 , void * var189 );
__stdcall void * IsDebuggerPresent __attribute__((dllimport))(void * var190 );
__stdcall void * IsProcessorFeaturePresent __attribute__((dllimport))(void * var191 );
__stdcall void * IsTextUnicode __attribute__((dllimport))(void * var192 , void * var193 , void * var194 );
__stdcall void * IsTokenRestricted __attribute__((dllimport))(void * var195 );
__stdcall void * IsValidCodePage __attribute__((dllimport))(void * var196 );
__stdcall void * IsWinEventHookInstalled __attribute__((dllimport))(void * var197 );
__stdcall void * LockFile __attribute__((dllimport))(void * var198 , void * var199 , void * var200 , void * var201 , void * var202 );
__stdcall void * LockSetForegroundWindow __attribute__((dllimport))(void * var203 );
__stdcall void * LockWorkStation __attribute__((dllimport))(void * var204 );
__stdcall void * MapVirtualKeyA __attribute__((dllimport))(void * var205 , void * var206 );
__stdcall void * MapVirtualKeyW __attribute__((dllimport))(void * var207 , void * var208 );
__stdcall void * MessageBeep __attribute__((dllimport))(void * var209 );
__stdcall void * MsgWaitForMultipleObjects __attribute__((dllimport))(void * var210 , void * var211 , void * var212 , void * var213 , void * var214 );
__stdcall void * MsgWaitForMultipleObjectsEx __attribute__((dllimport))(void * var215 , void * var216 , void * var217 , void * var218 , void * var219 );
__stdcall void * NotifyBootConfigStatus __attribute__((dllimport))(void * var220 );
__stdcall void * NotifyChangeEventLog __attribute__((dllimport))(void * var221 , void * var222 );
__stdcall void * OemKeyScan __attribute__((dllimport))(void * var223 );
__stdcall void * OpenProcess __attribute__((dllimport))(void * var224 , void * var225 , void * var226 );
__stdcall void * OpenThread __attribute__((dllimport))(void * var227 , void * var228 , void * var229 );
__stdcall void * PrepareTape __attribute__((dllimport))(void * var230 , void * var231 , void * var232 );
__stdcall void * ProcessIdToSessionId __attribute__((dllimport))(void * var233 , void * var234 );
__stdcall void * PulseEvent __attribute__((dllimport))(void * var235 );
__stdcall void * PurgeComm __attribute__((dllimport))(void * var236 , void * var237 );
__stdcall void * RaiseException __attribute__((dllimport))(void * var238 , void * var239 , void * var240 , void * var241 );
__stdcall void * ReadEventLogA __attribute__((dllimport))(void * var242 , void * var243 , void * var244 , void * var245 , void * var246 , void * var247 , void * var248 );
__stdcall void * ReadEventLogW __attribute__((dllimport))(void * var249 , void * var250 , void * var251 , void * var252 , void * var253 , void * var254 , void * var255 );
__stdcall void * ReleaseActCtx __attribute__((dllimport))(void * var256 );
__stdcall void * ReleaseCapture __attribute__((dllimport))(void * var257 );
__stdcall void * ReleaseMutex __attribute__((dllimport))(void * var258 );
__stdcall void * ReleaseSemaphore __attribute__((dllimport))(void * var259 , void * var260 , void * var261 );
__stdcall void * ResetEvent __attribute__((dllimport))(void * var262 );
__stdcall void * ResumeThread __attribute__((dllimport))(void * var263 );
__stdcall void * RevertToSelf __attribute__((dllimport))(void * var264 );
__stdcall void * RtlPcToFileHeader __attribute__((dllimport))(void * var265 , void * var266 );
__stdcall void * SetCaretBlinkTime __attribute__((dllimport))(void * var267 );
__stdcall void * SetCaretPos __attribute__((dllimport))(void * var268 , void * var269 );
__stdcall void * SetClipboardData __attribute__((dllimport))(void * var270 , void * var271 );
__stdcall void * SetCommBreak __attribute__((dllimport))(void * var272 );
__stdcall void * SetCommMask __attribute__((dllimport))(void * var273 , void * var274 );
__stdcall void * SetConsoleActiveScreenBuffer __attribute__((dllimport))(void * var275 );
__stdcall void * SetConsoleCP __attribute__((dllimport))(void * var276 );
__stdcall void * SetConsoleMode __attribute__((dllimport))(void * var277 , void * var278 );
__stdcall void * SetConsoleOutputCP __attribute__((dllimport))(void * var279 );
__stdcall void * SetConsoleTextAttribute __attribute__((dllimport))(void * var280 , void * var281 );
__stdcall void * SetCursorPos __attribute__((dllimport))(void * var282 , void * var283 );
__stdcall void * SetDoubleClickTime __attribute__((dllimport))(void * var284 );
__stdcall void * SetEndOfFile __attribute__((dllimport))(void * var285 );
__stdcall void * SetErrorMode __attribute__((dllimport))(void * var286 );
__stdcall void * SetEvent __attribute__((dllimport))(void * var287 );
__stdcall void * SetHandleCount __attribute__((dllimport))(void * var288 );
__stdcall void * SetHandleInformation __attribute__((dllimport))(void * var289 , void * var290 , void * var291 );
__stdcall void * SetLastError __attribute__((dllimport))(void * var292 );
__stdcall void * SetLastErrorEx __attribute__((dllimport))(void * var293 , void * var294 );
__stdcall void * SetMailslotInfo __attribute__((dllimport))(void * var295 , void * var296 );
__stdcall void * SetMessageQueue __attribute__((dllimport))(void * var297 );
__stdcall void * SetPriorityClass __attribute__((dllimport))(void * var298 , void * var299 );
__stdcall void * SetProcessDefaultLayout __attribute__((dllimport))(void * var300 );
__stdcall void * SetProcessShutdownParameters __attribute__((dllimport))(void * var301 , void * var302 );
__stdcall void * SetStdHandle __attribute__((dllimport))(void * var303 , void * var304 );
__stdcall void * SetSystemTimeAdjustment __attribute__((dllimport))(void * var305 , void * var306 );
__stdcall void * SetTapeParameters __attribute__((dllimport))(void * var307 , void * var308 , void * var309 );
__stdcall void * SetTapePosition __attribute__((dllimport))(void * var310 , void * var311 , void * var312 , void * var313 , void * var314 , void * var315 );
__stdcall void * SetThreadIdealProcessor __attribute__((dllimport))(void * var316 , void * var317 );
__stdcall void * SetThreadPriority __attribute__((dllimport))(void * var318 , void * var319 );
__stdcall void * SetThreadPriorityBoost __attribute__((dllimport))(void * var320 , void * var321 );
__stdcall void * SetUserObjectInformationA __attribute__((dllimport))(void * var322 , void * var323 , void * var324 , void * var325 );
__stdcall void * SetUserObjectInformationW __attribute__((dllimport))(void * var326 , void * var327 , void * var328 , void * var329 );
__stdcall void * SetupComm __attribute__((dllimport))(void * var330 , void * var331 , void * var332 );
__stdcall void * ShowCursor __attribute__((dllimport))(void * var333 );
__stdcall void * SignalObjectAndWait __attribute__((dllimport))(void * var334 , void * var335 , void * var336 , void * var337 );
__stdcall void * Sleep __attribute__((dllimport))(void * var338 );
__stdcall void * SleepEx __attribute__((dllimport))(void * var339 , void * var340 );
__stdcall void * SuspendThread __attribute__((dllimport))(void * var341 );
__stdcall void * SwapMouseButton __attribute__((dllimport))(void * var342 );
__stdcall void * SwitchToFiber __attribute__((dllimport))(void * var343 );
__stdcall void * SwitchToThread __attribute__((dllimport))(void * var344 );
__stdcall void * SystemParametersInfoA __attribute__((dllimport))(void * var345 , void * var346 , void * var347 , void * var348 );
__stdcall void * SystemParametersInfoW __attribute__((dllimport))(void * var349 , void * var350 , void * var351 , void * var352 );
__stdcall void * TerminateJobObject __attribute__((dllimport))(void * var353 , void * var354 );
__stdcall void * TerminateProcess __attribute__((dllimport))(void * var355 , void * var356 );
__stdcall void * TerminateThread __attribute__((dllimport))(void * var357 , void * var358 );
__stdcall void * TlsAlloc __attribute__((dllimport))(void * var359 );
__stdcall void * TlsFree __attribute__((dllimport))(void * var360 );
__stdcall void * TlsGetValue __attribute__((dllimport))(void * var361 );
__stdcall void * TlsSetValue __attribute__((dllimport))(void * var362 , void * var363 );
__stdcall void * TransmitCommChar __attribute__((dllimport))(void * var364 , void * var365 );
__stdcall void * UnlockFile __attribute__((dllimport))(void * var366 , void * var367 , void * var368 , void * var369 , void * var370 );
__stdcall void * UnmapViewOfFile __attribute__((dllimport))(void * var371 );
__stdcall void * UnrealizeObject __attribute__((dllimport))(void * var372 );
__stdcall void * UnregisterWait __attribute__((dllimport))(void * var373 );
__stdcall void * UnregisterWaitEx __attribute__((dllimport))(void * var374 , void * var375 );
__stdcall void * VerSetConditionMask __attribute__((dllimport))(void * var376 , void * var377 , void * var378 );
__stdcall void * VkKeyScanA __attribute__((dllimport))(void * var379 );
__stdcall void * WTSGetActiveConsoleSessionId __attribute__((dllimport))(void * var380 );
__stdcall void * WaitForInputIdle __attribute__((dllimport))(void * var381 , void * var382 );
__stdcall void * WaitForMultipleObjects __attribute__((dllimport))(void * var383 , void * var384 , void * var385 , void * var386 );
__stdcall void * WaitForMultipleObjectsEx __attribute__((dllimport))(void * var387 , void * var388 , void * var389 , void * var390 , void * var391 );
__stdcall void * WaitForSingleObject __attribute__((dllimport))(void * var392 , void * var393 );
__stdcall void * WaitForSingleObjectEx __attribute__((dllimport))(void * var394 , void * var395 , void * var396 );
__stdcall void * WaitMessage __attribute__((dllimport))(void * var397 );
__stdcall void * WriteTapemark __attribute__((dllimport))(void * var398 , void * var399 , void * var400 , void * var401 );
__stdcall void * _hread __attribute__((dllimport))(void * var402 , void * var403 , void * var404 );
__stdcall void * _lclose __attribute__((dllimport))(void * var405 );
__stdcall void * _llseek __attribute__((dllimport))(void * var406 , void * var407 , void * var408 );
__stdcall void * _lread __attribute__((dllimport))(void * var409 , void * var410 , void * var411 );
__stdcall void * keybd_event __attribute__((dllimport))(void * var412 , void * var413 , void * var414 , void * var415 );
__stdcall void * mouse_event __attribute__((dllimport))(void * var416 , void * var417 , void * var418 , void * var419 , void * var420 );
__stdcall void * AbortDoc __attribute__((dllimport))(void * var421 );
__stdcall void * AbortPath __attribute__((dllimport))(void * var422 );
__stdcall void * AbortSystemShutdownA __attribute__((dllimport))(void * var423 );
__stdcall void * ActivateKeyboardLayout __attribute__((dllimport))(void * var424 , void * var425 );
__stdcall void * AddAtomA __attribute__((dllimport))(void * var426 );
__stdcall void * AddFontResourceA __attribute__((dllimport))(void * var427 );
__stdcall void * AddFontResourceExA __attribute__((dllimport))(void * var428 , void * var429 , void * var430 );
__stdcall void * AngleArc __attribute__((dllimport))(void * var431 , void * var432 , void * var433 , void * var434 , void * var435 , void * var436 );
__stdcall void * AnimateWindow __attribute__((dllimport))(void * var437 , void * var438 , void * var439 );
__stdcall void * AppendMenuA __attribute__((dllimport))(void * var440 , void * var441 , void * var442 , void * var443 );
__stdcall void * Arc __attribute__((dllimport))(void * var444 , void * var445 , void * var446 , void * var447 , void * var448 , void * var449 , void * var450 , void * var451 , void * var452 );
__stdcall void * ArcTo __attribute__((dllimport))(void * var453 , void * var454 , void * var455 , void * var456 , void * var457 , void * var458 , void * var459 , void * var460 , void * var461 );
__stdcall void * ArrangeIconicWindows __attribute__((dllimport))(void * var462 );
__stdcall void * BackupEventLogA __attribute__((dllimport))(void * var463 , void * var464 );
__stdcall void * BackupRead __attribute__((dllimport))(void * var465 , void * var466 , void * var467 , void * var468 , void * var469 , void * var470 , void * var471 );
__stdcall void * BackupSeek __attribute__((dllimport))(void * var472 , void * var473 , void * var474 , void * var475 , void * var476 , void * var477 );
__stdcall void * BackupWrite __attribute__((dllimport))(void * var478 , void * var479 , void * var480 , void * var481 , void * var482 , void * var483 , void * var484 );
__stdcall void * BeginDeferWindowPos __attribute__((dllimport))(void * var485 );
__stdcall void * BeginPath __attribute__((dllimport))(void * var486 );
__stdcall void * BeginUpdateResourceA __attribute__((dllimport))(void * var487 , void * var488 );
__stdcall void * BitBlt __attribute__((dllimport))(void * var489 , void * var490 , void * var491 , void * var492 , void * var493 , void * var494 , void * var495 , void * var496 , void * var497 );
__stdcall void * BringWindowToTop __attribute__((dllimport))(void * var498 );
__stdcall void * BroadcastSystemMessageA __attribute__((dllimport))(void * var499 , void * var500 , void * var501 , void * var502 , void * var503 );
__stdcall void * BroadcastSystemMessageW __attribute__((dllimport))(void * var504 , void * var505 , void * var506 , void * var507 , void * var508 );
__stdcall void * CallNamedPipeA __attribute__((dllimport))(void * var509 , void * var510 , void * var511 , void * var512 , void * var513 , void * var514 , void * var515 );
__stdcall void * CallNextHookEx __attribute__((dllimport))(void * var516 , void * var517 , void * var518 , void * var519 );
__stdcall void * CancelDC __attribute__((dllimport))(void * var520 );
__stdcall void * ChangeClipboardChain __attribute__((dllimport))(void * var521 , void * var522 );
__stdcall void * ChangeMenuA __attribute__((dllimport))(void * var523 , void * var524 , void * var525 , void * var526 , void * var527 );
__stdcall void * ChangeServiceConfig2W __attribute__((dllimport))(void * var528 , void * var529 , void * var530 );
__stdcall void * ChangeServiceConfigA __attribute__((dllimport))(void * var531 , void * var532 , void * var533 , void * var534 , void * var535 , void * var536 , void * var537 , void * var538 , void * var539 , void * var540 , void * var541 );
__stdcall void * CharLowerA __attribute__((dllimport))(void * var542 );
__stdcall void * CharLowerBuffA __attribute__((dllimport))(void * var543 , void * var544 );
__stdcall void * CharNextA __attribute__((dllimport))(void * var545 );
__stdcall void * CharNextExA __attribute__((dllimport))(void * var546 , void * var547 , void * var548 );
__stdcall void * CharPrevA __attribute__((dllimport))(void * var549 , void * var550 );
__stdcall void * CharPrevExA __attribute__((dllimport))(void * var551 , void * var552 , void * var553 , void * var554 );
__stdcall void * CharToOemA __attribute__((dllimport))(void * var555 , void * var556 );
__stdcall void * CharToOemBuffA __attribute__((dllimport))(void * var557 , void * var558 , void * var559 );
__stdcall void * CharUpperA __attribute__((dllimport))(void * var560 );
__stdcall void * CharUpperBuffA __attribute__((dllimport))(void * var561 , void * var562 );
__stdcall void * CheckDlgButton __attribute__((dllimport))(void * var563 , void * var564 , void * var565 );
__stdcall void * CheckMenuItem __attribute__((dllimport))(void * var566 , void * var567 , void * var568 );
__stdcall void * CheckMenuRadioItem __attribute__((dllimport))(void * var569 , void * var570 , void * var571 , void * var572 , void * var573 );
__stdcall void * CheckRadioButton __attribute__((dllimport))(void * var574 , void * var575 , void * var576 , void * var577 );
__stdcall void * CheckTokenMembership __attribute__((dllimport))(void * var578 , void * var579 , void * var580 );
__stdcall void * Chord __attribute__((dllimport))(void * var581 , void * var582 , void * var583 , void * var584 , void * var585 , void * var586 , void * var587 , void * var588 , void * var589 );
__stdcall void * ClearEventLogA __attribute__((dllimport))(void * var590 , void * var591 );
__stdcall void * CloseDesktop __attribute__((dllimport))(void * var592 );
__stdcall void * CloseEnhMetaFile __attribute__((dllimport))(void * var593 );
__stdcall void * CloseFigure __attribute__((dllimport))(void * var594 );
__stdcall void * CloseMetaFile __attribute__((dllimport))(void * var595 );
__stdcall void * CloseServiceHandle __attribute__((dllimport))(void * var596 );
__stdcall void * CloseWindow __attribute__((dllimport))(void * var597 );
__stdcall void * CloseWindowStation __attribute__((dllimport))(void * var598 );
__stdcall void * CombineRgn __attribute__((dllimport))(void * var599 , void * var600 , void * var601 , void * var602 );
__stdcall void * CompareStringA __attribute__((dllimport))(void * var603 , void * var604 , void * var605 , void * var606 , void * var607 , void * var608 );
__stdcall void * ConvertDefaultLocale __attribute__((dllimport))(void * var609 );
__stdcall void * CopyEnhMetaFileA __attribute__((dllimport))(void * var610 , void * var611 );
__stdcall void * CopyFileA __attribute__((dllimport))(void * var612 , void * var613 , void * var614 );
__stdcall void * CopyIcon __attribute__((dllimport))(void * var615 );
__stdcall void * CopyMetaFileA __attribute__((dllimport))(void * var616 , void * var617 );
__stdcall void * CopySid __attribute__((dllimport))(void * var618 , void * var619 , void * var620 );
__stdcall void * CreateBitmap __attribute__((dllimport))(void * var621 , void * var622 , void * var623 , void * var624 , void * var625 );
__stdcall void * CreateCaret __attribute__((dllimport))(void * var626 , void * var627 , void * var628 , void * var629 );
__stdcall void * CreateCompatibleBitmap __attribute__((dllimport))(void * var630 , void * var631 , void * var632 );
__stdcall void * CreateCompatibleDC __attribute__((dllimport))(void * var633 );
__stdcall void * CreateDIBPatternBrushPt __attribute__((dllimport))(void * var634 , void * var635 );
__stdcall void * CreateDiscardableBitmap __attribute__((dllimport))(void * var636 , void * var637 , void * var638 );
__stdcall void * CreateEllipticRgn __attribute__((dllimport))(void * var639 , void * var640 , void * var641 , void * var642 );
__stdcall void * CreateFontA __attribute__((dllimport))(void * var643 , void * var644 , void * var645 , void * var646 , void * var647 , void * var648 , void * var649 , void * var650 , void * var651 , void * var652 , void * var653 , void * var654 , void * var655 , void * var656 );
__stdcall void * CreateHalftonePalette __attribute__((dllimport))(void * var657 );
__stdcall void * CreateHatchBrush __attribute__((dllimport))(void * var658 , void * var659 );
__stdcall void * CreateIcon __attribute__((dllimport))(void * var660 , void * var661 , void * var662 , void * var663 , void * var664 , void * var665 , void * var666 );
__stdcall void * CreateIconFromResource __attribute__((dllimport))(void * var667 , void * var668 , void * var669 , void * var670 );
__stdcall void * CreateIconFromResourceEx __attribute__((dllimport))(void * var671 , void * var672 , void * var673 , void * var674 , void * var675 , void * var676 , void * var677 );
__stdcall void * CreateMDIWindowA __attribute__((dllimport))(void * var678 , void * var679 , void * var680 , void * var681 , void * var682 , void * var683 , void * var684 , void * var685 , void * var686 , void * var687 );
__stdcall void * CreateMenu __attribute__((dllimport))(void * var688 );
__stdcall void * CreateMetaFileA __attribute__((dllimport))(void * var689 );
__stdcall void * CreatePatternBrush __attribute__((dllimport))(void * var690 );
__stdcall void * CreatePen __attribute__((dllimport))(void * var691 , void * var692 , void * var693 );
__stdcall void * CreatePopupMenu __attribute__((dllimport))(void * var694 );
__stdcall void * CreateRectRgn __attribute__((dllimport))(void * var695 , void * var696 , void * var697 , void * var698 );
__stdcall void * CreateRoundRectRgn __attribute__((dllimport))(void * var699 , void * var700 , void * var701 , void * var702 , void * var703 , void * var704 );
__stdcall void * CreateScalableFontResourceA __attribute__((dllimport))(void * var705 , void * var706 , void * var707 , void * var708 );
__stdcall void * CreateServiceA __attribute__((dllimport))(void * var709 , void * var710 , void * var711 , void * var712 , void * var713 , void * var714 , void * var715 , void * var716 , void * var717 , void * var718 , void * var719 , void * var720 , void * var721 );
__stdcall void * CreateSolidBrush __attribute__((dllimport))(void * var722 );
__stdcall void * CreateWellKnownSid __attribute__((dllimport))(void * var723 , void * var724 , void * var725 , void * var726 );
__stdcall void * CreateWindowExA __attribute__((dllimport))(void * var727 , void * var728 , void * var729 , void * var730 , void * var731 , void * var732 , void * var733 , void * var734 , void * var735 , void * var736 , void * var737 , void * var738 );
__stdcall void * DefDlgProcA __attribute__((dllimport))(void * var739 , void * var740 , void * var741 , void * var742 );
__stdcall void * DefDlgProcW __attribute__((dllimport))(void * var743 , void * var744 , void * var745 , void * var746 );
__stdcall void * DefFrameProcA __attribute__((dllimport))(void * var747 , void * var748 , void * var749 , void * var750 , void * var751 );
__stdcall void * DefFrameProcW __attribute__((dllimport))(void * var752 , void * var753 , void * var754 , void * var755 , void * var756 );
__stdcall void * DefMDIChildProcA __attribute__((dllimport))(void * var757 , void * var758 , void * var759 , void * var760 );
__stdcall void * DefMDIChildProcW __attribute__((dllimport))(void * var761 , void * var762 , void * var763 , void * var764 );
__stdcall void * DefWindowProcA __attribute__((dllimport))(void * var765 , void * var766 , void * var767 , void * var768 );
__stdcall void * DefWindowProcW __attribute__((dllimport))(void * var769 , void * var770 , void * var771 , void * var772 );
__stdcall void * DeferWindowPos __attribute__((dllimport))(void * var773 , void * var774 , void * var775 , void * var776 , void * var777 , void * var778 , void * var779 , void * var780 );
__stdcall void * DefineDosDeviceA __attribute__((dllimport))(void * var781 , void * var782 , void * var783 );
__stdcall void * DeleteAtom __attribute__((dllimport))(void * var784 );
__stdcall void * DeleteColorSpace __attribute__((dllimport))(void * var785 );
__stdcall void * DeleteDC __attribute__((dllimport))(void * var786 );
__stdcall void * DeleteEnhMetaFile __attribute__((dllimport))(void * var787 );
__stdcall void * DeleteFileA __attribute__((dllimport))(void * var788 );
__stdcall void * DeleteMenu __attribute__((dllimport))(void * var789 , void * var790 , void * var791 );
__stdcall void * DeleteMetaFile __attribute__((dllimport))(void * var792 );
__stdcall void * DeleteService __attribute__((dllimport))(void * var793 );
__stdcall void * DeregisterShellHookWindow __attribute__((dllimport))(void * var794 );
__stdcall void * DestroyAcceleratorTable __attribute__((dllimport))(void * var795 );
__stdcall void * DestroyIcon __attribute__((dllimport))(void * var796 );
__stdcall void * DestroyMenu __attribute__((dllimport))(void * var797 );
__stdcall void * DestroyPrivateObjectSecurity __attribute__((dllimport))(void * var798 );
__stdcall void * DestroyWindow __attribute__((dllimport))(void * var799 );
__stdcall void * DlgDirListA __attribute__((dllimport))(void * var800 , void * var801 , void * var802 , void * var803 , void * var804 );
__stdcall void * DlgDirListComboBoxA __attribute__((dllimport))(void * var805 , void * var806 , void * var807 , void * var808 , void * var809 );
__stdcall void * DlgDirSelectComboBoxExA __attribute__((dllimport))(void * var810 , void * var811 , void * var812 , void * var813 );
__stdcall void * DlgDirSelectExA __attribute__((dllimport))(void * var814 , void * var815 , void * var816 , void * var817 );
__stdcall void * DrawEscape __attribute__((dllimport))(void * var818 , void * var819 , void * var820 , void * var821 );
__stdcall void * DrawIcon __attribute__((dllimport))(void * var822 , void * var823 , void * var824 , void * var825 );
__stdcall void * DrawIconEx __attribute__((dllimport))(void * var826 , void * var827 , void * var828 , void * var829 , void * var830 , void * var831 , void * var832 , void * var833 , void * var834 );
__stdcall void * DrawMenuBar __attribute__((dllimport))(void * var835 );
__stdcall void * DuplicateHandle __attribute__((dllimport))(void * var836 , void * var837 , void * var838 , void * var839 , void * var840 , void * var841 , void * var842 );
__stdcall void * DuplicateToken __attribute__((dllimport))(void * var843 , void * var844 , void * var845 );
__stdcall void * Ellipse __attribute__((dllimport))(void * var846 , void * var847 , void * var848 , void * var849 , void * var850 );
__stdcall void * EnableMenuItem __attribute__((dllimport))(void * var851 , void * var852 , void * var853 );
__stdcall void * EnableScrollBar __attribute__((dllimport))(void * var854 , void * var855 , void * var856 );
__stdcall void * EnableWindow __attribute__((dllimport))(void * var857 , void * var858 );
__stdcall void * EndDeferWindowPos __attribute__((dllimport))(void * var859 );
__stdcall void * EndDialog __attribute__((dllimport))(void * var860 , void * var861 );
__stdcall void * EndDoc __attribute__((dllimport))(void * var862 );
__stdcall void * EndPage __attribute__((dllimport))(void * var863 );
__stdcall void * EndPath __attribute__((dllimport))(void * var864 );
__stdcall void * EqualDomainSid __attribute__((dllimport))(void * var865 , void * var866 , void * var867 );
__stdcall void * EqualPrefixSid __attribute__((dllimport))(void * var868 , void * var869 );
__stdcall void * EqualRgn __attribute__((dllimport))(void * var870 , void * var871 );
__stdcall void * EqualSid __attribute__((dllimport))(void * var872 , void * var873 );
__stdcall void * Escape __attribute__((dllimport))(void * var874 , void * var875 , void * var876 , void * var877 , void * var878 );
__stdcall void * ExcludeClipRect __attribute__((dllimport))(void * var879 , void * var880 , void * var881 , void * var882 , void * var883 );
__stdcall void * ExcludeUpdateRgn __attribute__((dllimport))(void * var884 , void * var885 );
__stdcall void * ExpandEnvironmentStringsA __attribute__((dllimport))(void * var886 , void * var887 , void * var888 );
__stdcall void * ExtEscape __attribute__((dllimport))(void * var889 , void * var890 , void * var891 , void * var892 , void * var893 , void * var894 );
__stdcall void * ExtFloodFill __attribute__((dllimport))(void * var895 , void * var896 , void * var897 , void * var898 , void * var899 );
__stdcall void * ExtSelectClipRgn __attribute__((dllimport))(void * var900 , void * var901 , void * var902 );
__stdcall void * FatalAppExitA __attribute__((dllimport))(void * var903 , void * var904 );
__stdcall void * FillPath __attribute__((dllimport))(void * var905 );
__stdcall void * FillRgn __attribute__((dllimport))(void * var906 , void * var907 , void * var908 );
__stdcall void * FindAtomA __attribute__((dllimport))(void * var909 );
__stdcall void * FindFirstChangeNotificationA __attribute__((dllimport))(void * var910 , void * var911 , void * var912 );
__stdcall void * FindFirstFileExA __attribute__((dllimport))(void * var913 , void * var914 , void * var915 , void * var916 , void * var917 , void * var918 );
__stdcall void * FindWindowA __attribute__((dllimport))(void * var919 , void * var920 );
__stdcall void * FindWindowExA __attribute__((dllimport))(void * var921 , void * var922 , void * var923 , void * var924 );
__stdcall void * FlashWindow __attribute__((dllimport))(void * var925 , void * var926 );
__stdcall void * FlattenPath __attribute__((dllimport))(void * var927 );
__stdcall void * FloodFill __attribute__((dllimport))(void * var928 , void * var929 , void * var930 , void * var931 );
__stdcall void * FlushInstructionCache __attribute__((dllimport))(void * var932 , void * var933 , void * var934 );
__stdcall void * FlushViewOfFile __attribute__((dllimport))(void * var935 , void * var936 );
__stdcall void * FormatMessageA __attribute__((dllimport))(void * var937 , void * var938 , void * var939 , void * var940 , void * var941 , void * var942 , void * var943 );
__stdcall void * FrameRgn __attribute__((dllimport))(void * var944 , void * var945 , void * var946 , void * var947 , void * var948 );
__stdcall void * FreeEnvironmentStringsA __attribute__((dllimport))(void * var949 );
__stdcall void * FreeResource __attribute__((dllimport))(void * var950 );
__stdcall void * FreeSid __attribute__((dllimport))(void * var951 );
__stdcall void * GdiComment __attribute__((dllimport))(void * var952 , void * var953 , void * var954 );
__stdcall void * GdiTransparentBlt __attribute__((dllimport))(void * var955 , void * var956 , void * var957 , void * var958 , void * var959 , void * var960 , void * var961 , void * var962 , void * var963 , void * var964 , void * var965 );
__stdcall void * GetActiveWindow __attribute__((dllimport))(void * var966 );
__stdcall void * GetAncestor __attribute__((dllimport))(void * var967 , void * var968 );
__stdcall void * GetArcDirection __attribute__((dllimport))(void * var969 );
__stdcall void * GetAtomNameA __attribute__((dllimport))(void * var970 , void * var971 , void * var972 );
__stdcall void * GetBinaryTypeA __attribute__((dllimport))(void * var973 , void * var974 );
__stdcall void * GetBitmapBits __attribute__((dllimport))(void * var975 , void * var976 , void * var977 );
__stdcall void * GetBkColor __attribute__((dllimport))(void * var978 );
__stdcall void * GetBkMode __attribute__((dllimport))(void * var979 );
__stdcall void * GetCapture __attribute__((dllimport))(void * var980 );
__stdcall void * GetCharWidth32A __attribute__((dllimport))(void * var981 , void * var982 , void * var983 , void * var984 );
__stdcall void * GetCharWidth32W __attribute__((dllimport))(void * var985 , void * var986 , void * var987 , void * var988 );
__stdcall void * GetCharWidthA __attribute__((dllimport))(void * var989 , void * var990 , void * var991 , void * var992 );
__stdcall void * GetCharWidthFloatA __attribute__((dllimport))(void * var993 , void * var994 , void * var995 , void * var996 );
__stdcall void * GetCharWidthW __attribute__((dllimport))(void * var997 , void * var998 , void * var999 , void * var1000 );
__stdcall void * GetClassLongA __attribute__((dllimport))(void * var1001 , void * var1002 );
__stdcall void * GetClassLongW __attribute__((dllimport))(void * var1003 , void * var1004 );
__stdcall void * GetClassNameA __attribute__((dllimport))(void * var1005 , void * var1006 , void * var1007 );
__stdcall void * GetClassWord __attribute__((dllimport))(void * var1008 , void * var1009 );
__stdcall void * GetClipRgn __attribute__((dllimport))(void * var1010 , void * var1011 );
__stdcall void * GetClipboardFormatNameA __attribute__((dllimport))(void * var1012 , void * var1013 , void * var1014 );
__stdcall void * GetClipboardOwner __attribute__((dllimport))(void * var1015 );
__stdcall void * GetClipboardViewer __attribute__((dllimport))(void * var1016 );
__stdcall void * GetCommMask __attribute__((dllimport))(void * var1017 , void * var1018 );
__stdcall void * GetCommModemStatus __attribute__((dllimport))(void * var1019 , void * var1020 );
__stdcall void * GetCommandLineA __attribute__((dllimport))(void * var1021 );
__stdcall void * GetCompressedFileSizeA __attribute__((dllimport))(void * var1022 , void * var1023 );
__stdcall void * GetComputerNameA __attribute__((dllimport))(void * var1024 , void * var1025 );
__stdcall void * GetComputerNameExA __attribute__((dllimport))(void * var1026 , void * var1027 , void * var1028 );
__stdcall void * GetConsoleDisplayMode __attribute__((dllimport))(void * var1029 );
__stdcall void * GetConsoleMode __attribute__((dllimport))(void * var1030 , void * var1031 );
__stdcall void * GetConsoleTitleA __attribute__((dllimport))(void * var1032 , void * var1033 );
__stdcall void * GetCurrentDirectoryA __attribute__((dllimport))(void * var1034 , void * var1035 );
__stdcall void * GetCurrentObject __attribute__((dllimport))(void * var1036 , void * var1037 );
__stdcall void * GetDC __attribute__((dllimport))(void * var1038 );
__stdcall void * GetDCEx __attribute__((dllimport))(void * var1039 , void * var1040 , void * var1041 );
__stdcall void * GetDesktopWindow __attribute__((dllimport))(void * var1042 );
__stdcall void * GetDeviceCaps __attribute__((dllimport))(void * var1043 , void * var1044 );
__stdcall void * GetDeviceGammaRamp __attribute__((dllimport))(void * var1045 , void * var1046 );
__stdcall void * GetDiskFreeSpaceA __attribute__((dllimport))(void * var1047 , void * var1048 , void * var1049 , void * var1050 , void * var1051 );
__stdcall void * GetDlgCtrlID __attribute__((dllimport))(void * var1052 );
__stdcall void * GetDlgItem __attribute__((dllimport))(void * var1053 , void * var1054 );
__stdcall void * GetDlgItemInt __attribute__((dllimport))(void * var1055 , void * var1056 , void * var1057 , void * var1058 );
__stdcall void * GetDlgItemTextA __attribute__((dllimport))(void * var1059 , void * var1060 , void * var1061 , void * var1062 );
__stdcall void * GetDriveTypeA __attribute__((dllimport))(void * var1063 );
__stdcall void * GetEnhMetaFileA __attribute__((dllimport))(void * var1064 );
__stdcall void * GetEnhMetaFileBits __attribute__((dllimport))(void * var1065 , void * var1066 , void * var1067 );
__stdcall void * GetEnhMetaFileDescriptionA __attribute__((dllimport))(void * var1068 , void * var1069 , void * var1070 );
__stdcall void * GetEnvironmentStrings __attribute__((dllimport))(void * var1071 );
__stdcall void * GetEnvironmentVariableA __attribute__((dllimport))(void * var1072 , void * var1073 , void * var1074 );
__stdcall void * GetEventLogInformation __attribute__((dllimport))(void * var1075 , void * var1076 , void * var1077 , void * var1078 , void * var1079 );
__stdcall void * GetExitCodeProcess __attribute__((dllimport))(void * var1080 , void * var1081 );
__stdcall void * GetExitCodeThread __attribute__((dllimport))(void * var1082 , void * var1083 );
__stdcall void * GetFileAttributesA __attribute__((dllimport))(void * var1084 );
__stdcall void * GetFileAttributesExA __attribute__((dllimport))(void * var1085 , void * var1086 , void * var1087 );
__stdcall void * GetFileSecurityA __attribute__((dllimport))(void * var1088 , void * var1089 , void * var1090 , void * var1091 , void * var1092 );
__stdcall void * GetFileSize __attribute__((dllimport))(void * var1093 , void * var1094 );
__stdcall void * GetFocus __attribute__((dllimport))(void * var1095 );
__stdcall void * GetFontData __attribute__((dllimport))(void * var1096 , void * var1097 , void * var1098 , void * var1099 , void * var1100 );
__stdcall void * GetFontLanguageInfo __attribute__((dllimport))(void * var1101 );
__stdcall void * GetForegroundWindow __attribute__((dllimport))(void * var1102 );
__stdcall void * GetFullPathNameA __attribute__((dllimport))(void * var1103 , void * var1104 , void * var1105 , void * var1106 );
__stdcall void * GetGraphicsMode __attribute__((dllimport))(void * var1107 );
__stdcall void * GetHandleInformation __attribute__((dllimport))(void * var1108 , void * var1109 );
__stdcall void * GetICMProfileA __attribute__((dllimport))(void * var1110 , void * var1111 , void * var1112 );
__stdcall void * GetKernelObjectSecurity __attribute__((dllimport))(void * var1113 , void * var1114 , void * var1115 , void * var1116 , void * var1117 );
__stdcall void * GetKeyNameTextA __attribute__((dllimport))(void * var1118 , void * var1119 , void * var1120 );
__stdcall void * GetKeyboardLayout __attribute__((dllimport))(void * var1121 );
__stdcall void * GetKeyboardLayoutList __attribute__((dllimport))(void * var1122 , void * var1123 );
__stdcall void * GetKeyboardLayoutNameA __attribute__((dllimport))(void * var1124 );
__stdcall void * GetKeyboardState __attribute__((dllimport))(void * var1125 );
__stdcall void * GetLastActivePopup __attribute__((dllimport))(void * var1126 );
__stdcall void * GetLayout __attribute__((dllimport))(void * var1127 );
__stdcall void * GetLengthSid __attribute__((dllimport))(void * var1128 );
__stdcall void * GetLocaleInfoA __attribute__((dllimport))(void * var1129 , void * var1130 , void * var1131 , void * var1132 );
__stdcall void * GetLogicalDriveStringsA __attribute__((dllimport))(void * var1133 , void * var1134 );
__stdcall void * GetLongPathNameA __attribute__((dllimport))(void * var1135 , void * var1136 , void * var1137 );
__stdcall void * GetMailslotInfo __attribute__((dllimport))(void * var1138 , void * var1139 , void * var1140 , void * var1141 , void * var1142 );
__stdcall void * GetMapMode __attribute__((dllimport))(void * var1143 );
__stdcall void * GetMenu __attribute__((dllimport))(void * var1144 );
__stdcall void * GetMenuContextHelpId __attribute__((dllimport))(void * var1145 );
__stdcall void * GetMenuDefaultItem __attribute__((dllimport))(void * var1146 , void * var1147 , void * var1148 );
__stdcall void * GetMenuItemCount __attribute__((dllimport))(void * var1149 );
__stdcall void * GetMenuItemID __attribute__((dllimport))(void * var1150 , void * var1151 );
__stdcall void * GetMenuState __attribute__((dllimport))(void * var1152 , void * var1153 , void * var1154 );
__stdcall void * GetMenuStringA __attribute__((dllimport))(void * var1155 , void * var1156 , void * var1157 , void * var1158 , void * var1159 );
__stdcall void * GetMessageExtraInfo __attribute__((dllimport))(void * var1160 );
__stdcall void * GetMetaFileA __attribute__((dllimport))(void * var1161 );
__stdcall void * GetMetaFileBitsEx __attribute__((dllimport))(void * var1162 , void * var1163 , void * var1164 );
__stdcall void * GetMiterLimit __attribute__((dllimport))(void * var1165 , void * var1166 );
__stdcall void * GetNamedPipeHandleStateA __attribute__((dllimport))(void * var1167 , void * var1168 , void * var1169 , void * var1170 , void * var1171 , void * var1172 , void * var1173 );
__stdcall void * GetNamedPipeInfo __attribute__((dllimport))(void * var1174 , void * var1175 , void * var1176 , void * var1177 , void * var1178 );
__stdcall void * GetNearestColor __attribute__((dllimport))(void * var1179 , void * var1180 );
__stdcall void * GetNearestPaletteIndex __attribute__((dllimport))(void * var1181 , void * var1182 );
__stdcall void * GetNextDlgGroupItem __attribute__((dllimport))(void * var1183 , void * var1184 , void * var1185 );
__stdcall void * GetNextDlgTabItem __attribute__((dllimport))(void * var1186 , void * var1187 , void * var1188 );
__stdcall void * GetNumberOfConsoleInputEvents __attribute__((dllimport))(void * var1189 , void * var1190 );
__stdcall void * GetNumberOfEventLogRecords __attribute__((dllimport))(void * var1191 , void * var1192 );
__stdcall void * GetOldestEventLogRecord __attribute__((dllimport))(void * var1193 , void * var1194 );
__stdcall void * GetOpenClipboardWindow __attribute__((dllimport))(void * var1195 );
__stdcall void * GetParent __attribute__((dllimport))(void * var1196 );
__stdcall void * GetPixel __attribute__((dllimport))(void * var1197 , void * var1198 , void * var1199 );
__stdcall void * GetPixelFormat __attribute__((dllimport))(void * var1200 );
__stdcall void * GetPolyFillMode __attribute__((dllimport))(void * var1201 );
__stdcall void * GetPrivateObjectSecurity __attribute__((dllimport))(void * var1202 , void * var1203 , void * var1204 , void * var1205 , void * var1206 );
__stdcall void * GetPrivateProfileIntA __attribute__((dllimport))(void * var1207 , void * var1208 , void * var1209 , void * var1210 );
__stdcall void * GetPrivateProfileSectionA __attribute__((dllimport))(void * var1211 , void * var1212 , void * var1213 , void * var1214 );
__stdcall void * GetPrivateProfileSectionNamesA __attribute__((dllimport))(void * var1215 , void * var1216 , void * var1217 );
__stdcall void * GetPrivateProfileStringA __attribute__((dllimport))(void * var1218 , void * var1219 , void * var1220 , void * var1221 , void * var1222 , void * var1223 );
__stdcall void * GetPrivateProfileStructA __attribute__((dllimport))(void * var1224 , void * var1225 , void * var1226 , void * var1227 , void * var1228 );
__stdcall void * GetProcessAffinityMask __attribute__((dllimport))(void * var1229 , void * var1230 , void * var1231 );
__stdcall void * GetProcessShutdownParameters __attribute__((dllimport))(void * var1232 , void * var1233 );
__stdcall void * GetProcessWindowStation __attribute__((dllimport))(void * var1234 );
__stdcall void * GetProcessWorkingSetSize __attribute__((dllimport))(void * var1235 , void * var1236 , void * var1237 );
__stdcall void * GetProfileIntA __attribute__((dllimport))(void * var1238 , void * var1239 , void * var1240 );
__stdcall void * GetProfileSectionA __attribute__((dllimport))(void * var1241 , void * var1242 , void * var1243 );
__stdcall void * GetProfileStringA __attribute__((dllimport))(void * var1244 , void * var1245 , void * var1246 , void * var1247 , void * var1248 );
__stdcall void * GetPropA __attribute__((dllimport))(void * var1249 , void * var1250 );
__stdcall void * GetROP2 __attribute__((dllimport))(void * var1251 );
__stdcall void * GetRandomRgn __attribute__((dllimport))(void * var1252 , void * var1253 , void * var1254 );
__stdcall void * GetRasterizerCaps __attribute__((dllimport))(void * var1255 , void * var1256 );
__stdcall void * GetRawInputData __attribute__((dllimport))(void * var1257 , void * var1258 , void * var1259 , void * var1260 , void * var1261 );
__stdcall void * GetScrollPos __attribute__((dllimport))(void * var1262 , void * var1263 );
__stdcall void * GetScrollRange __attribute__((dllimport))(void * var1264 , void * var1265 , void * var1266 , void * var1267 );
__stdcall void * GetSecurityDescriptorControl __attribute__((dllimport))(void * var1268 , void * var1269 , void * var1270 );
__stdcall void * GetSecurityDescriptorGroup __attribute__((dllimport))(void * var1271 , void * var1272 , void * var1273 );
__stdcall void * GetSecurityDescriptorLength __attribute__((dllimport))(void * var1274 );
__stdcall void * GetSecurityDescriptorOwner __attribute__((dllimport))(void * var1275 , void * var1276 , void * var1277 );
__stdcall void * GetServiceDisplayNameA __attribute__((dllimport))(void * var1278 , void * var1279 , void * var1280 , void * var1281 );
__stdcall void * GetServiceKeyNameA __attribute__((dllimport))(void * var1282 , void * var1283 , void * var1284 , void * var1285 );
__stdcall void * GetShellWindow __attribute__((dllimport))(void * var1286 );
__stdcall void * GetShortPathNameA __attribute__((dllimport))(void * var1287 , void * var1288 , void * var1289 );
__stdcall void * GetSidSubAuthority __attribute__((dllimport))(void * var1290 , void * var1291 );
__stdcall void * GetSidSubAuthorityCount __attribute__((dllimport))(void * var1292 );
__stdcall void * GetStretchBltMode __attribute__((dllimport))(void * var1293 );
__stdcall void * GetStringTypeA __attribute__((dllimport))(void * var1294 , void * var1295 , void * var1296 , void * var1297 , void * var1298 );
__stdcall void * GetStringTypeExA __attribute__((dllimport))(void * var1299 , void * var1300 , void * var1301 , void * var1302 , void * var1303 );
__stdcall void * GetSubMenu __attribute__((dllimport))(void * var1304 , void * var1305 );
__stdcall void * GetSysColorBrush __attribute__((dllimport))(void * var1306 );
__stdcall void * GetSystemDefaultLCID __attribute__((dllimport))(void * var1307 );
__stdcall void * GetSystemDefaultLangID __attribute__((dllimport))(void * var1308 );
__stdcall void * GetSystemDefaultUILanguage __attribute__((dllimport))(void * var1309 );
__stdcall void * GetSystemDirectoryA __attribute__((dllimport))(void * var1310 , void * var1311 );
__stdcall void * GetSystemMenu __attribute__((dllimport))(void * var1312 , void * var1313 );
__stdcall void * GetSystemPaletteUse __attribute__((dllimport))(void * var1314 );
__stdcall void * GetSystemTimeAdjustment __attribute__((dllimport))(void * var1315 , void * var1316 , void * var1317 );
__stdcall void * GetSystemWindowsDirectoryA __attribute__((dllimport))(void * var1318 , void * var1319 );
__stdcall void * GetTabbedTextExtentA __attribute__((dllimport))(void * var1320 , void * var1321 , void * var1322 , void * var1323 , void * var1324 );
__stdcall void * GetTapeParameters __attribute__((dllimport))(void * var1325 , void * var1326 , void * var1327 , void * var1328 );
__stdcall void * GetTapePosition __attribute__((dllimport))(void * var1329 , void * var1330 , void * var1331 , void * var1332 , void * var1333 );
__stdcall void * GetTempFileNameA __attribute__((dllimport))(void * var1334 , void * var1335 , void * var1336 , void * var1337 );
__stdcall void * GetTempPathA __attribute__((dllimport))(void * var1338 , void * var1339 );
__stdcall void * GetTextAlign __attribute__((dllimport))(void * var1340 );
__stdcall void * GetTextCharacterExtra __attribute__((dllimport))(void * var1341 );
__stdcall void * GetTextCharset __attribute__((dllimport))(void * var1342 );
__stdcall void * GetTextColor __attribute__((dllimport))(void * var1343 );
__stdcall void * GetTextFaceA __attribute__((dllimport))(void * var1344 , void * var1345 , void * var1346 );
__stdcall void * GetThreadDesktop __attribute__((dllimport))(void * var1347 );
__stdcall void * GetThreadLocale __attribute__((dllimport))(void * var1348 );
__stdcall void * GetTokenInformation __attribute__((dllimport))(void * var1349 , void * var1350 , void * var1351 , void * var1352 , void * var1353 );
__stdcall void * GetTopWindow __attribute__((dllimport))(void * var1354 );
__stdcall void * GetUpdateRgn __attribute__((dllimport))(void * var1355 , void * var1356 , void * var1357 );
__stdcall void * GetUserDefaultLCID __attribute__((dllimport))(void * var1358 );
__stdcall void * GetUserDefaultLangID __attribute__((dllimport))(void * var1359 );
__stdcall void * GetUserDefaultUILanguage __attribute__((dllimport))(void * var1360 );
__stdcall void * GetUserGeoID __attribute__((dllimport))(void * var1361 );
__stdcall void * GetUserNameA __attribute__((dllimport))(void * var1362 , void * var1363 );
__stdcall void * GetUserObjectInformationA __attribute__((dllimport))(void * var1364 , void * var1365 , void * var1366 , void * var1367 , void * var1368 );
__stdcall void * GetUserObjectInformationW __attribute__((dllimport))(void * var1369 , void * var1370 , void * var1371 , void * var1372 , void * var1373 );
__stdcall void * GetUserObjectSecurity __attribute__((dllimport))(void * var1374 , void * var1375 , void * var1376 , void * var1377 , void * var1378 );
__stdcall void * GetVolumeInformationA __attribute__((dllimport))(void * var1379 , void * var1380 , void * var1381 , void * var1382 , void * var1383 , void * var1384 , void * var1385 , void * var1386 );
__stdcall void * GetVolumeNameForVolumeMountPointA __attribute__((dllimport))(void * var1387 , void * var1388 , void * var1389 );
__stdcall void * GetWinMetaFileBits __attribute__((dllimport))(void * var1390 , void * var1391 , void * var1392 , void * var1393 , void * var1394 );
__stdcall void * GetWindow __attribute__((dllimport))(void * var1395 , void * var1396 );
__stdcall void * GetWindowContextHelpId __attribute__((dllimport))(void * var1397 );
__stdcall void * GetWindowDC __attribute__((dllimport))(void * var1398 );
__stdcall void * GetWindowLongA __attribute__((dllimport))(void * var1399 , void * var1400 );
__stdcall void * GetWindowLongW __attribute__((dllimport))(void * var1401 , void * var1402 );
__stdcall void * GetWindowRgn __attribute__((dllimport))(void * var1403 , void * var1404 );
__stdcall void * GetWindowTextA __attribute__((dllimport))(void * var1405 , void * var1406 , void * var1407 );
__stdcall void * GetWindowTextLengthA __attribute__((dllimport))(void * var1408 );
__stdcall void * GetWindowTextLengthW __attribute__((dllimport))(void * var1409 );
__stdcall void * GetWindowThreadProcessId __attribute__((dllimport))(void * var1410 , void * var1411 );
__stdcall void * GetWindowWord __attribute__((dllimport))(void * var1412 , void * var1413 );
__stdcall void * GetWindowsAccountDomainSid __attribute__((dllimport))(void * var1414 , void * var1415 , void * var1416 );
__stdcall void * GetWindowsDirectoryA __attribute__((dllimport))(void * var1417 , void * var1418 );
__stdcall void * GlobalAddAtomA __attribute__((dllimport))(void * var1419 );
__stdcall void * GlobalAlloc __attribute__((dllimport))(void * var1420 , void * var1421 );
__stdcall void * GlobalCompact __attribute__((dllimport))(void * var1422 );
__stdcall void * GlobalDeleteAtom __attribute__((dllimport))(void * var1423 );
__stdcall void * GlobalFindAtomA __attribute__((dllimport))(void * var1424 );
__stdcall void * GlobalFlags __attribute__((dllimport))(void * var1425 );
__stdcall void * GlobalFree __attribute__((dllimport))(void * var1426 );
__stdcall void * GlobalGetAtomNameA __attribute__((dllimport))(void * var1427 , void * var1428 , void * var1429 );
__stdcall void * GlobalHandle __attribute__((dllimport))(void * var1430 );
__stdcall void * GlobalLock __attribute__((dllimport))(void * var1431 );
__stdcall void * GlobalReAlloc __attribute__((dllimport))(void * var1432 , void * var1433 , void * var1434 );
__stdcall void * GlobalSize __attribute__((dllimport))(void * var1435 );
__stdcall void * GlobalUnlock __attribute__((dllimport))(void * var1436 );
__stdcall void * HeapAlloc __attribute__((dllimport))(void * var1437 , void * var1438 , void * var1439 );
__stdcall void * HeapCompact __attribute__((dllimport))(void * var1440 , void * var1441 );
__stdcall void * HeapCreate __attribute__((dllimport))(void * var1442 , void * var1443 , void * var1444 );
__stdcall void * HeapReAlloc __attribute__((dllimport))(void * var1445 , void * var1446 , void * var1447 , void * var1448 );
__stdcall void * HeapSetInformation __attribute__((dllimport))(void * var1449 , void * var1450 , void * var1451 , void * var1452 );
__stdcall void * HeapSize __attribute__((dllimport))(void * var1453 , void * var1454 , void * var1455 );
__stdcall void * HideCaret __attribute__((dllimport))(void * var1456 );
__stdcall void * HiliteMenuItem __attribute__((dllimport))(void * var1457 , void * var1458 , void * var1459 , void * var1460 );
__stdcall void * ImpersonateSelf __attribute__((dllimport))(void * var1461 );
__stdcall void * InitializeSecurityDescriptor __attribute__((dllimport))(void * var1462 , void * var1463 );
__stdcall void * InitiateSystemShutdownA __attribute__((dllimport))(void * var1464 , void * var1465 , void * var1466 , void * var1467 , void * var1468 );
__stdcall void * InsertMenuA __attribute__((dllimport))(void * var1469 , void * var1470 , void * var1471 , void * var1472 , void * var1473 );
__stdcall void * IntersectClipRect __attribute__((dllimport))(void * var1474 , void * var1475 , void * var1476 , void * var1477 , void * var1478 );
__stdcall void * InvalidateRgn __attribute__((dllimport))(void * var1479 , void * var1480 , void * var1481 );
__stdcall void * InvertRgn __attribute__((dllimport))(void * var1482 , void * var1483 );
__stdcall void * IsBadStringPtrA __attribute__((dllimport))(void * var1484 , void * var1485 );
__stdcall void * IsCharAlphaNumericW __attribute__((dllimport))(void * var1486 );
__stdcall void * IsCharAlphaW __attribute__((dllimport))(void * var1487 );
__stdcall void * IsCharLowerW __attribute__((dllimport))(void * var1488 );
__stdcall void * IsCharUpperW __attribute__((dllimport))(void * var1489 );
__stdcall void * IsChild __attribute__((dllimport))(void * var1490 , void * var1491 );
__stdcall void * IsDlgButtonChecked __attribute__((dllimport))(void * var1492 , void * var1493 );
__stdcall void * IsHungAppWindow __attribute__((dllimport))(void * var1494 );
__stdcall void * IsIconic __attribute__((dllimport))(void * var1495 );
__stdcall void * IsMenu __attribute__((dllimport))(void * var1496 );
__stdcall void * IsValidLanguageGroup __attribute__((dllimport))(void * var1497 , void * var1498 );
__stdcall void * IsValidLocale __attribute__((dllimport))(void * var1499 , void * var1500 );
__stdcall void * IsValidSecurityDescriptor __attribute__((dllimport))(void * var1501 );
__stdcall void * IsValidSid __attribute__((dllimport))(void * var1502 );
__stdcall void * IsWellKnownSid __attribute__((dllimport))(void * var1503 , void * var1504 );
__stdcall void * IsWindow __attribute__((dllimport))(void * var1505 );
__stdcall void * IsWindowEnabled __attribute__((dllimport))(void * var1506 );
__stdcall void * IsWindowUnicode __attribute__((dllimport))(void * var1507 );
__stdcall void * IsWindowVisible __attribute__((dllimport))(void * var1508 );
__stdcall void * IsWow64Process __attribute__((dllimport))(void * var1509 , void * var1510 );
__stdcall void * IsZoomed __attribute__((dllimport))(void * var1511 );
__stdcall void * KillTimer __attribute__((dllimport))(void * var1512 , void * var1513 );
__stdcall void * LCMapStringA __attribute__((dllimport))(void * var1514 , void * var1515 , void * var1516 , void * var1517 , void * var1518 , void * var1519 );
__stdcall void * LineTo __attribute__((dllimport))(void * var1520 , void * var1521 , void * var1522 );
__stdcall void * LoadAcceleratorsA __attribute__((dllimport))(void * var1523 , void * var1524 );
__stdcall void * LoadBitmapA __attribute__((dllimport))(void * var1525 , void * var1526 );
__stdcall void * LoadIconA __attribute__((dllimport))(void * var1527 , void * var1528 );
__stdcall void * LoadImageA __attribute__((dllimport))(void * var1529 , void * var1530 , void * var1531 , void * var1532 , void * var1533 , void * var1534 );
__stdcall void * LoadKeyboardLayoutA __attribute__((dllimport))(void * var1535 , void * var1536 );
__stdcall void * LoadMenuA __attribute__((dllimport))(void * var1537 , void * var1538 );
__stdcall void * LoadMenuIndirectA __attribute__((dllimport))(void * var1539 );
__stdcall void * LoadStringA __attribute__((dllimport))(void * var1540 , void * var1541 , void * var1542 , void * var1543 );
__stdcall void * LocalAlloc __attribute__((dllimport))(void * var1544 , void * var1545 );
__stdcall void * LocalFlags __attribute__((dllimport))(void * var1546 );
__stdcall void * LocalFree __attribute__((dllimport))(void * var1547 );
__stdcall void * LocalHandle __attribute__((dllimport))(void * var1548 );
__stdcall void * LocalLock __attribute__((dllimport))(void * var1549 );
__stdcall void * LocalReAlloc __attribute__((dllimport))(void * var1550 , void * var1551 , void * var1552 );
__stdcall void * LocalSize __attribute__((dllimport))(void * var1553 );
__stdcall void * LocalUnlock __attribute__((dllimport))(void * var1554 );
__stdcall void * LockResource __attribute__((dllimport))(void * var1555 );
__stdcall void * LockServiceDatabase __attribute__((dllimport))(void * var1556 );
__stdcall void * LockWindowUpdate __attribute__((dllimport))(void * var1557 );
__stdcall void * LogonUserA __attribute__((dllimport))(void * var1558 , void * var1559 , void * var1560 , void * var1561 , void * var1562 , void * var1563 );
__stdcall void * LookupAccountNameA __attribute__((dllimport))(void * var1564 , void * var1565 , void * var1566 , void * var1567 , void * var1568 , void * var1569 , void * var1570 );
__stdcall void * LookupAccountSidA __attribute__((dllimport))(void * var1571 , void * var1572 , void * var1573 , void * var1574 , void * var1575 , void * var1576 , void * var1577 );
__stdcall void * LookupIconIdFromDirectory __attribute__((dllimport))(void * var1578 , void * var1579 );
__stdcall void * LookupIconIdFromDirectoryEx __attribute__((dllimport))(void * var1580 , void * var1581 , void * var1582 , void * var1583 , void * var1584 );
__stdcall void * LookupPrivilegeDisplayNameA __attribute__((dllimport))(void * var1585 , void * var1586 , void * var1587 , void * var1588 , void * var1589 );
__stdcall void * MakeSelfRelativeSD __attribute__((dllimport))(void * var1590 , void * var1591 , void * var1592 );
__stdcall void * MapViewOfFile __attribute__((dllimport))(void * var1593 , void * var1594 , void * var1595 , void * var1596 , void * var1597 );
__stdcall void * MapViewOfFileEx __attribute__((dllimport))(void * var1598 , void * var1599 , void * var1600 , void * var1601 , void * var1602 , void * var1603 );
__stdcall void * MapVirtualKeyExA __attribute__((dllimport))(void * var1604 , void * var1605 , void * var1606 );
__stdcall void * MapVirtualKeyExW __attribute__((dllimport))(void * var1607 , void * var1608 , void * var1609 );
__stdcall void * MaskBlt __attribute__((dllimport))(void * var1610 , void * var1611 , void * var1612 , void * var1613 , void * var1614 , void * var1615 , void * var1616 , void * var1617 , void * var1618 , void * var1619 , void * var1620 , void * var1621 );
__stdcall void * MessageBoxA __attribute__((dllimport))(void * var1622 , void * var1623 , void * var1624 , void * var1625 );
__stdcall void * MessageBoxExA __attribute__((dllimport))(void * var1626 , void * var1627 , void * var1628 , void * var1629 , void * var1630 );
__stdcall void * ModifyMenuA __attribute__((dllimport))(void * var1631 , void * var1632 , void * var1633 , void * var1634 , void * var1635 );
__stdcall void * MonitorFromWindow __attribute__((dllimport))(void * var1636 , void * var1637 );
__stdcall void * MoveFileA __attribute__((dllimport))(void * var1638 , void * var1639 );
__stdcall void * MoveFileExA __attribute__((dllimport))(void * var1640 , void * var1641 , void * var1642 );
__stdcall void * MoveWindow __attribute__((dllimport))(void * var1643 , void * var1644 , void * var1645 , void * var1646 , void * var1647 , void * var1648 );
__stdcall void * NotifyWinEvent __attribute__((dllimport))(void * var1649 , void * var1650 , void * var1651 , void * var1652 );
__stdcall void * NtQueryObject __attribute__((dllimport))(void * var1653 , void * var1654 , void * var1655 , void * var1656 , void * var1657 );
__stdcall void * ObjectCloseAuditAlarmA __attribute__((dllimport))(void * var1658 , void * var1659 , void * var1660 );
__stdcall void * OemToCharA __attribute__((dllimport))(void * var1661 , void * var1662 );
__stdcall void * OemToCharBuffA __attribute__((dllimport))(void * var1663 , void * var1664 , void * var1665 );
__stdcall void * OffsetClipRgn __attribute__((dllimport))(void * var1666 , void * var1667 , void * var1668 );
__stdcall void * OffsetRgn __attribute__((dllimport))(void * var1669 , void * var1670 , void * var1671 );
__stdcall void * OpenBackupEventLogA __attribute__((dllimport))(void * var1672 , void * var1673 );
__stdcall void * OpenClipboard __attribute__((dllimport))(void * var1674 );
__stdcall void * OpenDesktopA __attribute__((dllimport))(void * var1675 , void * var1676 , void * var1677 , void * var1678 );
__stdcall void * OpenEventA __attribute__((dllimport))(void * var1679 , void * var1680 , void * var1681 );
__stdcall void * OpenEventLogA __attribute__((dllimport))(void * var1682 , void * var1683 );
__stdcall void * OpenFileMappingA __attribute__((dllimport))(void * var1684 , void * var1685 , void * var1686 );
__stdcall void * OpenIcon __attribute__((dllimport))(void * var1687 );
__stdcall void * OpenInputDesktop __attribute__((dllimport))(void * var1688 , void * var1689 , void * var1690 );
__stdcall void * OpenMutexA __attribute__((dllimport))(void * var1691 , void * var1692 , void * var1693 );
__stdcall void * OpenProcessToken __attribute__((dllimport))(void * var1694 , void * var1695 , void * var1696 );
__stdcall void * OpenSCManagerA __attribute__((dllimport))(void * var1697 , void * var1698 , void * var1699 );
__stdcall void * OpenSemaphoreA __attribute__((dllimport))(void * var1700 , void * var1701 , void * var1702 );
__stdcall void * OpenServiceA __attribute__((dllimport))(void * var1703 , void * var1704 , void * var1705 );
__stdcall void * OpenThreadToken __attribute__((dllimport))(void * var1706 , void * var1707 , void * var1708 , void * var1709 );
__stdcall void * OpenWindowStationA __attribute__((dllimport))(void * var1710 , void * var1711 , void * var1712 );
__stdcall void * OutputDebugStringA __attribute__((dllimport))(void * var1713 );
__stdcall void * PaintDesktop __attribute__((dllimport))(void * var1714 );
__stdcall void * PaintRgn __attribute__((dllimport))(void * var1715 , void * var1716 );
__stdcall void * PatBlt __attribute__((dllimport))(void * var1717 , void * var1718 , void * var1719 , void * var1720 , void * var1721 , void * var1722 );
__stdcall void * PathToRegion __attribute__((dllimport))(void * var1723 );
__stdcall void * PeekNamedPipe __attribute__((dllimport))(void * var1724 , void * var1725 , void * var1726 , void * var1727 , void * var1728 , void * var1729 );
__stdcall void * Pie __attribute__((dllimport))(void * var1730 , void * var1731 , void * var1732 , void * var1733 , void * var1734 , void * var1735 , void * var1736 , void * var1737 , void * var1738 );
__stdcall void * PlayMetaFile __attribute__((dllimport))(void * var1739 , void * var1740 );
__stdcall void * PostMessageA __attribute__((dllimport))(void * var1741 , void * var1742 , void * var1743 , void * var1744 );
__stdcall void * PostMessageW __attribute__((dllimport))(void * var1745 , void * var1746 , void * var1747 , void * var1748 );
__stdcall void * PostThreadMessageA __attribute__((dllimport))(void * var1749 , void * var1750 , void * var1751 , void * var1752 );
__stdcall void * PostThreadMessageW __attribute__((dllimport))(void * var1753 , void * var1754 , void * var1755 , void * var1756 );
__stdcall void * PrintWindow __attribute__((dllimport))(void * var1757 , void * var1758 , void * var1759 );
__stdcall void * PtInRegion __attribute__((dllimport))(void * var1760 , void * var1761 , void * var1762 );
__stdcall void * PtVisible __attribute__((dllimport))(void * var1763 , void * var1764 , void * var1765 );
__stdcall void * QueryActCtxW __attribute__((dllimport))(void * var1766 , void * var1767 , void * var1768 , void * var1769 , void * var1770 , void * var1771 , void * var1772 );
__stdcall void * QueryDosDeviceA __attribute__((dllimport))(void * var1773 , void * var1774 , void * var1775 );
__stdcall void * QueryInformationJobObject __attribute__((dllimport))(void * var1776 , void * var1777 , void * var1778 , void * var1779 , void * var1780 );
__stdcall void * QueryServiceConfig2W __attribute__((dllimport))(void * var1781 , void * var1782 , void * var1783 , void * var1784 , void * var1785 );
__stdcall void * QueryServiceObjectSecurity __attribute__((dllimport))(void * var1786 , void * var1787 , void * var1788 , void * var1789 , void * var1790 );
__stdcall void * QueryServiceStatusEx __attribute__((dllimport))(void * var1791 , void * var1792 , void * var1793 , void * var1794 , void * var1795 );
__stdcall void * QueueUserAPC __attribute__((dllimport))(void * var1796 , void * var1797 , void * var1798 );
__stdcall void * ReadProcessMemory __attribute__((dllimport))(void * var1799 , void * var1800 , void * var1801 , void * var1802 , void * var1803 );
__stdcall void * RealGetWindowClassA __attribute__((dllimport))(void * var1804 , void * var1805 , void * var1806 );
__stdcall void * RealizePalette __attribute__((dllimport))(void * var1807 );
__stdcall void * Rectangle __attribute__((dllimport))(void * var1808 , void * var1809 , void * var1810 , void * var1811 , void * var1812 );
__stdcall void * RegCloseKey __attribute__((dllimport))(void * var1813 );
__stdcall void * RegDeleteKeyA __attribute__((dllimport))(void * var1814 , void * var1815 );
__stdcall void * RegDeleteValueA __attribute__((dllimport))(void * var1816 , void * var1817 );
__stdcall void * RegDisablePredefinedCache __attribute__((dllimport))(void * var1818 );
__stdcall void * RegEnumKeyA __attribute__((dllimport))(void * var1819 , void * var1820 , void * var1821 , void * var1822 );
__stdcall void * RegEnumValueA __attribute__((dllimport))(void * var1823 , void * var1824 , void * var1825 , void * var1826 , void * var1827 , void * var1828 , void * var1829 , void * var1830 );
__stdcall void * RegFlushKey __attribute__((dllimport))(void * var1831 );
__stdcall void * RegGetKeySecurity __attribute__((dllimport))(void * var1832 , void * var1833 , void * var1834 , void * var1835 );
__stdcall void * RegLoadKeyA __attribute__((dllimport))(void * var1836 , void * var1837 , void * var1838 );
__stdcall void * RegNotifyChangeKeyValue __attribute__((dllimport))(void * var1839 , void * var1840 , void * var1841 , void * var1842 , void * var1843 );
__stdcall void * RegOverridePredefKey __attribute__((dllimport))(void * var1844 , void * var1845 );
__stdcall void * RegQueryValueA __attribute__((dllimport))(void * var1846 , void * var1847 , void * var1848 , void * var1849 );
__stdcall void * RegQueryValueExA __attribute__((dllimport))(void * var1850 , void * var1851 , void * var1852 , void * var1853 , void * var1854 , void * var1855 );
__stdcall void * RegReplaceKeyA __attribute__((dllimport))(void * var1856 , void * var1857 , void * var1858 , void * var1859 );
__stdcall void * RegRestoreKeyA __attribute__((dllimport))(void * var1860 , void * var1861 , void * var1862 );
__stdcall void * RegSetKeySecurity __attribute__((dllimport))(void * var1863 , void * var1864 , void * var1865 );
__stdcall void * RegSetValueA __attribute__((dllimport))(void * var1866 , void * var1867 , void * var1868 , void * var1869 , void * var1870 );
__stdcall void * RegSetValueExA __attribute__((dllimport))(void * var1871 , void * var1872 , void * var1873 , void * var1874 , void * var1875 , void * var1876 );
__stdcall void * RegUnLoadKeyA __attribute__((dllimport))(void * var1877 , void * var1878 );
__stdcall void * RegisterClipboardFormatA __attribute__((dllimport))(void * var1879 );
__stdcall void * RegisterDeviceNotificationA __attribute__((dllimport))(void * var1880 , void * var1881 , void * var1882 );
__stdcall void * RegisterDeviceNotificationW __attribute__((dllimport))(void * var1883 , void * var1884 , void * var1885 );
__stdcall void * RegisterEventSourceA __attribute__((dllimport))(void * var1886 , void * var1887 );
__stdcall void * RegisterHotKey __attribute__((dllimport))(void * var1888 , void * var1889 , void * var1890 , void * var1891 );
__stdcall void * RegisterServiceCtrlHandlerA __attribute__((dllimport))(void * var1892 , void * var1893 );
__stdcall void * RegisterServiceCtrlHandlerExA __attribute__((dllimport))(void * var1894 , void * var1895 , void * var1896 );
__stdcall void * RegisterShellHookWindow __attribute__((dllimport))(void * var1897 );
__stdcall void * RegisterWindowMessageA __attribute__((dllimport))(void * var1898 );
__stdcall void * ReleaseDC __attribute__((dllimport))(void * var1899 , void * var1900 );
__stdcall void * RemoveDirectoryA __attribute__((dllimport))(void * var1901 );
__stdcall void * RemoveFontResourceA __attribute__((dllimport))(void * var1902 );
__stdcall void * RemoveMenu __attribute__((dllimport))(void * var1903 , void * var1904 , void * var1905 );
__stdcall void * RemovePropA __attribute__((dllimport))(void * var1906 , void * var1907 );
__stdcall void * ReplyMessage __attribute__((dllimport))(void * var1908 );
__stdcall void * ReportEventA __attribute__((dllimport))(void * var1909 , void * var1910 , void * var1911 , void * var1912 , void * var1913 , void * var1914 , void * var1915 , void * var1916 , void * var1917 );
__stdcall void * ResizePalette __attribute__((dllimport))(void * var1918 , void * var1919 );
__stdcall void * RestoreDC __attribute__((dllimport))(void * var1920 , void * var1921 );
__stdcall void * RoundRect __attribute__((dllimport))(void * var1922 , void * var1923 , void * var1924 , void * var1925 , void * var1926 , void * var1927 , void * var1928 );
__stdcall void * RtlCaptureStackBackTrace __attribute__((dllimport))(void * var1929 , void * var1930 , void * var1931 , void * var1932 );
__stdcall void * RtlCompareMemory __attribute__((dllimport))(void * var1933 , void * var1934 , void * var1935 );
__stdcall void * SaveDC __attribute__((dllimport))(void * var1936 );
__stdcall void * SearchPathA __attribute__((dllimport))(void * var1937 , void * var1938 , void * var1939 , void * var1940 , void * var1941 , void * var1942 );
__stdcall void * SelectClipPath __attribute__((dllimport))(void * var1943 , void * var1944 );
__stdcall void * SelectClipRgn __attribute__((dllimport))(void * var1945 , void * var1946 );
__stdcall void * SelectObject __attribute__((dllimport))(void * var1947 , void * var1948 );
__stdcall void * SelectPalette __attribute__((dllimport))(void * var1949 , void * var1950 , void * var1951 );
__stdcall void * SendDlgItemMessageA __attribute__((dllimport))(void * var1952 , void * var1953 , void * var1954 , void * var1955 , void * var1956 );
__stdcall void * SendDlgItemMessageW __attribute__((dllimport))(void * var1957 , void * var1958 , void * var1959 , void * var1960 , void * var1961 );
__stdcall void * SendMessageA __attribute__((dllimport))(void * var1962 , void * var1963 , void * var1964 , void * var1965 );
__stdcall void * SendMessageTimeoutA __attribute__((dllimport))(void * var1966 , void * var1967 , void * var1968 , void * var1969 , void * var1970 , void * var1971 , void * var1972 );
__stdcall void * SendMessageTimeoutW __attribute__((dllimport))(void * var1973 , void * var1974 , void * var1975 , void * var1976 , void * var1977 , void * var1978 , void * var1979 );
__stdcall void * SendMessageW __attribute__((dllimport))(void * var1980 , void * var1981 , void * var1982 , void * var1983 );
__stdcall void * SendNotifyMessageA __attribute__((dllimport))(void * var1984 , void * var1985 , void * var1986 , void * var1987 );
__stdcall void * SendNotifyMessageW __attribute__((dllimport))(void * var1988 , void * var1989 , void * var1990 , void * var1991 );
__stdcall void * SetActiveWindow __attribute__((dllimport))(void * var1992 );
__stdcall void * SetArcDirection __attribute__((dllimport))(void * var1993 , void * var1994 );
__stdcall void * SetBitmapBits __attribute__((dllimport))(void * var1995 , void * var1996 , void * var1997 );
__stdcall void * SetBkColor __attribute__((dllimport))(void * var1998 , void * var1999 );
__stdcall void * SetBkMode __attribute__((dllimport))(void * var2000 , void * var2001 );
__stdcall void * SetCapture __attribute__((dllimport))(void * var2002 );
__stdcall void * SetClassLongA __attribute__((dllimport))(void * var2003 , void * var2004 , void * var2005 );
__stdcall void * SetClassLongW __attribute__((dllimport))(void * var2006 , void * var2007 , void * var2008 );
__stdcall void * SetClassWord __attribute__((dllimport))(void * var2009 , void * var2010 , void * var2011 );
__stdcall void * SetClipboardViewer __attribute__((dllimport))(void * var2012 );
__stdcall void * SetColorSpace __attribute__((dllimport))(void * var2013 , void * var2014 );
__stdcall void * SetComputerNameA __attribute__((dllimport))(void * var2015 );
__stdcall void * SetConsoleCtrlHandler __attribute__((dllimport))(void * var2016 , void * var2017 );
__stdcall void * SetConsoleTitleA __attribute__((dllimport))(void * var2018 );
__stdcall void * SetCurrentDirectoryA __attribute__((dllimport))(void * var2019 );
__stdcall void * SetDCBrushColor __attribute__((dllimport))(void * var2020 , void * var2021 );
__stdcall void * SetDlgItemInt __attribute__((dllimport))(void * var2022 , void * var2023 , void * var2024 , void * var2025 );
__stdcall void * SetDlgItemTextA __attribute__((dllimport))(void * var2026 , void * var2027 , void * var2028 );
__stdcall void * SetEnhMetaFileBits __attribute__((dllimport))(void * var2029 , void * var2030 );
__stdcall void * SetEnvironmentVariableA __attribute__((dllimport))(void * var2031 , void * var2032 );
__stdcall void * SetFileAttributesA __attribute__((dllimport))(void * var2033 , void * var2034 );
__stdcall void * SetFilePointer __attribute__((dllimport))(void * var2035 , void * var2036 , void * var2037 , void * var2038 );
__stdcall void * SetFileSecurityA __attribute__((dllimport))(void * var2039 , void * var2040 , void * var2041 );
__stdcall void * SetFocus __attribute__((dllimport))(void * var2042 );
__stdcall void * SetForegroundWindow __attribute__((dllimport))(void * var2043 );
__stdcall void * SetGraphicsMode __attribute__((dllimport))(void * var2044 , void * var2045 );
__stdcall void * SetICMMode __attribute__((dllimport))(void * var2046 , void * var2047 );
__stdcall void * SetICMProfileA __attribute__((dllimport))(void * var2048 , void * var2049 );
__stdcall void * SetInformationJobObject __attribute__((dllimport))(void * var2050 , void * var2051 , void * var2052 , void * var2053 );
__stdcall void * SetKernelObjectSecurity __attribute__((dllimport))(void * var2054 , void * var2055 , void * var2056 );
__stdcall void * SetKeyboardState __attribute__((dllimport))(void * var2057 );
__stdcall void * SetLayeredWindowAttributes __attribute__((dllimport))(void * var2058 , void * var2059 , void * var2060 , void * var2061 );
__stdcall void * SetLayout __attribute__((dllimport))(void * var2062 , void * var2063 );
__stdcall void * SetLocaleInfoA __attribute__((dllimport))(void * var2064 , void * var2065 , void * var2066 );
__stdcall void * SetMapMode __attribute__((dllimport))(void * var2067 , void * var2068 );
__stdcall void * SetMapperFlags __attribute__((dllimport))(void * var2069 , void * var2070 );
__stdcall void * SetMenu __attribute__((dllimport))(void * var2071 , void * var2072 );
__stdcall void * SetMenuContextHelpId __attribute__((dllimport))(void * var2073 , void * var2074 );
__stdcall void * SetMenuDefaultItem __attribute__((dllimport))(void * var2075 , void * var2076 , void * var2077 );
__stdcall void * SetMenuItemBitmaps __attribute__((dllimport))(void * var2078 , void * var2079 , void * var2080 , void * var2081 , void * var2082 );
__stdcall void * SetMessageExtraInfo __attribute__((dllimport))(void * var2083 );
__stdcall void * SetMetaFileBitsEx __attribute__((dllimport))(void * var2084 , void * var2085 );
__stdcall void * SetMetaRgn __attribute__((dllimport))(void * var2086 );
__stdcall void * SetMiterLimit __attribute__((dllimport))(void * var2087 , void * var2088 , void * var2089 );
__stdcall void * SetNamedPipeHandleState __attribute__((dllimport))(void * var2090 , void * var2091 , void * var2092 , void * var2093 );
__stdcall void * SetParent __attribute__((dllimport))(void * var2094 , void * var2095 );
__stdcall void * SetPixel __attribute__((dllimport))(void * var2096 , void * var2097 , void * var2098 , void * var2099 );
__stdcall void * SetPixelV __attribute__((dllimport))(void * var2100 , void * var2101 , void * var2102 , void * var2103 );
__stdcall void * SetPolyFillMode __attribute__((dllimport))(void * var2104 , void * var2105 );
__stdcall void * SetProcessAffinityMask __attribute__((dllimport))(void * var2106 , void * var2107 );
__stdcall void * SetProcessWindowStation __attribute__((dllimport))(void * var2108 );
__stdcall void * SetProcessWorkingSetSize __attribute__((dllimport))(void * var2109 , void * var2110 , void * var2111 );
__stdcall void * SetPropA __attribute__((dllimport))(void * var2112 , void * var2113 , void * var2114 );
__stdcall void * SetROP2 __attribute__((dllimport))(void * var2115 , void * var2116 );
__stdcall void * SetRectRgn __attribute__((dllimport))(void * var2117 , void * var2118 , void * var2119 , void * var2120 , void * var2121 );
__stdcall void * SetScrollPos __attribute__((dllimport))(void * var2122 , void * var2123 , void * var2124 , void * var2125 );
__stdcall void * SetScrollRange __attribute__((dllimport))(void * var2126 , void * var2127 , void * var2128 , void * var2129 , void * var2130 );
__stdcall void * SetSecurityDescriptorControl __attribute__((dllimport))(void * var2131 , void * var2132 , void * var2133 );
__stdcall void * SetSecurityDescriptorGroup __attribute__((dllimport))(void * var2134 , void * var2135 , void * var2136 );
__stdcall void * SetSecurityDescriptorOwner __attribute__((dllimport))(void * var2137 , void * var2138 , void * var2139 );
__stdcall void * SetServiceObjectSecurity __attribute__((dllimport))(void * var2140 , void * var2141 , void * var2142 );
__stdcall void * SetStretchBltMode __attribute__((dllimport))(void * var2143 , void * var2144 );
__stdcall void * SetSysColors __attribute__((dllimport))(void * var2145 , void * var2146 , void * var2147 );
__stdcall void * SetSystemPaletteUse __attribute__((dllimport))(void * var2148 , void * var2149 );
__stdcall void * SetTextAlign __attribute__((dllimport))(void * var2150 , void * var2151 );
__stdcall void * SetTextCharacterExtra __attribute__((dllimport))(void * var2152 , void * var2153 );
__stdcall void * SetTextColor __attribute__((dllimport))(void * var2154 , void * var2155 );
__stdcall void * SetTextJustification __attribute__((dllimport))(void * var2156 , void * var2157 , void * var2158 );
__stdcall void * SetThreadAffinityMask __attribute__((dllimport))(void * var2159 , void * var2160 );
__stdcall void * SetThreadDesktop __attribute__((dllimport))(void * var2161 );
__stdcall void * SetThreadExecutionState __attribute__((dllimport))(void * var2162 );
__stdcall void * SetThreadLocale __attribute__((dllimport))(void * var2163 );
__stdcall void * SetThreadToken __attribute__((dllimport))(void * var2164 , void * var2165 );
__stdcall void * SetThreadUILanguage __attribute__((dllimport))(void * var2166 );
__stdcall void * SetTokenInformation __attribute__((dllimport))(void * var2167 , void * var2168 , void * var2169 , void * var2170 );
__stdcall void * SetUserGeoID __attribute__((dllimport))(void * var2171 );
__stdcall void * SetUserObjectSecurity __attribute__((dllimport))(void * var2172 , void * var2173 , void * var2174 );
__stdcall void * SetVolumeLabelA __attribute__((dllimport))(void * var2175 , void * var2176 );
__stdcall void * SetWindowContextHelpId __attribute__((dllimport))(void * var2177 , void * var2178 );
__stdcall void * SetWindowLongA __attribute__((dllimport))(void * var2179 , void * var2180 , void * var2181 );
__stdcall void * SetWindowLongW __attribute__((dllimport))(void * var2182 , void * var2183 , void * var2184 );
__stdcall void * SetWindowPos __attribute__((dllimport))(void * var2185 , void * var2186 , void * var2187 , void * var2188 , void * var2189 , void * var2190 , void * var2191 );
__stdcall void * SetWindowRgn __attribute__((dllimport))(void * var2192 , void * var2193 , void * var2194 );
__stdcall void * SetWindowTextA __attribute__((dllimport))(void * var2195 , void * var2196 );
__stdcall void * SetWindowWord __attribute__((dllimport))(void * var2197 , void * var2198 , void * var2199 );
__stdcall void * ShowCaret __attribute__((dllimport))(void * var2200 );
__stdcall void * ShowOwnedPopups __attribute__((dllimport))(void * var2201 , void * var2202 );
__stdcall void * ShowScrollBar __attribute__((dllimport))(void * var2203 , void * var2204 , void * var2205 );
__stdcall void * ShowWindow __attribute__((dllimport))(void * var2206 , void * var2207 );
__stdcall void * ShowWindowAsync __attribute__((dllimport))(void * var2208 , void * var2209 );
__stdcall void * StartPage __attribute__((dllimport))(void * var2210 );
__stdcall void * StartServiceA __attribute__((dllimport))(void * var2211 , void * var2212 , void * var2213 );
__stdcall void * StretchBlt __attribute__((dllimport))(void * var2214 , void * var2215 , void * var2216 , void * var2217 , void * var2218 , void * var2219 , void * var2220 , void * var2221 , void * var2222 , void * var2223 , void * var2224 );
__stdcall void * StrokeAndFillPath __attribute__((dllimport))(void * var2225 );
__stdcall void * StrokePath __attribute__((dllimport))(void * var2226 );
__stdcall void * SwapBuffers __attribute__((dllimport))(void * var2227 );
__stdcall void * SwitchDesktop __attribute__((dllimport))(void * var2228 );
__stdcall void * SwitchToThisWindow __attribute__((dllimport))(void * var2229 , void * var2230 );
__stdcall void * TabbedTextOutA __attribute__((dllimport))(void * var2231 , void * var2232 , void * var2233 , void * var2234 , void * var2235 , void * var2236 , void * var2237 , void * var2238 );
__stdcall void * TextOutA __attribute__((dllimport))(void * var2239 , void * var2240 , void * var2241 , void * var2242 , void * var2243 );
__stdcall void * ToAscii __attribute__((dllimport))(void * var2244 , void * var2245 , void * var2246 , void * var2247 , void * var2248 );
__stdcall void * ToAsciiEx __attribute__((dllimport))(void * var2249 , void * var2250 , void * var2251 , void * var2252 , void * var2253 , void * var2254 );
__stdcall void * TransparentBlt __attribute__((dllimport))(void * var2255 , void * var2256 , void * var2257 , void * var2258 , void * var2259 , void * var2260 , void * var2261 , void * var2262 , void * var2263 , void * var2264 , void * var2265 );
__stdcall void * UnhookWinEvent __attribute__((dllimport))(void * var2266 );
__stdcall void * UnhookWindowsHookEx __attribute__((dllimport))(void * var2267 );
__stdcall void * UnloadKeyboardLayout __attribute__((dllimport))(void * var2268 );
__stdcall void * UnlockServiceDatabase __attribute__((dllimport))(void * var2269 );
__stdcall void * UnregisterClassA __attribute__((dllimport))(void * var2270 , void * var2271 );
__stdcall void * UnregisterDeviceNotification __attribute__((dllimport))(void * var2272 );
__stdcall void * UnregisterHotKey __attribute__((dllimport))(void * var2273 , void * var2274 );
__stdcall void * UpdateColors __attribute__((dllimport))(void * var2275 );
__stdcall void * UpdateResourceA __attribute__((dllimport))(void * var2276 , void * var2277 , void * var2278 , void * var2279 , void * var2280 , void * var2281 );
__stdcall void * UpdateWindow __attribute__((dllimport))(void * var2282 );
__stdcall void * ValidateRgn __attribute__((dllimport))(void * var2283 , void * var2284 );
__stdcall void * VirtualAlloc __attribute__((dllimport))(void * var2285 , void * var2286 , void * var2287 , void * var2288 );
__stdcall void * VirtualAllocEx __attribute__((dllimport))(void * var2289 , void * var2290 , void * var2291 , void * var2292 , void * var2293 );
__stdcall void * VirtualFree __attribute__((dllimport))(void * var2294 , void * var2295 , void * var2296 );
__stdcall void * VirtualFreeEx __attribute__((dllimport))(void * var2297 , void * var2298 , void * var2299 , void * var2300 );
__stdcall void * VirtualLock __attribute__((dllimport))(void * var2301 , void * var2302 );
__stdcall void * VirtualProtect __attribute__((dllimport))(void * var2303 , void * var2304 , void * var2305 , void * var2306 );
__stdcall void * VirtualUnlock __attribute__((dllimport))(void * var2307 , void * var2308 );
__stdcall void * VkKeyScanExA __attribute__((dllimport))(void * var2309 , void * var2310 );
__stdcall void * VkKeyScanW __attribute__((dllimport))(void * var2311 );
__stdcall void * WaitNamedPipeA __attribute__((dllimport))(void * var2312 , void * var2313 );
__stdcall void * WidenPath __attribute__((dllimport))(void * var2314 );
__stdcall void * WinExec __attribute__((dllimport))(void * var2315 , void * var2316 );
__stdcall void * WinHelpA __attribute__((dllimport))(void * var2317 , void * var2318 , void * var2319 , void * var2320 );
__stdcall void * WindowFromDC __attribute__((dllimport))(void * var2321 );
__stdcall void * WriteConsoleA __attribute__((dllimport))(void * var2322 , void * var2323 , void * var2324 , void * var2325 , void * var2326 );
__stdcall void * WriteConsoleW __attribute__((dllimport))(void * var2327 , void * var2328 , void * var2329 , void * var2330 , void * var2331 );
__stdcall void * WritePrivateProfileSectionA __attribute__((dllimport))(void * var2332 , void * var2333 , void * var2334 );
__stdcall void * WritePrivateProfileStringA __attribute__((dllimport))(void * var2335 , void * var2336 , void * var2337 , void * var2338 );
__stdcall void * WritePrivateProfileStructA __attribute__((dllimport))(void * var2339 , void * var2340 , void * var2341 , void * var2342 , void * var2343 );
__stdcall void * WriteProcessMemory __attribute__((dllimport))(void * var2344 , void * var2345 , void * var2346 , void * var2347 , void * var2348 );
__stdcall void * WriteProfileSectionA __attribute__((dllimport))(void * var2349 , void * var2350 );
__stdcall void * WriteProfileStringA __attribute__((dllimport))(void * var2351 , void * var2352 , void * var2353 );
__stdcall void * _hwrite __attribute__((dllimport))(void * var2354 , void * var2355 , void * var2356 );
__stdcall void * _lcreat __attribute__((dllimport))(void * var2357 , void * var2358 );
__stdcall void * _lopen __attribute__((dllimport))(void * var2359 , void * var2360 );
__stdcall void * _lwrite __attribute__((dllimport))(void * var2361 , void * var2362 , void * var2363 );
__stdcall void * lstrcatA __attribute__((dllimport))(void * var2364 , void * var2365 );
__stdcall void * lstrcmpA __attribute__((dllimport))(void * var2366 , void * var2367 );
__stdcall void * lstrcmpiA __attribute__((dllimport))(void * var2368 , void * var2369 );
__stdcall void * lstrcpyA __attribute__((dllimport))(void * var2370 , void * var2371 );
__stdcall void * lstrcpynA __attribute__((dllimport))(void * var2372 , void * var2373 , void * var2374 );
__stdcall void * lstrlenA __attribute__((dllimport))(void * var2375 );
__stdcall void * wvsprintfA __attribute__((dllimport))(void * var2376 , void * var2377 , void * var2378 );
__stdcall void * AbortSystemShutdownW __attribute__((dllimport))(void * var2379 );
__stdcall void * AddAtomW __attribute__((dllimport))(void * var2380 );
__stdcall void * AddConsoleAliasW __attribute__((dllimport))(void * var2381 , void * var2382 , void * var2383 );
__stdcall void * AddFontResourceExW __attribute__((dllimport))(void * var2384 , void * var2385 , void * var2386 );
__stdcall void * AddFontResourceW __attribute__((dllimport))(void * var2387 );
__stdcall void * AdjustWindowRect __attribute__((dllimport))(void * var2388 , void * var2389 , void * var2390 );
__stdcall void * AdjustWindowRectEx __attribute__((dllimport))(void * var2391 , void * var2392 , void * var2393 , void * var2394 );
__stdcall void * AllocateAndInitializeSid __attribute__((dllimport))(void * var2395 , void * var2396 , void * var2397 , void * var2398 , void * var2399 , void * var2400 , void * var2401 , void * var2402 , void * var2403 , void * var2404 , void * var2405 );
__stdcall void * AllocateLocallyUniqueId __attribute__((dllimport))(void * var2406 );
__stdcall void * AlphaBlend __attribute__((dllimport))(void * var2407 , void * var2408 , void * var2409 , void * var2410 , void * var2411 , void * var2412 , void * var2413 , void * var2414 , void * var2415 , void * var2416 , void * var2417 );
__stdcall void * AnimatePalette __attribute__((dllimport))(void * var2418 , void * var2419 , void * var2420 , void * var2421 );
__stdcall void * AppendMenuW __attribute__((dllimport))(void * var2422 , void * var2423 , void * var2424 , void * var2425 );
__stdcall void * BackupEventLogW __attribute__((dllimport))(void * var2426 , void * var2427 );
__stdcall void * BeginUpdateResourceW __attribute__((dllimport))(void * var2428 , void * var2429 );
__stdcall void * BuildCommDCBA __attribute__((dllimport))(void * var2430 , void * var2431 );
__stdcall void * BuildCommDCBAndTimeoutsA __attribute__((dllimport))(void * var2432 , void * var2433 , void * var2434 );
__stdcall void * BuildCommDCBW __attribute__((dllimport))(void * var2435 , void * var2436 );
__stdcall void * CallNamedPipeW __attribute__((dllimport))(void * var2437 , void * var2438 , void * var2439 , void * var2440 , void * var2441 , void * var2442 , void * var2443 );
__stdcall void * CallWindowProcA __attribute__((dllimport))(void * var2444 , void * var2445 , void * var2446 , void * var2447 , void * var2448 );
__stdcall void * CallWindowProcW __attribute__((dllimport))(void * var2449 , void * var2450 , void * var2451 , void * var2452 , void * var2453 );
__stdcall void * CascadeWindows __attribute__((dllimport))(void * var2454 , void * var2455 , void * var2456 , void * var2457 , void * var2458 );
__stdcall void * ChangeMenuW __attribute__((dllimport))(void * var2459 , void * var2460 , void * var2461 , void * var2462 , void * var2463 );
__stdcall void * ChangeServiceConfigW __attribute__((dllimport))(void * var2464 , void * var2465 , void * var2466 , void * var2467 , void * var2468 , void * var2469 , void * var2470 , void * var2471 , void * var2472 , void * var2473 , void * var2474 );
__stdcall void * CharLowerBuffW __attribute__((dllimport))(void * var2475 , void * var2476 );
__stdcall void * CharLowerW __attribute__((dllimport))(void * var2477 );
__stdcall void * CharNextW __attribute__((dllimport))(void * var2478 );
__stdcall void * CharPrevW __attribute__((dllimport))(void * var2479 , void * var2480 );
__stdcall void * CharToOemBuffW __attribute__((dllimport))(void * var2481 , void * var2482 , void * var2483 );
__stdcall void * CharToOemW __attribute__((dllimport))(void * var2484 , void * var2485 );
__stdcall void * CharUpperBuffW __attribute__((dllimport))(void * var2486 , void * var2487 );
__stdcall void * CharUpperW __attribute__((dllimport))(void * var2488 );
__stdcall void * ChildWindowFromPoint __attribute__((dllimport))(void * var2489 , void * var2490 );
__stdcall void * ChildWindowFromPointEx __attribute__((dllimport))(void * var2491 , void * var2492 , void * var2493 );
__stdcall void * ClearCommError __attribute__((dllimport))(void * var2494 , void * var2495 , void * var2496 );
__stdcall void * ClearEventLogW __attribute__((dllimport))(void * var2497 , void * var2498 );
__stdcall void * ClientToScreen __attribute__((dllimport))(void * var2499 , void * var2500 );
__stdcall void * ClipCursor __attribute__((dllimport))(void * var2501 );
__stdcall void * CombineTransform __attribute__((dllimport))(void * var2502 , void * var2503 , void * var2504 );
__stdcall void * CompareFileTime __attribute__((dllimport))(void * var2505 , void * var2506 );
__stdcall void * CompareStringW __attribute__((dllimport))(void * var2507 , void * var2508 , void * var2509 , void * var2510 , void * var2511 , void * var2512 );
__stdcall void * ConnectNamedPipe __attribute__((dllimport))(void * var2513 , void * var2514 );
__stdcall void * ControlService __attribute__((dllimport))(void * var2515 , void * var2516 , void * var2517 );
__stdcall void * CopyAcceleratorTableA __attribute__((dllimport))(void * var2518 , void * var2519 , void * var2520 );
__stdcall void * CopyAcceleratorTableW __attribute__((dllimport))(void * var2521 , void * var2522 , void * var2523 );
__stdcall void * CopyEnhMetaFileW __attribute__((dllimport))(void * var2524 , void * var2525 );
__stdcall void * CopyFileW __attribute__((dllimport))(void * var2526 , void * var2527 , void * var2528 );
__stdcall void * CopyMetaFileW __attribute__((dllimport))(void * var2529 , void * var2530 );
__stdcall void * CopyRect __attribute__((dllimport))(void * var2531 , void * var2532 );
__stdcall void * CreateAcceleratorTableA __attribute__((dllimport))(void * var2533 , void * var2534 );
__stdcall void * CreateAcceleratorTableW __attribute__((dllimport))(void * var2535 , void * var2536 );
__stdcall void * CreateBitmapIndirect __attribute__((dllimport))(void * var2537 );
__stdcall void * CreateConsoleScreenBuffer __attribute__((dllimport))(void * var2538 , void * var2539 , void * var2540 , void * var2541 , void * var2542 );
__stdcall void * CreateCursor __attribute__((dllimport))(void * var2543 , void * var2544 , void * var2545 , void * var2546 , void * var2547 , void * var2548 , void * var2549 );
__stdcall void * CreateDialogIndirectParamA __attribute__((dllimport))(void * var2550 , void * var2551 , void * var2552 , void * var2553 , void * var2554 );
__stdcall void * CreateDialogIndirectParamW __attribute__((dllimport))(void * var2555 , void * var2556 , void * var2557 , void * var2558 , void * var2559 );
__stdcall void * CreateDialogParamA __attribute__((dllimport))(void * var2560 , void * var2561 , void * var2562 , void * var2563 , void * var2564 );
__stdcall void * CreateDialogParamW __attribute__((dllimport))(void * var2565 , void * var2566 , void * var2567 , void * var2568 , void * var2569 );
__stdcall void * CreateDirectoryA __attribute__((dllimport))(void * var2570 , void * var2571 );
__stdcall void * CreateDirectoryExA __attribute__((dllimport))(void * var2572 , void * var2573 , void * var2574 );
__stdcall void * CreateDirectoryExW __attribute__((dllimport))(void * var2575 , void * var2576 , void * var2577 );
__stdcall void * CreateDirectoryW __attribute__((dllimport))(void * var2578 , void * var2579 );
__stdcall void * CreateEllipticRgnIndirect __attribute__((dllimport))(void * var2580 );
__stdcall void * CreateEnhMetaFileA __attribute__((dllimport))(void * var2581 , void * var2582 , void * var2583 , void * var2584 );
__stdcall void * CreateEnhMetaFileW __attribute__((dllimport))(void * var2585 , void * var2586 , void * var2587 , void * var2588 );
__stdcall void * CreateEventA __attribute__((dllimport))(void * var2589 , void * var2590 , void * var2591 , void * var2592 );
__stdcall void * CreateEventW __attribute__((dllimport))(void * var2593 , void * var2594 , void * var2595 , void * var2596 );
__stdcall void * CreateFiber __attribute__((dllimport))(void * var2597 , void * var2598 , void * var2599 );
__stdcall void * CreateFileA __attribute__((dllimport))(void * var2600 , void * var2601 , void * var2602 , void * var2603 , void * var2604 , void * var2605 , void * var2606 );
__stdcall void * CreateFileMappingA __attribute__((dllimport))(void * var2607 , void * var2608 , void * var2609 , void * var2610 , void * var2611 , void * var2612 );
__stdcall void * CreateFileMappingW __attribute__((dllimport))(void * var2613 , void * var2614 , void * var2615 , void * var2616 , void * var2617 , void * var2618 );
__stdcall void * CreateFileW __attribute__((dllimport))(void * var2619 , void * var2620 , void * var2621 , void * var2622 , void * var2623 , void * var2624 , void * var2625 );
__stdcall void * CreateFontIndirectA __attribute__((dllimport))(void * var2626 );
__stdcall void * CreateFontW __attribute__((dllimport))(void * var2627 , void * var2628 , void * var2629 , void * var2630 , void * var2631 , void * var2632 , void * var2633 , void * var2634 , void * var2635 , void * var2636 , void * var2637 , void * var2638 , void * var2639 , void * var2640 );
__stdcall void * CreateHardLinkW __attribute__((dllimport))(void * var2641 , void * var2642 , void * var2643 );
__stdcall void * CreateJobObjectA __attribute__((dllimport))(void * var2644 , void * var2645 );
__stdcall void * CreateJobObjectW __attribute__((dllimport))(void * var2646 , void * var2647 );
__stdcall void * CreateMailslotA __attribute__((dllimport))(void * var2648 , void * var2649 , void * var2650 , void * var2651 );
__stdcall void * CreateMailslotW __attribute__((dllimport))(void * var2652 , void * var2653 , void * var2654 , void * var2655 );
__stdcall void * CreateMetaFileW __attribute__((dllimport))(void * var2656 );
__stdcall void * CreateMutexA __attribute__((dllimport))(void * var2657 , void * var2658 , void * var2659 );
__stdcall void * CreateMutexW __attribute__((dllimport))(void * var2660 , void * var2661 , void * var2662 );
__stdcall void * CreateNamedPipeA __attribute__((dllimport))(void * var2663 , void * var2664 , void * var2665 , void * var2666 , void * var2667 , void * var2668 , void * var2669 , void * var2670 );
__stdcall void * CreateNamedPipeW __attribute__((dllimport))(void * var2671 , void * var2672 , void * var2673 , void * var2674 , void * var2675 , void * var2676 , void * var2677 , void * var2678 );
__stdcall void * CreatePipe __attribute__((dllimport))(void * var2679 , void * var2680 , void * var2681 , void * var2682 );
__stdcall void * CreatePolyPolygonRgn __attribute__((dllimport))(void * var2683 , void * var2684 , void * var2685 , void * var2686 );
__stdcall void * CreatePolygonRgn __attribute__((dllimport))(void * var2687 , void * var2688 , void * var2689 );
__stdcall void * CreateRectRgnIndirect __attribute__((dllimport))(void * var2690 );
__stdcall void * CreateRemoteThread __attribute__((dllimport))(void * var2691 , void * var2692 , void * var2693 , void * var2694 , void * var2695 , void * var2696 , void * var2697 );
__stdcall void * CreateSemaphoreA __attribute__((dllimport))(void * var2698 , void * var2699 , void * var2700 , void * var2701 );
__stdcall void * CreateSemaphoreW __attribute__((dllimport))(void * var2702 , void * var2703 , void * var2704 , void * var2705 );
__stdcall void * CreateServiceW __attribute__((dllimport))(void * var2706 , void * var2707 , void * var2708 , void * var2709 , void * var2710 , void * var2711 , void * var2712 , void * var2713 , void * var2714 , void * var2715 , void * var2716 , void * var2717 , void * var2718 );
__stdcall void * CreateThread __attribute__((dllimport))(void * var2719 , void * var2720 , void * var2721 , void * var2722 , void * var2723 , void * var2724 );
__stdcall void * CreateWaitableTimerA __attribute__((dllimport))(void * var2725 , void * var2726 , void * var2727 );
__stdcall void * CreateWaitableTimerW __attribute__((dllimport))(void * var2728 , void * var2729 , void * var2730 );
__stdcall void * CreateWindowExW __attribute__((dllimport))(void * var2731 , void * var2732 , void * var2733 , void * var2734 , void * var2735 , void * var2736 , void * var2737 , void * var2738 , void * var2739 , void * var2740 , void * var2741 , void * var2742 );
__stdcall void * CreateWindowStationA __attribute__((dllimport))(void * var2743 , void * var2744 , void * var2745 , void * var2746 );
__stdcall void * CreateWindowStationW __attribute__((dllimport))(void * var2747 , void * var2748 , void * var2749 , void * var2750 );
__stdcall void * DPtoLP __attribute__((dllimport))(void * var2751 , void * var2752 , void * var2753 );
__stdcall void * DecryptFileW __attribute__((dllimport))(void * var2754 , void * var2755 );
__stdcall void * DefineDosDeviceW __attribute__((dllimport))(void * var2756 , void * var2757 , void * var2758 );
__stdcall void * DeleteFileW __attribute__((dllimport))(void * var2759 );
__stdcall void * DeleteVolumeMountPointW __attribute__((dllimport))(void * var2760 );
__stdcall void * DescribePixelFormat __attribute__((dllimport))(void * var2761 , void * var2762 , void * var2763 , void * var2764 );
__stdcall void * DestroyCursor __attribute__((dllimport))(void * var2765 );
__stdcall void * DeviceIoControl __attribute__((dllimport))(void * var2766 , void * var2767 , void * var2768 , void * var2769 , void * var2770 , void * var2771 , void * var2772 , void * var2773 );
__stdcall void * DialogBoxIndirectParamA __attribute__((dllimport))(void * var2774 , void * var2775 , void * var2776 , void * var2777 , void * var2778 );
__stdcall void * DialogBoxIndirectParamW __attribute__((dllimport))(void * var2779 , void * var2780 , void * var2781 , void * var2782 , void * var2783 );
__stdcall void * DialogBoxParamA __attribute__((dllimport))(void * var2784 , void * var2785 , void * var2786 , void * var2787 , void * var2788 );
__stdcall void * DialogBoxParamW __attribute__((dllimport))(void * var2789 , void * var2790 , void * var2791 , void * var2792 , void * var2793 );
__stdcall void * DisableThreadLibraryCalls __attribute__((dllimport))(void * var2794 );
__stdcall void * DlgDirListComboBoxW __attribute__((dllimport))(void * var2795 , void * var2796 , void * var2797 , void * var2798 , void * var2799 );
__stdcall void * DlgDirListW __attribute__((dllimport))(void * var2800 , void * var2801 , void * var2802 , void * var2803 , void * var2804 );
__stdcall void * DlgDirSelectComboBoxExW __attribute__((dllimport))(void * var2805 , void * var2806 , void * var2807 , void * var2808 );
__stdcall void * DlgDirSelectExW __attribute__((dllimport))(void * var2809 , void * var2810 , void * var2811 , void * var2812 );
__stdcall void * DnsHostnameToComputerNameW __attribute__((dllimport))(void * var2813 , void * var2814 , void * var2815 );
__stdcall void * DosDateTimeToFileTime __attribute__((dllimport))(void * var2816 , void * var2817 , void * var2818 );
__stdcall void * DragDetect __attribute__((dllimport))(void * var2819 , void * var2820 );
__stdcall void * DragObject __attribute__((dllimport))(void * var2821 , void * var2822 , void * var2823 , void * var2824 , void * var2825 );
__stdcall void * DrawAnimatedRects __attribute__((dllimport))(void * var2826 , void * var2827 , void * var2828 , void * var2829 );
__stdcall void * DrawCaption __attribute__((dllimport))(void * var2830 , void * var2831 , void * var2832 , void * var2833 );
__stdcall void * DrawEdge __attribute__((dllimport))(void * var2834 , void * var2835 , void * var2836 , void * var2837 );
__stdcall void * DrawFocusRect __attribute__((dllimport))(void * var2838 , void * var2839 );
__stdcall void * DrawFrameControl __attribute__((dllimport))(void * var2840 , void * var2841 , void * var2842 , void * var2843 );
__stdcall void * DrawStateA __attribute__((dllimport))(void * var2844 , void * var2845 , void * var2846 , void * var2847 , void * var2848 , void * var2849 , void * var2850 , void * var2851 , void * var2852 , void * var2853 );
__stdcall void * DrawStateW __attribute__((dllimport))(void * var2854 , void * var2855 , void * var2856 , void * var2857 , void * var2858 , void * var2859 , void * var2860 , void * var2861 , void * var2862 , void * var2863 );
__stdcall void * DrawTextA __attribute__((dllimport))(void * var2864 , void * var2865 , void * var2866 , void * var2867 , void * var2868 );
__stdcall void * DrawTextExA __attribute__((dllimport))(void * var2869 , void * var2870 , void * var2871 , void * var2872 , void * var2873 , void * var2874 );
__stdcall void * DrawTextExW __attribute__((dllimport))(void * var2875 , void * var2876 , void * var2877 , void * var2878 , void * var2879 , void * var2880 );
__stdcall void * DrawTextW __attribute__((dllimport))(void * var2881 , void * var2882 , void * var2883 , void * var2884 , void * var2885 );
__stdcall void * DuplicateTokenEx __attribute__((dllimport))(void * var2886 , void * var2887 , void * var2888 , void * var2889 , void * var2890 , void * var2891 );
__stdcall void * EncryptFileW __attribute__((dllimport))(void * var2892 );
__stdcall void * EnumCalendarInfoA __attribute__((dllimport))(void * var2893 , void * var2894 , void * var2895 , void * var2896 );
__stdcall void * EnumChildWindows __attribute__((dllimport))(void * var2897 , void * var2898 , void * var2899 );
__stdcall void * EnumDateFormatsA __attribute__((dllimport))(void * var2900 , void * var2901 , void * var2902 );
__stdcall void * EnumDesktopWindows __attribute__((dllimport))(void * var2903 , void * var2904 , void * var2905 );
__stdcall void * EnumDisplayDevicesA __attribute__((dllimport))(void * var2906 , void * var2907 , void * var2908 , void * var2909 );
__stdcall void * EnumICMProfilesA __attribute__((dllimport))(void * var2910 , void * var2911 , void * var2912 );
__stdcall void * EnumObjects __attribute__((dllimport))(void * var2913 , void * var2914 , void * var2915 , void * var2916 );
__stdcall void * EnumPropsA __attribute__((dllimport))(void * var2917 , void * var2918 );
__stdcall void * EnumPropsExA __attribute__((dllimport))(void * var2919 , void * var2920 , void * var2921 );
__stdcall void * EnumServicesStatusExW __attribute__((dllimport))(void * var2922 , void * var2923 , void * var2924 , void * var2925 , void * var2926 , void * var2927 , void * var2928 , void * var2929 , void * var2930 , void * var2931 );
__stdcall void * EnumSystemGeoID __attribute__((dllimport))(void * var2932 , void * var2933 , void * var2934 );
__stdcall void * EnumSystemLocalesA __attribute__((dllimport))(void * var2935 , void * var2936 );
__stdcall void * EnumThreadWindows __attribute__((dllimport))(void * var2937 , void * var2938 , void * var2939 );
__stdcall void * EnumTimeFormatsA __attribute__((dllimport))(void * var2940 , void * var2941 , void * var2942 );
__stdcall void * EnumWindows __attribute__((dllimport))(void * var2943 , void * var2944 );
__stdcall void * EqualRect __attribute__((dllimport))(void * var2945 , void * var2946 );
__stdcall void * ExpandEnvironmentStringsW __attribute__((dllimport))(void * var2947 , void * var2948 , void * var2949 );
__stdcall void * ExtTextOutA __attribute__((dllimport))(void * var2950 , void * var2951 , void * var2952 , void * var2953 , void * var2954 , void * var2955 , void * var2956 , void * var2957 );
__stdcall void * ExtTextOutW __attribute__((dllimport))(void * var2958 , void * var2959 , void * var2960 , void * var2961 , void * var2962 , void * var2963 , void * var2964 , void * var2965 );
__stdcall void * FatalAppExitW __attribute__((dllimport))(void * var2966 , void * var2967 );
__stdcall void * FileEncryptionStatusW __attribute__((dllimport))(void * var2968 , void * var2969 );
__stdcall void * FileTimeToDosDateTime __attribute__((dllimport))(void * var2970 , void * var2971 , void * var2972 );
__stdcall void * FileTimeToLocalFileTime __attribute__((dllimport))(void * var2973 , void * var2974 );
__stdcall void * FileTimeToSystemTime __attribute__((dllimport))(void * var2975 , void * var2976 );
__stdcall void * FillConsoleOutputAttribute __attribute__((dllimport))(void * var2977 , void * var2978 , void * var2979 , void * var2980 , void * var2981 );
__stdcall void * FillConsoleOutputCharacterA __attribute__((dllimport))(void * var2982 , void * var2983 , void * var2984 , void * var2985 , void * var2986 );
__stdcall void * FillConsoleOutputCharacterW __attribute__((dllimport))(void * var2987 , void * var2988 , void * var2989 , void * var2990 , void * var2991 );
__stdcall void * FillRect __attribute__((dllimport))(void * var2992 , void * var2993 , void * var2994 );
__stdcall void * FindAtomW __attribute__((dllimport))(void * var2995 );
__stdcall void * FindFirstChangeNotificationW __attribute__((dllimport))(void * var2996 , void * var2997 , void * var2998 );
__stdcall void * FindFirstFileExW __attribute__((dllimport))(void * var2999 , void * var3000 , void * var3001 , void * var3002 , void * var3003 , void * var3004 );
__stdcall void * FindFirstVolumeMountPointW __attribute__((dllimport))(void * var3005 , void * var3006 , void * var3007 );
__stdcall void * FindFirstVolumeW __attribute__((dllimport))(void * var3008 , void * var3009 );
__stdcall void * FindNextVolumeMountPointW __attribute__((dllimport))(void * var3010 , void * var3011 , void * var3012 );
__stdcall void * FindNextVolumeW __attribute__((dllimport))(void * var3013 , void * var3014 , void * var3015 );
__stdcall void * FindResourceA __attribute__((dllimport))(void * var3016 , void * var3017 , void * var3018 );
__stdcall void * FindResourceExA __attribute__((dllimport))(void * var3019 , void * var3020 , void * var3021 , void * var3022 );
__stdcall void * FindResourceExW __attribute__((dllimport))(void * var3023 , void * var3024 , void * var3025 , void * var3026 );
__stdcall void * FindResourceW __attribute__((dllimport))(void * var3027 , void * var3028 , void * var3029 );
__stdcall void * FindWindowExW __attribute__((dllimport))(void * var3030 , void * var3031 , void * var3032 , void * var3033 );
__stdcall void * FindWindowW __attribute__((dllimport))(void * var3034 , void * var3035 );
__stdcall void * FlashWindowEx __attribute__((dllimport))(void * var3036 );
__stdcall void * FoldStringW __attribute__((dllimport))(void * var3037 , void * var3038 , void * var3039 , void * var3040 , void * var3041 );
__stdcall void * FormatMessageW __attribute__((dllimport))(void * var3042 , void * var3043 , void * var3044 , void * var3045 , void * var3046 , void * var3047 , void * var3048 );
__stdcall void * FrameRect __attribute__((dllimport))(void * var3049 , void * var3050 , void * var3051 );
__stdcall void * FreeEnvironmentStringsW __attribute__((dllimport))(void * var3052 );
__stdcall void * FreeLibrary __attribute__((dllimport))(void * var3053 );
__stdcall void * FreeLibraryAndExitThread __attribute__((dllimport))(void * var3054 , void * var3055 );
__stdcall void * GdiAlphaBlend __attribute__((dllimport))(void * var3056 , void * var3057 , void * var3058 , void * var3059 , void * var3060 , void * var3061 , void * var3062 , void * var3063 , void * var3064 , void * var3065 , void * var3066 );
__stdcall void * GetAspectRatioFilterEx __attribute__((dllimport))(void * var3067 , void * var3068 );
__stdcall void * GetAtomNameW __attribute__((dllimport))(void * var3069 , void * var3070 , void * var3071 );
__stdcall void * GetBinaryTypeW __attribute__((dllimport))(void * var3072 , void * var3073 );
__stdcall void * GetBitmapDimensionEx __attribute__((dllimport))(void * var3074 , void * var3075 );
__stdcall void * GetBoundsRect __attribute__((dllimport))(void * var3076 , void * var3077 , void * var3078 );
__stdcall void * GetBrushOrgEx __attribute__((dllimport))(void * var3079 , void * var3080 );
__stdcall void * GetCPInfo __attribute__((dllimport))(void * var3081 , void * var3082 );
__stdcall void * GetCalendarInfoW __attribute__((dllimport))(void * var3083 , void * var3084 , void * var3085 , void * var3086 , void * var3087 , void * var3088 );
__stdcall void * GetCaretPos __attribute__((dllimport))(void * var3089 );
__stdcall void * GetCharABCWidthsA __attribute__((dllimport))(void * var3090 , void * var3091 , void * var3092 , void * var3093 );
__stdcall void * GetCharABCWidthsFloatA __attribute__((dllimport))(void * var3094 , void * var3095 , void * var3096 , void * var3097 );
__stdcall void * GetCharABCWidthsW __attribute__((dllimport))(void * var3098 , void * var3099 , void * var3100 , void * var3101 );
__stdcall void * GetClassNameW __attribute__((dllimport))(void * var3102 , void * var3103 , void * var3104 );
__stdcall void * GetClientRect __attribute__((dllimport))(void * var3105 , void * var3106 );
__stdcall void * GetClipBox __attribute__((dllimport))(void * var3107 , void * var3108 );
__stdcall void * GetClipCursor __attribute__((dllimport))(void * var3109 );
__stdcall void * GetClipboardFormatNameW __attribute__((dllimport))(void * var3110 , void * var3111 , void * var3112 );
__stdcall void * GetCommState __attribute__((dllimport))(void * var3113 , void * var3114 );
__stdcall void * GetCommTimeouts __attribute__((dllimport))(void * var3115 , void * var3116 );
__stdcall void * GetCommandLineW __attribute__((dllimport))(void * var3117 );
__stdcall void * GetCompressedFileSizeW __attribute__((dllimport))(void * var3118 , void * var3119 );
__stdcall void * GetComputerNameExW __attribute__((dllimport))(void * var3120 , void * var3121 , void * var3122 );
__stdcall void * GetComputerNameW __attribute__((dllimport))(void * var3123 , void * var3124 );
__stdcall void * GetConsoleAliasExesW __attribute__((dllimport))(void * var3125 , void * var3126 );
__stdcall void * GetConsoleAliasesLengthW __attribute__((dllimport))(void * var3127 );
__stdcall void * GetConsoleAliasesW __attribute__((dllimport))(void * var3128 , void * var3129 , void * var3130 );
__stdcall void * GetConsoleCursorInfo __attribute__((dllimport))(void * var3131 , void * var3132 );
__stdcall void * GetConsoleFontSize __attribute__((dllimport))(void * var3133 , void * var3134 );
__stdcall void * GetConsoleTitleW __attribute__((dllimport))(void * var3135 , void * var3136 );
__stdcall void * GetCurrentDirectoryW __attribute__((dllimport))(void * var3137 , void * var3138 );
__stdcall void * GetCurrentHwProfileA __attribute__((dllimport))(void * var3139 );
__stdcall void * GetCurrentPositionEx __attribute__((dllimport))(void * var3140 , void * var3141 );
__stdcall void * GetCursor __attribute__((dllimport))(void * var3142 );
__stdcall void * GetCursorPos __attribute__((dllimport))(void * var3143 );
__stdcall void * GetDCOrgEx __attribute__((dllimport))(void * var3144 , void * var3145 );
__stdcall void * GetDIBColorTable __attribute__((dllimport))(void * var3146 , void * var3147 , void * var3148 , void * var3149 );
__stdcall void * GetDateFormatA __attribute__((dllimport))(void * var3150 , void * var3151 , void * var3152 , void * var3153 , void * var3154 , void * var3155 );
__stdcall void * GetDateFormatW __attribute__((dllimport))(void * var3156 , void * var3157 , void * var3158 , void * var3159 , void * var3160 , void * var3161 );
__stdcall void * GetDiskFreeSpaceW __attribute__((dllimport))(void * var3162 , void * var3163 , void * var3164 , void * var3165 , void * var3166 );
__stdcall void * GetDlgItemTextW __attribute__((dllimport))(void * var3167 , void * var3168 , void * var3169 , void * var3170 );
__stdcall void * GetDriveTypeW __attribute__((dllimport))(void * var3171 );
__stdcall void * GetEnhMetaFileDescriptionW __attribute__((dllimport))(void * var3172 , void * var3173 , void * var3174 );
__stdcall void * GetEnhMetaFilePaletteEntries __attribute__((dllimport))(void * var3175 , void * var3176 , void * var3177 );
__stdcall void * GetEnhMetaFileW __attribute__((dllimport))(void * var3178 );
__stdcall void * GetEnvironmentStringsW __attribute__((dllimport))(void * var3179 );
__stdcall void * GetEnvironmentVariableW __attribute__((dllimport))(void * var3180 , void * var3181 , void * var3182 );
__stdcall void * GetFileAttributesExW __attribute__((dllimport))(void * var3183 , void * var3184 , void * var3185 );
__stdcall void * GetFileAttributesW __attribute__((dllimport))(void * var3186 );
__stdcall void * GetFileSecurityW __attribute__((dllimport))(void * var3187 , void * var3188 , void * var3189 , void * var3190 , void * var3191 );
__stdcall void * GetFileTime __attribute__((dllimport))(void * var3192 , void * var3193 , void * var3194 , void * var3195 );
__stdcall void * GetFullPathNameW __attribute__((dllimport))(void * var3196 , void * var3197 , void * var3198 , void * var3199 );
__stdcall void * GetGeoInfoW __attribute__((dllimport))(void * var3200 , void * var3201 , void * var3202 , void * var3203 , void * var3204 );
__stdcall void * GetGlyphIndicesW __attribute__((dllimport))(void * var3205 , void * var3206 , void * var3207 , void * var3208 , void * var3209 );
__stdcall void * GetKerningPairsA __attribute__((dllimport))(void * var3210 , void * var3211 , void * var3212 );
__stdcall void * GetKerningPairsW __attribute__((dllimport))(void * var3213 , void * var3214 , void * var3215 );
__stdcall void * GetKeyNameTextW __attribute__((dllimport))(void * var3216 , void * var3217 , void * var3218 );
__stdcall void * GetKeyboardLayoutNameW __attribute__((dllimport))(void * var3219 );
__stdcall void * GetLargestConsoleWindowSize __attribute__((dllimport))(void * var3220 );
__stdcall void * GetLastInputInfo __attribute__((dllimport))(void * var3221 );
__stdcall void * GetLocalTime __attribute__((dllimport))(void * var3222 );
__stdcall void * GetLocaleInfoW __attribute__((dllimport))(void * var3223 , void * var3224 , void * var3225 , void * var3226 );
__stdcall void * GetLogicalDriveStringsW __attribute__((dllimport))(void * var3227 , void * var3228 );
__stdcall void * GetLongPathNameW __attribute__((dllimport))(void * var3229 , void * var3230 , void * var3231 );
__stdcall void * GetMenuItemRect __attribute__((dllimport))(void * var3232 , void * var3233 , void * var3234 , void * var3235 );
__stdcall void * GetMenuStringW __attribute__((dllimport))(void * var3236 , void * var3237 , void * var3238 , void * var3239 , void * var3240 );
__stdcall void * GetMetaFileW __attribute__((dllimport))(void * var3241 );
__stdcall void * GetModuleFileNameA __attribute__((dllimport))(void * var3242 , void * var3243 , void * var3244 );
__stdcall void * GetModuleFileNameW __attribute__((dllimport))(void * var3245 , void * var3246 , void * var3247 );
__stdcall void * GetModuleHandleA __attribute__((dllimport))(void * var3248 );
__stdcall void * GetModuleHandleExW __attribute__((dllimport))(void * var3249 , void * var3250 , void * var3251 );
__stdcall void * GetModuleHandleW __attribute__((dllimport))(void * var3252 );
__stdcall void * GetOverlappedResult __attribute__((dllimport))(void * var3253 , void * var3254 , void * var3255 , void * var3256 );
__stdcall void * GetPaletteEntries __attribute__((dllimport))(void * var3257 , void * var3258 , void * var3259 , void * var3260 );
__stdcall void * GetPath __attribute__((dllimport))(void * var3261 , void * var3262 , void * var3263 , void * var3264 );
__stdcall void * GetPrivateProfileIntW __attribute__((dllimport))(void * var3265 , void * var3266 , void * var3267 , void * var3268 );
__stdcall void * GetPrivateProfileSectionNamesW __attribute__((dllimport))(void * var3269 , void * var3270 , void * var3271 );
__stdcall void * GetPrivateProfileSectionW __attribute__((dllimport))(void * var3272 , void * var3273 , void * var3274 , void * var3275 );
__stdcall void * GetPrivateProfileStringW __attribute__((dllimport))(void * var3276 , void * var3277 , void * var3278 , void * var3279 , void * var3280 , void * var3281 );
__stdcall void * GetPrivateProfileStructW __attribute__((dllimport))(void * var3282 , void * var3283 , void * var3284 , void * var3285 , void * var3286 );
__stdcall void * GetProcAddress __attribute__((dllimport))(void * var3287 , void * var3288 );
__stdcall void * GetProcessTimes __attribute__((dllimport))(void * var3289 , void * var3290 , void * var3291 , void * var3292 , void * var3293 );
__stdcall void * GetProfileIntW __attribute__((dllimport))(void * var3294 , void * var3295 , void * var3296 );
__stdcall void * GetProfileSectionW __attribute__((dllimport))(void * var3297 , void * var3298 , void * var3299 );
__stdcall void * GetProfileStringW __attribute__((dllimport))(void * var3300 , void * var3301 , void * var3302 , void * var3303 , void * var3304 );
__stdcall void * GetPropW __attribute__((dllimport))(void * var3305 , void * var3306 );
__stdcall void * GetQueuedCompletionStatus __attribute__((dllimport))(void * var3307 , void * var3308 , void * var3309 , void * var3310 , void * var3311 );
__stdcall void * GetRawInputDeviceList __attribute__((dllimport))(void * var3312 , void * var3313 , void * var3314 );
__stdcall void * GetRgnBox __attribute__((dllimport))(void * var3315 , void * var3316 );
__stdcall void * GetScrollInfo __attribute__((dllimport))(void * var3317 , void * var3318 , void * var3319 );
__stdcall void * GetServiceDisplayNameW __attribute__((dllimport))(void * var3320 , void * var3321 , void * var3322 , void * var3323 );
__stdcall void * GetServiceKeyNameW __attribute__((dllimport))(void * var3324 , void * var3325 , void * var3326 , void * var3327 );
__stdcall void * GetShortPathNameW __attribute__((dllimport))(void * var3328 , void * var3329 , void * var3330 );
__stdcall void * GetSidIdentifierAuthority __attribute__((dllimport))(void * var3331 );
__stdcall void * GetStringTypeExW __attribute__((dllimport))(void * var3332 , void * var3333 , void * var3334 , void * var3335 , void * var3336 );
__stdcall void * GetStringTypeW __attribute__((dllimport))(void * var3337 , void * var3338 , void * var3339 , void * var3340 );
__stdcall void * GetSystemDirectoryW __attribute__((dllimport))(void * var3341 , void * var3342 );
__stdcall void * GetSystemPaletteEntries __attribute__((dllimport))(void * var3343 , void * var3344 , void * var3345 , void * var3346 );
__stdcall void * GetSystemPowerStatus __attribute__((dllimport))(void * var3347 );
__stdcall void * GetSystemTime __attribute__((dllimport))(void * var3348 );
__stdcall void * GetSystemTimeAsFileTime __attribute__((dllimport))(void * var3349 );
__stdcall void * GetSystemWindowsDirectoryW __attribute__((dllimport))(void * var3350 , void * var3351 );
__stdcall void * GetSystemWow64DirectoryW __attribute__((dllimport))(void * var3352 , void * var3353 );
__stdcall void * GetTabbedTextExtentW __attribute__((dllimport))(void * var3354 , void * var3355 , void * var3356 , void * var3357 , void * var3358 );
__stdcall void * GetTempFileNameW __attribute__((dllimport))(void * var3359 , void * var3360 , void * var3361 , void * var3362 );
__stdcall void * GetTempPathW __attribute__((dllimport))(void * var3363 , void * var3364 );
__stdcall void * GetTextCharsetInfo __attribute__((dllimport))(void * var3365 , void * var3366 , void * var3367 );
__stdcall void * GetTextExtentExPointA __attribute__((dllimport))(void * var3368 , void * var3369 , void * var3370 , void * var3371 , void * var3372 , void * var3373 , void * var3374 );
__stdcall void * GetTextExtentExPointW __attribute__((dllimport))(void * var3375 , void * var3376 , void * var3377 , void * var3378 , void * var3379 , void * var3380 , void * var3381 );
__stdcall void * GetTextExtentPoint32A __attribute__((dllimport))(void * var3382 , void * var3383 , void * var3384 , void * var3385 );
__stdcall void * GetTextExtentPoint32W __attribute__((dllimport))(void * var3386 , void * var3387 , void * var3388 , void * var3389 );
__stdcall void * GetTextExtentPointA __attribute__((dllimport))(void * var3390 , void * var3391 , void * var3392 , void * var3393 );
__stdcall void * GetTextExtentPointW __attribute__((dllimport))(void * var3394 , void * var3395 , void * var3396 , void * var3397 );
__stdcall void * GetTextFaceW __attribute__((dllimport))(void * var3398 , void * var3399 , void * var3400 );
__stdcall void * GetTextMetricsA __attribute__((dllimport))(void * var3401 , void * var3402 );
__stdcall void * GetThreadTimes __attribute__((dllimport))(void * var3403 , void * var3404 , void * var3405 , void * var3406 , void * var3407 );
__stdcall void * GetTimeFormatA __attribute__((dllimport))(void * var3408 , void * var3409 , void * var3410 , void * var3411 , void * var3412 , void * var3413 );
__stdcall void * GetTimeFormatW __attribute__((dllimport))(void * var3414 , void * var3415 , void * var3416 , void * var3417 , void * var3418 , void * var3419 );
__stdcall void * GetUpdateRect __attribute__((dllimport))(void * var3420 , void * var3421 , void * var3422 );
__stdcall void * GetUserNameW __attribute__((dllimport))(void * var3423 , void * var3424 );
__stdcall void * GetVersionExA __attribute__((dllimport))(void * var3425 );
__stdcall void * GetViewportExtEx __attribute__((dllimport))(void * var3426 , void * var3427 );
__stdcall void * GetViewportOrgEx __attribute__((dllimport))(void * var3428 , void * var3429 );
__stdcall void * GetVolumeInformationW __attribute__((dllimport))(void * var3430 , void * var3431 , void * var3432 , void * var3433 , void * var3434 , void * var3435 , void * var3436 , void * var3437 );
__stdcall void * GetVolumeNameForVolumeMountPointW __attribute__((dllimport))(void * var3438 , void * var3439 , void * var3440 );
__stdcall void * GetVolumePathNameW __attribute__((dllimport))(void * var3441 , void * var3442 , void * var3443 );
__stdcall void * GetVolumePathNamesForVolumeNameW __attribute__((dllimport))(void * var3444 , void * var3445 , void * var3446 , void * var3447 );
__stdcall void * GetWindowExtEx __attribute__((dllimport))(void * var3448 , void * var3449 );
__stdcall void * GetWindowModuleFileNameW __attribute__((dllimport))(void * var3450 , void * var3451 , void * var3452 );
__stdcall void * GetWindowOrgEx __attribute__((dllimport))(void * var3453 , void * var3454 );
__stdcall void * GetWindowRect __attribute__((dllimport))(void * var3455 , void * var3456 );
__stdcall void * GetWindowRgnBox __attribute__((dllimport))(void * var3457 , void * var3458 );
__stdcall void * GetWindowTextW __attribute__((dllimport))(void * var3459 , void * var3460 , void * var3461 );
__stdcall void * GetWindowsDirectoryW __attribute__((dllimport))(void * var3462 , void * var3463 );
__stdcall void * GetWorldTransform __attribute__((dllimport))(void * var3464 , void * var3465 );
__stdcall void * GlobalAddAtomW __attribute__((dllimport))(void * var3466 );
__stdcall void * GlobalFindAtomW __attribute__((dllimport))(void * var3467 );
__stdcall void * GlobalGetAtomNameW __attribute__((dllimport))(void * var3468 , void * var3469 , void * var3470 );
__stdcall void * GrayStringA __attribute__((dllimport))(void * var3471 , void * var3472 , void * var3473 , void * var3474 , void * var3475 , void * var3476 , void * var3477 , void * var3478 , void * var3479 );
__stdcall void * GrayStringW __attribute__((dllimport))(void * var3480 , void * var3481 , void * var3482 , void * var3483 , void * var3484 , void * var3485 , void * var3486 , void * var3487 , void * var3488 );
__stdcall void * HeapWalk __attribute__((dllimport))(void * var3489 , void * var3490 );
__stdcall void * InflateRect __attribute__((dllimport))(void * var3491 , void * var3492 , void * var3493 );
__stdcall void * InitializeSid __attribute__((dllimport))(void * var3494 , void * var3495 , void * var3496 );
__stdcall void * InitiateSystemShutdownExW __attribute__((dllimport))(void * var3497 , void * var3498 , void * var3499 , void * var3500 , void * var3501 , void * var3502 );
__stdcall void * InitiateSystemShutdownW __attribute__((dllimport))(void * var3503 , void * var3504 , void * var3505 , void * var3506 , void * var3507 );
__stdcall void * InsertMenuW __attribute__((dllimport))(void * var3508 , void * var3509 , void * var3510 , void * var3511 , void * var3512 );
__stdcall void * InternalGetWindowText __attribute__((dllimport))(void * var3513 , void * var3514 , void * var3515 );
__stdcall void * IntersectRect __attribute__((dllimport))(void * var3516 , void * var3517 , void * var3518 );
__stdcall void * InvalidateRect __attribute__((dllimport))(void * var3519 , void * var3520 , void * var3521 );
__stdcall void * InvertRect __attribute__((dllimport))(void * var3522 , void * var3523 );
__stdcall void * IsBadStringPtrW __attribute__((dllimport))(void * var3524 , void * var3525 );
__stdcall void * IsRectEmpty __attribute__((dllimport))(void * var3526 );
__stdcall void * LCMapStringW __attribute__((dllimport))(void * var3527 , void * var3528 , void * var3529 , void * var3530 , void * var3531 , void * var3532 );
__stdcall void * LPtoDP __attribute__((dllimport))(void * var3533 , void * var3534 , void * var3535 );
__stdcall void * LineDDA __attribute__((dllimport))(void * var3536 , void * var3537 , void * var3538 , void * var3539 , void * var3540 , void * var3541 );
__stdcall void * LoadAcceleratorsW __attribute__((dllimport))(void * var3542 , void * var3543 );
__stdcall void * LoadBitmapW __attribute__((dllimport))(void * var3544 , void * var3545 );
__stdcall void * LoadCursorA __attribute__((dllimport))(void * var3546 , void * var3547 );
__stdcall void * LoadCursorFromFileA __attribute__((dllimport))(void * var3548 );
__stdcall void * LoadCursorW __attribute__((dllimport))(void * var3549 , void * var3550 );
__stdcall void * LoadIconW __attribute__((dllimport))(void * var3551 , void * var3552 );
__stdcall void * LoadImageW __attribute__((dllimport))(void * var3553 , void * var3554 , void * var3555 , void * var3556 , void * var3557 , void * var3558 );
__stdcall void * LoadKeyboardLayoutW __attribute__((dllimport))(void * var3559 , void * var3560 );
__stdcall void * LoadLibraryA __attribute__((dllimport))(void * var3561 );
__stdcall void * LoadLibraryExA __attribute__((dllimport))(void * var3562 , void * var3563 , void * var3564 );
__stdcall void * LoadLibraryExW __attribute__((dllimport))(void * var3565 , void * var3566 , void * var3567 );
__stdcall void * LoadLibraryW __attribute__((dllimport))(void * var3568 );
__stdcall void * LoadMenuW __attribute__((dllimport))(void * var3569 , void * var3570 );
__stdcall void * LoadResource __attribute__((dllimport))(void * var3571 , void * var3572 );
__stdcall void * LoadStringW __attribute__((dllimport))(void * var3573 , void * var3574 , void * var3575 , void * var3576 );
__stdcall void * LocalFileTimeToFileTime __attribute__((dllimport))(void * var3577 , void * var3578 );
__stdcall void * LockFileEx __attribute__((dllimport))(void * var3579 , void * var3580 , void * var3581 , void * var3582 , void * var3583 , void * var3584 );
__stdcall void * LogonUserW __attribute__((dllimport))(void * var3585 , void * var3586 , void * var3587 , void * var3588 , void * var3589 , void * var3590 );
__stdcall void * LookupAccountNameW __attribute__((dllimport))(void * var3591 , void * var3592 , void * var3593 , void * var3594 , void * var3595 , void * var3596 , void * var3597 );
__stdcall void * LookupAccountSidW __attribute__((dllimport))(void * var3598 , void * var3599 , void * var3600 , void * var3601 , void * var3602 , void * var3603 , void * var3604 );
__stdcall void * LookupPrivilegeDisplayNameW __attribute__((dllimport))(void * var3605 , void * var3606 , void * var3607 , void * var3608 , void * var3609 );
__stdcall void * LookupPrivilegeNameA __attribute__((dllimport))(void * var3610 , void * var3611 , void * var3612 , void * var3613 );
__stdcall void * LookupPrivilegeNameW __attribute__((dllimport))(void * var3614 , void * var3615 , void * var3616 , void * var3617 );
__stdcall void * LookupPrivilegeValueA __attribute__((dllimport))(void * var3618 , void * var3619 , void * var3620 );
__stdcall void * LookupPrivilegeValueW __attribute__((dllimport))(void * var3621 , void * var3622 , void * var3623 );
__stdcall void * MapDialogRect __attribute__((dllimport))(void * var3624 , void * var3625 );
__stdcall void * MapWindowPoints __attribute__((dllimport))(void * var3626 , void * var3627 , void * var3628 , void * var3629 );
__stdcall void * MenuItemFromPoint __attribute__((dllimport))(void * var3630 , void * var3631 , void * var3632 );
__stdcall void * MessageBoxExW __attribute__((dllimport))(void * var3633 , void * var3634 , void * var3635 , void * var3636 , void * var3637 );
__stdcall void * MessageBoxW __attribute__((dllimport))(void * var3638 , void * var3639 , void * var3640 , void * var3641 );
__stdcall void * ModifyMenuW __attribute__((dllimport))(void * var3642 , void * var3643 , void * var3644 , void * var3645 , void * var3646 );
__stdcall void * ModifyWorldTransform __attribute__((dllimport))(void * var3647 , void * var3648 , void * var3649 );
__stdcall void * MonitorFromPoint __attribute__((dllimport))(void * var3650 , void * var3651 );
__stdcall void * MoveFileExW __attribute__((dllimport))(void * var3652 , void * var3653 , void * var3654 );
__stdcall void * MoveFileW __attribute__((dllimport))(void * var3655 , void * var3656 );
__stdcall void * MoveToEx __attribute__((dllimport))(void * var3657 , void * var3658 , void * var3659 , void * var3660 );
__stdcall void * MultiByteToWideChar __attribute__((dllimport))(void * var3661 , void * var3662 , void * var3663 , void * var3664 , void * var3665 , void * var3666 );
__stdcall void * ObjectCloseAuditAlarmW __attribute__((dllimport))(void * var3667 , void * var3668 , void * var3669 );
__stdcall void * ObjectDeleteAuditAlarmW __attribute__((dllimport))(void * var3670 , void * var3671 , void * var3672 );
__stdcall void * OemToCharBuffW __attribute__((dllimport))(void * var3673 , void * var3674 , void * var3675 );
__stdcall void * OemToCharW __attribute__((dllimport))(void * var3676 , void * var3677 );
__stdcall void * OffsetRect __attribute__((dllimport))(void * var3678 , void * var3679 , void * var3680 );
__stdcall void * OffsetViewportOrgEx __attribute__((dllimport))(void * var3681 , void * var3682 , void * var3683 , void * var3684 );
__stdcall void * OffsetWindowOrgEx __attribute__((dllimport))(void * var3685 , void * var3686 , void * var3687 , void * var3688 );
__stdcall void * OpenBackupEventLogW __attribute__((dllimport))(void * var3689 , void * var3690 );
__stdcall void * OpenDesktopW __attribute__((dllimport))(void * var3691 , void * var3692 , void * var3693 , void * var3694 );
__stdcall void * OpenEncryptedFileRawW __attribute__((dllimport))(void * var3695 , void * var3696 , void * var3697 );
__stdcall void * OpenEventLogW __attribute__((dllimport))(void * var3698 , void * var3699 );
__stdcall void * OpenEventW __attribute__((dllimport))(void * var3700 , void * var3701 , void * var3702 );
__stdcall void * OpenFile __attribute__((dllimport))(void * var3703 , void * var3704 , void * var3705 );
__stdcall void * OpenFileMappingW __attribute__((dllimport))(void * var3706 , void * var3707 , void * var3708 );
__stdcall void * OpenJobObjectW __attribute__((dllimport))(void * var3709 , void * var3710 , void * var3711 );
__stdcall void * OpenMutexW __attribute__((dllimport))(void * var3712 , void * var3713 , void * var3714 );
__stdcall void * OpenSCManagerW __attribute__((dllimport))(void * var3715 , void * var3716 , void * var3717 );
__stdcall void * OpenSemaphoreW __attribute__((dllimport))(void * var3718 , void * var3719 , void * var3720 );
__stdcall void * OpenServiceW __attribute__((dllimport))(void * var3721 , void * var3722 , void * var3723 );
__stdcall void * OpenWaitableTimerW __attribute__((dllimport))(void * var3724 , void * var3725 , void * var3726 );
__stdcall void * OpenWindowStationW __attribute__((dllimport))(void * var3727 , void * var3728 , void * var3729 );
__stdcall void * OutputDebugStringW __attribute__((dllimport))(void * var3730 );
__stdcall void * PlayEnhMetaFile __attribute__((dllimport))(void * var3731 , void * var3732 , void * var3733 );
__stdcall void * PlayEnhMetaFileRecord __attribute__((dllimport))(void * var3734 , void * var3735 , void * var3736 , void * var3737 );
__stdcall void * PlayMetaFileRecord __attribute__((dllimport))(void * var3738 , void * var3739 , void * var3740 , void * var3741 );
__stdcall void * PlgBlt __attribute__((dllimport))(void * var3742 , void * var3743 , void * var3744 , void * var3745 , void * var3746 , void * var3747 , void * var3748 , void * var3749 , void * var3750 , void * var3751 );
__stdcall void * PolyBezier __attribute__((dllimport))(void * var3752 , void * var3753 , void * var3754 );
__stdcall void * PolyBezierTo __attribute__((dllimport))(void * var3755 , void * var3756 , void * var3757 );
__stdcall void * PolyDraw __attribute__((dllimport))(void * var3758 , void * var3759 , void * var3760 , void * var3761 );
__stdcall void * PolyPolygon __attribute__((dllimport))(void * var3762 , void * var3763 , void * var3764 , void * var3765 );
__stdcall void * PolyPolyline __attribute__((dllimport))(void * var3766 , void * var3767 , void * var3768 , void * var3769 );
__stdcall void * Polygon __attribute__((dllimport))(void * var3770 , void * var3771 , void * var3772 );
__stdcall void * Polyline __attribute__((dllimport))(void * var3773 , void * var3774 , void * var3775 );
__stdcall void * PolylineTo __attribute__((dllimport))(void * var3776 , void * var3777 , void * var3778 );
__stdcall void * PostQueuedCompletionStatus __attribute__((dllimport))(void * var3779 , void * var3780 , void * var3781 , void * var3782 );
__stdcall void * PrivateExtractIconsW __attribute__((dllimport))(void * var3783 , void * var3784 , void * var3785 , void * var3786 , void * var3787 , void * var3788 , void * var3789 , void * var3790 );
__stdcall void * PtInRect __attribute__((dllimport))(void * var3791 , void * var3792 );
__stdcall void * QueryDosDeviceW __attribute__((dllimport))(void * var3793 , void * var3794 , void * var3795 );
__stdcall void * QueryPerformanceCounter __attribute__((dllimport))(void * var3796 );
__stdcall void * QueryPerformanceFrequency __attribute__((dllimport))(void * var3797 );
__stdcall void * QueryServiceStatus __attribute__((dllimport))(void * var3798 , void * var3799 );
__stdcall void * QueueUserWorkItem __attribute__((dllimport))(void * var3800 , void * var3801 , void * var3802 );
__stdcall void * ReadConsoleA __attribute__((dllimport))(void * var3803 , void * var3804 , void * var3805 , void * var3806 , void * var3807 );
__stdcall void * ReadConsoleOutputAttribute __attribute__((dllimport))(void * var3808 , void * var3809 , void * var3810 , void * var3811 , void * var3812 );
__stdcall void * ReadConsoleW __attribute__((dllimport))(void * var3813 , void * var3814 , void * var3815 , void * var3816 , void * var3817 );
__stdcall void * ReadEncryptedFileRaw __attribute__((dllimport))(void * var3818 , void * var3819 , void * var3820 );
__stdcall void * ReadFile __attribute__((dllimport))(void * var3821 , void * var3822 , void * var3823 , void * var3824 , void * var3825 );
__stdcall void * RectInRegion __attribute__((dllimport))(void * var3826 , void * var3827 );
__stdcall void * RectVisible __attribute__((dllimport))(void * var3828 , void * var3829 );
__stdcall void * RedrawWindow __attribute__((dllimport))(void * var3830 , void * var3831 , void * var3832 , void * var3833 );
__stdcall void * RegConnectRegistryA __attribute__((dllimport))(void * var3834 , void * var3835 , void * var3836 );
__stdcall void * RegConnectRegistryW __attribute__((dllimport))(void * var3837 , void * var3838 , void * var3839 );
__stdcall void * RegCreateKeyA __attribute__((dllimport))(void * var3840 , void * var3841 , void * var3842 );
__stdcall void * RegCreateKeyExA __attribute__((dllimport))(void * var3843 , void * var3844 , void * var3845 , void * var3846 , void * var3847 , void * var3848 , void * var3849 , void * var3850 , void * var3851 );
__stdcall void * RegCreateKeyExW __attribute__((dllimport))(void * var3852 , void * var3853 , void * var3854 , void * var3855 , void * var3856 , void * var3857 , void * var3858 , void * var3859 , void * var3860 );
__stdcall void * RegCreateKeyW __attribute__((dllimport))(void * var3861 , void * var3862 , void * var3863 );
__stdcall void * RegDeleteKeyW __attribute__((dllimport))(void * var3864 , void * var3865 );
__stdcall void * RegDeleteValueW __attribute__((dllimport))(void * var3866 , void * var3867 );
__stdcall void * RegEnumKeyExA __attribute__((dllimport))(void * var3868 , void * var3869 , void * var3870 , void * var3871 , void * var3872 , void * var3873 , void * var3874 , void * var3875 );
__stdcall void * RegEnumKeyExW __attribute__((dllimport))(void * var3876 , void * var3877 , void * var3878 , void * var3879 , void * var3880 , void * var3881 , void * var3882 , void * var3883 );
__stdcall void * RegEnumKeyW __attribute__((dllimport))(void * var3884 , void * var3885 , void * var3886 , void * var3887 );
__stdcall void * RegEnumValueW __attribute__((dllimport))(void * var3888 , void * var3889 , void * var3890 , void * var3891 , void * var3892 , void * var3893 , void * var3894 , void * var3895 );
__stdcall void * RegLoadKeyW __attribute__((dllimport))(void * var3896 , void * var3897 , void * var3898 );
__stdcall void * RegOpenCurrentUser __attribute__((dllimport))(void * var3899 , void * var3900 );
__stdcall void * RegOpenKeyA __attribute__((dllimport))(void * var3901 , void * var3902 , void * var3903 );
__stdcall void * RegOpenKeyExA __attribute__((dllimport))(void * var3904 , void * var3905 , void * var3906 , void * var3907 , void * var3908 );
__stdcall void * RegOpenKeyExW __attribute__((dllimport))(void * var3909 , void * var3910 , void * var3911 , void * var3912 , void * var3913 );
__stdcall void * RegOpenKeyW __attribute__((dllimport))(void * var3914 , void * var3915 , void * var3916 );
__stdcall void * RegOpenUserClassesRoot __attribute__((dllimport))(void * var3917 , void * var3918 , void * var3919 , void * var3920 );
__stdcall void * RegQueryInfoKeyA __attribute__((dllimport))(void * var3921 , void * var3922 , void * var3923 , void * var3924 , void * var3925 , void * var3926 , void * var3927 , void * var3928 , void * var3929 , void * var3930 , void * var3931 , void * var3932 );
__stdcall void * RegQueryInfoKeyW __attribute__((dllimport))(void * var3933 , void * var3934 , void * var3935 , void * var3936 , void * var3937 , void * var3938 , void * var3939 , void * var3940 , void * var3941 , void * var3942 , void * var3943 , void * var3944 );
__stdcall void * RegQueryValueExW __attribute__((dllimport))(void * var3945 , void * var3946 , void * var3947 , void * var3948 , void * var3949 , void * var3950 );
__stdcall void * RegQueryValueW __attribute__((dllimport))(void * var3951 , void * var3952 , void * var3953 , void * var3954 );
__stdcall void * RegReplaceKeyW __attribute__((dllimport))(void * var3955 , void * var3956 , void * var3957 , void * var3958 );
__stdcall void * RegRestoreKeyW __attribute__((dllimport))(void * var3959 , void * var3960 , void * var3961 );
__stdcall void * RegSaveKeyA __attribute__((dllimport))(void * var3962 , void * var3963 , void * var3964 );
__stdcall void * RegSaveKeyExW __attribute__((dllimport))(void * var3965 , void * var3966 , void * var3967 , void * var3968 );
__stdcall void * RegSaveKeyW __attribute__((dllimport))(void * var3969 , void * var3970 , void * var3971 );
__stdcall void * RegSetValueExW __attribute__((dllimport))(void * var3972 , void * var3973 , void * var3974 , void * var3975 , void * var3976 , void * var3977 );
__stdcall void * RegSetValueW __attribute__((dllimport))(void * var3978 , void * var3979 , void * var3980 , void * var3981 , void * var3982 );
__stdcall void * RegUnLoadKeyW __attribute__((dllimport))(void * var3983 , void * var3984 );
__stdcall void * RegisterClipboardFormatW __attribute__((dllimport))(void * var3985 );
__stdcall void * RegisterEventSourceW __attribute__((dllimport))(void * var3986 , void * var3987 );
__stdcall void * RegisterServiceCtrlHandlerExW __attribute__((dllimport))(void * var3988 , void * var3989 , void * var3990 );
__stdcall void * RegisterServiceCtrlHandlerW __attribute__((dllimport))(void * var3991 , void * var3992 );
__stdcall void * RegisterWindowMessageW __attribute__((dllimport))(void * var3993 );
__stdcall void * RemoveDirectoryW __attribute__((dllimport))(void * var3994 );
__stdcall void * RemoveFontResourceExW __attribute__((dllimport))(void * var3995 , void * var3996 , void * var3997 );
__stdcall void * RemoveFontResourceW __attribute__((dllimport))(void * var3998 );
__stdcall void * RemovePropW __attribute__((dllimport))(void * var3999 , void * var4000 );
__stdcall void * ReplaceFileW __attribute__((dllimport))(void * var4001 , void * var4002 , void * var4003 , void * var4004 , void * var4005 , void * var4006 );
__stdcall void * ReportEventW __attribute__((dllimport))(void * var4007 , void * var4008 , void * var4009 , void * var4010 , void * var4011 , void * var4012 , void * var4013 , void * var4014 , void * var4015 );
__stdcall void * ScaleViewportExtEx __attribute__((dllimport))(void * var4016 , void * var4017 , void * var4018 , void * var4019 , void * var4020 , void * var4021 );
__stdcall void * ScaleWindowExtEx __attribute__((dllimport))(void * var4022 , void * var4023 , void * var4024 , void * var4025 , void * var4026 , void * var4027 );
__stdcall void * ScreenToClient __attribute__((dllimport))(void * var4028 , void * var4029 );
__stdcall void * ScrollDC __attribute__((dllimport))(void * var4030 , void * var4031 , void * var4032 , void * var4033 , void * var4034 , void * var4035 , void * var4036 );
__stdcall void * ScrollWindow __attribute__((dllimport))(void * var4037 , void * var4038 , void * var4039 , void * var4040 , void * var4041 );
__stdcall void * ScrollWindowEx __attribute__((dllimport))(void * var4042 , void * var4043 , void * var4044 , void * var4045 , void * var4046 , void * var4047 , void * var4048 , void * var4049 );
__stdcall void * SearchPathW __attribute__((dllimport))(void * var4050 , void * var4051 , void * var4052 , void * var4053 , void * var4054 , void * var4055 );
__stdcall void * SendMessageCallbackA __attribute__((dllimport))(void * var4056 , void * var4057 , void * var4058 , void * var4059 , void * var4060 , void * var4061 );
__stdcall void * SendMessageCallbackW __attribute__((dllimport))(void * var4062 , void * var4063 , void * var4064 , void * var4065 , void * var4066 , void * var4067 );
__stdcall void * SetAbortProc __attribute__((dllimport))(void * var4068 , void * var4069 );
__stdcall void * SetBitmapDimensionEx __attribute__((dllimport))(void * var4070 , void * var4071 , void * var4072 , void * var4073 );
__stdcall void * SetBoundsRect __attribute__((dllimport))(void * var4074 , void * var4075 , void * var4076 );
__stdcall void * SetBrushOrgEx __attribute__((dllimport))(void * var4077 , void * var4078 , void * var4079 , void * var4080 );
__stdcall void * SetColorAdjustment __attribute__((dllimport))(void * var4081 , void * var4082 );
__stdcall void * SetCommState __attribute__((dllimport))(void * var4083 , void * var4084 );
__stdcall void * SetCommTimeouts __attribute__((dllimport))(void * var4085 , void * var4086 );
__stdcall void * SetComputerNameExW __attribute__((dllimport))(void * var4087 , void * var4088 );
__stdcall void * SetComputerNameW __attribute__((dllimport))(void * var4089 );
__stdcall void * SetConsoleCursorInfo __attribute__((dllimport))(void * var4090 , void * var4091 );
__stdcall void * SetConsoleCursorPosition __attribute__((dllimport))(void * var4092 , void * var4093 );
__stdcall void * SetConsoleScreenBufferSize __attribute__((dllimport))(void * var4094 , void * var4095 );
__stdcall void * SetConsoleTitleW __attribute__((dllimport))(void * var4096 );
__stdcall void * SetConsoleWindowInfo __attribute__((dllimport))(void * var4097 , void * var4098 , void * var4099 );
__stdcall void * SetCurrentDirectoryW __attribute__((dllimport))(void * var4100 );
__stdcall void * SetCursor __attribute__((dllimport))(void * var4101 );
__stdcall void * SetDIBColorTable __attribute__((dllimport))(void * var4102 , void * var4103 , void * var4104 , void * var4105 );
__stdcall void * SetDlgItemTextW __attribute__((dllimport))(void * var4106 , void * var4107 , void * var4108 );
__stdcall void * SetEnvironmentVariableW __attribute__((dllimport))(void * var4109 , void * var4110 );
__stdcall void * SetFileAttributesW __attribute__((dllimport))(void * var4111 , void * var4112 );
__stdcall void * SetFileSecurityW __attribute__((dllimport))(void * var4113 , void * var4114 , void * var4115 );
__stdcall void * SetFileShortNameW __attribute__((dllimport))(void * var4116 , void * var4117 );
__stdcall void * SetFileTime __attribute__((dllimport))(void * var4118 , void * var4119 , void * var4120 , void * var4121 );
__stdcall void * SetLocalTime __attribute__((dllimport))(void * var4122 );
__stdcall void * SetPaletteEntries __attribute__((dllimport))(void * var4123 , void * var4124 , void * var4125 , void * var4126 );
__stdcall void * SetPropW __attribute__((dllimport))(void * var4127 , void * var4128 , void * var4129 );
__stdcall void * SetRect __attribute__((dllimport))(void * var4130 , void * var4131 , void * var4132 , void * var4133 , void * var4134 );
__stdcall void * SetRectEmpty __attribute__((dllimport))(void * var4135 );
__stdcall void * SetServiceStatus __attribute__((dllimport))(void * var4136 , void * var4137 );
__stdcall void * SetSystemCursor __attribute__((dllimport))(void * var4138 , void * var4139 );
__stdcall void * SetSystemTime __attribute__((dllimport))(void * var4140 );
__stdcall void * SetTimer __attribute__((dllimport))(void * var4141 , void * var4142 , void * var4143 , void * var4144 );
__stdcall void * SetViewportExtEx __attribute__((dllimport))(void * var4145 , void * var4146 , void * var4147 , void * var4148 );
__stdcall void * SetViewportOrgEx __attribute__((dllimport))(void * var4149 , void * var4150 , void * var4151 , void * var4152 );
__stdcall void * SetVolumeLabelW __attribute__((dllimport))(void * var4153 , void * var4154 );
__stdcall void * SetVolumeMountPointW __attribute__((dllimport))(void * var4155 , void * var4156 );
__stdcall void * SetWaitableTimer __attribute__((dllimport))(void * var4157 , void * var4158 , void * var4159 , void * var4160 , void * var4161 , void * var4162 );
__stdcall void * SetWinEventHook __attribute__((dllimport))(void * var4163 , void * var4164 , void * var4165 , void * var4166 , void * var4167 , void * var4168 , void * var4169 );
__stdcall void * SetWindowExtEx __attribute__((dllimport))(void * var4170 , void * var4171 , void * var4172 , void * var4173 );
__stdcall void * SetWindowOrgEx __attribute__((dllimport))(void * var4174 , void * var4175 , void * var4176 , void * var4177 );
__stdcall void * SetWindowTextW __attribute__((dllimport))(void * var4178 , void * var4179 );
__stdcall void * SetWindowsHookA __attribute__((dllimport))(void * var4180 , void * var4181 );
__stdcall void * SetWindowsHookExA __attribute__((dllimport))(void * var4182 , void * var4183 , void * var4184 , void * var4185 );
__stdcall void * SetWindowsHookExW __attribute__((dllimport))(void * var4186 , void * var4187 , void * var4188 , void * var4189 );
__stdcall void * SetWindowsHookW __attribute__((dllimport))(void * var4190 , void * var4191 );
__stdcall void * SetWorldTransform __attribute__((dllimport))(void * var4192 , void * var4193 );
__stdcall void * SizeofResource __attribute__((dllimport))(void * var4194 , void * var4195 );
__stdcall void * StartServiceW __attribute__((dllimport))(void * var4196 , void * var4197 , void * var4198 );
__stdcall void * SubtractRect __attribute__((dllimport))(void * var4199 , void * var4200 , void * var4201 );
__stdcall void * SystemTimeToFileTime __attribute__((dllimport))(void * var4202 , void * var4203 );
__stdcall void * TabbedTextOutW __attribute__((dllimport))(void * var4204 , void * var4205 , void * var4206 , void * var4207 , void * var4208 , void * var4209 , void * var4210 , void * var4211 );
__stdcall void * TextOutW __attribute__((dllimport))(void * var4212 , void * var4213 , void * var4214 , void * var4215 , void * var4216 );
__stdcall void * TileWindows __attribute__((dllimport))(void * var4217 , void * var4218 , void * var4219 , void * var4220 , void * var4221 );
__stdcall void * ToUnicode __attribute__((dllimport))(void * var4222 , void * var4223 , void * var4224 , void * var4225 , void * var4226 , void * var4227 );
__stdcall void * ToUnicodeEx __attribute__((dllimport))(void * var4228 , void * var4229 , void * var4230 , void * var4231 , void * var4232 , void * var4233 , void * var4234 );
__stdcall void * TrackPopupMenu __attribute__((dllimport))(void * var4235 , void * var4236 , void * var4237 , void * var4238 , void * var4239 , void * var4240 , void * var4241 );
__stdcall void * TransactNamedPipe __attribute__((dllimport))(void * var4242 , void * var4243 , void * var4244 , void * var4245 , void * var4246 , void * var4247 , void * var4248 );
__stdcall void * UnhookWindowsHook __attribute__((dllimport))(void * var4249 , void * var4250 );
__stdcall void * UnionRect __attribute__((dllimport))(void * var4251 , void * var4252 , void * var4253 );
__stdcall void * UnlockFileEx __attribute__((dllimport))(void * var4254 , void * var4255 , void * var4256 , void * var4257 , void * var4258 );
__stdcall void * UnregisterClassW __attribute__((dllimport))(void * var4259 , void * var4260 );
__stdcall void * UpdateLayeredWindow __attribute__((dllimport))(void * var4261 , void * var4262 , void * var4263 , void * var4264 , void * var4265 , void * var4266 , void * var4267 , void * var4268 , void * var4269 );
__stdcall void * UpdateResourceW __attribute__((dllimport))(void * var4270 , void * var4271 , void * var4272 , void * var4273 , void * var4274 , void * var4275 );
__stdcall void * ValidateRect __attribute__((dllimport))(void * var4276 , void * var4277 );
__stdcall void * VerifyVersionInfoA __attribute__((dllimport))(void * var4278 , void * var4279 , void * var4280 );
__stdcall void * WaitCommEvent __attribute__((dllimport))(void * var4281 , void * var4282 , void * var4283 );
__stdcall void * WaitNamedPipeW __attribute__((dllimport))(void * var4284 , void * var4285 );
__stdcall void * WideCharToMultiByte __attribute__((dllimport))(void * var4286 , void * var4287 , void * var4288 , void * var4289 , void * var4290 , void * var4291 , void * var4292 , void * var4293 );
__stdcall void * WinHelpW __attribute__((dllimport))(void * var4294 , void * var4295 , void * var4296 , void * var4297 );
__stdcall void * WindowFromPoint __attribute__((dllimport))(void * var4298 );
__stdcall void * WriteConsoleOutputAttribute __attribute__((dllimport))(void * var4299 , void * var4300 , void * var4301 , void * var4302 , void * var4303 );
__stdcall void * WriteConsoleOutputCharacterA __attribute__((dllimport))(void * var4304 , void * var4305 , void * var4306 , void * var4307 , void * var4308 );
__stdcall void * WriteEncryptedFileRaw __attribute__((dllimport))(void * var4309 , void * var4310 , void * var4311 );
__stdcall void * WriteFile __attribute__((dllimport))(void * var4312 , void * var4313 , void * var4314 , void * var4315 , void * var4316 );
__stdcall void * WritePrivateProfileSectionW __attribute__((dllimport))(void * var4317 , void * var4318 , void * var4319 );
__stdcall void * WritePrivateProfileStringW __attribute__((dllimport))(void * var4320 , void * var4321 , void * var4322 , void * var4323 );
__stdcall void * WritePrivateProfileStructW __attribute__((dllimport))(void * var4324 , void * var4325 , void * var4326 , void * var4327 , void * var4328 );
__stdcall void * WriteProfileStringW __attribute__((dllimport))(void * var4329 , void * var4330 , void * var4331 );
__stdcall void * lstrcatW __attribute__((dllimport))(void * var4332 , void * var4333 );
__stdcall void * lstrcmpW __attribute__((dllimport))(void * var4334 , void * var4335 );
__stdcall void * lstrcmpiW __attribute__((dllimport))(void * var4336 , void * var4337 );
__stdcall void * lstrcpyW __attribute__((dllimport))(void * var4338 , void * var4339 );
__stdcall void * lstrcpynW __attribute__((dllimport))(void * var4340 , void * var4341 , void * var4342 );
__stdcall void * lstrlenW __attribute__((dllimport))(void * var4343 );
__stdcall void * wvsprintfW __attribute__((dllimport))(void * var4344 , void * var4345 , void * var4346 );
__stdcall void * AddAccessAllowedAce __attribute__((dllimport))(void * var4347 , void * var4348 , void * var4349 , void * var4350 );
__stdcall void * AddAccessAllowedAceEx __attribute__((dllimport))(void * var4351 , void * var4352 , void * var4353 , void * var4354 , void * var4355 );
__stdcall void * AddAccessAllowedObjectAce __attribute__((dllimport))(void * var4356 , void * var4357 , void * var4358 , void * var4359 , void * var4360 , void * var4361 , void * var4362 );
__stdcall void * AddAccessDeniedAce __attribute__((dllimport))(void * var4363 , void * var4364 , void * var4365 , void * var4366 );
__stdcall void * AddAccessDeniedAceEx __attribute__((dllimport))(void * var4367 , void * var4368 , void * var4369 , void * var4370 , void * var4371 );
__stdcall void * AddAccessDeniedObjectAce __attribute__((dllimport))(void * var4372 , void * var4373 , void * var4374 , void * var4375 , void * var4376 , void * var4377 , void * var4378 );
__stdcall void * AddAce __attribute__((dllimport))(void * var4379 , void * var4380 , void * var4381 , void * var4382 , void * var4383 );
__stdcall void * AddAuditAccessAce __attribute__((dllimport))(void * var4384 , void * var4385 , void * var4386 , void * var4387 , void * var4388 , void * var4389 );
__stdcall void * AddAuditAccessAceEx __attribute__((dllimport))(void * var4390 , void * var4391 , void * var4392 , void * var4393 , void * var4394 , void * var4395 , void * var4396 );
__stdcall void * AddAuditAccessObjectAce __attribute__((dllimport))(void * var4397 , void * var4398 , void * var4399 , void * var4400 , void * var4401 , void * var4402 , void * var4403 , void * var4404 , void * var4405 );
__stdcall void * BindIoCompletionCallback __attribute__((dllimport))(void * var4406 , void * var4407 , void * var4408 );
__stdcall void * BroadcastSystemMessageExW __attribute__((dllimport))(void * var4409 , void * var4410 , void * var4411 , void * var4412 , void * var4413 , void * var4414 );
__stdcall void * CopyFileExA __attribute__((dllimport))(void * var4415 , void * var4416 , void * var4417 , void * var4418 , void * var4419 , void * var4420 );
__stdcall void * CopyFileExW __attribute__((dllimport))(void * var4421 , void * var4422 , void * var4423 , void * var4424 , void * var4425 , void * var4426 );
__stdcall void * CreateBrushIndirect __attribute__((dllimport))(void * var4427 );
__stdcall void * CreateFontIndirectW __attribute__((dllimport))(void * var4428 );
__stdcall void * CreateProcessA __attribute__((dllimport))(void * var4429 , void * var4430 , void * var4431 , void * var4432 , void * var4433 , void * var4434 , void * var4435 , void * var4436 , void * var4437 , void * var4438 );
__stdcall void * CreateProcessAsUserA __attribute__((dllimport))(void * var4439 , void * var4440 , void * var4441 , void * var4442 , void * var4443 , void * var4444 , void * var4445 , void * var4446 , void * var4447 , void * var4448 , void * var4449 );
__stdcall void * CreateTimerQueueTimer __attribute__((dllimport))(void * var4450 , void * var4451 , void * var4452 , void * var4453 , void * var4454 , void * var4455 , void * var4456 );
__stdcall void * DeleteAce __attribute__((dllimport))(void * var4457 , void * var4458 );
__stdcall void * EnumCalendarInfoW __attribute__((dllimport))(void * var4459 , void * var4460 , void * var4461 , void * var4462 );
__stdcall void * EnumDateFormatsW __attribute__((dllimport))(void * var4463 , void * var4464 , void * var4465 );
__stdcall void * EnumDesktopsA __attribute__((dllimport))(void * var4466 , void * var4467 , void * var4468 );
__stdcall void * EnumDisplayDevicesW __attribute__((dllimport))(void * var4469 , void * var4470 , void * var4471 , void * var4472 );
__stdcall void * EnumDisplayMonitors __attribute__((dllimport))(void * var4473 , void * var4474 , void * var4475 , void * var4476 );
__stdcall void * EnumEnhMetaFile __attribute__((dllimport))(void * var4477 , void * var4478 , void * var4479 , void * var4480 , void * var4481 );
__stdcall void * EnumMetaFile __attribute__((dllimport))(void * var4482 , void * var4483 , void * var4484 , void * var4485 );
__stdcall void * EnumPropsExW __attribute__((dllimport))(void * var4486 , void * var4487 , void * var4488 );
__stdcall void * EnumResourceLanguagesA __attribute__((dllimport))(void * var4489 , void * var4490 , void * var4491 , void * var4492 , void * var4493 );
__stdcall void * EnumResourceLanguagesW __attribute__((dllimport))(void * var4494 , void * var4495 , void * var4496 , void * var4497 , void * var4498 );
__stdcall void * EnumResourceNamesA __attribute__((dllimport))(void * var4499 , void * var4500 , void * var4501 , void * var4502 );
__stdcall void * EnumResourceNamesW __attribute__((dllimport))(void * var4503 , void * var4504 , void * var4505 , void * var4506 );
__stdcall void * EnumResourceTypesA __attribute__((dllimport))(void * var4507 , void * var4508 , void * var4509 );
__stdcall void * EnumSystemCodePagesW __attribute__((dllimport))(void * var4510 , void * var4511 );
__stdcall void * EnumSystemLocalesW __attribute__((dllimport))(void * var4512 , void * var4513 );
__stdcall void * EnumTimeFormatsW __attribute__((dllimport))(void * var4514 , void * var4515 , void * var4516 );
__stdcall void * EnumUILanguagesW __attribute__((dllimport))(void * var4517 , void * var4518 , void * var4519 );
__stdcall void * EnumWindowStationsA __attribute__((dllimport))(void * var4520 , void * var4521 );
__stdcall void * ExtCreatePen __attribute__((dllimport))(void * var4522 , void * var4523 , void * var4524 , void * var4525 , void * var4526 );
__stdcall void * FindFirstFreeAce __attribute__((dllimport))(void * var4527 , void * var4528 );
__stdcall void * GetAce __attribute__((dllimport))(void * var4535 , void * var4536 , void * var4537 );
__stdcall void * GetAclInformation __attribute__((dllimport))(void * var4538 , void * var4539 , void * var4540 , void * var4541 );
__stdcall void * GetCommProperties __attribute__((dllimport))(void * var4542 , void * var4543 );
__stdcall void * GetCurrencyFormatA __attribute__((dllimport))(void * var4544 , void * var4545 , void * var4546 , void * var4547 , void * var4548 , void * var4549 );
__stdcall void * GetCurrentHwProfileW __attribute__((dllimport))(void * var4550 );
__stdcall void * GetDiskFreeSpaceExA __attribute__((dllimport))(void * var4551 , void * var4552 , void * var4553 , void * var4554 );
__stdcall void * GetDiskFreeSpaceExW __attribute__((dllimport))(void * var4555 , void * var4556 , void * var4557 , void * var4558 );
__stdcall void * GetFileSizeEx __attribute__((dllimport))(void * var4559 , void * var4560 );
__stdcall void * GetMenuItemInfoA __attribute__((dllimport))(void * var4561 , void * var4562 , void * var4563 , void * var4564 );
__stdcall void * GetNativeSystemInfo __attribute__((dllimport))(void * var4565 );
__stdcall void * GetNumberFormatA __attribute__((dllimport))(void * var4566 , void * var4567 , void * var4568 , void * var4569 , void * var4570 , void * var4571 );
__stdcall void * GetSecurityDescriptorDacl __attribute__((dllimport))(void * var4572 , void * var4573 , void * var4574 , void * var4575 );
__stdcall void * GetSecurityDescriptorSacl __attribute__((dllimport))(void * var4576 , void * var4577 , void * var4578 , void * var4579 );
__stdcall void * GetStartupInfoA __attribute__((dllimport))(void * var4580 );
__stdcall void * GetSystemInfo __attribute__((dllimport))(void * var4581 );
__stdcall void * GetTextMetricsW __attribute__((dllimport))(void * var4582 , void * var4583 );
__stdcall void * GetThreadSelectorEntry __attribute__((dllimport))(void * var4584 , void * var4585 , void * var4586 );
__stdcall void * GetVersionExW __attribute__((dllimport))(void * var4587 );
__stdcall void * GlobalMemoryStatus __attribute__((dllimport))(void * var4588 );
__stdcall void * GlobalMemoryStatusEx __attribute__((dllimport))(void * var4589 );
__stdcall void * InitializeAcl __attribute__((dllimport))(void * var4596 , void * var4597 , void * var4598 );
__stdcall void * InitializeSListHead __attribute__((dllimport))(void * var4599 );
__stdcall void * InterlockedFlushSList __attribute__((dllimport))(void * var4600 );
__stdcall void * InterlockedPopEntrySList __attribute__((dllimport))(void * var4601 );
__stdcall void * InterlockedPushEntrySList __attribute__((dllimport))(void * var4602 , void * var4603 );
__stdcall void * IsValidAcl __attribute__((dllimport))(void * var4604 );
__stdcall void * MakeAbsoluteSD __attribute__((dllimport))(void * var4605 , void * var4606 , void * var4607 , void * var4608 , void * var4609 , void * var4610 , void * var4611 , void * var4612 , void * var4613 , void * var4614 , void * var4615 );
__stdcall void * MonitorFromRect __attribute__((dllimport))(void * var4616 , void * var4617 );
__stdcall void * MoveFileWithProgressW __attribute__((dllimport))(void * var4618 , void * var4619 , void * var4620 , void * var4621 , void * var4622 );
__stdcall void * QueryDepthSList __attribute__((dllimport))(void * var4623 );
__stdcall void * QueryServiceConfigA __attribute__((dllimport))(void * var4624 , void * var4625 , void * var4626 , void * var4627 );
__stdcall void * QueryServiceLockStatusA __attribute__((dllimport))(void * var4628 , void * var4629 , void * var4630 , void * var4631 );
__stdcall void * ReadConsoleOutputA __attribute__((dllimport))(void * var4632 , void * var4633 , void * var4634 , void * var4635 , void * var4636 );
__stdcall void * ReadConsoleOutputW __attribute__((dllimport))(void * var4637 , void * var4638 , void * var4639 , void * var4640 , void * var4641 );
__stdcall void * ReadDirectoryChangesW __attribute__((dllimport))(void * var4642 , void * var4643 , void * var4644 , void * var4645 , void * var4646 , void * var4647 , void * var4648 , void * var4649 );
__stdcall void * ReadFileEx __attribute__((dllimport))(void * var4650 , void * var4651 , void * var4652 , void * var4653 , void * var4654 );
__stdcall void * RegisterWaitForSingleObject __attribute__((dllimport))(void * var4655 , void * var4656 , void * var4657 , void * var4658 , void * var4659 , void * var4660 );
__stdcall void * RegisterWaitForSingleObjectEx __attribute__((dllimport))(void * var4661 , void * var4662 , void * var4663 , void * var4664 , void * var4665 );
__stdcall void * RtlFirstEntrySList __attribute__((dllimport))(void * var4666 );
__stdcall void * RtlInitializeSListHead __attribute__((dllimport))(void * var4667 );
__stdcall void * RtlInterlockedPopEntrySList __attribute__((dllimport))(void * var4668 );
__stdcall void * RtlInterlockedPushEntrySList __attribute__((dllimport))(void * var4669 , void * var4670 );
__stdcall void * RtlUnwind __attribute__((dllimport))(void * var4671 , void * var4672 , void * var4673 , void * var4674 );
__stdcall void * ScrollConsoleScreenBufferA __attribute__((dllimport))(void * var4675 , void * var4676 , void * var4677 , void * var4678 , void * var4679 );
__stdcall void * ScrollConsoleScreenBufferW __attribute__((dllimport))(void * var4680 , void * var4681 , void * var4682 , void * var4683 , void * var4684 );
__stdcall void * SetFilePointerEx __attribute__((dllimport))(void * var4685 , void * var4686 , void * var4687 , void * var4688 );
__stdcall void * SetScrollInfo __attribute__((dllimport))(void * var4689 , void * var4690 , void * var4691 , void * var4692 );
__stdcall void * SetSecurityDescriptorDacl __attribute__((dllimport))(void * var4693 , void * var4694 , void * var4695 , void * var4696 );
__stdcall void * SetSecurityDescriptorSacl __attribute__((dllimport))(void * var4697 , void * var4698 , void * var4699 , void * var4700 );
__stdcall void * SetTimerQueueTimer __attribute__((dllimport))(void * var4701 , void * var4702 , void * var4703 , void * var4704 , void * var4705 , void * var4706 );
__stdcall void * SetWinMetaFileBits __attribute__((dllimport))(void * var4707 , void * var4708 , void * var4709 , void * var4710 );
__stdcall void * StartDocA __attribute__((dllimport))(void * var4711 , void * var4712 );
__stdcall void * TrackMouseEvent __attribute__((dllimport))(void * var4713 );
__stdcall void * VerifyVersionInfoW __attribute__((dllimport))(void * var4714 , void * var4715 , void * var4716 );
__stdcall void * VirtualQuery __attribute__((dllimport))(void * var4717 , void * var4718 , void * var4719 );
__stdcall void * VirtualQueryEx __attribute__((dllimport))(void * var4720 , void * var4721 , void * var4722 , void * var4723 );
__stdcall void * WriteConsoleOutputA __attribute__((dllimport))(void * var4724 , void * var4725 , void * var4726 , void * var4727 , void * var4728 );
__stdcall void * WriteConsoleOutputW __attribute__((dllimport))(void * var4729 , void * var4730 , void * var4731 , void * var4732 , void * var4733 );
__stdcall void * WriteFileEx __attribute__((dllimport))(void * var4734 , void * var4735 , void * var4736 , void * var4737 , void * var4738 );
__stdcall void * AccessCheckAndAuditAlarmA __attribute__((dllimport))(void * var4739 , void * var4740 , void * var4741 , void * var4742 , void * var4743 , void * var4744 , void * var4745 , void * var4746 , void * var4747 , void * var4748 , void * var4749 );
__stdcall void * AccessCheckAndAuditAlarmW __attribute__((dllimport))(void * var4750 , void * var4751 , void * var4752 , void * var4753 , void * var4754 , void * var4755 , void * var4756 , void * var4757 , void * var4758 , void * var4759 , void * var4760 );
__stdcall void * BeginPaint __attribute__((dllimport))(void * var4761 , void * var4762 );
__stdcall void * CallMsgFilterA __attribute__((dllimport))(void * var4763 , void * var4764 );
__stdcall void * CallMsgFilterW __attribute__((dllimport))(void * var4765 , void * var4766 );
__stdcall void * ChangeDisplaySettingsA __attribute__((dllimport))(void * var4767 , void * var4768 );
__stdcall void * ChangeDisplaySettingsExA __attribute__((dllimport))(void * var4769 , void * var4770 , void * var4771 , void * var4772 , void * var4773 );
__stdcall void * ChangeDisplaySettingsExW __attribute__((dllimport))(void * var4774 , void * var4775 , void * var4776 , void * var4777 , void * var4778 );
__stdcall void * ChangeDisplaySettingsW __attribute__((dllimport))(void * var4779 , void * var4780 );
__stdcall void * CommConfigDialogA __attribute__((dllimport))(void * var4781 , void * var4782 , void * var4783 );
__stdcall void * CommConfigDialogW __attribute__((dllimport))(void * var4784 , void * var4785 , void * var4786 );
__stdcall void * ConvertToAutoInheritPrivateObjectSecurity __attribute__((dllimport))(void * var4787 , void * var4788 , void * var4789 , void * var4790 , void * var4791 , void * var4792 );
__stdcall void * CreateDCA __attribute__((dllimport))(void * var4793 , void * var4794 , void * var4795 , void * var4796 );
__stdcall void * CreateDCW __attribute__((dllimport))(void * var4797 , void * var4798 , void * var4799 , void * var4800 );
__stdcall void * CreateDIBSection __attribute__((dllimport))(void * var4801 , void * var4802 , void * var4803 , void * var4804 , void * var4805 , void * var4806 );
__stdcall void * CreateDIBitmap __attribute__((dllimport))(void * var4807 , void * var4808 , void * var4809 , void * var4810 , void * var4811 , void * var4812 );
__stdcall void * CreateDesktopA __attribute__((dllimport))(void * var4813 , void * var4814 , void * var4815 , void * var4816 , void * var4817 , void * var4818 );
__stdcall void * CreateDesktopW __attribute__((dllimport))(void * var4819 , void * var4820 , void * var4821 , void * var4822 , void * var4823 , void * var4824 );
__stdcall void * CreateICA __attribute__((dllimport))(void * var4825 , void * var4826 , void * var4827 , void * var4828 );
__stdcall void * CreateICW __attribute__((dllimport))(void * var4829 , void * var4830 , void * var4831 , void * var4832 );
__stdcall void * CreateIconIndirect __attribute__((dllimport))(void * var4833 );
__stdcall void * CreatePalette __attribute__((dllimport))(void * var4834 );
__stdcall void * CreatePenIndirect __attribute__((dllimport))(void * var4835 );
__stdcall void * CreatePrivateObjectSecurity __attribute__((dllimport))(void * var4836 , void * var4837 , void * var4838 , void * var4839 , void * var4840 , void * var4841 );
__stdcall void * CreatePrivateObjectSecurityEx __attribute__((dllimport))(void * var4842 , void * var4843 , void * var4844 , void * var4845 , void * var4846 , void * var4847 , void * var4848 , void * var4849 );
__stdcall void * CreatePrivateObjectSecurityWithMultipleInheritance __attribute__((dllimport))(void * var4850 , void * var4851 , void * var4852 , void * var4853 , void * var4854 , void * var4855 , void * var4856 , void * var4857 , void * var4858 );
__stdcall void * CreateProcessAsUserW __attribute__((dllimport))(void * var4859 , void * var4860 , void * var4861 , void * var4862 , void * var4863 , void * var4864 , void * var4865 , void * var4866 , void * var4867 , void * var4868 , void * var4869 );
__stdcall void * CreateProcessW __attribute__((dllimport))(void * var4870 , void * var4871 , void * var4872 , void * var4873 , void * var4874 , void * var4875 , void * var4876 , void * var4877 , void * var4878 , void * var4879 );
__stdcall void * CreateProcessWithLogonW __attribute__((dllimport))(void * var4880 , void * var4881 , void * var4882 , void * var4883 , void * var4884 , void * var4885 , void * var4886 , void * var4887 , void * var4888 , void * var4889 , void * var4890 );
__stdcall void * CreateProcessWithTokenW __attribute__((dllimport))(void * var4891 , void * var4892 , void * var4893 , void * var4894 , void * var4895 , void * var4896 , void * var4897 , void * var4898 , void * var4899 );
__stdcall void * CreateRestrictedToken __attribute__((dllimport))(void * var4900 , void * var4901 , void * var4902 , void * var4903 , void * var4904 , void * var4905 , void * var4906 , void * var4907 , void * var4908 );
__stdcall void * DeviceCapabilitiesA __attribute__((dllimport))(void * var4909 , void * var4910 , void * var4911 , void * var4912 , void * var4913 );
__stdcall void * DeviceCapabilitiesW __attribute__((dllimport))(void * var4914 , void * var4915 , void * var4916 , void * var4917 , void * var4918 );
__stdcall void * DispatchMessageA __attribute__((dllimport))(void * var4919 );
__stdcall void * DispatchMessageW __attribute__((dllimport))(void * var4920 );
__stdcall void * EndPaint __attribute__((dllimport))(void * var4921 , void * var4922 );
__stdcall void * EnumDependentServicesA __attribute__((dllimport))(void * var4923 , void * var4924 , void * var4925 , void * var4926 , void * var4927 , void * var4928 );
__stdcall void * EnumDependentServicesW __attribute__((dllimport))(void * var4929 , void * var4930 , void * var4931 , void * var4932 , void * var4933 , void * var4934 );
__stdcall void * EnumDesktopsW __attribute__((dllimport))(void * var4935 , void * var4936 , void * var4937 );
__stdcall void * EnumDisplaySettingsA __attribute__((dllimport))(void * var4938 , void * var4939 , void * var4940 );
__stdcall void * EnumDisplaySettingsExW __attribute__((dllimport))(void * var4941 , void * var4942 , void * var4943 , void * var4944 );
__stdcall void * EnumDisplaySettingsW __attribute__((dllimport))(void * var4945 , void * var4946 , void * var4947 );
__stdcall void * EnumFontFamiliesA __attribute__((dllimport))(void * var4948 , void * var4949 , void * var4950 , void * var4951 );
__stdcall void * EnumFontFamiliesExA __attribute__((dllimport))(void * var4952 , void * var4953 , void * var4954 , void * var4955 , void * var4956 );
__stdcall void * EnumFontsA __attribute__((dllimport))(void * var4957 , void * var4958 , void * var4959 , void * var4960 );
__stdcall void * EnumServicesStatusA __attribute__((dllimport))(void * var4961 , void * var4962 , void * var4963 , void * var4964 , void * var4965 , void * var4966 , void * var4967 , void * var4968 );
__stdcall void * EnumServicesStatusW __attribute__((dllimport))(void * var4969 , void * var4970 , void * var4971 , void * var4972 , void * var4973 , void * var4974 , void * var4975 , void * var4976 );
__stdcall void * EnumWindowStationsW __attribute__((dllimport))(void * var4977 , void * var4978 );
__stdcall void * FindActCtxSectionGuid __attribute__((dllimport))(void * var4979 , void * var4980 , void * var4981 , void * var4982 , void * var4983 );
__stdcall void * FindActCtxSectionStringW __attribute__((dllimport))(void * var4984 , void * var4985 , void * var4986 , void * var4987 , void * var4988 );
__stdcall void * FindFirstFileA __attribute__((dllimport))(void * var4989 , void * var4990 );
__stdcall void * FindFirstFileW __attribute__((dllimport))(void * var4991 , void * var4992 );
__stdcall void * FindNextFileA __attribute__((dllimport))(void * var4993 , void * var4994 );
__stdcall void * FindNextFileW __attribute__((dllimport))(void * var4995 , void * var4996 );
__stdcall void * GetCharacterPlacementA __attribute__((dllimport))(void * var4997 , void * var4998 , void * var4999 , void * var5000 , void * var5001 , void * var5002 );
__stdcall void * GetCharacterPlacementW __attribute__((dllimport))(void * var5003 , void * var5004 , void * var5005 , void * var5006 , void * var5007 , void * var5008 );
__stdcall void * GetClassInfoA __attribute__((dllimport))(void * var5009 , void * var5010 , void * var5011 );
__stdcall void * GetClassInfoExA __attribute__((dllimport))(void * var5012 , void * var5013 , void * var5014 );
__stdcall void * GetClassInfoExW __attribute__((dllimport))(void * var5015 , void * var5016 , void * var5017 );
__stdcall void * GetClassInfoW __attribute__((dllimport))(void * var5018 , void * var5019 , void * var5020 );
__stdcall void * GetComboBoxInfo __attribute__((dllimport))(void * var5021 , void * var5022 );
__stdcall void * GetCommConfig __attribute__((dllimport))(void * var5023 , void * var5024 , void * var5025 );
__stdcall void * GetConsoleScreenBufferInfo __attribute__((dllimport))(void * var5026 , void * var5027 );
__stdcall void * GetCurrencyFormatW __attribute__((dllimport))(void * var5028 , void * var5029 , void * var5030 , void * var5031 , void * var5032 , void * var5033 );
__stdcall void * GetCurrentConsoleFont __attribute__((dllimport))(void * var5034 , void * var5035 , void * var5036 );
__stdcall void * GetCursorInfo __attribute__((dllimport))(void * var5037 );
__stdcall void * GetDIBits __attribute__((dllimport))(void * var5038 , void * var5039 , void * var5040 , void * var5041 , void * var5042 , void * var5043 , void * var5044 );
__stdcall void * GetDefaultCommConfigA __attribute__((dllimport))(void * var5045 , void * var5046 , void * var5047 );
__stdcall void * GetDefaultCommConfigW __attribute__((dllimport))(void * var5048 , void * var5049 , void * var5050 );
__stdcall void * GetFileInformationByHandle __attribute__((dllimport))(void * var5051 , void * var5052 );
__stdcall void * GetGUIThreadInfo __attribute__((dllimport))(void * var5053 , void * var5054 );
__stdcall void * GetGlyphOutlineA __attribute__((dllimport))(void * var5055 , void * var5056 , void * var5057 , void * var5058 , void * var5059 , void * var5060 , void * var5061 );
__stdcall void * GetGlyphOutlineW __attribute__((dllimport))(void * var5062 , void * var5063 , void * var5064 , void * var5065 , void * var5066 , void * var5067 , void * var5068 );
__stdcall void * GetIconInfo __attribute__((dllimport))(void * var5069 , void * var5070 );
__stdcall void * GetMenuBarInfo __attribute__((dllimport))(void * var5071 , void * var5072 , void * var5073 , void * var5074 );
__stdcall void * GetMenuItemInfoW __attribute__((dllimport))(void * var5075 , void * var5076 , void * var5077 , void * var5078 );
__stdcall void * GetMessageA __attribute__((dllimport))(void * var5079 , void * var5080 , void * var5081 , void * var5082 );
__stdcall void * GetMessageW __attribute__((dllimport))(void * var5083 , void * var5084 , void * var5085 , void * var5086 );
__stdcall void * GetMonitorInfoA __attribute__((dllimport))(void * var5087 , void * var5088 );
__stdcall void * GetMonitorInfoW __attribute__((dllimport))(void * var5089 , void * var5090 );
__stdcall void * GetNumberFormatW __attribute__((dllimport))(void * var5091 , void * var5092 , void * var5093 , void * var5094 , void * var5095 , void * var5096 );
__stdcall void * GetOutlineTextMetricsA __attribute__((dllimport))(void * var5097 , void * var5098 , void * var5099 );
__stdcall void * GetScrollBarInfo __attribute__((dllimport))(void * var5100 , void * var5101 , void * var5102 );
__stdcall void * GetStartupInfoW __attribute__((dllimport))(void * var5103 );
__stdcall void * GetTimeZoneInformation __attribute__((dllimport))(void * var5104 );
__stdcall void * GetTitleBarInfo __attribute__((dllimport))(void * var5105 , void * var5106 );
__stdcall void * GetWindowInfo __attribute__((dllimport))(void * var5107 , void * var5108 );
__stdcall void * GetWindowPlacement __attribute__((dllimport))(void * var5109 , void * var5110 );
__stdcall void * InsertMenuItemA __attribute__((dllimport))(void * var5111 , void * var5112 , void * var5113 , void * var5114 );
__stdcall void * IsDialogMessageA __attribute__((dllimport))(void * var5115 , void * var5116 );
__stdcall void * IsDialogMessageW __attribute__((dllimport))(void * var5117 , void * var5118 );
__stdcall void * LogonUserExW __attribute__((dllimport))(void * var5119 , void * var5120 , void * var5121 , void * var5122 , void * var5123 , void * var5124 , void * var5125 , void * var5126 , void * var5127 , void * var5128 );
__stdcall void * MapGenericMask __attribute__((dllimport))(void * var5129 , void * var5130 );
__stdcall void * PeekMessageA __attribute__((dllimport))(void * var5131 , void * var5132 , void * var5133 , void * var5134 , void * var5135 );
__stdcall void * PeekMessageW __attribute__((dllimport))(void * var5136 , void * var5137 , void * var5138 , void * var5139 , void * var5140 );
__stdcall void * PolyTextOutA __attribute__((dllimport))(void * var5141 , void * var5142 , void * var5143 );
__stdcall void * QueryServiceConfigW __attribute__((dllimport))(void * var5144 , void * var5145 , void * var5146 , void * var5147 );
__stdcall void * QueryServiceLockStatusW __attribute__((dllimport))(void * var5148 , void * var5149 , void * var5150 , void * var5151 );
__stdcall void * RegisterClassA __attribute__((dllimport))(void * var5152 );
__stdcall void * RegisterClassExA __attribute__((dllimport))(void * var5153 );
__stdcall void * RegisterClassExW __attribute__((dllimport))(void * var5154 );
__stdcall void * RegisterClassW __attribute__((dllimport))(void * var5155 );
__stdcall void * RegisterRawInputDevices __attribute__((dllimport))(void * var5156 , void * var5157 , void * var5158 );
__stdcall void * ResetDCA __attribute__((dllimport))(void * var5159 , void * var5160 );
__stdcall void * ResetDCW __attribute__((dllimport))(void * var5161 , void * var5162 );
__stdcall void * SendInput __attribute__((dllimport))(void * var5163 , void * var5164 , void * var5165 );
__stdcall void * SetCommConfig __attribute__((dllimport))(void * var5166 , void * var5167 , void * var5168 );
__stdcall void * SetDIBits __attribute__((dllimport))(void * var5169 , void * var5170 , void * var5171 , void * var5172 , void * var5173 , void * var5174 , void * var5175 );
__stdcall void * SetDIBitsToDevice __attribute__((dllimport))(void * var5176 , void * var5177 , void * var5178 , void * var5179 , void * var5180 , void * var5181 , void * var5182 , void * var5183 , void * var5184 , void * var5185 , void * var5186 , void * var5187 );
__stdcall void * SetDefaultCommConfigA __attribute__((dllimport))(void * var5188 , void * var5189 , void * var5190 );
__stdcall void * SetDefaultCommConfigW __attribute__((dllimport))(void * var5191 , void * var5192 , void * var5193 );
__stdcall void * SetMenuInfo __attribute__((dllimport))(void * var5194 , void * var5195 );
__stdcall void * SetMenuItemInfoA __attribute__((dllimport))(void * var5196 , void * var5197 , void * var5198 , void * var5199 );
__stdcall void * SetPrivateObjectSecurity __attribute__((dllimport))(void * var5200 , void * var5201 , void * var5202 , void * var5203 , void * var5204 );
__stdcall void * SetThreadContext __attribute__((dllimport))(void * var5205 , void * var5206 );
__stdcall void * SetTimeZoneInformation __attribute__((dllimport))(void * var5207 );
__stdcall void * SetWindowPlacement __attribute__((dllimport))(void * var5208 , void * var5209 );
__stdcall void * StartDocW __attribute__((dllimport))(void * var5210 , void * var5211 );
__stdcall void * StartServiceCtrlDispatcherA __attribute__((dllimport))(void * var5212 );
__stdcall void * StretchDIBits __attribute__((dllimport))(void * var5213 , void * var5214 , void * var5215 , void * var5216 , void * var5217 , void * var5218 , void * var5219 , void * var5220 , void * var5221 , void * var5222 , void * var5223 , void * var5224 , void * var5225 );
__stdcall void * SystemTimeToTzSpecificLocalTime __attribute__((dllimport))(void * var5226 , void * var5227 , void * var5228 );
__stdcall void * TranslateAcceleratorA __attribute__((dllimport))(void * var5229 , void * var5230 , void * var5231 );
__stdcall void * TranslateAcceleratorW __attribute__((dllimport))(void * var5232 , void * var5233 , void * var5234 );
__stdcall void * TranslateCharsetInfo __attribute__((dllimport))(void * var5235 , void * var5236 , void * var5237 );
__stdcall void * TranslateMDISysAccel __attribute__((dllimport))(void * var5238 , void * var5239 );
__stdcall void * TranslateMessage __attribute__((dllimport))(void * var5240 );
__stdcall void * TzSpecificLocalTimeToSystemTime __attribute__((dllimport))(void * var5241 , void * var5242 , void * var5243 );
__stdcall void * CreateActCtxW __attribute__((dllimport))(void * var5244 );
__stdcall void * EnumFontFamiliesExW __attribute__((dllimport))(void * var5245 , void * var5246 , void * var5247 , void * var5248 , void * var5249 );
__stdcall void * EnumFontFamiliesW __attribute__((dllimport))(void * var5250 , void * var5251 , void * var5252 , void * var5253 );
__stdcall void * EnumFontsW __attribute__((dllimport))(void * var5254 , void * var5255 , void * var5256 , void * var5257 );
__stdcall void * GetEnhMetaFileHeader __attribute__((dllimport))(void * var5258 , void * var5259 , void * var5260 );
__stdcall void * GetOutlineTextMetricsW __attribute__((dllimport))(void * var5261 , void * var5262 , void * var5263 );
__stdcall void * InsertMenuItemW __attribute__((dllimport))(void * var5264 , void * var5265 , void * var5266 , void * var5267 );
__stdcall void * RtlCaptureContext __attribute__((dllimport))(void * var5268 );
__stdcall void * SetMenuItemInfoW __attribute__((dllimport))(void * var5269 , void * var5270 , void * var5271 , void * var5272 );
__stdcall void * StartServiceCtrlDispatcherW __attribute__((dllimport))(void * var5273 );
__stdcall void * TrackPopupMenuEx __attribute__((dllimport))(void * var5274 , void * var5275 , void * var5276 , void * var5277 , void * var5278 , void * var5279 );
__stdcall void * AccessCheck __attribute__((dllimport))(void * var5280 , void * var5281 , void * var5282 , void * var5283 , void * var5284 , void * var5285 , void * var5286 , void * var5287 );
__stdcall void * AccessCheckByType __attribute__((dllimport))(void * var5288 , void * var5289 , void * var5290 , void * var5291 , void * var5292 , void * var5293 , void * var5294 , void * var5295 , void * var5296 , void * var5297 , void * var5298 );
__stdcall void * AccessCheckByTypeResultList __attribute__((dllimport))(void * var5299 , void * var5300 , void * var5301 , void * var5302 , void * var5303 , void * var5304 , void * var5305 , void * var5306 , void * var5307 , void * var5308 , void * var5309 );
__stdcall void * AdjustTokenPrivileges __attribute__((dllimport))(void * var5310 , void * var5311 , void * var5312 , void * var5313 , void * var5314 , void * var5315 );
__stdcall void * CreateColorSpaceA __attribute__((dllimport))(void * var5316 );
__stdcall void * CreateColorSpaceW __attribute__((dllimport))(void * var5317 );
__stdcall void * DeleteCriticalSection __attribute__((dllimport))(void * var5318 );
__stdcall void * EnterCriticalSection __attribute__((dllimport))(void * var5319 );
__stdcall void * ExtCreateRegion __attribute__((dllimport))(void * var5320 , void * var5321 , void * var5322 );
__stdcall void * GetLogColorSpaceA __attribute__((dllimport))(void * var5323 , void * var5324 , void * var5325 );
__stdcall void * GetRegionData __attribute__((dllimport))(void * var5326 , void * var5327 , void * var5328 );
__stdcall void * GetThreadContext __attribute__((dllimport))(void * var5329 , void * var5330 );
__stdcall void * InitializeCriticalSection __attribute__((dllimport))(void * var5331 );
__stdcall void * InitializeCriticalSectionAndSpinCount __attribute__((dllimport))(void * var5332 , void * var5333 );
__stdcall void * LeaveCriticalSection __attribute__((dllimport))(void * var5334 );
__stdcall void * ObjectOpenAuditAlarmA __attribute__((dllimport))(void * var5335 , void * var5336 , void * var5337 , void * var5338 , void * var5339 , void * var5340 , void * var5341 , void * var5342 , void * var5343 , void * var5344 , void * var5345 , void * var5346 );
__stdcall void * ObjectOpenAuditAlarmW __attribute__((dllimport))(void * var5347 , void * var5348 , void * var5349 , void * var5350 , void * var5351 , void * var5352 , void * var5353 , void * var5354 , void * var5355 , void * var5356 , void * var5357 , void * var5358 );
__stdcall void * ObjectPrivilegeAuditAlarmA __attribute__((dllimport))(void * var5359 , void * var5360 , void * var5361 , void * var5362 , void * var5363 , void * var5364 );
__stdcall void * PeekConsoleInputA __attribute__((dllimport))(void * var5365 , void * var5366 , void * var5367 , void * var5368 );
__stdcall void * PeekConsoleInputW __attribute__((dllimport))(void * var5369 , void * var5370 , void * var5371 , void * var5372 );
__stdcall void * PrivilegeCheck __attribute__((dllimport))(void * var5373 , void * var5374 , void * var5375 );
__stdcall void * PrivilegedServiceAuditAlarmA __attribute__((dllimport))(void * var5376 , void * var5377 , void * var5378 , void * var5379 , void * var5380 );
__stdcall void * ReadConsoleInputA __attribute__((dllimport))(void * var5381 , void * var5382 , void * var5383 , void * var5384 );
__stdcall void * ReadConsoleInputW __attribute__((dllimport))(void * var5385 , void * var5386 , void * var5387 , void * var5388 );
__stdcall void * SetCriticalSectionSpinCount __attribute__((dllimport))(void * var5389 , void * var5390 );
__stdcall void * TryEnterCriticalSection __attribute__((dllimport))(void * var5391 );
__stdcall void * UnhandledExceptionFilter __attribute__((dllimport))(void * var5392 );
__stdcall void * WaitForDebugEvent __attribute__((dllimport))(void * var5393 , void * var5394 );
__stdcall void * WriteConsoleInputA __attribute__((dllimport))(void * var5395 , void * var5396 , void * var5397 , void * var5398 );
__stdcall void * WriteConsoleInputW __attribute__((dllimport))(void * var5399 , void * var5400 , void * var5401 , void * var5402 );
__stdcall void * MessageBoxIndirectA __attribute__((dllimport))(void * var5403 );
__stdcall void * MessageBoxIndirectW __attribute__((dllimport))(void * var5404 );
__stdcall void * SetUnhandledExceptionFilter __attribute__((dllimport))(void * var5405 );

