**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1019

// &1[1019] Fehler beim ffnen des Verzeichnis '&2' aufgetrete

dcl-ds IFS1019;
  IFS10191 char(001) inz(*blanks);
  IFS10192 char(128) inz(*blanks);
  IFS10193 packed(010) inz(*zeros);
  IFS10194 char(128) inz(*blanks);
end-ds;
dcl-s IFS1019# bindec(8) inz(0263);
