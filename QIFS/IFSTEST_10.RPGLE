      *===============================================================*
      *    CALL PGM(IFSTEST_10) PARM('/home/raddatz/test_ifs/')       *
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
     D                 PR                         extpgm('IFSTEST_10')
     D  gi_path                     256A   const
      *
     D main...
     D                 PR
     D  i_path                      256A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_path                     256A   const
      *
     D g_x             S             10I 0 inz(32)
     D g_path          S                   like(gi_path ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         g_path = f_left(gi_path: g_x);
         dow (g_x < %len(gi_path) and %subst(gi_path: g_x + 1: 1) <> ' ');
            g_x = g_x + 1;
            %subst(g_path: g_x: 1) = %subst(gi_path: g_x: 1);
         enddo;

         main(g_path);

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
     D  i_path                      256A   const
      *
      *  Helper fields
     D isEmpty         S               N   inz(cFalse)
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Test non existant directory, message parameter not passed
         monitor;
            isEmpty = f_isIfsDirEmpty('/www_tools400_de/ifs/foo_baa/');
            f_sndPgmMsg(f_newMsg('CPF9898'
                                 : 'ERROR: +
                                    Expected error message has not been sent'
                                 : cMsg_Escape)
                        : cMsg_Prv: cMsg_ToCtlBdy);
         on-error;
            msg = f_newMsg(cMSG_ID_OK);
            msg = f_rcvPgmMsgObj(cMsg_Escape: *omit: cMsg_Act_Rmv);
            if (msg.ID <> 'IFS1011');
               f_sndPgmMsg(f_newMsg('CPF9898'
                                    : 'ERROR: +
                                       Received unexpected message ID: '+msg.ID
                                    : cMsg_Escape)
                           : cMsg_Prv: cMsg_ToCtlBdy);
            endif;
         endmon;

         // Test non existant directory, message parameter passed
         msg = f_newMsg(cMSG_ID_OK);
         isEmpty = f_isIfsDirEmpty('/www_tools400_de/ifs/foo_baa/': msg);
         if (msg.ID <> 'IFS1011');
            f_sndPgmMsg(f_newMsg('CPF9898'
                                 : 'ERROR: +
                                    Received unexpected message ID: '+msg.ID
                                 : cMsg_Escape)
                        : cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         // Test non existant directory, message parameter omitted
         isEmpty = f_isIfsDirEmpty('/www_tools400_de/ifs/foo_baa/': *omit);

         // Test specified directory
         isEmpty = f_isIfsDirEmpty(i_path: msg);
         if (msg.ID <> cMSG_ID_OK);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         if (isEmpty);
            f_sndPgmMsg(f_newMsg('CPF9897'
                                 : 'INFO: +
                                    The specified directory is empty')
                        : cMsg_Prv: cMsg_ToCtlBdy);
         else;
            f_sndPgmMsg(f_newMsg('CPF9897'
                                 : 'INFO: +
                                    ** The specified directory if not empty **')
                        : cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
