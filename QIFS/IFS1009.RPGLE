**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1009

// &1[1009] Fehler beim Umbenennen der IFS-Datei '&2' nach '&3

dcl-ds IFS1009;
  IFS10091 char(001) inz(*blanks);
  IFS10092 char(128) inz(*blanks);
  IFS10093 char(128) inz(*blanks);
  IFS10094 packed(010) inz(*zeros);
  IFS10095 char(128) inz(*blanks);
end-ds;
dcl-s IFS1009# bindec(8) inz(0391);
