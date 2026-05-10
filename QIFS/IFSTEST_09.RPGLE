**FREE
//===============================================================*
//    CALL PGM(IFSTEST_09) PARM('/home/raddatz/test_ifs/*')      *
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
//                              BNDSRVPGM(&LI/IFS      +         *
//                                        &LI/BASICS1) +         *
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

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_09');
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
  DCL-S numEntries INT(10) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

f_sndPgmMsg(f_newMsg(cMsg_ID_NONE
            : 'Delete all files and subdirectories:')
            : cMsg_Prv: cMsg_ToCtlBdy);

numEntries = f_dltIfsDir(i_path
                         : cIFS_RMDIR_DELETE_FILES +
                           cIFS_RMDIR_DELETE_SUB_DIRECTORIES +
                           cIFS_RMDIR_TEST_MODE
                         : msg);

if (numEntries < 0);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
endif;

f_sndPgmMsg(f_newMsg(cMsg_ID_NONE
            : 'Delete all files, but no subdirectories:')
            : cMsg_Prv: cMsg_ToCtlBdy);

numEntries = f_dltIfsDir(i_path
                         : cIFS_RMDIR_DELETE_FILES +
                           cIFS_RMDIR_TEST_MODE
                         : msg);

if (numEntries < 0);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
endif;

f_sndPgmMsg(f_newMsg(cMsg_ID_NONE: 'Delete only the given directory:')
            : cMsg_Prv: cMsg_ToCtlBdy);

numEntries = f_dltIfsDir(i_path
                         : cIFS_RMDIR_TEST_MODE
                         : msg);

if (numEntries < 0);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
endif;

return;


END-PROC MAIN;