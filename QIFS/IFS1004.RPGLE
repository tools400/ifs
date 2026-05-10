**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1004

// &1[1004] Fehler beim Lesen aus der IFS-Datei '&2' aufgetret

dcl-ds IFS1004;
  IFS10041 char(001) inz(*blanks);
  IFS10042 char(128) inz(*blanks);
  IFS10043 packed(010) inz(*zeros);
  IFS10044 char(128) inz(*blanks);
end-ds;
dcl-s IFS1004# bindec(8) inz(0263);
