**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1003

// &1[1003] Fehler beim Verschieben der IFS-Datei '&2' nach '&

dcl-ds IFS1003;
  IFS10031 char(001) inz(*blanks);
  IFS10032 char(128) inz(*blanks);
  IFS10033 char(128) inz(*blanks);
  IFS10034 packed(010) inz(*zeros);
  IFS10035 char(128) inz(*blanks);
end-ds;
dcl-s IFS1003# bindec(8) inz(0391);
