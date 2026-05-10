**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1000

// &1[1000] Fehler beim ffnen der IFS-Datei '&2' mit Fehlerco

dcl-ds IFS1000;
  IFS10001 char(001) inz(*blanks);
  IFS10002 char(128) inz(*blanks);
  IFS10003 packed(010) inz(*zeros);
  IFS10004 char(128) inz(*blanks);
end-ds;
dcl-s IFS1000# bindec(8) inz(0263);
