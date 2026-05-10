**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1002

// &1[1002] Fehler beim Schreiben in die IFS-Datei '&2' aufget

dcl-ds IFS1002;
  IFS10021 char(001) inz(*blanks);
  IFS10022 char(128) inz(*blanks);
  IFS10023 packed(010) inz(*zeros);
  IFS10024 char(128) inz(*blanks);
end-ds;
dcl-s IFS1002# bindec(8) inz(0263);
