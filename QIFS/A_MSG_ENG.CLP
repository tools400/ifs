     /*-----------------------------------------------------------------------*/
     /* STRPREPRC Compile Options:                                            */
     /* >>PRE-COMPILER<<                                                      */
     /*  >>CRTCMD<<   CRTBNDCL   PGM(QTEMP/&OB) +                             */
     /*                          SRCFILE(&SL/&SF) SRCMBR(&SM);                */
     /*   >>COMPILE<<                                                         */
     /*    >>PARM<<  TEXT('Tool: EXPJRNE    (Export Journal Entries  ) Eng'); */
     /*   >>END-COMPILE<<                                                     */
     /*   >>EXECUTE<<                                                         */
     /*   >>CMD<<     CALL PGM(QTEMP/&OB) PARM(&LI &OB);                      */
     /*   >>CMD<<     DLTPGM PGM(QTEMP/&OB);                                  */
     /* >>END-PRE-COMPILER<<                                                  */
     /*-----------------------------------------------------------------------*/
             PGM        PARM(&LI)

             DCL        VAR(&LI) TYPE(*CHAR) LEN(10)

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1000                    */
     /* &1[1000] File '&2' has not been opend. Error code &3.       */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1000) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1000] File ''&2'' has not been opend. Error code &3.'             +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix open() function returned error cod-
e &3 when attemting to open file ''&2''. The error text is: ''&4''.'  +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1001                    */
     /* &1[1001] File '&2' has not been closed. Error code &3.      */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1001) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1001] File ''&2'' has not been closed. Error code &3.'            +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix close() function returned error co-
de &3 when attemting to close file ''&2''. The error text is: ''&4''.'+
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1002                    */
     /* &1[1002] Data has not been written to file '&2'. Error code */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1002) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1002] Data has not been written to file ''&2''. Error code &3.'   +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix write() function returned error co-
de &3 when attemting to write to file ''&2''. The error text is: ''&4'-
'.'                                                                   +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1003                    */
     /* &1[1003] File '&2' has not been moved to '&3'. Error code & */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1003) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1003] File ''&2'' has not been moved to ''&3''. Error code &4.'   +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix Qp0lRenameKeep() function returned-
error code &4 when attemting to move file ''&2'' to ''&3''. The error -
text is: ''&5''.'                                                     +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1004                    */
     /* &1[1004] Data has not been red from file '&2'. Error code & */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1004) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1004] Data has not been red from file ''&2''. Error code &3.'     +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix read() function returned error cod-
e &3 when attemting to read from file ''&2''. The error text is: ''&4'-
'.'                                                                   +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1005                    */
     /* &1[1005] File '&2' has not been deleted. Error code &3.     */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1005) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1005] File ''&2'' has not been deleted. Error code &3.'           +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix unlink() function returned error c-
ode &3 when attemting to delete file ''&2''. The error text is: ''&4''-
.'                                                                    +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1006                    */
     /* &1[1006] The size of file '&2' has not been retrieved. Erro */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1006) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1006] The size of file ''&2'' has not been retrieved. Error code &-
3.'                                                                   +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix stat() function returned error cod-
e &3 when attemting to retrieve the status of file ''&2''. The error t-
ext is: ''&4''.'                                                      +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1007                    */
     /* &1[1007] The size of file '&2' has not been changed. Error  */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1007) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1007] The size of file ''&2'' has not been changed. Error code &3.-
'                                                                     +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix ftruncate() function returned erro-
r code &3 when attemting change the size of file ''&2''. The error tex-
t is: ''&4''.'                                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1008                    */
     /* &1[1008] The offset of the read/write pointer of file '&2'  */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1008) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1008] The offset of the read/write pointer of file ''&2'' has not -
been changed. Error code: &3.'                                        +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix lseek() function returned error co-
de &3 when attemting set the new file offset. The error text is: ''&4'-
'.'                                                                   +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*DEC 010 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1009                    */
     /* &1[1009] File '&2' has not been renamed to '&3'. Error code */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1009) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1009] File ''&2'' has not been renamed to ''&3''. Error code &4.' +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix Qp0lRenameKeep() function returned-
 error code &4 when attempting to rename file ''&2'' to ''&3''. The er-
ror text is: ''&5''.'                                                 +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1011                    */
     /* &1[1011] Directory '&2' has not been found.                 */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1011) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1011] Directory ''&2'' has not been found.'                       +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The requested function can not be performed-
 because directory ''&2'' does not exist.'                            +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1012                    */
     /* &1[1012] File '&2' has not been found.                      */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1012) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1012] File ''&2'' has not been found.'                            +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The requested function can not be performed-
 because file ''&2'' does not exist.'                                 +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1013                    */
     /* &1[1013] File '&2' exists.                                  */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1013) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1013] File ''&2'' exists.'                                        +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The requested function can not be performed-
 because file ''&2'' already exists.'                                 +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1014                    */
     /* &1[1014] File name '&2' contains invalid characters.        */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1014) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1014] File name ''&2'' contains invalid characters.'              +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The requested function can not be performed-
 because file name ''&2'' contains invalid characters.'               +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1015                    */
     /* &1[1015] Directory '&2' exists.                             */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1015) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1015] Directory ''&2'' exists.'                                   +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The requested function can not be performed-
 because directory ''&2'' already exists.'                            +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1016                    */
     /* &1[1016] Buffer overflow occurred while reading from IFS fi */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1016) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1016] Buffer overflow occurred while reading from IFS file ''&2''.-
'                                                                     +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   A buffer overflow occured while attempting -
to read data from IFS file ''&2''. The specified buffer size of &3 byt-
es was too small to read a line completely.'                          +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1017                    */
     /* &1[1017] Entry has not been red from directory '&2'.        */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1017) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1017] Entry has not been red from directory ''&2''.'              +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix readdir() function returned error -
