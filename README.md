## InjectDll - An AutoHotKey library for injecting dll files into processes

**Example:**
  ```AutoHotKey
  #include InjectDll.ahk
  Inject_Dll(pid, dllPath)
  ```
  Requires AutoHotKey ANSI (See History)

**History:**

  Obviously, Injecting dlls has several applications in my instance I just wanted to inject steams overlay manually for acouple annoying cases where steam just wouldn't load the overlay itself (Even when removing the games launcher from the scenario).
  For whatever reason, AHK Unicode could never retrieve the address of LoadLibraryW (the unicode version of LoadLibrary), but as you may guess AHK ANSI was able to find LoadLibraryA. If anyone has insight as to why this is feel free to let me know.

**Licensing:**

  This software is licensed under the terms of the GPLv3.  
  You can find a copy of the license in the LICENSE file.
