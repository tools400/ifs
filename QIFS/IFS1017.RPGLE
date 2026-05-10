**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1017

// &1[1017] Fehler beim Lesen aus dem Verzeichnis '&2' aufgetr

dcl-ds IFS1017;
  IFS10171 char(001) inz(*blanks);
  IFS10172 char(128) inz(*blanks);
  IFS10173 packed(010) inz(*zeros);
  IFS10174 char(128) inz(*blanks);
end-ds;
dcl-s IFS1017# bindec(8) inz(0263);
