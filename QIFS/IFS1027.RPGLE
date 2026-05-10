**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1027

// &1[1027] Berechtigungen fr Verzeichnis nicht gesetzt. Der

dcl-ds IFS1027;
  IFS10271 char(001) inz(*blanks);
  IFS10272 char(128) inz(*blanks);
  IFS10273 packed(010) inz(*zeros);
  IFS10274 char(128) inz(*blanks);
end-ds;
dcl-s IFS1027# bindec(8) inz(0263);
