**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1028

// &1[1028] Fehler bei der Ermittlung der eindeutigen Datei-ID

dcl-ds IFS1028;
  IFS10281 char(001) inz(*blanks);
  IFS10282 char(128) inz(*blanks);
  IFS10283 packed(010) inz(*zeros);
  IFS10284 char(128) inz(*blanks);
end-ds;
dcl-s IFS1028# bindec(8) inz(0263);
