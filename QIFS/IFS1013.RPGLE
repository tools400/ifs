**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1013

// &1[1013] IFS-Datei existiert.

dcl-ds IFS1013;
  IFS10131 char(001) inz(*blanks);
  IFS10132 char(128) inz(*blanks);
end-ds;
dcl-s IFS1013# bindec(8) inz(0129);
