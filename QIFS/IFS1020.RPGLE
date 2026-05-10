**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1020

// &1[1020] Fehler beim Schlieen des Verzeichnis '&2' aufgetr

dcl-ds IFS1020;
  IFS10201 char(001) inz(*blanks);
  IFS10202 char(128) inz(*blanks);
  IFS10203 packed(010) inz(*zeros);
  IFS10204 char(128) inz(*blanks);
end-ds;
dcl-s IFS1020# bindec(8) inz(0263);
