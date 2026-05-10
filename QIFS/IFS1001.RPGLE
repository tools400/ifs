**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1001

// &1[1001] Fehler beim Schlieen der IFS-Datei '&2' aufgetret

dcl-ds IFS1001;
  IFS10011 char(001) inz(*blanks);
  IFS10012 char(128) inz(*blanks);
  IFS10013 packed(010) inz(*zeros);
  IFS10014 char(128) inz(*blanks);
end-ds;
dcl-s IFS1001# bindec(8) inz(0263);