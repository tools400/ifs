      /if not defined(CLIB)
      /define CLIB
      *
      *  Basic C data types
      /if not defined(C_DATA_TYPES)
      /define C_DATA_TYPES
      * C Data Types
     d char_t          s              1a   template
     d short_t         s              5i 0 template
     d ushort_t        s              5u 0 template
     d int_t           s             10i 0 template
     d uint_t          s             10u 0 template
     d long_t          s             10i 0 template
     d ulong_t         s             10u 0 template
     d float_t         s              4f   template
     d double_t        s              8f   template
      /endif
      *
      *  stdin, stdout and stderr
     d stdin           s               *   import('_C_IFS_stdin')
     d stdout          s               *   import('_C_IFS_stdout')
     d stderr          s               *   import('_C_IFS_stderr')
      *
      *  system -- Execute a Command
      *     Return value       Meaning
      *     ----------------   --------------------------------------
      *     0                  the command is successful
      *     -1                 for a NULL pointer
      *     1                  the command fails
     d system          pr            10i 0 extproc('system')
     d  i_clCommand                    *   value options(*string)
      *
     d EXCP_MSGID      s              7a   import('_EXCP_MSGID')
      *
      *  time -- Determine Current Time
      *     The time() function returns the current calendar time.
      *     The return value is also stored in the location that
      *     is given by timeptr.
     d time...
     d                 pr            10i 0 extproc('time')
     d  timeptr                        *   value
      *
      *  strftime -- Convert to Formatted Time
      *     strftime() returns the number of bytes placed into the
      *     array pointed to by 'dest'.
     d strftime...
     d                 pr            10i 0 extproc('strftime')
     d  dest                           *   value
     d  maxsize                      10i 0 value
     d  format                         *   value options(*string)
     d  timeptr                            const  likeds(tm_t)
      *
     d tm_t            ds                  qualified  template
     d  tm_sec                       10i 0
     d  tm_min                       10i 0
     d  tm_hour                      10i 0
     d  tm_mday                      10i 0
     d  tm_mon                       10i 0
     d  tm_year                      10i 0
     d  tm_wday                      10i 0
     d  tm_yday                      10i 0
     d  tm_isdst                     10i 0
      *
      *  localtime() -- Correct Local Time, returns tm_t*
      *     The localtime() function converts a time value, in
      *     seconds, to a structure of type tm.
     d localtime...
     d                 pr              *   extproc('localtime')
     d  time                         10i 0 const
      *
      *  localtime_r() -- Correct Local Time
      *     It is the same as localtime() except that it passes
      *     in the place to store the returned structure result.
     d localtime_r...
     d                 pr              *   extproc('localtime_r')
     d  time                         10i 0 const
     d  tm                                 const  likeds(tm_t)
      *
      *  strtok -- Tokenize String
      *     The first time the strtok() function is called, it returns
      *     a pointer to the first token in i_string. In later calls
      *     it returns a pointer to the next token. A null pointer is
      *     returned when there are no more tokens.
     d strtok          pr              *          extproc('strtok')
     d  i_string                       *   value  options(*string)
     d  i_delimiters                   *   value  options(*string)
      *
      *  atoi -- Convert Character String to Integer
      *     The atoi() function returns an int value of the
      *     interpreted input string.
     d atoi            pr            10i 0        extproc('atoi')
     d  i_string                       *   value  options(*string)
      *
      *  memcpy -- Copy Bytes
      *     The behavior is undefined if copying takes place
      *     between objects that overlap.
      *     The memcpy() function returns a pointer to dest.
     d memcpy          pr              *          extproc('memcpy')
     d  i_pDest                        *   value
     d  i_pSrc                         *   value
     d  i_count                      10u 0 value
      *
      *  memset -- Set Bytes to Value
      *     The memset() function returns a pointer to dest.
     d memset          pr              *          extproc('memset')
     d  i_pDest                        *   value
     d  i_char                       10i 0 value
     d  i_count                      10u 0 value
      *
      *  memmove -- Copy Bytes
      *     memmove allows copying between objects that may overlap
      *     as if src is first copied into a temporary array.
      *     The memmove() function returns a pointer to dest.
     d memmove         pr              *          extproc('memmove')
     d  pMemDest                       *   value
     d  pMemSrc                        *   value
     d  memSize                            value like(size_t)
      *
      *  memcmp -- Compare Buffers
      *     Return value       Meaning
      *     ----------------   --------------------------------------
      *     Less than 0        buf1 less than buf2
      *     0                  buf1 identical to buf2
      *     Greater than 0     buf1 greater than buf2
     d memcmp          pr            10i 0        extproc('memcmp')
     d  pBuf1                          *   value
     d  pBuf2                          *   value
     d  count                              value like(size_t)
      *
      *  memicmp -- Compare Bytes (ignore case)
      *     Return value       Meaning
      *     ----------------   --------------------------------------
      *     Less than 0        buf1 less than buf2
      *     0                  buf1 identical to buf2
      *     Greater than 0     buf1 greater than buf2
     d memicmp         pr            10i 0        extproc('__memicmp')
     d  pBuf1                          *   value
     d  pBuf2                          *   value
     d  count                        10u 0 value
      *
      *  strcmp() -- Compare Strings
      *     Return value       Meaning
      *     ----------------   --------------------------------------
      *     Less than 0        string 1 less than string 2
      *     0                  string 1 equivalent to string 2
      *     Greater than 0     string 1 greater than string 2
     d strcmp...
     d                 pr            10i 0
     d                                            extproc('strcmp')
     d  string1                        *   value  options(*string)
     d  string2                        *   value  options(*string)
      *
      *  strcasecmp() -- Compare Strings without Case Sensitivity
      *     Return value       Meaning
      *     ----------------   --------------------------------------
      *     Less than 0        string 1 less than string 2
      *     0                  string 1 equivalent to string 2
      *     Greater than 0     string 1 greater than string 2
     d strcasecmp...
     d                 pr            10i 0
     d                                            extproc('strcasecmp')
     d  string1                        *   value  options(*string)
     d  string2                        *   value  options(*string)
      /if not defined(TESTPTR)
      /define TESTPTR
      *
      *  Test Pointer (TESTPTR)
     d testptr         pr            10i 0 extproc('_TESTPTR')
     d  i_ptr                          *   value
     d  i_test_type                  10i 0 value
      *
     d cTESTPTR_TYPE_PROCPTR...
     d                 c                   0
     d cTESTPTR_NO_OPTIMIZED_PARAMETER_PASSING...
     d                 c                   0
     d cTESTPTR_OPTIMIZED_PARAMETER_PASSING...
     d                 c                   1
      *
     d cTESTPTR_TYPE_MEMPTR...
     d                 c                   1
     d cTESTPTR_NON_TERASPACE...
     d                 c                   0
     d cTESTPTR_TERASPACE...
     d                 c                   1
      *
     d cTESTPTR_ERROR_NOT_EXIST...
     d                 c                   x'2401'
     d cTESTPTR_ERROR_INVALID...
     d                 c                   x'2402'
     d cTESTPTR_ERROR_OBJECT_DESTROYED...
     d                 c                   x'2202'
      /endif
      *
      *  malloc() - Reserve Storage Block
     d TS_malloc...
     d                 pr              *   extproc('_C_TS_malloc')
     d  i_size                       10u 0 value
      *
      *  realloc() - Change Reserved Storage Block Size
     d TS_realloc...
     d                 pr              *   extproc('_C_TS_realloc')
     d  i_pMem                         *   value
     d  i_size                       10u 0 value
      *
      *  free() - Release Storage Blocks
     d TS_free...
     d                 pr                  extproc('_C_TS_free')
     d  i_pMem                         *   value
      *
      *  _C_TS_malloc_info() - Determine amount of teraspace memory used
     d TS_malloc_info...
     d                 pr            10i 0 extproc('_C_TS_malloc_info')
     d  o_c_mallinfo                       const  likeds(C_mallinfo_t)
     d  i_size                       10u 0 value
      *
      *  _C_TS_malloc_debug() - Determine amount of teraspace memory
      *                         used (with optional dumps and verification)
     d TS_malloc_debug...
     d                 pr            10i 0 extproc('_C_TS_malloc_debug')
     d  i_dump_level                 10u 0 value
     d  i_vrfy_level                 10u 0 value
     d  o_c_mallinfo                       const  likeds(C_mallinfo_t)
     d  i_size                       10u 0 value
      *
      * The following are possible values for the dump_level parameter
     d C_NO_DUMPS      c                   0
      *  Dumps the _C_mallinfo_t structure:
     d C_DUMP_TOTALS   c                   1
      *  Does a hex dump of all allocated chunks of teraspace storage,
      *  this is the entire 512K chunk of storage:
     d C_DUMP_CHUNKS   c                   2
      *  Dumps each of the allocated nodes.
      *  There is a node for each malloc performed with the header
      *  associated with that malloc:
     d C_DUMP_NODES    c                   3
      *  Dumps the cartesian tree used to keep track of the freed nodes:
     d C_DUMP_TREE     c                   4
     d C_DUMP_ALL      c                   9999
      *
      *  The following are possible values for the verify_level parameter
     d C_NO_CHECKS     c                   0
     d C_CHECK_TOTALS  c                   1
     d C_CHECK_CHUNKS  c                   2
     d C_CHECK_NODES   c                   3
     d C_CHECK_TREE    c                   4
     d C_CHECK_ALL     c                   9998
      *  Will call abort() if verification fails
     d C_CHECK_ALL_AND_ABORT...
     d                 c                   9999
      *
      * The following structure is used to return information
      * from the _C_TS_malloc_info routine.  The fields are:
      *   total_bytes        - bytes allocated from system
      *                        (high water mark)
      *   allocated_bytes    - number of allocated bytes
      *   unallocated_bytes  - number of unallocated bytes
      *   allocated_blocks   - number of allocated blocks
      *   unallocated_blocks - number of unallocated blocks
      *   requested_bytes    - bytes actually requested from malloc
      *   pad_bytes          - bytes used to pad allocation length
      *                        to a multiple of 16
      *   overhead_bytes     - bytes used for malloc overhead
     d C_mallinfo_t...
     d                 ds                  qualified               template
     d  total_bytes...
     d                               20i 0
     d  allocated_bytes...
     d                               20i 0
     d  unallocated_bytes...
     d                               20i 0
     d  allocated_blocks...
     d                               20i 0
     d  unallocated_blocks...
     d                               20i 0
     d  requested_bytes...
     d                               20i 0
     d  pad_bytes...
     d                               20i 0
     d  overhead_bytes...
     d                               20i 0
      *
      *  malloc -- Reserve Storage Block
     d malloc          pr              *          extproc('malloc')
     d  i_size                       10u 0 value
      *
      *  realloc -- Change Reserved Storage Block Size
     d realloc         pr              *          extproc('realloc')
     d  i_pMem                         *   value
     d  i_size                       10u 0 value
      *
      *  free -- Release Storage Blocks
     d free            pr                         extproc('free')
     d  i_pMem                         *   value
      *
      *  srand -- Set Seed for rand Function   e.g.:   srand(getSeed(*null))
     d srand           pr                         extproc('srand')
     d  i_seed                       10u 0 value
      *
      *  rand -- Generate Random Number                x = rand()
     d rand            pr            10i 0        extproc('rand')
      *
     d RAND_MAX        c                   const(32767)
      *
      *  getSeed -- Get Seed for srand function
     d getSeed         pr            10i 0        extproc('time')
     d  i_timePtr                      *   value
      *
      *  strlen -- Determine String Length
     d strlen...
     d                 pr            10u 0 extproc('strlen')
     d  i_string                       *   value
      *
      *  tmpnam -- Produce Temporary File Name
     d tmpnam          pr              *          extproc('tmpnam')
     d  pTmpNme                        *   value
      *
      *  _C_IFS_tmpnam -- Produce Temporary File Name for the IFS file system
     d ifs_tmpnam      pr              *          extproc('_C_IFS_tmpnam')
     d  fileName                       *   value
      *
     d L_tmpnam        c                   const(39)                            ! <stdio.h>
      *
     d TMP_MAX         c                   const(32767)                         ! <stdio.h>
      *
      *  qsort -- Sort Array
     d qsort           pr              *                       extproc('qsort')
     d  memPtr                         *   value
     d  numElem                            value  like(size_t)
     d  width                              value  like(size_t)
     d  pSortFunc                      *   value  procptr
      *
      *  bsearch -- Search Arrays
     d bsearch         pr              *          extproc('bsearch')
     d  keyPtr                         *   value
     d  memPtr                         *   value
     d  numElem                            value  like(size_t)
     d  width                              value  like(size_t)
     d  pSearchFnc                     *   value  procptr
      *
      *  iconv_open()--Code Conversion Allocation API
     d iconv_open...
     d                 pr                  extproc('iconv_open')
     d                                     like(iconv_t   )
     d  i_toCode                       *   value
     d  i_fromCode                     *   value
      *
     d iconv_t         ds                  qualified   template   align
     d  return_value                 10i 0
     d  cd                           10i 0 dim(12)
      *
     d iconv_fromcode_t...
     d                 ds                  qualified   template
     d  ibmccsid                      8a
     d  ccsid                         5a
     d  convAlt                       3a
     d  substAlt                      1a
     d  shiftStateAlt                 1a
     d  inpLengthOpt                  1a
     d  errOption                     1a
     d  reserved                     12a
      *
     d iconv_tocode_t...
     d                 ds                  qualified   template
     d  ibmccsid                      8a
     d  ccsid                         5a
     d  reserved                     19a
      *
      *  QtqIconvOpen()--Code Conversion Allocation API
     d QtqIconv_open...
     d                 pr                  extproc('QtqIconvOpen')
     d                                     likeds(iconv_t )
     d  i_toCode                           const  likeds(QtqCode_t)
     d  i_fromCode                         const  likeds(QtqCode_t)
      *
     d QtqCode_t...
     d                 ds                  qualified   template
     d  ccsid                        10i 0
     d  conversionA                  10i 0
     d  substitutionA                10i 0
     d  shiftStateA                  10i 0
     d  inpLenOpt                    10i 0
     d  errOptMxdDta                 10i 0
     d  reserved                     12a
      *
      *  iconv()--Code Conversion API
     d iconv...
     d                 pr            10u 0        extproc('iconv')
     d  i_cd                               value likeds(iconv_t  )
     d  i_pInBuf                       *
     d  i_inBytLeft                  10u 0
     d  i_pOutBuf                      *
     d  i_outBytLeft                 10u 0
      *
     d cICONV_ERROR    c                   const(4294967295)
      *
      *  iconv_close()--Code Conversion Deallocation API
     d iconv_close...
     d                 pr            10i 0        extproc('iconv_close')
     d  i_cd                               value likeds(iconv_t  )
      *
      *  0/-1 = stat()--Get File Information                include <sys/stat.h>
     d stat...
     d                 pr            10i 0        extproc('stat')               = int
     d  i_pPath                        *   value options(*string)               = *path
     d  i_pStat                        *   value                                = *buf
      *
      *  0/-1 = fstat()--Get File Information by Descriptor include <sys/stat.h>
     d fstat...
     d                 pr            10i 0        extproc('fstat')              = int
     d  i_fd                         10i 0 value                                = int
     d  i_stat                             const likeds(st_stat_t)              = *buf
      *
      *  0/-1 = lstat()--Get File or Link Information       include <sys/stat.h>
     d lstat...
     d                 pr            10i 0        extproc('lstat')              = int
     d  i_pPath                        *   value options(*string)               = *path
     d  i_pStat                        *   value                                = *buf
      *
     d st_stat_t       ds                  qualified   template   align
     d  mode                         10u 0                                      mode_t =uint
     d  ino                          10u 0                                      ino_t  =uint
     d  nlink                         5u 0                                      nlink_t=ushort
     d  reserved2                     2a
     d  uid                          10u 0                                      uid_t  =uint
     d  gid                          10u 0                                      gid_t  =uint
     d  size                         10i 0                                      off_t  =int
     d  atime                        10i 0                                      time_t =long
     d  mtime                        10i 0                                      time_t =long
     d  ctime                        10i 0                                      time_t =long
     d  dev                          10u 0                                      dev_t  =uint
     d  blksize                      10u 0                                      size_t =uint
     d  allocsize                    10u 0                                      ulong
     d  objtype                      11A                                        qp0l_objtype_t
     d  reserved3                     1a
     d  codepage                      5u 0                                      ushort
     d  ccsid                         5u 0                                      ushort
     d  rdev                         10u 0                                      dev_t  =uint
     d  nlink32                      10u 0                                      nlink32_t=ulng
     d  rdev64                       20U 0                                      dev64_t=ullng
     d  dev64                        20U 0                                      dev64_t=ullng
     d  reserved1                    36A
     d  ino_gen_id                   10u 0                                      uint
      *
      *  Qp0lGetAttr()--Get Attributes
     d Qp0lGetAttr...
     d                 pr            10i 0 extproc('Qp0lGetAttr')
     d  i_path                             const  likeds(Qlg_Path_Name_t)
     d  i_attrArray                        const  like(Qlg_attrArray_t  )
     d  i_pBuffer                      *   value
     d  i_bytPrv                     10u 0 value
     d  o_sizeNeeded                 10u 0
     d  o_bytRet                     10u 0
     d  i_followLnk                  10u 0 value
      *
      /if not defined(Qlg_Path_Name)
      /define Qlg_Path_Name
     d Qlg_Path_Name_t...
     d                 ds                  qualified align         template
     d   CCSID                       10i 0
     d   Country_ID                   2a
     d   Language_ID                  3a
     d   Reserved                     3a
     d   Path_Type                   10u 0
     d   Path_Length                 10i 0
     d   Path_Name_Delimiter...
     d                                2a
     d   Reserved2                   10a
     d   Path_Name                  256a
      *
     d QLG_PATH_JOB_CCSID...
     d                 c                   const(0)
     d QLG_PATH_JOB_COUNTRYID...
     d                 c                   const(X'0000')
     d QLG_PATH_JOB_LANGUAGEID...
     d                 c                   const(X'000000')
      *
      *  The Path_Name is a character string and the delimiter is one byte long.
     d QLG_CHAR_SINGLE...
     d                 c                   const(0)
      *
      *  The Path_Name is a pointer and the delimiter is one byte long.
     d QLG_PTR_SINGLE...
     d                 c                   const(1)
      *
      *  The Path_Name is a character string and the delimiter is two bytes long.
     d QLG_CHAR_DOUBLE...
     d                 c                   const(2)
      *
      *  The Path_Name is a pointer and the delimiter is two bytes long.
     d QLG_PTR_DOUBLE...
     d                 c                   const(3)
      *
      /endif
      *
     d Qlg_attrArray_t...
     d                 ds                  qualified               template
     d  numE                         10i 0
     d  attr                         10i 0 dim(64)
      *
     d Qlg_rtnAttr_t...
     d                 ds                  qualified               template
     d  ofsNextAttr                  10i 0
     d  ID                           10i 0
     d  size                         10i 0
     d  reserved                      4a
      *
     d QP0L_ATTR_OBJTYPE...
     d                 c                   const(0)                             CHAR(10)
     d QP0L_ATTR_DATA_SIZE...
     d                 c                   const(1)                             UINT(4)
     d QP0L_ATTR_ALLOC_SIZE...
     d                 c                   const(2)                             UINT(4)
     d QP0L_ATTR_EXTENDED_ATTR_SIZE...
     d                 c                   const(3)                             UINT(4)
     d QP0L_ATTR_CREATE_TIME...
     d                 c                   const(4)                             UINT(4)
     d QP0L_ATTR_ACCESS_TIME...
     d                 c                   const(5)                             UINT(4)
     d QP0L_ATTR_CHANGE_TIME...
     d                 c                   const(6)                             UINT(4)
     d QP0L_ATTR_MODIFY_TIME...
     d                 c                   const(7)                             UINT(4)
     d QP0L_ATTR_STG_FREE...
     d                 c                   const(8)                             CHAR(1)
     d QP0L_ATTR_CHECKED_OUT...
     d                 c                   const(9)                             chkOut Fmt
     d QP0L_ATTR_LOCAL_REMOTE...
     d                 c                   const(10)                            CHAR(1)
      *
     d QP0L_DONOT_FOLLOW_SYMLNK...
     d                 c                   const(x'00')
     d QP0L_FOLLOW_SYMLNK...
     d                 c                   const(x'01')
      *
     d QP0L_NOT_CHECKED_OUT...
     d                 c                   const(x'00')
     d QP0L_CHECKED_OUT...
     d                 c                   const(x'01')
      *
     d QP0L_LOCAL_OBJ...
     d                 c                   const(x'01')
     d QP0L_REMOTE_OBJ...
     d                 c                   const(x'02')
      *
      *  QlgGetcwd()--Get Current Directory (using NLS-enabled path name)
      *  Returns: Qlg_Path_Name_T
     d QlgGetcwd...
     d                 pr              *   extproc('QlgGetcwd')
     d  o_path                             const  likeds(Qlg_Path_Name_t)
     d  i_size                             value  like(size_t)
      *
      *  getcwd()--Get Current Directory
     d getcwd...
     d                 pr              *   extproc('getcwd')
     d  o_path                    65535a   const  options(*varsize)
     d  i_size                             value  like(size_t)
      *
      *  QlgChdir()--Change Current Directory (using NLS-enabled path name)
      *  Returns: Qlg_Path_Name_T
     d QlgChdir...
     d                 pr            10i 0 extproc('QlgChdir')
     d  i_path                             const  likeds(Qlg_Path_Name_t)
      *
      *  chdir()--Change Current Directory
     d chdir...
     d                 pr            10i 0 extproc('chdir')
     d  i_path                         *   value  options(*string)
      *
      *  QSYSINC/SYS.TYPES
     d off_t           s             10i 0 template
     d size_t          s             10u 0 template
     d ssize_t         s             10i 0 template
     d time_t          s             10i 0 template
      *
      *  0/-1 = chmod()--Change File Authorizations         include <sys/stat.h>
     d chmod...
     d                 pr            10i 0        extproc('chmod')              = int
     d  i_pPath                        *   value  options(*string)              = *path
     d  i_mode                       10u 0 value                                = mode_t =uint
      *
      *  mkdir()--Make Directory                            include <sys/stat.h>
     d mkdir...
     d                 pr            10i 0        extproc('mkdir')              = rc
     d  i_pPath                        *   value options(*string)               = *path
     d  i_mode                       10u 0 value                                = mode_t =uint
      *
      *  rmdir()--Remove Directory                          include <sys/stat.h>
     d rmdir...
     d                 pr            10i 0        extproc('rmdir')              = rc
     d  i_pPath                        *   value options(*string)               = *path
      *
      *  opendir()--Open Directory                          include <dirent.h>
     d opendir...
     d                 pr              *          extproc('opendir')            = *DIR
     d  i_pDirName                     *   value options(*string)               = *dirname
      *
      *  readdir()--Read Directory Entry
     d readdir...
     d                 pr              *          extproc('readdir')            = *dirent
     d  i_dirp                         *   value                                = *DIR
      *
     d dirent_t        ds                  qualified  template
     d   d_reserv1                   16a
     d   d_fileno_gen_id...
     d                               10u 0
     d   d_fileno                    10u 0
     d   d_reclen                    10u 0
     d   d_reserv3                   10i 0
     d   d_reserv4                    8a
      /if not defined(*V5R2M0)
     d   d_nlsinfo                         like(qlg_nls_t)
      /else
     d   d_nlsinfo                         likeds(qlg_nls_t)
      /endif
     d   d_namelen                   10u 0
     d   d_name                     640A
      *
     d qlg_nls_t       ds                  qualified  template    align
     d  ccsid                        10i 0
     d  country_id                    2a
     d  language_id                   3a
     d  nls_reserved                  3a
      *
      *  rewinddir()--Reset Directory Stream to Beginning
     d rewinddir...
     d                 pr                  extproc('rewinddir')
     d  i_dirp                         *   value                                = *DIR
      *
      *  closedir()--Close Directory
     d closedir...
     d                 pr            10i 0        extproc('closedir')           = rc
     d  i_dirp                         *   value                                = *DIR
      *
      *  fd/-1 = open()--Open File                          include <fcntl.h>
     d open...
     d                 pr            10i 0        extproc('open')               = int
     d  i_pPath                        *   value  options(*string)              = *path
     d  i_opnFLag                    10i 0 value                                = int
     d  i_mode                       10u 0 value  options(*nopass)              = uint
     d  i_codePage                   10u 0 value  options(*nopass)              = uint
     d  i_crtCodePage                10u 0 value  options(*nopass)              = uint
      *
      *  <sys/stat.h>
     d S_IRUSR         c                   const(         256)                  ! Read For Own
     d S_IWUSR         c                   const(         128)                  ! Write For Ow
     d S_IXUSR         c                   const(          64)                  ! Exc/Srch For
     d S_IRWXU         c                   const(         448)                  ! Rd/Wrt/Exc O
      *
     d S_IRGRP         c                   const(          32)                  ! Read For Gro
     d S_IWGRP         c                   const(          16)                  ! Write For Gr
     d S_IXGRP         c                   const(           8)                  ! Exc/Srch For
     d S_IRWXG         c                   const(          56)                  ! Rd/Wrt/Exc G
      *
     d S_IROTH         c                   const(           4)                  ! Read For Oth
     d S_IWOTH         c                   const(           2)                  ! Write For Ot
     d S_IXOTH         c                   const(           1)                  ! Exc/Srch For
     d S_IRWXO         c                   const(           7)                  ! Rd/Wrt/Exc O
      *
     d S_ISUID         c                   const(        2048)
     d S_ISGID         c                   const(        1024)
     d S_ISVTX         c                   const(         512)
      *
      *  <h/fcntl.h>
     d O_CREAT         c                   const( 8)                            ! Append Mode
     d O_EXCL          c                   const(16)                            ! Exclusive Us
     d O_TRUNC         c                   const(64)                            ! Truncate Fla
      *
     d O_APPEND        c                   const(256)                           ! Append Mode
      *
     d O_CODEPAGE      c                   const(  8388608)                     ! Codepage Fla
     d O_TEXTDATA      c                   const( 16777216)                     ! Text Data Fl
     d O_FORCE_SCAN    c                   const( 67108864)                     ! Force scan
     d O_INHERITMODE   c                   const(134217728)                     ! Inherit Mode
     d O_CCSID         c                   const(       32)                     ! CCSID
     d O_TEXT_CREAT    c                   const( 33554432)                     !
      *
     d O_SHARE_RDONLY  c                   const( 65536)                        ! Shared Read
     d O_SHARE_WRONLY  c                   const(131072)                        ! Shared Write
     d O_SHARE_RDWR    c                   const(262144)                        ! Shared Rd/Wr
     d O_SHARE_NONE    c                   const(524288)                        ! No Share
      *
     d O_RDONLY        c                   const(1)                             ! Read Only
     d O_WRONLY        c                   const(2)                             ! Write Only
     d O_RDWR          c                   const(4)                             ! Read/Write
      *
      *  value/-1 = read()--Write from Descriptor           include <unistd.h>
     d read...
     d                 pr                  extproc('read')   like(ssize_t   )   = ssize_t
     d  i_fd                         10i 0 value                                = int
     d  i_pBuffer                      *   value                                = *buf
     d  i_buflen                           value like(size_t    )               = size_t
      *
      *  value/-1 = write()--Write to Descriptor            include <unistd.h>
     d write...
     d                 pr                  extproc('write')  like(ssize_t   )   = ssize_t
     d  i_fd                         10i 0 value                                = int
     d  i_pBuffer                      *   value                                = *buf
     d  i_buflen                           value like(size_t    )               = size_t
      *
      *  0/-1 = ftruncate()--Truncate File                  include <unistd.h>
     d ftruncate...
     d                 pr            10i 0 extproc('ftruncate')                 = int
     d  i_fd                         10i 0 value                                = int
     d  i_length                           value like(off_t     )               = off_t
      *
      *  off_t = lseek()--Set File Read/Write Offset        include <unistd.h>
     d lseek...
     d                 pr                  extproc('lseek')  like(off_t     )   = off_t
     d  i_fd                         10i 0 value                                = int
     d  i_offset                           value like(off_t     )               = off_t
     d  i_whence                     10i 0 value                                = int
      *
      *  <h/unistd.h>
     d SEEK_SET        c                   const(0)                             ! seek start
     d SEEK_CUR        c                   const(1)                             ! seek curPos
     d SEEK_END        c                   const(2)                             ! seek end
      *
      *  0/-1 = unlink()--Remove Link to File               include <unistd.h>
     d unlink...
     d                 pr            10i 0 extproc('unlink')                    = int
     d  i_pPath                        *   value options(*string)               = *path
      *
      *  0/-1 = Qp0lRenameKeep()--Rename File or Directory, Keep "new" If It Exists
     d Qp0lRenameKeep...
     d                 pr            10i 0 extproc('Qp0lRenameKeep')            = int
     d  i_pOldPath                     *   value options(*string)               = *path
     d  i_pNewPath                     *   value options(*string)               = *path
      *
      *  0/-1 = Qp0lRenameUnlink()--Rename File or Directory, Unlink "new" If It Exists
     d Qp0lRenameUnlink...
     d                 pr            10i 0 extproc('Qp0lRenameUnlink')          = int
     d  i_pOldPath                     *   value options(*string)               = *path
     d  i_pNewPath                     *   value options(*string)               = *path
      *
      *  0/-1 = close()--Close File or Socket Descriptor    include <unistd.h>
      /if not defined(c_close_function)
      /define c_close_function
     d close...
     d                 pr            10i 0 extproc('close')                     = int
     d  i_fd                         10i 0 value                                = int
      /endif
      *
      *  erno--Set Pointer to Runtime Error Code
     d errno           pr              *                     extproc('__errno')
      *
      *  strerror -- Set Pointer to Runtime Error Message
     d strerror        pr              *                     extproc('strerror')
     d  errno                        10i 0 value
      *
      *  <sys/errno.h>
     d EDOM_C          c                   const(3001)                          domain error i
     d ERANGE_C        c                   const(3002)                          range error in
     d ETRUNC_C        c                   const(3003)                          truncation on
     d ENOTOPEN_C      c                   const(3004)                          file has not b
     d ENOTREAD_C      c                   const(3005)                          file not opene
     d ERECIO_C        c                   const(3008)                          file opened fo
     d ENOTWRITE_C     c                   const(3009)                          file not opene
     d ESTDIN_C        c                   const(3010)                          stdin cannot b
     d ESTDOUT_C       c                   const(3011)                          stdout cannot
     d ESTDERR_C       c                   const(3012)                          stderr cannot
     d EBADSEEK_C      c                   const(3013)                          bad offset to
     d EBADNAME_C      c                   const(3014)                          invalid file n
     d EBADMODE_C      c                   const(3015)                          invalid file m
     d EBADPOS_C       c                   const(3017)                          invalid positi
     d ENOPOS_C        c                   const(3018)                          no record at s
     d ENUMMBRS_C      c                   const(3019)                          no ftell if mo
     d ENUMRECS_C      c                   const(3020)                          no ftell if to
     d EBADFUNC_C      c                   const(3022)                          invalid functi
     d ENOREC_C        c                   const(3026)                          record not fou
     d EBADDATA_C      c                   const(3028)                          message data i
     d EBADOPT_C       c                   const(3040)                          bad option on
     d ENOTUPD_C       c                   const(3041)                          file not opene
     d ENOTDLT_C       c                   const(3042)                          file not opene
     d EPAD_C          c                   const(3043)                          padding occurr
     d EBADKEYLN_C     c                   const(3044)                          bad key length
     d EPUTANDGET_C    c                   const(3080)                          illegal write
     d EGETANDPUT_C    c                   const(3081)                          illegal read a
     d EIOERROR_C      c                   const(3101)                          I/O exception
     d EIORECERR_C     c                   const(3102)                          I/O exception
      *
      *  The following values are defined by POSIX ISO/IEC 9945-1:1990.
     d EINVAL_C        c                   const(3021)                          invalid argume
     d EIO_C           c                   const(3006)                          input/output e
     d ENODEV_C        c                   const(3007)                          no such device
     d EBUSY_C         c                   const(3029)                          resource busy
     d ENOENT_C        c                   const(3025)                          no such file o
     d EPERM_C         c                   const(3027)                          operation not
      *
      *  AS/400 specific error numbers
     d EACCES_C        c                   const(3401)                          Permission den
     d ENOTDIR_C       c                   const(3403)                          Not a director
     d ENOSPC_C        c                   const(3404)                          No space avail
     d EXDEV_C         c                   const(3405)                          Improper link.
     d EWOULDBLOCK_C   c                   const(3406)                          Operation woul
     d EAGAIN_C        c                   const(3406)                          Operation woul
     d EINTR_C         c                   const(3407)                          Interrupted fu
     d EFAULT_C        c                   const(3408)                          The address us
     d ETIME_C         c                   const(3409)                          Operation time
     d ENXIO_C         c                   const(3415)                          No such device
     d ECLOSED_C       c                   const(3417)                          Socket closed
     d EADDRINUSE_C    c                   const(3420)                          Address alread
     d EADDRNOTAVAIL_C...
     d                 c                   const(3421)                          Address not av
     d EAFNOSUPPORT_C  c                   const(3422)                          The type of so
     d EALREADY_C      c                   const(3423)                          Operation alre
     d ECONNABORTED_C  c                   const(3424)                          Connection end
     d ECONNREFUSED_C  c                   const(3425)                          A remote host
     d ECONNRESET_C    c                   const(3426)                          A connection w
     d EDESTADDRREQ_C  c                   const(3427)                          Operation requ
     d EHOSTDOWN_C     c                   const(3428)                          A remote host
     d EHOSTUNREACH_C  c                   const(3429)                          A route to the
     d EINPROGRESS_C   c                   const(3430)                          Operation in p
     d EISCONN_C       c                   const(3431)                          A connection h
     d EMSGSIZE_C      c                   const(3432)                          Message size o
     d ENETDOWN_C      c                   const(3433)                          The network is
     d ENETRESET_C     c                   const(3434)                          A socket is co
     d ENETUNREACH_C   c                   const(3435)                          Cannot reach t
     d ENOBUFS_C       c                   const(3436)                          There is not e
     d ENOPROTOOPT_C   c                   const(3437)                          The protocol d
     d ENOTCONN_C      c                   const(3438)                          Requested oper
     d ENOTSOCK_C      c                   const(3439)                          The specified
     d ENOTSUP_C       c                   const(3440)                          Operation not
     d EOPNOTSUPP_C    c                   const(3440)                          Operation not
     d EPFNOSUPPORT_C  c                   const(3441)                          The socket pro
     d EPROTONOSUPPORT_C...
     d                 c                   const(3442)                          No protocol of
     d EPROTOTYPE_C    c                   const(3443)                          The socket typ
     d ERCVDERR_C      c                   const(3444)                          An error indic
     d ESHUTDOWN_C     c                   const(3445)                          Cannot send da
     d ESOCKTNOSUPPORT_C...
     d                 c                   const(3446)                          The specified
     d ETIMEDOUT_C     c                   const(3447)                          A remote host
     d EUNATCH_C       c                   const(3448)                          The protocol r
     d EBADF_C         c                   const(3450)                          Descriptor not
     d EMFILE_C        c                   const(3452)                          Too many open
     d ENFILE_C        c                   const(3453)                          Too many open
     d EPIPE_C         c                   const(3455)                          Broken pipe.
     d EEXIST_C        c                   const(3457)                          File exists.
     d EDEADLK_C       c                   const(3459)                          Resource deadl
     d ENOMEM_C        c                   const(3460)                          Storage alloca
     d EOWNERTERM_C    c                   const(3462)                          The mutex no l
     d EDESTROYED_C    c                   const(3463)                          he synchroniza
     d ETERM_C         c                   const(3464)                          Operation term
     d EMLINK_C        c                   const(3468)                          Maximum link c
     d ESPIPE_C        c                   const(3469)                          Seek request n
     d ENOSYS_C        c                   const(3470)                          Function not i
     d EISDIR_C        c                   const(3471)                          Specified targ
     d EROFS_C         c                   const(3472)                          Read-only file
     d EUNKNOWN_C      c                   const(3474)                          Unknown system
     d EITERBAD_C      c                   const(3475)                          Iterator is in
     d EDAMAGE_C       c                   const(3484)                          A damaged obje
     d ELOOP_C         c                   const(3485)                          A loop exists
     d ENAMETOOLONG_C  c                   const(3486)                          A path name is
     d ENOLCK_C        c                   const(3487)                          No locks avail
     d ENOTEMPTY_C     c                   const(3488)                          Directory not
     d ENOSYSRSC_C     c                   const(3489)                          System resourc
     d ECONVERT_C      c                   const(3490)                          Conversion err
     d E2BIG_C         c                   const(3491)                          Argument list
     d EILSEQ_C        c                   const(3492)                          Conversion sto
     d ESOFTDAMAGE_C   c                   const(3497)                          Object has sof
     d ENOTENROLL_C    c                   const(3498)                          User not enrol
     d EOFFLINE_C      c                   const(3499)                          Object is susp
     d EROOBJ_C        c                   const(3500)                          Object is a re
     d ELOCKED_C       c                   const(3506)                          Area being rea
     d EFBIG_C         c                   const(3507)                          Object too lar
     d EIDRM_C         c                   const(3509)                          The semaphore,
     d ENOMSG_C        c                   const(3510)                          The queue does
     d EFILECVT_C      c                   const(3511)                          File ID conver
     d EBADFID_C       c                   const(3512)                          A File ID coul
     d ESTALE_C        c                   const(3513)                          A File ID coul
     d ESRCH_C         c                   const(3515)                          No such proces
     d ENOTSIGINIT_C   c                   const(3516)                          Process not en
     d ECHILD_C        c                   const(3517)                          No child proce
     d EBADH_C         c                   const(3520)                          Handle is not
     d ETOOMANYREFS_C  c                   const(3523)                          The operation
     d ENOTSAFE_C      c                   const(3524)                          Function not a
     d EOVERFLOW_C     c                   const(3525)                          Object is too
     d EJRNDAMAGE_C    c                   CONST(3526)                          Journal damage
     d EJRNINACTIVE_C  c                   CONST(3527)                          Journal inacti
     d EJRNRCVSPC_C    c                   CONST(3528)                          Journal space
     d EJRNRMT_C       c                   CONST(3529)                          Journal is rem
     d ENEWJRNRCV_C    c                   CONST(3530)                          New journal re
     d ENEWJRN_C       c                   CONST(3531)                          New journal is
     d EJOURNALED_C    c                   CONST(3532)                          Object already
     d EJRNENTTOOLONG_C...
     d                 c                   CONST(3533)                          Entry too larg
     d EDATALINK_C     c                   CONST(3534)                          Object is a Da
     d ENOTAVAIL_C     c                   CONST(3535)                          Independent AS
     d ENOTTY_C        c                   CONST(3536)                          Inappropriate
     d EFBIG2_C        c                   CONST(3540)                          Write or trunc
     d ETXTBSY_C       c                   CONST(3543)                          Text file busy
     d EASPGRPNOTSET_C...
     d                 c                   CONST(3544)                          ASP group not
     d ERESTART_C      c                   CONST(3545)                          System call ca
     d ESCANFAILURE_C  c                   CONST(3546)                          Object marked
      *
      *  Unix return codes
     d RC_OK           c                   const(0)
     d RC_ERROR        c                   const(-1)
      *
      *  Convert External Form to Numeric Value (CVTEFN)
     d cvtefnd...
     d                 pr             8f   extproc('cvtefnd')
     d  i_source                       *   value
     d  i_len                        10u 0 value
     d  i_mask                         *   value
      *
      *  Test Bit in String (TSTBTS)
     d tstbts...
     d                 pr            10i 0 extproc('tstbts')
     d  bit_string                     *   value
     d  bit_offset                   10i 0 value
      *
      *  getenv()--Get Value of Environment Variable
     d getenv...
     d                 pr              *   extproc('getenv')
     d  name                           *   value  options(*string)
      *
      *  putenv()--Change or Add Environment Variable
     d putenv...
     d                 pr            10i 0 extproc('putenv')
     d  string                         *   value  options(*string)
      *
      *  Qp0zDltEnv()--Delete an Environment Variable
     d Qp0zDltEnv...
     d                 pr            10i 0 extproc('Qp0zDltEnv')
     d  name                           *   value  options(*string)
      *
      *  Qp0zInitEnv()--Initialize Environment for Variables
     d Qp0zInitEnv...
     d                 pr            10i 0 extproc('Qp0zInitEnv')
      *
     d ENVIRON         s               *   import('environ')
      *
      *  Generate Universal Unique Identifier (GENUUID)
     d genUUID...
     d                 pr                  extproc('_GENUUID')
     d  uuid_template                  *   value
      *
     d uuid_template_t...
     d                 ds                  qualified  template
     d  bytPrv                       10u 0
     d  bytAvl                       10u 0
     d  reserved                      8a
     d  uuid                         16a
      *
      *  Convert Hex to Character (CVTHC)
     d cvthc...
     d                 pr                  extproc('cvthc')
     d  pResult                        *   value
     d  pSource                        *   value
     d  sourceSize                   10i 0 value
      *
      *  Convert Eight Bit Character to Hex Nibbles (CVTCH)
     d cvtch...
     d                 pr                  extproc('cvtch')
     d  pResult                        *   value
     d  pSource                        *   value
     d  sourceLen                    10i 0 value
      *
      *  Cipher (CIPHER)
     d cipher...
     d                 pr                  extproc('_CIPHER')
     d                                 *   const
     d                                 *   value
     d                                 *   const
      *
     d cipherCtrls_t   ds                  qualified  template  align
     d  function               1      2a
     d  hashAlg                3      3a
     d  sequence               4      4a
     d  dataLength             5      8u 0
     d  output                 9      9a
     d  reserved_1            10     16a
     d  hashContext           17     32*
     d  HMACKey               33     48*
     d  HMACKeyLength         49     52u 0
     d  reserved_2            53     96a
      *
     d cCIPHER_MD5...
     d                 c                   const(x'00')
     d cCIPHER_SHA1...
     d                 c                   const(x'01')
      *
     d cCIPHER_ONLY...
     d                 c                   const(x'00')
     d cCIPHER_FIRST...
     d                 c                   const(x'01')
     d cCIPHER_MIDDLE...
     d                 c                   const(x'02')
     d cCIPHER_FINAL...
     d                 c                   const(x'03')
      *
     d cCIPHER_HASH...
     d                 c                   const(x'00')
     d cCIPHER_HMAC...
     d                 c                   const(x'01')
      *
      /endif
