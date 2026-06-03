**free
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
//  Datum       Name          nderung                                 *
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
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-IMPORTANT<<                                               *
//     >>EXECUTE<<                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain;
ctl-opt option(*srcstmt: *nodebugio);
ctl-opt extbinint(*yes) bnddir('QC2LE');
ctl-opt datfmt(*iso) timfmt(*iso) debug(*yes);
ctl-opt copyright('V1.0 - 05.03.2019 - mailto: thomas.raddatz@tools400.de');

dcl-f QSYSPRT printer(80) usage(*output) usropn oflind(*in70);

/copy qlstsplf,puslutils Utility for IBM QUSL* List APIs
/copy qlstsplf,fdboolean Boolean Constants
/copy qlstsplf,fdqobj qualified object Name
/copy qlstsplf,genlsthdr Generic list API header

// tmpnam -- Produce Temporary File Name
dcl-pr tmpnam pointer extproc('tmpnam');
  io_pTmpName pointer value;
end-pr;

dcl-c L_TMPNAM 39; // ! <stdio.h>

// strtok -- Tokenize String
dcl-pr strtok pointer extproc('strtok');
  i_string pointer options(*string) value;
  i_token  pointer options(*string) value;
end-pr;

// memcpy -- Copy Bytes
dcl-pr memcpy extproc('memcpy');
  i_dest  pointer value;
  i_src   pointer value;
  i_count int(10) value;
end-pr;

// Create User Space (QUSCRTUS) API
dcl-pr QUSCRTUS extpgm('QUSCRTUS');
  i_qUsrSpc    char(20) const;
  i_extAttr    char(10) const;
  i_initSize   int(10) const;
  i_initValue  char(1) const;
  i_pubAuth    char(10) const;
  i_text       char(50) const;
  i_replace    char(10) options(*nopass) const; // | optGrp 1
  io_ErrCode   char(65535) options(*nopass: *varsize); // |
  i_domain     char(10) options(*nopass) const; // | optGrp 2
  i_tfrSizeReq int(10) options(*nopass) const; // | optGrp 3
  i_optSpcAlgn char(1) options(*nopass) const; // | optGrp 3
end-pr;

// Retrieve Pointer to User Space (QUSPTRUS) API
dcl-pr QUSPTRUS extpgm('QUSPTRUS');
  i_qUsrSpc  char(20) const;
  o_pUsrSpc  pointer;
  io_ErrCode char(65535) options(*nopass: *varsize); // | optGrp 1
end-pr;

// Delete User Space (QUSDLTUS) API
dcl-pr QUSDLTUS extpgm('QUSDLTUS');
  i_qUsrSpc  char(20) const;
  io_ErrCode char(65535) options(*varsize);
end-pr;

//==================================================================*
//  Creates a user space.
//  Returns TRUE on success, else FALSE.
//==================================================================*
dcl-proc Utils_crtUsrSpc export;
  dcl-pi *n ind;
    i_qUsrSpc likeds(qObj_t) value;
    i_text    char(50) value;
    o_errCode likeds(errCode_t);
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds errCode likeds(errCode_t) inz;

  errCode = Utils_newApiErrCode(TRUE);

  QUSCRTUS(
     i_qUsrSpc: 'TEMP': 65536: x'00': '*USE': i_text: '*NO': errCode);

  isSuccess = not Utils_isApiError(errCode);
  o_errCode = errCode;

  return isSuccess;

end-proc;

//==================================================================*
//  Creates the pointer of the data of a given user space.
//==================================================================*
dcl-proc Utils_getPtrUsrSpc export;
  dcl-pi *n pointer;
    i_qUsrSpc likeds(qObj_t) value;
    o_errCode likeds(errCode_t);
  end-pi;

  dcl-s pUsrSpc pointer;

  dcl-ds errCode likeds(errCode_t) inz;

  errCode = Utils_newApiErrCode(TRUE);

  QUSPTRUS(i_qUsrSpc: pUsrSpc: errCode);

  if (Utils_isApiError(errCode));
    pUsrSpc = *null;
  endif;

  o_errCode = errCode;

  return pUsrSpc;

