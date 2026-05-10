**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1014

// &1[1014] IFS-Dateiname enthlt ungltige Zeichen oder Pfada

dcl-ds IFS1014;
  IFS10141 char(001) inz(*blanks);
  IFS10142 char(128) inz(*blanks);
end-ds;
dcl-s IFS1014# bindec(8) inz(0129);
