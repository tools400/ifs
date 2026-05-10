**FREE
//===============================================================*
//    CALL PGM(IFSTEST_04) PARM('/home/raddatz/test_ifs/*')      *
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

DCL-PR PGM_ENTRY_POINT EXTPGM('IFSTEST_04');
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
  DCL-S x INT(10) INZ;
  DCL-S numEntries INT(10) INZ;
  DCL-DS resultSet1 LIKEDS(resultSet_t) INZ;
  DCL-DS resultSet2 LIKEDS(resultSet_t) INZ;
/IF not defined(*V5R2M0)
  DCL-DS entryElem LIKEDS(entry_t) BASED(pEntryElem);
  DCL-S entry1 LIKE(entry_t) DIM(10) BASED(pEntry1);
  DCL-S entry2 LIKE(entry_t) DIM(10) BASED(pEntry2);
  DCL-DS msg1 LIKEDS(msg_t) BASED(pMsg1);
  DCL-DS msg2 LIKEDS(msg_t) BASED(pMsg2);
/ENDIF
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // -----------------------------------------------------
  // Read directory using callback f_readDirIfs_path.
  // -----------------------------------------------------
clear resultSet1;
/IF not defined(*V5R2M0)
pEntry1 = %addr(resultSet1.entry);
pMsg1   = %addr(resultSet1.msg  );
clear entry1;
clear msg1;
/ENDIF
resultSet1.selectedPath = f_rtvIfsDirFromPath(i_path);
resultSet1.msg          = f_newMsg(cMsg_ID_OK);
numEntries = f_readIfsDir(%trim(i_path): %paddr('f_readDirIfs_path'):
                          cIFS_READDIR_DFT + cIFS_READDIR_SUBDIR +
                          cIFS_READDIR_PRE_ORDER                    :
                          %addr(resultSet1)                         :
                          msg                                       );
if (msg.ID <> cMsg_ID_OK);
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
endif;

/IF not defined(*V5R2M0)
if (msg1.ID <> cMsg_ID_OK);
/ELSE
   if (resultSet1.msg.ID <> cMsg_ID_OK);
/ENDIF
      f_sndPgmMsg(resultSet1.msg: cMsg_Prv: cMsg_toCtlBdy);
   endif;

   msg = f_newMsg(cMsg_ID_NONE:
                  'Total number of entries (pre-order): ' +
                   %char(numEntries));
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

   for x = 1 to resultSet1.numE;
/IF not defined(*V5R2M0)
      pEntryElem = %addr(entry1) + ((x-1) * %size(entry1));
      msg = f_newMsg(cMsg_ID_NONE: entryElem.type + ': ' +
                                   entryElem.path);
/ELSE
      msg = f_newMsg(cMsg_ID_NONE: resultSet1.entry(x).type + ': ' +
                                   resultSet1.entry(x).path);
/ENDIF
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
   endfor;

  // -----------------------------------------------------
  // Read directory using callback f_readDirIfs_dirent.
  // -----------------------------------------------------
   clear resultSet2;
/IF not defined(*V5R2M0)
   pEntry2 = %addr(resultSet2.entry);
   pMsg2   = %addr(resultSet2.msg  );
   clear entry2;
   clear msg2;
/ENDIF
   resultSet2.selectedPath = f_rtvIfsDirFromPath(i_path);
   resultSet2.msg          = f_newMsg(cMsg_ID_OK);
  numEntries = f_readIfsDir(%trim(i_path): %paddr('f_readDirIfs_dirent'):
                            cIFS_READDIR_FILES +
                            cIFS_READDIR_DIR   +
                            cIFS_READDIR_CB_DIRENT +
                            cIFS_READDIR_SUBDIR +
                            cIFS_READDIR_POST_ORDER                     :
                            %addr(resultSet2)                           :
                            msg                                        );
   if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
   endif;

/IF not defined(*V5R2M0)
   if (msg2.ID <> cMsg_ID_OK);
/ELSE
      if (resultSet2.msg.ID <> cMsg_ID_OK);
/ENDIF
         f_sndPgmMsg(resultSet2.msg: cMsg_Prv: cMsg_toCtlBdy);
      endif;

      msg = f_newMsg(cMsg_ID_NONE:
                     'Total number of entries (post-order): ' +
                      %char(numEntries));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

      for x = 1 to resultSet2.numE;
