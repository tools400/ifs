**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1005

// &1[1005] Fehler beim Lschen der IFS-Datei '&2' aufgetreten

dcl-ds IFS1005;
  IFS10051 char(001) inz(*blanks);
  IFS10052 char(128) inz(*blanks);
  IFS10053 packed(010) inz(*zeros);
  IFS10054 char(128) inz(*blanks);
end-ds;
dcl-s IFS1005# bindec(8) inz(0263);
