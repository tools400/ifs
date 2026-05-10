**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1033

// &1[1033] Das angegebene Verzeichnis '&2' konnte nicht angel

dcl-ds IFS1033;
  IFS10331 char(001) inz(*blanks);
  IFS10332 char(128) inz(*blanks);
  IFS10333 packed(010) inz(*zeros);
  IFS10334 char(128) inz(*blanks);
end-ds;
dcl-s IFS1033# bindec(8) inz(0263);
