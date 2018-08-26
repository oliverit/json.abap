interface YEA_JSON_VALUE
  public .


  methods TYPE
    returning
      value(RETURNING) type I .
  methods EQUAL
    importing
      !OBJECT type ref to YEA_JSON_VALUE
    returning
      value(RETURNING) type ABAP_BOOL .
endinterface.
