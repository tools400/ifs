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
     /* &1[1000] Fehler beim ffnen der IFS-Datei '&2' mit Fehlerco */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1000) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1000] Fehler beim ffnen der IFS-Datei ''&2'' mit Fehlercode &3 au-
fgetreten.'                                                           +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch die IFS Datei ''&2'' mit de-
r Unix open()-Funktion zu ffnen ist ein Fehler mit dem Fehlercode &3 -
aufgetreten. Der Fehlertext lautet: ''&4'''                           +
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
     /* &1[1001] Fehler beim Schlieen der IFS-Datei '&2' aufgetret */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1001) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1001] Fehler beim Schlieen der IFS-Datei ''&2'' aufgetreten.'    +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch die IFS-Datei ''&2'' mit de-
r Unix close()-Funktion zu schlieen ist ein Fehler mit dem Fehlercode-
 &3 aufgetreten. Der Fehlertext lautet: ''&4'''                       +
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
     /* &1[1002] Fehler beim Schreiben in die IFS-Datei '&2' aufget */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1002) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1002] Fehler beim Schreiben in die IFS-Datei ''&2'' aufgetreten.' +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix write()-Funkti-
on in die IFS Datei ''&2'' zu schreiben ist ein Fehler mit dem Fehlerc-
ode &3 aufgetreten. Der Fehlertext lautet: ''&4'''                    +
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
     /* &1[1003] Fehler beim Verschieben der IFS-Datei '&2' nach '& */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1003) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1003] Fehler beim Verschieben der IFS-Datei ''&2'' nach ''&3'' auf-
getreten.'                                                            +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix Qp0lRenameKeep-
()-Funktion die IFS Datei von ''&2'' nach ''&3'' zu verschieben ist ei-
n Fehler mit dem Fehlercode &4 aufgetreten. Der Fehlertext lautet: ''&-
5'''                                                                  +
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
     /* &1[1004] Fehler beim Lesen aus der IFS-Datei '&2' aufgetret */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1004) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1004] Fehler beim Lesen aus der IFS-Datei ''&2'' aufgetreten.'    +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix read()-Funktio-
n Daten aus der IFS Datei ''&2'' zu lesen ist ein Fehler mit dem Fehle-
rcode &3 aufgetreten. Der Fehlertext lautet: ''&4'''                  +
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
     /* &1[1005] Fehler beim Lschen der IFS-Datei '&2' aufgetreten */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1005) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1005] Fehler beim Lschen der IFS-Datei ''&2'' aufgetreten.'      +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix unlink()-Funkt-
ion die IFS Datei ''&2'' zu lschen ist ein Fehler mit dem Fehlercode -
&3 aufgetreten. Der Fehlertext lautet: ''&4'''                        +
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
     /* &1[1006] Fehler beim Ermitteln der Gre der IFS-Datei '&2' */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1006) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1006] Fehler beim Ermitteln der Gre der IFS-Datei ''&2'' aufgetr-
eten.'                                                                +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix stat()-Funktio-
n die Gre der IFS Datei ''&2'' zu ermitteln ist ein Fehler mit dem F-
ehlercode &3 aufgetreten. Der Fehlertext lautet: ''&4'''              +
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
     /* &1[1007] Fehler beim Setzen der Gre der IFS-Datei '&2' au */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1007) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1007] Fehler beim Setzen der Gre der IFS-Datei ''&2'' aufgetrete-
n.'                                                                   +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix ftruncate()-Fu-
nktion in die Gre der IFS Datei ''&2'' zu setzen ist ein Fehler mit -
dem Fehlercode &3 aufgetreten. Der Fehlertext lautet: ''&4'''         +
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
     /* &1[1008] Fehler beim Setzen des Schreib-/Lesezeigers der IF */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1008) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1008] Fehler beim Setzen des Schreib-/Lesezeigers der IFS-Datei ''-
