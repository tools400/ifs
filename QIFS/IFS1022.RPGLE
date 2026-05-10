**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1022

// &1[1022] Fehler beim Ermitteln der Zeit der letzten nderun

dcl-ds IFS1022;
  IFS10221 char(001) inz(*blanks);
  IFS10222 char(128) inz(*blanks);
  IFS10223 packed(010) inz(*zeros);
  IFS10224 char(128) inz(*blanks);
end-ds;
dcl-s IFS1022# bindec(8) inz(0263);
