**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1032

// &1[1032] Das angegebene Verzeichnis '&2' existiert bereits.

dcl-ds IFS1032;
  IFS10321 char(001) inz(*blanks);
  IFS10322 char(128) inz(*blanks);
  IFS10323 packed(010) inz(*zeros);
  IFS10324 char(128) inz(*blanks);
end-ds;
dcl-s IFS1032# bindec(8) inz(0263);