&2'' aufgetreten.'                                                    +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix lseek()-Funkti-
on den Schreib-/Lesezeiger der IFS Datei ''&2'' auf den neuen Offset &-
5 mit dem Bezugspunkt &6 zu setzen ist ein Fehler mit dem Fehlercode &-
3 aufgetreten. Der Fehlertext lautet: ''&4'''                         +
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
     /* &1[1009] Fehler beim Umbenennen der IFS-Datei '&2' nach '&3 */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1009) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1009] Fehler beim Umbenennen der IFS-Datei ''&2'' nach ''&3'' aufg-
etreten.'                                                             +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix Qp0lRenameKeep-
()-Funktion die IFS Datei von ''&2'' nach ''&3'' umzubenennen ist ein -
Fehler mit dem Fehlercode &4 aufgetreten. Der Fehlertext lautet: ''&5'-
''                                                                    +
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
     /* &1[1011] IFS-Verzeichnis nicht vorhanden.                   */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1011) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1011] IFS-Verzeichnis nicht vorhanden.'                           +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Das angebene Verzeichnis ''&2'' ist nicht v-
orhanden. &N &N Fehlerbehebung  :   Ein anderes Verzeichnis angeben od-
er das Verzeichnis anlegen und die Anforderung wiederholen.'          +
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
     /* &1[1012] IFS-Datei nicht vorhanden.                         */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1012) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1012] IFS-Datei nicht vorhanden.'                                 +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Die angegebene Datei &2 ist nicht vorhanden-
. &N &N Fehlerbehebung  :   Eine andere Datei angeben oder die Datei a-
nlegen und die Anforderung wiederholen. Mglicherweise fehlt auch die -
Berechtigung fr den Zugriff auf die Datei.'                          +
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
     /* &1[1013] IFS-Datei existiert.                               */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1013) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1013] IFS-Datei existiert.'                                       +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Die angegebene Datei &2 ist bereits vorhand-
en. &N &N Fehlerbehebung  :   Einen anderen Dateinamen angeben oder di-
e vorhandene Datei lschen und die Anforderung wiederholen.'          +
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
     /* &1[1014] IFS-Dateiname enthlt ungltige Zeichen oder Pfada */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1014) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1014] IFS-Dateiname enthlt ungltige Zeichen oder Pfadangaben.'  +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Der angegebene Dateiname &2 enthlt unglti-
ge Zeichen oder Pfadangaben.'                                         +
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
     /* &1[1015] IFS-Verzeichnis existiert.                         */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1015) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1015] IFS-Verzeichnis existiert.'                                 +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Das angegebene Verzeichnis &2 ist bereits v-
orhanden. &N &N Fehlerbehebung  :   Einen anderen Dateinamen angeben o-
der die vorhandene Datei lschen und die Anforderung wiederholen.'    +
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
     /* &1[1016] Pufferberlauf beim Lesen aus der IFS Datei '&2'   */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1016) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1016] Pufferberlauf beim Lesen aus der IFS Datei ''&2'''         +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch Daten aus der IFS Datei ''&-
2'' zu lsen ist ein Pufferberlauf aufgetreten. Die Gre des Datenpu-
ffers von &3 Byte reichte nicht aus, um ein Zeile einzulesen.'        +
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
     /* &1[1017] Fehler beim Lesen aus dem Verzeichnis '&2' aufgetr */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1017) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1017] Fehler beim Lesen aus dem Verzeichnis ''&2'' aufgetreten.'  +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix readdir()-Funk-
tion einen Eintrag aus dem Verzeichnis ''&2'' zu lesen ist ein Fehler -
mit dem Fehlercode &3 aufgetreten. Der Fehlertext lautet: ''&4'''     +
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
     /* &1[1018] Fehler beim Abrufen der Attribute der Datei '&2' a */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1018) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1018] Fehler beim Abrufen der Attribute der Datei ''&2'' aufgetret-
en.'                                                                  +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix stat()-Funktio-
n die Attribute der Datei  ''&2'' abzurufen ist ein Fehler mit dem Feh-
lercode &3 aufgetreten. Der Fehlertext lautet: ''&4'''                +
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
     /* &1[1019] Fehler beim ffnen des Verzeichnis '&2' aufgetrete */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1019) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1019] Fehler beim ffnen des Verzeichnis ''&2'' aufgetreten.'     +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix opendir()-Funk-
tion das Verzeichnis ''&2'' zu ffnen ist ein Fehler mit dem Fehlercod-
e &3 aufgetreten. Der Fehlertext lautet: ''&4'''                      +
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
     /* &1[1020] Fehler beim Schlieen des Verzeichnis '&2' aufgetr */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1020) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1020] Fehler beim Schlieen des Verzeichnis ''&2'' aufgetreten.'  +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix closedir()-Fun-
ktion das Verzeichnis ''&2'' zu schlieen ist ein Fehler mit dem Fehle-
rcode &3 aufgetreten. Der Fehlertext lautet: ''&4'''                  +
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
     /* &1[1021] Fehler beim Ermitteln der Erstellungszeit der IFS- */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1021) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1021] Fehler beim Ermitteln der Erstellungszeit der IFS-Datei ''&2-
'' aufgetreten.'                                                      +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Qp0lGetAttr()-Funkt-
ion die Erstellungszeit der IFS Datei ''&2'' zu ermitteln ist ein Fehl-
er mit dem Fehlercode &3 aufgetreten. Der Fehlertext lautet: ''&4'''  +
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
     /* &1[1022] Fehler beim Ermitteln der Zeit der letzten nderun */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1022) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1022] Fehler beim Ermitteln der Zeit der letzten nderung der Date-
n der Datei ''&2'' aufgetreten.'                                      +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Qp0lGetAttr()-Funkt-
ion die Zeit der letzten nderung der Daten der IFS Datei ''&2'' zu er-
mitteln ist ein Fehler mit dem Fehlercode &3 aufgetreten. Der Fehlerte-
xt lautet: ''&4'''                                                    +
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
     /* &1[1023] Fehler beim Erstellen eines temporren Pfadnamens  */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1023) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1023] Fehler beim Erstellen eines temporren Pfadnamens mit Fehler-