/IF not defined(*V5R2M0)
         pEntryElem = %addr(entry2) + ((x-1) * %size(entry2));
         msg = f_newMsg(cMsg_ID_NONE: entryElem.type + ': ' +
                                      entryElem.path);
/ELSE
         msg = f_newMsg(cMsg_ID_NONE: resultSet2.entry(x).type + ': ' +
                                      resultSet2.entry(x).path);
/ENDIF
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
      endfor;

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

  //  User data passed to f_readIfsDir( ... : %addr(resultSet1): ... )
  DCL-DS resultSet LIKEDS(resultSet_t) BASED(i_pUsrDta);
/IF not defined(*V5R2M0)
  DCL-DS entryElem LIKEDS(entry_t) BASED(pEntryElem);
  DCL-S entry LIKE(entry_t) DIM(10) BASED(pEntry);
  DCL-DS msg LIKEDS(msg_t) BASED(pMsg);
/ENDIF
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/IF not defined(*V5R2M0)
      pEntry = %addr(resultSet.entry);
      pMsg   = %addr(resultSet.msg  );
/ENDIF

  // if   %trimR(i_directory) = %trimR(resultSet.selectedPath);
      if resultSet.numE < %elem(resultSet.entry);
         resultSet.numE = resultSet.numE + 1;
/IF not defined(*V5R2M0)
         pEntryElem = %addr(entry) + ((resultSet.numE-1) * %size(entry));
         entryElem.path = i_entry;
         entryElem.type = i_type;
/ELSE
         resultSet.entry(resultSet.numE).path = i_entry;
         resultSet.entry(resultSet.numE).type = i_type;
/ENDIF
      else;
         resultSet.msg = f_newMsg('CPF9898':
                                  'Result set overflow!': cMsg_Diag);
      endif;
  // endif;

      isOK = cTrue;

      return   isOK;


END-PROC;

//===============================================================*
//  Callback: f_readDirIfs_dirent()
//===============================================================*
DCL-PROC f_readDirIfs_dirent EXPORT;
  DCL-PI *N IND;
    i_level     INT(10) VALUE;
    i_directory LIKE(ifs_path_t) VALUE;
    i_dirent    LIKEDS(dirent_t) VALUE;
    i_type      LIKE(ifs_type_t) VALUE;
    i_pUsrDta   POINTER VALUE;
    o_msg       LIKE(msg_t) VALUE;
  END-PI;

  //  Return value
  DCL-S isOK IND INZ(cFalse);

  //  User data passed to f_readIfsDir( ... : %addr(resultSet2): ... )
  DCL-DS resultSet LIKEDS(resultSet_t) BASED(i_pUsrDta);
/IF not defined(*V5R2M0)
  DCL-DS entryElem LIKEDS(entry_t) BASED(pEntryElem);
  DCL-S entry LIKE(entry_t) DIM(10) BASED(pEntry);
  DCL-DS msg LIKEDS(msg_t) BASED(pMsg);
/ENDIF
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/IF not defined(*V5R2M0)
      pEntry = %addr(resultSet.entry);
      pMsg   = %addr(resultSet.msg  );
/ENDIF

  // if   %trimR(i_directory) = %trimR(resultSet.selectedPath);
      if resultSet.numE < %elem(resultSet.entry);
         resultSet.numE = resultSet.numE + 1;
/IF not defined(*V5R2M0)
         pEntryElem = %addr(entry) + ((resultSet.numE-1) * %size(entry));
         entryElem.path = %subst(i_dirent.d_name: 1:
                                 i_dirent.d_namelen);
         entryElem.type = i_type;
/ELSE
         resultSet.entry(resultSet.numE).path =%subst(i_dirent.d_name: 1:
                                                     i_dirent.d_namelen);
         resultSet.entry(resultSet.numE).type = i_type;
/ENDIF
      else;
         resultSet.msg = f_newMsg('CPF9898':
                                  'Result set overflow!': cMsg_Diag);
      endif;
  // endif;

      isOK = cTrue;

      return   isOK;


END-PROC;