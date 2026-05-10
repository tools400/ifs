**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1007

// &1[1007] Fehler beim Setzen der Gre der IFS-Datei '&2' au

dcl-ds IFS1007;
  IFS10071 char(001) inz(*blanks);
  IFS10072 char(128) inz(*blanks);
  IFS10073 packed(010) inz(*zeros);
  IFS10074 char(128) inz(*blanks);
end-ds;
dcl-s IFS1007# bindec(8) inz(0263);
