**free
/if not defined(QUSLSPL)
/define QUSLSPL

//  List Spooled Files (QUSLSPL) API
dcl-pr QUSLSPL extpgm('QUSLSPL');
  i_qUsrSpc    char(20) const;
  i_format     char(8) const;
  i_user       char(10) const;
  i_qOutQ      char(20) const;
  i_formType   char(10) const;
  i_userData   char(10) const;
  io_errCode   char(65535) options(*nopass: *varsize); // optGrp 1
  i_qJob       char(26) options(*nopass) const; // optGrp 2
  i_keyFldsRtn int(10) options(*nopass) dim(32) const;
  i_numFldsRtn int(10) options(*nopass) const;
end-pr;

//  Input Parameter Section
dcl-ds QUSLSPL_inpParm_t qualified template;
  qUsrSpc    likeds(QUSLSPL_qObj_t);
  format     char(8);
  user       char(10);
  qOutQ      likeds(QUSLSPL_qObj_t);
  formType   char(10);
  userData   char(10);
  qJob       likeds(QUSLSPL_qJob_t);
  numKeyFlds int(10);
  flds       int(10) dim(32);
end-ds;

//  SPLF0100 List Data Section
dcl-ds splf0100_t qualified template;
  user       char(10);
  outQ       char(10);
  outQLib    char(10);
  formType   char(10);
  userData   char(10);
  intJobId   char(16);
  intSplFId  char(16);
  reserved_1 char(2);
  auxStgPool int(10);
end-ds;

dcl-ds QUSLSPL_qObj_t qualified template;
  name char(10);
  lib  char(10);
end-ds;

dcl-ds QUSLSPL_qJob_t qualified template;
  name char(10);
  user char(10);
  nbr  char(6);
end-ds;

/endif
