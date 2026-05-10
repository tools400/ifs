**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1031

// &1[1031] Fehler beim Lschen des IFS-Verzeichnis '&2' aufge

dcl-ds IFS1031;
  IFS10311 char(001) inz(*blanks);
  IFS10312 char(128) inz(*blanks);
  IFS10313 packed(010) inz(*zeros);
  IFS10314 char(128) inz(*blanks);
end-ds;
dcl-s IFS1031# bindec(8) inz(0263);
