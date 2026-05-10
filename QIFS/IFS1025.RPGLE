**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1025

// &1[1025] Fehler beim Abrufen der Objektberechtigungen fr d

dcl-ds IFS1025;
  IFS10251 char(001) inz(*blanks);
  IFS10252 char(128) inz(*blanks);
  IFS10253 packed(010) inz(*zeros);
  IFS10254 char(128) inz(*blanks);
end-ds;
dcl-s IFS1025# bindec(8) inz(0263);
