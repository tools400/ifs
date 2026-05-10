**FREE
//===============================================================*
//    CALL PGM(IFSTEST_04) PARM('/home/raddatz/genStrCmp/*')     *
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
/IF not defined(*V5R2M0)
DCL-DS resultSet_t TEMPLATE QUALIFIED;
  selectedPath LIKE(ifs_path_t);
  msg          LIKE(msg_t);
  numE         INT(10);
  entry        LIKE(entry_t) DIM(10);
END-DS;

DCL-DS entry_t TEMPLATE QUALIFIED;
  type LIKE(ifs_type_t);
  path LIKE(ifs_path_t);
END-DS;
/ELSE
DCL-DS resultSet_t TEMPLATE QUALIFIED;
  selectedPath LIKE(ifs_path_t);
  msg          LIKEDS(msg_t);
  numE         INT(10);
  entry        LIKEDS(entry_t) DIM(10);
END-DS;

DCL-DS entry_t TEMPLATE QUALIFIED;
  type LIKE(ifs_type_t);
  path LIKE(ifs_path_t);
END-DS;
/ENDIF

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

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_98');
END-PR;

DCL-PR main;
END-PR;

//===============================================================*
//  Program Entry Point
//===============================================================*
DCL-PI PGM_ENTRY_POINT;
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  DCL-PI *N;
  END-PI;

  //  Helper fields
  DCL-S x INT(10) INZ;
  DCL-S fd LIKE(ifs_hFile_t) INZ;
  DCL-S tempFiles VARCHAR(256) DIM(10) INZ;
  DCL-S dir VARCHAR(256) INZ;

  DCL-C FILE_EXTENSION '.ifsTest_98';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // -----------------------------------------------------
  //   Produce temporary files.
  // -----------------------------------------------------
for x = 1 to %elem(tempFiles);
   tempFiles(x) = %trim(f_getIfsTmpPath()) + FILE_EXTENSION;
   fd = f_openIfsFile(tempFiles(x): O_CREAT + O_EXCL + O_WRONLY);
   f_writeLineIfsFile(fd: 'Test Serviceprogramm IFS': 0);
   f_closeIfsFile(fd);
   if (x = 1);
      dir = %trim(f_rtvIfsDirFromPath(tempFiles(x)));
   endif;
endfor;

  // -----------------------------------------------------
  //   Read directory.
  // -----------------------------------------------------
f_readIfsDir(dir + '/*' + FILE_EXTENSION
             : %paddr('f_readDirIfs_path')
             : cIFS_READDIR_DFT
             : %addr(tempFiles));

return;


END-PROC MAIN;

//===============================================================*
//  Callback: f_readDirIfs_path()
//===============================================================*
DCL-PROC f_readDirIfs_path EXPORT;
  DCL-PI *N IND;
    i_level     INT(10) VALUE;
    i_directory LIKE(ifs_path_t) VALUE;
    i_entry     LIKE(ifs_path_t) VALUE;
    i_type      LIKE(ifs_type_t) VALUE;
    i_pUsrDta   POINTER VALUE;
    o_msg       LIKE(msg_t) VALUE;
  END-PI;

  //  Return value
  DCL-S isOK IND INZ(cFalse);

  DCL-S isInit IND INZ(cFalse) STATIC;
  DCL-S tempFiles VARCHAR(256) DIM(10) BASED(i_pUsrDta);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (not isInit);
   f_deleteIfsFile(tempFiles(2));
   isInit = cTrue;
endif;

f_deleteIfsFile(%trim(i_directory) + %trim(i_entry));

isOK = cTrue;

return   isOK;


END-PROC;