**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1018

// &1[1018] Fehler beim Abrufen der Attribute der Datei '&2' a

dcl-ds IFS1018;
  IFS10181 char(001) inz(*blanks);
  IFS10182 char(128) inz(*blanks);
  IFS10183 packed(010) inz(*zeros);
  IFS10184 char(128) inz(*blanks);
end-ds;
dcl-s IFS1018# bindec(8) inz(0263);
