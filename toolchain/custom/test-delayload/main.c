#include <assert.h>
#include <stdio.h>
#include <winsock2.h>
#include <windows.h>
#include <delayimp.h>


#ifdef __i386__
extern void * __imp_htonl __asm("__imp__htonl@4");
#else
extern void * __imp_htonl;
#endif

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

int main(void) {
  setvbuf(stdout, NULL, _IONBF, 0);
  printf("MAIN: before calling htonl, __imp_htonl = %p\n", __imp_htonl);
  assert(htonl(0x12345678) == 0x78563412);
  printf("MAIN: after calling htonl, __imp_htonl = %p\n", __imp_htonl);
  return 0;
}
