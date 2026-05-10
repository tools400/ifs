**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1011

// &1[1011] IFS-Verzeichnis nicht vorhanden.

dcl-ds IFS1011;
  IFS10111 char(001) inz(*blanks);
  IFS10112 char(128) inz(*blanks);
end-ds;
dcl-s IFS1011# bindec(8) inz(0129);
