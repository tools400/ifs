IFS - A Tools/400 Service Program
---------------------------------

IFS is service program that offers services for reading and writing
IFS files and directories.

Dependencies: BASICS1

Compile members with the following PDM option:                                                     
                                                                          
   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO) 
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)          
     USER1(*LIST) USER2(*FULL)                                            

Members of type MAKPGM or BND are used for linking programs (MAKPGM) 
and service programs (BND).

2018, Thomas Raddatz

-----------------------
      History
-----------------------

Version 1.9.5
-------------

Added:   Added member COPYRIGHT.
Fixed:   Fixed compile error message RNF7597.
Changed: Updated CEELIB and CLIB.

Version 1.9.4
-------------

Fixed:   Added compiler directives and lfbitand() to get a clean compile on
         V5R1 systems.

Version 1.9.3
-------------

Fixed:   Fixed problem that O_CCSID flag was not removed from the open flags
         when re-opening a newly created file.

Version 1.9.2
-------------

Changed: Updated CLIB to latest version.

Version 1.9.1
-------------

Fixed:   Fixed compiler error in IFSTEST_09.
Fixed:   Changed passing mode of parameter i_followLnk of prototype Qp0lGetAttr
         from 'const' to 'value'.
Added:   Added constant cIFS_RMDIR_DELETE_FILES to f_dltIfsDir().

Version 1.9
-----------

Fixed:   Fixed problem that f_readIfsDir() did not properly retrieve the file
         status information (stat()) if a file name had trailing blanks.
Added:   Added procedures: f_getIfsCurDir()
                           f_chgIfsCurDir()
                           f_dltIfsDir()
                           f_isIfsDirEmpty()
Added:   Addes options cIFS_READDIR_PRE_ORDER and cIFS_READDIR_POST_ORDER
         to f_readIfsDir().
Added:   Added additional checks and messages to f_crtIfsDir(): IFS1032, IFS1033.

Version 1.8
-----------

Added:   Added procedures: f_getIfsTmpPath()
                           f_crtIfsDir()
                           f_getIfsFileSizeH()
                           f_getIfsFileID()
                           f_getIfsFileIDH()

Version 1.7
-----------

Fixed:   Fixed problem in f_writeLineIfsFile() when writing to a file shared with
         other writers.

Version 1.6
-----------

Fixed:   Fixed problem in f_renameIfsFile(). Now correctly producing the target
         file path from the source path and the target file name.

Version 1.5
-----------

Added:   Added procedure f_getIfsFileDataChgTime().

Version 1.4.2
-------------

Fixed:   Fixed problem in IFSTEST_04.

Version 1.4.1
-------------

Changed: Changed '#' in message copy books to 'LEN'.

Version 1.4:
------------

Added:   Added procedure f_getIfsFileCrtTime().

Version 1.3.1:
--------------

Fixed:   Fixed problem that caused an endless
         loop in f_renameIfsFile().

Version 1.3:
------------

Fixed:   Fixed problem that f_readLineIfsFile() did not
         return -1 in case of an error.
Fixed:   Fixed problem that caller to f_readLineIfsFile()
         could not distinguish betwenn EOF and an empty
         line returned. f_readLineIfsFile() now returns -2
         in case of EOF. Introduced constants cIFS_EOF and
         cIFS_ERROR.
Added:   Added procedure f_rtvIfsFileExtFromPath().
         Added procedure f_rmvIfsFileExtFromPath().

Version 1.2.3:
--------------

Added:   Changed IFS to be V5R1M0 compliant.

Version 1.2.2:
--------------

Added:   Added support for new open() flag O_CCSID.

Version 1.2.1:
--------------

Changed: Renamed test programs from TEST_R1* to IFSTEST*.
Changed: Added parameter TGTRLS(*CURRENT) to all creation commands.
Changed: Removed '#' from member names.

Version 1.2:
------------

Procedures since V1.1                          Program:
----------------------------------------       ----------------------------------------
IFSR01_f_readIfsDir                            TEST_R1#04

Changed: Changed structure dirent_t in member CLIB. Changed
         type of field d_nlsinfo from 12A to likeds(qlg_nls_t).
Added:   Added procedure f_readIfsDir() to automatically iterate
         through all entries of a given directory and optionally
         all sub-directories. All callback procedure is called
         for all entries that matches the search criteria.

Version 1.1:
------------

Procedures since V1.0                          Program:
----------------------------------------       ----------------------------------------
IFSR01_f_readLineIfsFile                       TEST_R1#02
IFSR01_f_writeLineIfsFile                      TEST_R1#03

Added:   Added procedure f_readLineIfsFile() to read a line from a
         stream file. A line is considered as a series of bytes
         delimited by an End-Of-Line character.
Added:   Added procedure f_writeLineIfsFile() to write line to a
         stream file. A line is considered as a series of bytes
         terminated by an End-Of-Line character.

Version 1.0:
------------

Procedures:
----------------------------------------       ----------------------------------------
IFSR01_f_openIfsFile                              TEST_R1#01
IFSR01_f_writeIfsFile                             TEST_R1#01
IFSR01_f_seekIfsFile                              TEST_R1#01
IFSR01_f_readIfsFile                              TEST_R1#01
IFSR01_f_closeIfsFile                             TEST_R1#01

