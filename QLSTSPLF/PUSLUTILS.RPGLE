**free
/if not defined(PUSLUTILS)
/define PUSLUTILS

/copy qlstsplf,fdqobj qualified object name structure
/copy qlstsplf,fdmsg Message structure
/copy qlstsplf,fderrcode API error code
/copy qlstsplf,genlsthdr Generic list API header

dcl-pr Utils_crtUsrSpc ind extproc('USLUTILS_Utils_crtUsrSpc');
  i_qUsrSpc likeds(qObj_t) value;
  i_text    char(50) value;
  o_errCode likeds(errCode_t);
end-pr;

dcl-pr Utils_getPtrUsrSpc pointer extproc('USLUTILS_Utils_getPtrUsrSpc');
  i_qUsrSpc likeds(qObj_t) value;
  o_errCode likeds(errCode_t);
end-pr;

dcl-pr Utils_dltUsrSpc ind extproc('USLUTILS_Utils_dltUsrSpc');
  i_qUsrSpc likeds(qObj_t) value;
end-pr;

dcl-pr Utils_getTmpName ind extproc('USLUTILS_Utils_getTmpName');
  o_qUsrSpc likeds(qObj_t);
end-pr;

dcl-pr Utils_getListEntry ind extproc('USLUTILS_Utils_getListEntry');
  i_pUsrSpc pointer const;
  i_index   int(10) const;
  i_length  int(10) const;
  o_data    char(32767) options(*varsize);
end-pr;

dcl-pr Utils_isApiError ind extproc('USLUTILS_Utils_isApiError');
  i_errCode likeds(errCode_t) value;
end-pr;

dcl-pr Utils_newApiErrCode likeds(errCode_t) extproc('USLUTILS_Utils_newApiErrCode');
  i_monmsg ind value;
end-pr;

dcl-pr Utils_cvtApiErrCodeToMsg likeds(msg_t) extproc('USLUTILS_Utils_cvtApiErrCodeToMsg');
  i_errCode likeds(errCode_t) value;
end-pr;

dcl-pr Utils_openPrinter extproc('USLUTILS_Utils_openPrinter');
end-pr;

dcl-pr Utils_print extproc('USLUTILS_Utils_print');
  i_text varchar(80) options(*nopass) const;
end-pr;

dcl-pr Utils_closePrinter extproc('USLUTILS_Utils_closePrinter');
end-pr;

/endif
