#include <assert.h>
#include <stdio.h>
#include <windows.h>
#include <delayimp.h>

FARPROC WINAPI dll_failure_hook(unsigned dliNotify, PDelayLoadInfo pdli);
PfnDliHook __pfnDliFailureHook2 = dll_failure_hook;
FARPROC WINAPI dll_failure_hook(unsigned dliNotify, PDelayLoadInfo pdli) {
  if (dliNotify == dliFailLoadLib) {
    printf("FAILURE-HOOK: Loading DLL %s\n", pdli->szDll);
    if (strcmp(pdli->szDll, "does_not_exist.exe") == 0) {
      /* we return main executable */
      return (FARPROC)GetModuleHandle(NULL);
    }
    assert(0);
  } else if (dliNotify == dliFailGetProc && pdli->dwLastError == ERROR_MOD_NOT_FOUND) {
    printf("FAILURE-HOOK: Loading Proc %s from DLL %s\n", pdli->dlp.szProcName, pdli->szDll);
    if (strcmp(pdli->szDll, "does_not_exist.exe") == 0) {
      /* we return proc from main executable */
      return (FARPROC)GetProcAddress(GetModuleHandle(NULL), pdli->dlp.szProcName);
    }
    assert(0);
  }

  /* ignore other requests */
  return 0;
}

/* this hook is only here to show what's happening */
FARPROC WINAPI dll_notify_hook(unsigned dliNotify, PDelayLoadInfo pdli);
PfnDliHook __pfnDliNotifyHook2 = dll_notify_hook;
FARPROC WINAPI dll_notify_hook(unsigned dliNotify, PDelayLoadInfo pdli) {
  switch (dliNotify)
  {
  case dliStartProcessing:
    printf("NOTIFY-HOOK: DLL delay-load processing started\n");
    break;
  case dliNotePreLoadLibrary:
    printf("NOTIFY-HOOK: About to load library: %s\n", pdli->szDll);
    break;
  case dliNotePreGetProcAddress:
    printf("NOTIFY-HOOK: About to get proc address: %s from %s\n",
           pdli->dlp.szProcName ? pdli->dlp.szProcName : "???",
           pdli->szDll);
    break;
  case dliFailLoadLib:
    printf("NOTIFY-HOOK: Failed to load library: %s\n", pdli->szDll);
    break;
  case dliFailGetProc:
    printf("NOTIFY-HOOK: Failed to get proc address: %s from %s\n",
           pdli->dlp.szProcName ? pdli->dlp.szProcName : "???",
           pdli->szDll);
    break;
  case dliNoteEndProcessing:
    printf("NOTIFY-HOOK: DLL delay-load processing ended\n");
    break;
  default:
    printf("NOTIFY-HOOK: Unknown notification: %d\n", dliNotify);
    break;
  }

  return NULL;
}

#if defined(__MINGW32__) && !defined(__MINGW64__) && defined(__GNUC__) && !defined(__clang__)
// MINGW32 crashes with dllimport
// https://sourceforge.net/p/mingw-w64/mailman/mingw-w64-public/thread/ea87573f-65ea-44a2-b4bb-ca96c0a136ab@akeo.ie/
// https://sourceware.org/bugzilla/show_bug.cgi?id=14339
int main_f(void);
#else
__declspec(dllimport) int main_f(void);
#endif

int lib_f(void) {
  printf("LIB: call main_f\n");
  int ret = main_f();
  printf("LIB: return value f\n");
  return ret;
}
