**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1021

// &1[1021] Fehler beim Ermitteln der Erstellungszeit der IFS-

dcl-ds IFS1021;
  IFS10211 char(001) inz(*blanks);
  IFS10212 char(128) inz(*blanks);
  IFS10213 packed(010) inz(*zeros);
  IFS10214 char(128) inz(*blanks);
end-ds;
dcl-s IFS1021# bindec(8) inz(0263);
