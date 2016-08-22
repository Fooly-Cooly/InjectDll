;=====================================================================
;Requires AutoHotKey ANSI
;Written by Fooly-Cooly: https://github.com/Fooly-Cooly
;Licensed under GPL v3:  https://www.gnu.org/licenses/gpl-3.0.txt
;=====================================================================

Inject_CleanUp(pMsg, pHandle, pLibrary)
{
    If pMsg
        MsgBox, 0, :(, % "Error Code: " . DllCall("GetLastError") . "`n" . pMsg

    If pLibrary
        DllCall("VirtualFreeEx", "UInt", pHandle, "UInt", pLibrary, "UInt", 0, "UInt", 0x8000)

    If pHandle
        DllCall("CloseHandle", "UInt", pHandle)

    Return False
}

Inject_Dll(pid, dllPath)
{
    Size := VarSetCapacity(dllFile, StrLen(dllPath)+1, 0)
    StrPut(dllPath, &dllFile)

    If (!pHandle := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", False, "UInt", pid))
        Return Inject_CleanUp("Couldn't open process!`nPossible Invalid PID.", NULL, NULL)

    If (!pLibrary := DllCall("VirtualAllocEx", "Ptr", pHandle, "Ptr", 0, "Ptr", Size, "UInt", 0x1000, "UInt", 0x04, "Ptr"))
        Return Inject_CleanUp("Couldn't allocate memory!", pHandle, NULL)

    If (!DllCall("WriteProcessMemory", "Ptr", pHandle, "Ptr", pLibrary, "Ptr", &dllFile, "Ptr", Size, "Ptr"))
        Return Inject_CleanUp("Couldn't write to memory in process!`nPossible permission Issue, Try Run as Admin.", pHandle, pLibrary)

    If (!pModule := DllCall("GetModuleHandle", "str", "kernel32.dll", "Ptr"))
        Return Inject_CleanUp("Couldn't find kernel32.dll handle!", pHandle, pLibrary)

    If (!pFunc := DllCall("GetProcAddress", "Ptr", pModule, "AStr", "LoadLibraryA", "Ptr"))
        Return Inject_CleanUp("Couldn't find function 'LoadLibraryA' in kernel32.dll!", pHandle, pLibrary)

    If (!hThread := DllCall("CreateRemoteThread", "Ptr", pHandle, "UInt", 0, "UInt", 0, "Ptr", pFunc, "Ptr", pLibrary, "UInt", 0, "UInt", 0))
        Return Inject_CleanUp("Couldn't create thread in PID: " pid, pHandle, pLibrary)

    DllCall("WaitForSingleObject", "Ptr", hThread, "UInt", 0xFFFFFFFF)
    DllCall("GetExitCodeThread", "Ptr", hThread, "UIntP", lpExitCode)
    DllCall("CloseHandle", "UInt", hThread)

    If !lpExitCode
        Return Inject_CleanUp("Couldn't create thread in PID: " pid, pHandle, pLibrary)
}