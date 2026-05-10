**FREE
//===============================================================*
//    CALL PGM(IFSTEST_01) PARM('/home/raddatz/fileName')        *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/IFS    ) +         *
//                              BNDDIR(QC2LE         ) +         *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
CTL-OPT DEBUG OPTION(*SRCSTMT: *NODEBUGIO);
CTL-OPT DECEDIT('0,') DATEDIT(*DMY.);
CTL-OPT DATFMT(*ISO) TIMFMT(*ISO);
CTL-OPT EXPROPTS(*RESDECPOS);
CTL-OPT EXTBININT(*YES);
//===============================================================*
//
// ------------------------------------
//  Type Definitions
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QIFS,PIFS
/COPY QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------
//
// ------------------------------------
//  Global Constants
// ------------------------------------
//
// ------------------------------------
//  Prototypes
// ------------------------------------

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_01');
  gi_path CHAR(32) CONST;
END-PR;

DCL-PR main;
  i_path CHAR(32) CONST;
END-PR;

//===============================================================*
//  Program Entry Point
//===============================================================*
DCL-PI PGM_ENTRY_POINT;
  gi_path CHAR(32) CONST;
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main(gi_path);

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  DCL-PI *N;
    i_path CHAR(32) CONST;
  END-PI;

  //  Helper fields
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  DCL-S bytesRed INT(10) INZ;
  DCL-S buffer CHAR(64) INZ;
  DCL-S size INT(10) INZ;
  DCL-S crtTime TIMESTAMP INZ;
  DCL-S chgTime TIMESTAMP INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Open IFS file (The file must not yet exists!)
  // Open flags:     read & write
  //                 share with readers
  //                 create file, send message if file exists
  //                 open for text data
hFile = f_openIfsFile(%trim(i_path): O_RDWR + O_SHARE_RDONLY +
                                     O_CREAT + O_EXCL + O_TEXTDATA);

  // Get file creation time
crtTime = f_getIfsFileCrtTime(%trim(i_path));

  // Write to file
f_writeIfsFile(hFile: 'Hello World!': 0);

  // Set read pointer to 'World!'
f_seekIfsFile(hFile: 6: SEEK_SET);
  //    ^-----------------  Offset to 'World', starting at 0.

  // Read from file
bytesRed = f_readIfsFile(hFile: %addr(buffer): %size(buffer));

  // Close IFS file
f_closeIfsFile(hFile);

  // Get file size
size = f_getIfsFileSize(%trim(i_path));

  // Get file last changed time
chgTime = f_getIfsFileDataChgTime(%trim(i_path));

return;


END-PROC MAIN;