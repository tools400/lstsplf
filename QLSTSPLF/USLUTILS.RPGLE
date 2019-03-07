       //=====================================================================*
       //  Author  :  Thomas Raddatz                                          *
       //  Date    :  16.09.2002                                              *
       //  E-mail  :  thomas.raddatz@tools400.de                              *
       //  Homepage:  www.tools400.de                                         *
       //=====================================================================*
       //                                                                     *
       //  This software is free software, you can redistribute it and/or     *
       //  modify it under the terms of the GNU General Public License (GPL)  *
       //  as published by the Free Software Foundation.                      *
       //                                                                     *
       //  See GNU General Public License for details.                        *
       //          http://www.opensource.org                                  *
       //          http://www.opensource.org/licenses/gpl-license.html        *
       //                                                                     *
       //=====================================================================*
       //  History:                                                           *
       //                                                                     *
       //  Datum       Name          Änderung                                 *
       //  ----------  ------------  ---------------------------------------  *
       //  05.03.2019  Th.Raddatz    Initial version.                         *
       //                                                                     *
       //=====================================================================*
       //   >>PRE-COMPILER<<                                                  *
       //     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
       //                              SRCFILE(&SL/&SF) SRCMBR(&SM);          *
       //     >>IMPORTANT<<                                                   *
       //       >>PARM<< TRUNCNBR(*NO);                                       *
       //       >>PARM<< DBGVIEW(*LIST);                                      *
       //       >>PARM<< OPTION(*EVENTF);                                     *
       //       >>PARM<< TGTRLS(V7R1M0);                                      *
       //     >>END-IMPORTANT<<                                               *
       //     >>EXECUTE<<                                                     *
       //   >>END-PRE-COMPILER<<                                              *
       //=====================================================================*
     H NOMAIN
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H EXTBININT(*YES) BNDDIR('QC2LE')
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)
     H COPYRIGHT('V1.0 - 05.03.2019 - mailto: thomas.raddatz@tools400.de')

     FQSYSPRT   O    F   80        printer usropn oflind(*in70)

      /copy qlstsplf,puslutils                    Utility for IBM QUSL* List APIs
      /copy qlstsplf,fdboolean                    Boolean Constants
      /copy qlstsplf,fdqobj                       Qualified Object Name
      /copy qlstsplf,genlsthdr                    Generic list API header

      // tmpnam -- Produce Temporary File Name
     D tmpnam          PR              *   extproc('tmpnam')
     D  io_pTmpName                    *   value

     D L_TMPNAM        C                   const(39)                            ! <stdio.h>

      // strtok -- Tokenize String
     D strtok          PR              *   extproc('strtok')
     D  i_string                       *   value options(*string)
     D  i_token                        *   value options(*string)

      // memcpy -- Copy Bytes
     D memcpy          PR                  extproc('memcpy')
     D  i_dest                         *   value
     D  i_src                          *   value
     D  i_count                      10I 0 value

      // Create User Space (QUSCRTUS) API
     d QUSCRTUS...
     d                 pr                  extpgm('QUSCRTUS')
     d  i_qUsrSpc                    20A   const
     d  i_extAttr                    10a   const
     d  i_initSize                   10i 0 const
     d  i_initValue                   1a   const
     d  i_pubAuth                    10a   const
     d  i_text                       50A   const
     d  i_replace                    10a   const options(*nopass)               | optGrp 1
     d  io_ErrCode                65535a         options(*nopass: *varsize)     |
     d  i_domain                     10a   const options(*nopass)               | optGrp 2
     d  i_tfrSizeReq                 10i 0 const options(*nopass)               | optGrp 3
     d  i_optSpcAlgn                  1a   const options(*nopass)               | optGrp 3

      // Retrieve Pointer to User Space (QUSPTRUS) API
     d QUSPTRUS...
     d                 pr                  extpgm('QUSPTRUS')
     d  i_qUsrSpc                    20A   const
     d  o_pUsrSpc                      *
     d  io_ErrCode                65535a         options(*nopass: *varsize)     | optGrp 1

      // Delete User Space (QUSDLTUS) API
     d QUSDLTUS...
     d                 pr                  extpgm('QUSDLTUS')
     d  i_qUsrSpc                    20A   const
     d  io_ErrCode                65535a         options(*varsize)

       //==================================================================*
       //  Creates a user space.
       //  Returns TRUE on success, else FALSE.
       //==================================================================*
     P Utils_crtUsrSpc...
     P                 B                   export
     D                 PI              N
     D  i_qUsrSpc                          value  likeds(qObj_t)
     D  i_text                       50A   value
     D  o_errCode                                 likeds(errCode_t )

     D isSuccess       S               N   inz(FALSE)

     D errCode         DS                  likeds(errCode_t) inz
      /free

       errCode = Utils_newApiErrCode(TRUE);

       QUSCRTUS(
          i_qUsrSpc: 'TEMP': 65536: x'00': '*USE': i_text: '*NO': errCode);

       isSuccess = not Utils_isApiError(errCode);
       o_errCode = errCode;

       return isSuccess;

      /end-free
     P                 E

       //==================================================================*
       //  Creates the pointer of the data of a given user space.
       //==================================================================*
     P Utils_getPtrUsrSpc...
     P                 B                   export
     D                 PI              *
     D  i_qUsrSpc                          value  likeds(qObj_t)
     D  o_errCode                                 likeds(errCode_t)

     D pUsrSpc         S               *

     D errCode         DS                  likeds(errCode_t) inz
      /free

       errCode = Utils_newApiErrCode(TRUE);

       QUSPTRUS(i_qUsrSpc: pUsrSpc: errCode);

       if (Utils_isApiError(errCode));
          pUsrSpc = *null;
       endif;

       o_errCode = errCode;

       return pUsrSpc;

      /end-free
     P                 E

       //==================================================================*
       //  Deletes a given user space by name.
       //  Returns TRUE on success, else FALSE.
       //==================================================================*
     P Utils_dltUsrSpc...
     P                 B                   export
     D                 PI              N
     D  i_qUsrSpc                          value  likeds(qObj_t)

     D isSuccess       S               N   inz(FALSE)

     D errCode         DS                  likeds(errCode_t) inz
      /free

       errCode = Utils_newApiErrCode(TRUE);

       QUSDLTUS(i_qUsrSpc: errCode);

       isSuccess = not Utils_isApiError(errCode);

       return isSuccess;

      /end-free
     P                 E

       //==================================================================*
       //  Gets a temporary object name
       //  Returns TRUE on success, else FALSE.
       //==================================================================*
     P Utils_getTmpName...
     P                 B                   export
     D                 PI              N
     D  o_qUsrSpc                                 likeds(qObj_t)

     D isSuccess       S               N   inz(FALSE)

     D tmpName         S              1A   dim(L_TMPNAM)
     D                                     based(pTmpName)
      /free

       pTmpName = tmpnam(%addr(tmpName));
       if (pTmpName <> *NULL);
          o_qUsrSpc.lib  = %str(strtok(pTmpName:'/'));
          o_qUsrSpc.name = %str(strtok(*NULL   :'/'));
          isSuccess = TRUE;
       else;
          o_qUsrSpc.lib  = '';
          o_qUsrSpc.name = '';
          isSuccess = FALSE;
       endif;

       return isSuccess;

      /end-free
     P                 E

       //==================================================================*
       //  Get Entry
       //==================================================================*
     P Utils_getListEntry...
     P                 B                   export
     D                 PI              N
     D  i_pUsrSpc                      *   const
     D  i_index                      10I 0 const
     D  i_length                     10I 0 const
     D  o_data                    32767A          options(*varsize)

     D isSuccess       S               N   inz(FALSE)

     D genLstHdr       DS                  likeds(genLstHdr_t)
     D                                     based(i_pUsrSpc)
     D pDest           S               *   inz
     D pSrc            S               *   inz
     D count           S             10I 0 inz
      /free

       if (genLstHdr.numE > 0 and i_index < genLstHdr.numE);

          pDest = %addr(o_data);
          pSrc  = %addr(genLstHdr) + genLstHdr.ofsLstSct
                        + (i_index * genLstHdr.sizeE);

          if (i_length < genLstHdr.sizeE);
             count = i_length;
          else;
             count = genLstHdr.sizeE;
          endif;

          memcpy(pDest: pSrc: count);
          isSuccess = TRUE;
       else;
          isSuccess = FALSE;
       endif;

       return isSuccess;

      /end-free
     P                 E

       //==================================================================*
       //  Checks a given API error code for an error condition.
       //  Returns TRUE if the API reported an error, else FALSE.
       //==================================================================*
     P Utils_isApiError...
     P                 B                   export
     D                 PI              N
     D  i_errCode                          value  likeds(errCode_t )

     D isError         S               N   inz(FALSE)
      /free

       if (i_errCode.bytAvl = 0);
          isError = FALSE;
       else;
          isError = TRUE;
       endif;

       return isError;

      /end-free
     P                 E

       //==================================================================*
       //  Creates an API error code.
       //==================================================================*
     P Utils_newApiErrCode...
     P                 B                   export
     D                 PI                         likeds(errCode_t )
     D  i_monmsg                       N   value

     D errCode         DS                  likeds(errCode_t)
      /free

       Clear errCode;

       if (i_monMsg);
          errCode.bytPrv = %size(errCode);
       else;
          errCode.bytPrv = 0;
       endif;

       return errCode;

      /end-free
     P                 E

       //==================================================================*
       //  Converts an API error code to the related CPF message.
       //==================================================================*
     P Utils_cvtApiErrCodeToMsg...
     P                 B                   export
     D                 PI                         likeds(msg_t     )
     D  i_errCode                          value  likeds(errCode_t )

     D errorMsg        DS                  likeds(msg_t) inz
      /free

       if (i_errCode.bytAvl = 0);
          Clear errorMsg;
       else;
          Clear errorMsg;
          errorMsg.ID = i_errCode.excID;
          errorMsg.data = i_errCode.excDta;
          errorMsg.type = '*ESCAPE';
          errorMsg.file = 'QCPFMSG';
          errorMsg.lib = 'QSYS';
       endif;

       return errorMsg;

      /end-free
     P                 E

       //==================================================================*
       //  Opens the output log.
       //==================================================================*
     P Utils_openPrinter...
     P                 B                   export
     D                 PI
      /free

       if (not %open(QSYSPRT));
          open QSYSPRT;
       endif;

      /end-free
     P                 E

       //==================================================================*
       //  Appends a line to the output log.
       //==================================================================*
     P Utils_print...
     P                 B                   export
     D                 PI
     D  i_text                       80A   const varying options(*nopass)

     D lineOutput      DS            80    inz
      /free

       if (%parms() >= %parmnum(i_text));
          lineOutput = i_text;
       else;
          lineOutput = '';
       endif;

       write QSYSPRT lineOutput;

      /end-free
     P                 E

       //==================================================================*
       //  Closes the output log.
       //==================================================================*
     P Utils_closePrinter...
     P                 B                   export
     D                 PI
      /free

       if (%open(QSYSPRT));
          close QSYSPRT;
       endif;

      /end-free
     P                 E

