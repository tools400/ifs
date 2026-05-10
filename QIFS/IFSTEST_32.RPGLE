**FREE
//===============================================================*
//    CALL PGM(IFSTEST_32) PARM('/home/raddatz/fileName')        *
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

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_32');
  gi_path CHAR(32) OPTIONS(*NOPASS) CONST;
END-PR;

DCL-PR main;
  i_path VARCHAR(256) CONST;
END-PR;

//===============================================================*
//  Program Entry Point
//===============================================================*
DCL-PI PGM_ENTRY_POINT;
  gi_path CHAR(32) OPTIONS(*NOPASS) CONST;
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 1);
   main(%trim(gi_path));
else;
   main('/home/Raddatz/test_ifs/file_5.txt');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  DCL-PI *N;
    i_path VARCHAR(256) CONST;
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
  // Open flags:     write
  //                 share with readers
  //                 create file, send message if file exists
  //                 open for text data
  //                 ccsid = 1208
hFile = f_openIfsFile(%trim(i_path): O_WRONLY + O_SHARE_RDONLY +
                                     O_CREAT + O_EXCL + O_TEXTDATA +
                                     O_CCSID: 1208);

f_writeLineIfsFile(hFile
                   : 'This has has been created using ccsid 1208': 0);
f_writeLineIfsFile(hFile
                   : '': 0);
f_writeLineIfsFile(hFile
                   :'Default authority set by IFS service program:':0);
f_writeLineIfsFile(hFile
                   : '': 0);
f_writeLineIfsFile(hFile
                   :'              Data     --Object Authorities--':0);
f_writeLineIfsFile(hFile
                   :'User        Authority  Exist  Mgt  Alter  Ref':0);
f_writeLineIfsFile(hFile
                   :'                                             ':0);
f_writeLineIfsFile(hFile
                   :'*PUBLIC     *RWX         X     X     X     X ':0);
f_writeLineIfsFile(hFile
                   :'RADDATZ     *RWX         X     X     X     X ':0);


  // Close IFS file
f_closeIfsFile(hFile);

return;


END-PROC MAIN;