code &3 when attempting to read the next entry from directory ''&2''. -
The error text is: ''&4''.'                                           +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1018                    */
     /* &1[1018] Attributes of file '&2' not retrieved.             */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1018) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1018] Attributes of file ''&2'' not retrieved.'                   +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix stat() function returned error cod-
e &3 when attempting to retrieve attributes of file ''&2''. The error -
text is: ''&4''.'                                                     +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1019                    */
     /* &1[1019] Directory '&2' not opened.                         */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1019) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1019] Directory ''&2'' not opened.'                               +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix opendir() function returned error -
code &3 when attempting to open directory ''&2''. The error text is: '-
'&4''.'                                                               +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1020                    */
     /* &1[1020] Directory '&2' not closed.                         */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1020) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1020] Directory ''&2'' not closed.'                               +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix closedir() function returned error-
 code &3 when attempting to close directory ''&2''. The error text is:-
 ''&4''.'                                                             +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1021                    */
     /* &1[1021] The creation time of file '&2' has not been retrie */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1021) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1021] The creation time of file ''&2'' has not been retrieved. Err-
or code &3.'                                                          +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Qp0lGetAttr() function returned error c-
ode &3 when attemting to retrieve the attributes of file ''&2''. The e-
rror text is: ''&4''.'                                                +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1022                    */
     /* &1[1022] The time the data of file '&2' was last changed ha */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1022) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1022] The time the data of file ''&2'' was last changed has not be-
en retrieved. Error code &3.'                                         +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Qp0lGetAttr() function returned error c-
ode &3 when attemting to retrieve the attributes of file ''&2''. The e-
rror text is: ''&4''.'                                                +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1023                    */
     /* &1[1023] Cannot produce temporary path name. Error code &2. */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1023) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1023] Cannot produce temporary path name. Error code &2.'         +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The _C_IFS_tmpnam() function returned error-
 code &3 when attemting to produce a temporary path name. The error te-
xt is: ''&3''.'                                                       +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1024                    */
     /* &1[1024] Invalid path name.                                 */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1024) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1024] Invalid path name.'                                         +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The specified directory ''&2'' is invalid. -
Please check the directory for invalid characters and ensure it is not-
 the root directory.'                                                 +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1025                    */
     /* &1[1025] Failed to retrieve permissions and privileges of f */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1025) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1025] Failed to retrieve permissions and privileges of file or dir-
ectory ''&2''.'                                                       +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix stat() function returned error cod-
e &3 when attemting to retrieve the status of file or directory ''&2''-
. The error text is: ''&4''.'                                         +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1026                    */
     /* &1[1026] Failed to create directory with error code &3.     */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1026) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1026] Failed to create directory with error code &3.'             +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix mkdir() function returned error co-
de &3 when attemting to create directory ''&2''. The error text is: ''-
&4''.'                                                                +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1027                    */
     /* &1[1027] Could not set permissions for directory. Error cod */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1027) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1027] Could not set permissions for directory. Error code: &3.'   +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   The Unix chmod() function returned error co-
de &3 when attempting to set permissions for directory ''&2''. The err-
or text is: ''&4'''                                                   +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1028                    */
     /* &1[1028] The unique file identifier of file '&2' has not be */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1028) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1028] The unique file identifier of file ''&2'' has not been retri-
eved. Error code &3.'                                                 +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix stat() function returned error cod-
e &3 when attemting to retrieve the unique file identifier of file ''&-
2''. The error text is: ''&4''.'                                      +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1029                    */
     /* &1[1029] Failed to get the current working directory. Error */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1029) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1029] Failed to get the current working directory. Error code &1.'+
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix getcwd() function returned error c-
ode &1 when attemting to retrieve the current working directory. The e-
rror text is: ''&2''.'                                                +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1030                    */
     /* &1[1030] Failed to change the current working directory to  */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1030) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1030] Failed to change the current working directory to ''&1''. Er-
ror code &2.'                                                         +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   The Unix QlgChdir() function returned error-
 code &2 when attemting to change the current working directory. The e-
rror text is: ''&3''.'                                                +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1031                    */
     /* &1[1031] Failed to delete IFS directory '&2'. Error code &3 */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1031) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1031] Failed to delete IFS directory ''&2''. Error code &3.'      +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   The Unix rmdir()-function returned error co-
de &3 when attempting to delete directory ''&2''. The error text is : -
''&4''.'                                                              +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                    (*DEC 010 0) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */
                                                                                      /* RADD */
     /* ----------------------------------------------------------- */                /* RADD */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1032                    */                /* RADD */
     /* &1[1032] The specified directory '&2' does already exist.   */                /* RADD */
     /* ----------------------------------------------------------- */                /* RADD */
                                                                                      /* RADD */
             ADDMSGD +
                MSGID(IFS1032) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1032] The specified directory ''&2'' does already exist.'         +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Failed to create directory ''&2'' because t-
he directory does already exist.'                                     +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */                                                         /* RADD */
                                                                                      /* RADD */
     /* ----------------------------------------------------------- */                /* RADD */
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1033                    */                /* RADD */
     /* &1[1033] Failed to create directory '&2'.                   */                /* RADD */
     /* ----------------------------------------------------------- */                /* RADD */
                                                                                      /* RADD */
             ADDMSGD +
                MSGID(IFS1033) +
                MSGF(&LI/IFS) +
                MSG(+
'Failed to create directory ''&2''.'                                  +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Failed to create directory ''&2'' because a-
 file with the same name does already exist.'                         +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */                                                         /* RADD */

             RCLRSC LVL(*)

             ENDPGM