code &2 aufgetreten.'                                                 +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der _C_IFS_tmpnam() Fun-
ktion einen temporren Pfadnamen zu erstellen ist ein Fehler mit dem F-
ehlercode &2 aufgetreten. Der Fehlertext lautet: ''&3'''              +
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
     /* &1[1024] Ungltige Pfadangabe.                              */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1024) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1024] Ungltige Pfadangabe.'                                      +
                ) +
                SECLVL(+
'&N &N Cause   . . . . :   Der angegebene Pfad ''&2'' ist ungltig. M-
glicherweise wurde das Root-Verzeichnis angegeben oder der Pfad enthl-
t ungltige Zeichen.'                                                 +
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
     /* &1[1025] Fehler beim Abrufen der Objektberechtigungen fr d */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1025) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1025] Fehler beim Abrufen der Objektberechtigungen fr die Datei o-
der das Verzechnis ''&2'' aufgetreten.'                               +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix stat()-Funktio-
n die Berechtigungen fr die IFS Datei oder das IFS Verzeichnis ''&2''-
 zu ermitteln ist ein Fehler mit dem Fehlercode &3 aufgetreten. Der Fe-
hlertext lautet: ''&4'''                                              +
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
     /* &1[1026] Verzeichnis konnte nicht erstellt werden. Der Fehl */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1026) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1026] Verzeichnis konnte nicht erstellt werden. Der Fehlercode ist-
 &3.'                                                                 +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix mkdir()-Funkti-
on das Verzeichnis ''&2'' anzulegen ist ein Fehler mit dem Fehlercode -
&3 aufgetreten. Der Fehlertext lautet: ''&4'''                        +
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
     /* &1[1027] Berechtigungen fr Verzeichnis nicht gesetzt. Der  */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1027) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1027] Berechtigungen fr Verzeichnis nicht gesetzt. Der Fehlercode-
 ist &3.'                                                             +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix chmod()-Funkti-
on die Berechtigungen fr das Verzeichnis ''&2'' zu setzen ist ein Feh-
ler mit dem Fehlercode &3 aufgetreten. Der Fehlertext lautet: ''&4''' +
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
     /* &1[1028] Fehler bei der Ermittlung der eindeutigen Datei-ID */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1028) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1028] Fehler bei der Ermittlung der eindeutigen Datei-ID der IFS-D-
atei ''&2'' aufgetreten.'                                             +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix stat()-Funktio-
n die eindeutige Datei-ID der IFS Datei ''&2'' zu ermitteln ist ein Fe-
hler mit dem Fehlercode &3 aufgetreten. Der Fehlertext lautet: ''&4'''+
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
     /* &1[1029] Das aktuelle Verzeichnis konnte nicht ermittelt we */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1029) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1029] Das aktuelle Verzeichnis konnte nicht ermittelt werden. Der -
Fehlercode ist &1.'                                                   +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix getcwd()-Funkt-
ion das aktuelle Verzeichnis zu ermitteln ist ein Fehler mit dem Fehle-
rcode &1 aufgetreten. Der Fehlertext lautet: ''&2'''                  +
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
     /* &1[1030] Das aktuelle Verzeichnis konnte nicht auf '&1' ge */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1030) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1030] Das aktuelle Verzeichnis konnte nicht auf ''&1'' gendert we-
rden. Der Fehlercode ist &2.'                                         +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix QlgChdir()-Fun-
ktion das aktuelle Verzeichnis zu ndern ist ein Fehler mit dem Fehler-
code &2 aufgetreten. Der Fehlertext lautet: ''&3'''                   +
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
     /* &1[1031] Fehler beim Lschen des IFS-Verzeichnis '&2' aufge */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1031) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1031] Fehler beim Lschen des IFS-Verzeichnis ''&2'' aufgetreten.'+
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Bei dem Versuch mit der Unix rmdir()-Funkti-
on das IFS Verzeichnis ''&2'' zu lschen ist ein Fehler mit dem Fehler-
code &3 aufgetreten. Der Fehlertext lautet: ''&4'''                   +
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
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1032                    */
     /* &1[1032] Das angegebene Verzeichnis '&2' existiert bereits. */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1032) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1032] Das angegebene Verzeichnis ''&2'' existiert bereits.'       +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Das angegebene Verzeichnis ''&2'' konnte ni-
cht erzeugt werden, weil es bereits existiert.'                       +
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
     /*   Cmd-ADDMSGD fr Message-ID :   IFS1033                    */
     /* &1[1033] Das angegebene Verzeichnis '&2' konnte nicht angel */
     /* ----------------------------------------------------------- */

             ADDMSGD +
                MSGID(IFS1033) +
                MSGF(&LI/IFS) +
                MSG(+
'&1[1033] Das angegebene Verzeichnis ''&2'' konnte nicht angelegt werd-
en.'                                                                  +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Das angegebene Verzeichnis ''&2'' konnte ni-
cht angelegt werden, weil es bereits eine Datei gleichen Namens gibt.'+
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 001) +
                    (*CHAR 128) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

             RCLRSC LVL(*)

             ENDPGM