end-proc;

//==================================================================*
//  Deletes a given user space by name.
//  Returns TRUE on success, else FALSE.
//==================================================================*
dcl-proc Utils_dltUsrSpc export;
  dcl-pi *n ind;
    i_qUsrSpc likeds(qObj_t) value;
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds errCode likeds(errCode_t) inz;

  errCode = Utils_newApiErrCode(TRUE);

  QUSDLTUS(i_qUsrSpc: errCode);

  isSuccess = not Utils_isApiError(errCode);

  return isSuccess;

end-proc;

//==================================================================*
//  Gets a temporary object name
//  Returns TRUE on success, else FALSE.
//==================================================================*
dcl-proc Utils_getTmpName export;
  dcl-pi *n ind;
    o_qUsrSpc likeds(qObj_t);
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-s tmpName char(1) dim(L_TMPNAM) based(pTmpName);

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

end-proc;

//==================================================================*
//  Get Entry
//==================================================================*
dcl-proc Utils_getListEntry export;
  dcl-pi *n ind;
    i_pUsrSpc pointer const;
    i_index   int(10) const;
    i_length  int(10) const;
    o_data    char(32767) options(*varsize);
  end-pi;

  dcl-s isSuccess ind inz(FALSE);

  dcl-ds genLstHdr likeds(genLstHdr_t) based(i_pUsrSpc);
  dcl-s pDest pointer inz;
  dcl-s pSrc pointer inz;
  dcl-s count int(10) inz;

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

end-proc;

//==================================================================*
//  Checks a given API error code for an error condition.
//  Returns TRUE if the API reported an error, else FALSE.
//==================================================================*
dcl-proc Utils_isApiError export;
  dcl-pi *n ind;
    i_errCode likeds(errCode_t) value;
  end-pi;

  dcl-s isError ind inz(FALSE);

  if (i_errCode.bytAvl = 0);
    isError = FALSE;
  else;
    isError = TRUE;
  endif;

  return isError;

end-proc;

//==================================================================*
//  Creates an API error code.
//==================================================================*
dcl-proc Utils_newApiErrCode export;
  dcl-pi *n likeds(errCode_t);
    i_monmsg ind value;
  end-pi;

  dcl-ds errCode likeds(errCode_t);

  Clear errCode;

  if (i_monMsg);
    errCode.bytPrv = %size(errCode);
  else;
    errCode.bytPrv = 0;
  endif;

  return errCode;

end-proc;

//==================================================================*
//  Converts an API error code to the related CPF message.
//==================================================================*
dcl-proc Utils_cvtApiErrCodeToMsg export;
  dcl-pi *n likeds(msg_t);
    i_errCode likeds(errCode_t) value;
  end-pi;

  dcl-ds errorMsg likeds(msg_t) inz;

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

end-proc;

//==================================================================*
//  Opens the output log.
//==================================================================*
dcl-proc Utils_openPrinter export;
  dcl-pi *n;
  end-pi;

  if (not %open(QSYSPRT));
    open QSYSPRT;
  endif;

end-proc;

//==================================================================*
//  Appends a line to the output log.
//==================================================================*
dcl-proc Utils_print export;
  dcl-pi *n;
    i_text varchar(80) options(*nopass) const;
  end-pi;

  dcl-ds lineOutput len(80) inz;
  end-ds;

  if (%parms() >= %parmnum(i_text));
    lineOutput = i_text;
  else;
    lineOutput = '';
  endif;

  write QSYSPRT lineOutput;

end-proc;

//==================================================================*
//  Closes the output log.
//==================================================================*
dcl-proc Utils_closePrinter export;
  dcl-pi *n;
  end-pi;

  if (%open(QSYSPRT));
    close QSYSPRT;
  endif;

end-proc;

