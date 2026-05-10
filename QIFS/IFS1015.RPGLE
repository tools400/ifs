**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1015

// &1[1015] IFS-Verzeichnis existiert.

dcl-ds IFS1015;
  IFS10151 char(001) inz(*blanks);
  IFS10152 char(128) inz(*blanks);
end-ds;
dcl-s IFS1015# bindec(8) inz(0129);
