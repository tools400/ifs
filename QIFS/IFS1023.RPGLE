**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1023

// &1[1023] Fehler beim Erstellen eines temporren Pfadnamens

dcl-ds IFS1023;
  IFS10231 char(001) inz(*blanks);
  IFS10232 packed(010) inz(*zeros);
  IFS10233 char(128) inz(*blanks);
end-ds;
dcl-s IFS1023# bindec(8) inz(0135);
