      *===============================================================*
      *    CALL PGM(IFSTEST_04) PARM('/home/raddatz/genStrCmp/*')     *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/IFS      +         *
      *                                        &LI/BASICS1) +         *
      *                              BNDDIR(QC2LE         ) +         *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      /if not defined(*V5R2M0)
     D resultSet_t     DS                  based(pDummy)   qualified
     D  selectedPath                       like(ifs_path_t)
     D  msg                                like(msg_t   )
     D  numE                         10I 0
     D  entry                              like(entry_t) dim(10)
      *
     D entry_t         DS                  based(pDummy)   qualified
     D  type                               like(ifs_type_t)
     D  path                               like(ifs_path_t)
      /else
     D resultSet_t     DS                  based(pDummy)   qualified
     D  selectedPath                       like(ifs_path_t)
     D  msg                                likeds(msg_t   )
     D  numE                         10I 0
     D  entry                              likeds(entry_t) dim(10)
      *
     D entry_t         DS                  based(pDummy)   qualified
     D  type                               like(ifs_type_t)
     D  path                               like(ifs_path_t)
      /endif
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QIFS,PIFS
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('IFSTEST_04')
     D  gi_path                      32A   const
      *
     D main...
     D                 PR
     D  i_path                       32A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_path                      32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(gi_path);

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
     D  i_path                       32A   const
      *
      *  Helper fields
     D x               S             10I 0                     inz
     D numEntries      S             10I 0                     inz
     D resultSet1      DS                  likeds(resultSet_t) inz
     D resultSet2      DS                  likeds(resultSet_t) inz
      /if not defined(*V5R2M0)
     D entryElem       DS                  likeds(entry_t)
     D                                     based(pEntryElem)
     D entry1          S                   like(entry_t)       dim(10)
     D                                     based(pEntry1)
     D entry2          S                   like(entry_t)       dim(10)
     D                                     based(pEntry2)
     D msg1            DS                  likeds(msg_t)
     D                                     based(pMsg1)
     D msg2            DS                  likeds(msg_t)
     D                                     based(pMsg2)
      /endif
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // -----------------------------------------------------
         // Read directory using callback f_readDirIfs_path.
         // -----------------------------------------------------
         clear resultSet1;
      /if not defined(*V5R2M0)
         pEntry1 = %addr(resultSet1.entry);
         pMsg1   = %addr(resultSet1.msg  );
         clear entry1;
         clear msg1;
      /endif
         resultSet1.selectedPath = f_rtvIfsDirFromPath(i_path);
         resultSet1.msg          = f_newMsg(cMsg_ID_OK);
         numEntries = f_readIfsDir(%trim(i_path): %paddr('f_readDirIfs_path'):
                                   cIFS_READDIR_DFT                          :
                                   %addr(resultSet1)                         :
                                   msg                                       );
         if (msg.ID <> cMsg_ID_OK);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
         endif;

      /if not defined(*V5R2M0)
         if (msg1.ID <> cMsg_ID_OK);
      /else
         if (resultSet1.msg.ID <> cMsg_ID_OK);
      /endif
            f_sndPgmMsg(resultSet1.msg: cMsg_Prv: cMsg_toCtlBdy);
         endif;

         msg = f_newMsg(cMsg_ID_NONE:
                        'Total number of entries: ' + %char(numEntries));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

         for x = 1 to resultSet1.numE;
      /if not defined(*V5R2M0)
            pEntryElem = %addr(entry1) + ((x-1) * %size(entry1));
            msg = f_newMsg(cMsg_ID_NONE: entryElem.type + ': ' +
                                         entryElem.path);
      /else
            msg = f_newMsg(cMsg_ID_NONE: resultSet1.entry(x).type + ': ' +
                                         resultSet1.entry(x).path);
      /endif
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
         endfor;

         // -----------------------------------------------------
         // Read directory using callback f_readDirIfs_dirent.
         // -----------------------------------------------------
         clear resultSet2;
      /if not defined(*V5R2M0)
         pEntry2 = %addr(resultSet2.entry);
         pMsg2   = %addr(resultSet2.msg  );
         clear entry2;
         clear msg2;
      /endif
         resultSet2.selectedPath = f_rtvIfsDirFromPath(i_path);
         resultSet2.msg          = f_newMsg(cMsg_ID_OK);
         numEntries = f_readIfsDir(%trim(i_path): %paddr('f_readDirIfs_dirent'):
                                  cIFS_READDIR_FILES +
                                  cIFS_READDIR_DIR   +
                                  cIFS_READDIR_CB_DIRENT                      :
                                  %addr(resultSet2)                           :
                                   msg                                        );
         if (msg.ID <> cMsg_ID_OK);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
         endif;

      /if not defined(*V5R2M0)
         if (msg2.ID <> cMsg_ID_OK);
      /else
         if (resultSet2.msg.ID <> cMsg_ID_OK);
      /endif
            f_sndPgmMsg(resultSet2.msg: cMsg_Prv: cMsg_toCtlBdy);
         endif;

         msg = f_newMsg(cMsg_ID_NONE:
                        'Total number of entries: ' + %char(numEntries));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);

         for x = 1 to resultSet2.numE;
      /if not defined(*V5R2M0)
            pEntryElem = %addr(entry2) + ((x-1) * %size(entry2));
            msg = f_newMsg(cMsg_ID_NONE: entryElem.type + ': ' +
                                         entryElem.path);
      /else
            msg = f_newMsg(cMsg_ID_NONE: resultSet2.entry(x).type + ': ' +
                                         resultSet2.entry(x).path);
      /endif
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_toCtlBdy);
         endfor;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
      *===============================================================*
      *  Callback: f_readDirIfs_path()
      *===============================================================*
     P f_readDirIfs_path...
     P                 B                   export
      *
     D f_readDirIfs_path...
     D                 PI              N
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_entry                            value  like(ifs_path_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUsrDta                      *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Return value
     D isOK            S               N   inz(cFalse)
      *
      *  User data passed to f_readIfsDir( ... : %addr(resultSet1): ... )
     D resultSet       DS                  likeds(resultSet_t) based(i_pUsrDta)
      /if not defined(*V5R2M0)
     D entryElem       DS                  likeds(entry_t)
     D                                     based(pEntryElem)
     D entry           S                   like(entry_t)       dim(10)
     D                                     based(pEntry)
     D msg             DS                  likeds(msg_t)
     D                                     based(pMsg)
      /endif
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
      /if not defined(*V5R2M0)
         pEntry = %addr(resultSet.entry);
         pMsg   = %addr(resultSet.msg  );
      /endif

         if   %trimR(i_directory) = %trimR(resultSet.selectedPath);
            if resultSet.numE < %elem(resultSet.entry);
               resultSet.numE = resultSet.numE + 1;
      /if not defined(*V5R2M0)
               pEntryElem = %addr(entry) + ((resultSet.numE-1) * %size(entry));
               entryElem.path = i_entry;
               entryElem.type = i_type;
      /else
               resultSet.entry(resultSet.numE).path = i_entry;
               resultSet.entry(resultSet.numE).type = i_type;
      /endif
            else;
               resultSet.msg = f_newMsg('CPF9898':
                                        'Result set overflow!': cMsg_Diag);
            endif;
         endif;

         isOK = cTrue;

         return   isOK;

      /END-FREE
      *
     P f_readDirIfs_path...
     P                 E
      *
      *===============================================================*
      *  Callback: f_readDirIfs_dirent()
      *===============================================================*
     P f_readDirIfs_dirent...
     P                 B                   export
      *
     D f_readDirIfs_dirent...
     D                 PI              N
     D  i_level                      10I 0 value
     D  i_directory                        value  like(ifs_path_t    )
     D  i_dirent                           value  likeds(dirent_t    )
     D  i_type                             value  like(ifs_type_t    )
     D  i_pUsrDta                      *   value
     D  o_msg                              value  like(msg_t         )
      *
      *  Return value
     D isOK            S               N   inz(cFalse)
      *
      *  User data passed to f_readIfsDir( ... : %addr(resultSet2): ... )
     D resultSet       DS                  likeds(resultSet_t) based(i_pUsrDta)
      /if not defined(*V5R2M0)
     D entryElem       DS                  likeds(entry_t)
     D                                     based(pEntryElem)
     D entry           S                   like(entry_t)       dim(10)
     D                                     based(pEntry)
     D msg             DS                  likeds(msg_t)
     D                                     based(pMsg)
      /endif
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
      /if not defined(*V5R2M0)
         pEntry = %addr(resultSet.entry);
         pMsg   = %addr(resultSet.msg  );
      /endif

         if   %trimR(i_directory) = %trimR(resultSet.selectedPath);
            if resultSet.numE < %elem(resultSet.entry);
               resultSet.numE = resultSet.numE + 1;
      /if not defined(*V5R2M0)
               pEntryElem = %addr(entry) + ((resultSet.numE-1) * %size(entry));
               entryElem.path = %subst(i_dirent.d_name: 1:
                                       i_dirent.d_namelen);
               entryElem.type = i_type;
      /else
               resultSet.entry(resultSet.numE).path =%subst(i_dirent.d_name: 1:
                                                            i_dirent.d_namelen);
               resultSet.entry(resultSet.numE).type = i_type;
      /endif
            else;
               resultSet.msg = f_newMsg('CPF9898':
                                        'Result set overflow!': cMsg_Diag);
            endif;
         endif;

         isOK = cTrue;

         return   isOK;

      /END-FREE
      *
     P f_readDirIfs_dirent...
     P                 E
      *
