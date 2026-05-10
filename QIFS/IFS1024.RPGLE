**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1024

// &1[1024] Ungltige Pfadangabe.

dcl-ds IFS1024;
  IFS10241 char(001) inz(*blanks);
  IFS10242 char(128) inz(*blanks);
end-ds;
dcl-s IFS1024# bindec(8) inz(0129);
