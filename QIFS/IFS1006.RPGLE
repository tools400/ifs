**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : IFS1006

// &1[1006] Fehler beim Ermitteln der Gre der IFS-Datei '&2'

dcl-ds IFS1006;
  IFS10061 char(001) inz(*blanks);
  IFS10062 char(128) inz(*blanks);
  IFS10063 packed(010) inz(*zeros);
  IFS10064 char(128) inz(*blanks);
end-ds;
dcl-s IFS1006# bindec(8) inz(0263);
