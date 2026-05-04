      /if not defined(CEELIB)
      /define CEELIB
      *
      * ---------------------------------------------------------------
      *   Program or Procedure Call APIs
      * ---------------------------------------------------------------
      *
      *  Condition token, used as feedback code
     d cee_fc_t        ds                  qualified               template
     d  Condition_ID...
     d                         1      4A
     d   MsgSev                1      2I 0
     d   Msg_No                3      4U 0
     d  Flags                  5      5A
     d  Facility_ID...
     d                         6      8A
     d  I_S_Info               9     12A
      *
      *  Retrieve Operational Descriptor Information (CEEDOD)
     d CEEDOD...
     d                 pr
     d                                            extproc('CEEDOD')
     d  i_posn                       10i 0 const
     d  o_desctype                   10i 0
     d  o_datatype                   10i 0
     d  o_descinf1                   10i 0
     d  o_descinf2                   10i 0
     d  o_datalen                    10i 0
     d  o_fc                         12a          options(*omit   )
      *
      *  Reference fields for CEEDOD API
     d descInf_t       ds                  template   qualified
     d  desctype                     10i 0
     d  datatype                     10i 0
     d  descinf1                     10i 0
     d  descinf2                     10i 0
     d  datalen                      10i 0
      *
      *  Test for Omitted Argument (CEETSTA) API
     d CEETSTA...
     d                 pr
     d                                            extproc('CEETSTA')
     d  io_isPresent                 10i 0
     d  i_argNum                     10i 0 const
     d  o_fc                         12a          options(*omit   )
      *
      *  Get String Information (CEEGSI) API
     d CEEGSI...
     d                 pr
     d                                            extproc('CEEGSI')
     d  i_posn                       10i 0 const
     d  o_datatype                   10i 0
     d  o_curlen                     10i 0
     d  o_maxlen                     10i 0
     d  o_fb                         12a          options(*omit   )
      *
      *  Reference fields for CEEGSI API
     d strInf_t        ds                  template   qualified
     d  datatype                     10i 0
     d  curlen                       10i 0
     d  maxlen                       10i 0
      *
      * ---------------------------------------------------------------
      *   Storage Management APIs
      * ---------------------------------------------------------------
      *
      *  Allocation Strategy Type (CEE4ALC)
     d CEE4ALC         ds
     d   MaxSglAloc                  10i 0
     d   MinBdy                      10i 0
     d   CrtSiz                      10i 0
     d   ExtSiz                      10i 0
     d   res1                         5i 0
     d   AllocBits                    3U 0
     d   InitValue                    3U 0
     d   res2                         5a
      *
      *  Use BITON to set on the appropriate bit.
      *  For example:   BITON     AllocInit     AllocBits
     d ALC_ABITS_AllocStrat...
     d                 c                    x'80'
     d ALC_BITS_NoMark...
     d                 c                    x'40'
     d ALC_ABITS_BlkXfer...
     d                 c                    x'20'
     d ALC_ABITS_PAG...
     d                 c                    x'10'
     d ALC_ABITS_AllocInit...
     d                 c                    x'08'
      *
      *  Create Heap (CEECRHP) API
      *  The Create Heap (CEECRHP) API creates a new heap.
     d CEECRHP...
     d                 pr                  extproc('CEECRHP')
     d  o_heap_Id                    10i 0
     d  i_initial_size...
     d                               10i 0 const  options(*omit   )
     d  i_increment                  10i 0 const  options(*omit   )
     d  i_alloc_strat_id...
     d                               10i 0 const  options(*omit   )
     d  o_fc                         12a          options(*omit   )
      *
      *  Discard Heap (CEEDSHP) API
      *  The Discard Heap (CEEDSHP) API deletes an existing heap.
     d CEEDSHP...
     d                 pr                  extproc('CEEDSHP')
     d  i_heap_Id                    10i 0 const
     d  o_fc                         12a          options(*omit   )
      *
      *  Get Heap Storage (CEEGTST) API
      *  The Get Heap Storage (CEEGTST) API allocates storage within a heap.
     d CEEGTST...
     d                 pr                  extproc('CEEGTST')
     d  i_heap_Id                    10i 0 const
     d  i_size                       10i 0 const
     d  o_address                      *
     d  o_fc                         12a          options(*omit   )
      *
      *  Reallocate Storage (CEECZST) API
      *  The Reallocate Storage (CEECZST) API changes the size of a previously
      *  allocated storage block, preserving the contents.
     d CEECZST...
     d                 pr                  extproc('CEECZST')
     d  io_address                     *
     d  i_size                       10i 0 const
     d  o_fc                         12a          options(*omit   )
      *
      *  Free Storage (CEEFRST) API
      *  The Free Storage (CEEFRST) API frees previously allocated heap storage.
     d CEEFRST...
     d                 pr                  extproc('CEEFRST')
     d  i_address                      *   const
     d  o_fc                         12a          options(*omit   )
      *
      *  Mark Heap (CEEMKHP) API
      *  The Mark Heap (CEEMKHP) API returns a token, which can be used with
      *  the Release Heap (CEERLHP) API to free a heap storage group. After
      *  a CEEMKHP call, all storage subsequently obtained by the CEEGTST API
      *  can be freed by a single CEERLHP call. A heap may have multiple marks.
     d CEEMKHP...
     d                 pr
     d                                            extproc('CEEMKHP')
     d  i_heap_id                    10i 0 const
     d  o_mark                         *
     d  o_fc                         12a          options(*omit)
      *
      *  Release Heap (CEERLHP) API
      *  The Release Heap (CEERLHP) API frees all storage allocated since
      *  the specified mark in the heap.
     d CEERLHP...
     d                 pr
     d                                            extproc('CEERLHP')
     d  i_mark                         *   const
     d  o_fc                         12a          options(*omit)
      *
      * ---------------------------------------------------------------
      *   Math APIs
      * ---------------------------------------------------------------
      *
      *  Logarithm base 10 (double float)
     d CEESDLG1...
     d                 pr                  extproc('CEESDLG1')
     d  i_value                       8f   const
     d  o_result                      8f
      *
      * ---------------------------------------------------------------
      *   ILE CEE Date and Time APIs
      * ---------------------------------------------------------------
      *
      *  Calculate Day of Week from Lilian Date (CEEDYWK) API
     d CEEDYWK         pr                  opdesc extproc('CEEDYWK')
     d   lilian_date                 10i 0 const
     d   day_no                      10i 0
     d   feedback                    12a   options(*omit)
      *
      *  Convert Lilian Date to Character Format (CEEDATE) API
     d CEEDATE         pr                  opdesc extproc('CEEDATE')
     d   lilian_date                 10i 0 const
     d   date_format                 80A   const options(*varsize)
     d   char_date                   80A   options(*varsize)
     d   feedback                    12a   options(*omit)
      *
      *  Convert Date to Lilian Format (CEEDAYS) API
     d CEEDAYS         pr                  opdesc extproc('CEEDAYS')
     d   char_date                   80A   const options(*varsize)
     d   date_format                 80A   const options(*varsize)
     d   lilian_date                 10i 0
     d   feedback                    12a   options(*omit)
      *
      *  Convert Seconds to Character Timestamp (CEEDATM) API
     d CEEDATM         pr                  opdesc extproc('CEEDATM')
     d  input_seconds                 8f   const
     d  picture_string...
     d                               80A   const options(*varsize)
     d  output_timestamp...
     d                               80A         options(*varsize)
     d   feedback                    12a   options(*omit)
      *
      *  Get Offset from Universal Time Coordinated to Local Time (CEEUTCO) API
     d CEEUTCO         pr                  extproc('CEEUTCO')
     d  offsethours                  10i 0
     d  offsetminutes                10i 0
     d  offsetseconds                 8f
     d  feedback                     12a   options(*nopass)
      *
     d cee_utco_t      ds                  qualified   template
     d  offhours                     10i 0
     d  offmins                      10i 0
     d  offsecs                       8f
      *
      *  Convert Timestamp to Number of Seconds (CEESECS) API
     d CEESECS         pr                  extproc('CEESECS') opdesc
     d  inTimestamp                 255a   const options(*varsize)
     d  inPicture                   255a   const options(*varsize)
     d  outSeconds                    8f
     d  outFC                        12a         options(*omit)
      *
      * ---------------------------------------------------------------
      *   Activation Group and Control Flow APIs
      * ---------------------------------------------------------------
      *
      *  Register Activation Group Exit Procedure (CEE4RAGE) API
     d CEE4RAGE...
     d                 pr                  extproc('CEE4RAGE')
     d  i_pProc                        *   const procptr
     d   fc                          12a         options(*OMIT)
      *
     d END_ACTGRP_CODE_EXCEPTION_MESSAGE...
     d                 c                   x'40000000'
     d END_ACTGRP_CODE_ABNORMAL_END...
     d                 c                   x'00008000'
     d END_ACTGRP_CODE_ACTGRP_IS_ENDING...
     d                 c                   x'00004000'
     d END_ACTGRP_CODE_INIT_BY_RCLACTGRP...
     d                 c                   x'00002000'
     d END_ACTGRP_CODE_INIT_BY_JOB_END...
     d                 c                   x'00001000'
     d END_ACTGRP_CODE_INIT_BY_EXIT_VERB...
     d                 c                   x'00000800'
     d END_ACTGRP_CODE_INIT_BY_FUNCTION_CHECK...
     d                 c                   x'00000400'
     d END_ACTGRP_CODE_INIT_BY_OUT_OF_SCOPE_JUMP...
     d                 c                   x'00000200'
      *
     d CEE4RAGE_user_exit...
     d                 pr                         extproc('CEE4RAGE_user_exit')
     d  i_ag_mark                    10u 0 const
     d  i_reason                     10u 0 const
     d  io_result_code...
     d                               10u 0 const
     d  io_user_rc                   10i 0 const
      *
      *  Register Call Stack Entry Termination User Exit Procedure (CEERTX)
     d CEERTX...
     d                 pr                         extproc('CEERTX')
     d  i_procPtr                      *   const  procptr
     d  i_rtxToken                     *   const  options(*omit)
     d  o_fc                         12a          options(*omit)
      *
     d CEERTX_user_exit...
     d                 pr                         extproc('CEERTX_user_exit')
     d  i_rtxToken                     *   const
      *
      *  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
     d CEEUTX...
     d                 pr                         extproc('CEEUTX')
     d  i_procPtr                      *   const  procptr
     d  o_fc                         12a          options(*omit)
      *
      /endif
