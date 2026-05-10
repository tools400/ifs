**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1016

// &1[1016] Pufferberlauf beim Lesen aus der IFS Datei '&2'

dcl-ds IFS1016;
  IFS10161 char(001) inz(*blanks);
  IFS10162 char(128) inz(*blanks);
  IFS10163 packed(010) inz(*zeros);
end-ds;
dcl-s IFS1016# bindec(8) inz(0135);
