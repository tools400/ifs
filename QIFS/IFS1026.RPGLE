**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1026

// &1[1026] Verzeichnis konnte nicht erstellt werden. Der Fehl

dcl-ds IFS1026;
  IFS10261 char(001) inz(*blanks);
  IFS10262 char(128) inz(*blanks);
  IFS10263 packed(010) inz(*zeros);
  IFS10264 char(128) inz(*blanks);
end-ds;
dcl-s IFS1026# bindec(8) inz(0263);
