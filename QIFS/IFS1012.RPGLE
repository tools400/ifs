**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1012

// &1[1012] IFS-Datei nicht vorhanden.

dcl-ds IFS1012;
  IFS10121 char(001) inz(*blanks);
  IFS10122 char(128) inz(*blanks);
end-ds;
dcl-s IFS1012# bindec(8) inz(0129);
