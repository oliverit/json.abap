class YEA_JSON_OBJECT definition
  public
  final
  create public .

public section.

  interfaces YEA_JSON_VALUE .

  methods ADD
    importing
      !PAIR type ref to YEA_JSON_PAIR
    returning
      value(RETURNING) type ABAP_BOOL .
  methods HAS
    importing
      !KEY type STRING
    returning
      value(RETURNING) type ABAP_BOOL .
  methods REMOVE
    importing
      !PAIR type ref to YEA_JSON_PAIR
    returning
      value(RETURNING) type ABAP_BOOL .
  methods GET
    importing
      !NAME type STRING
    returning
      value(RETURNING) type ref to YEA_JSON_PAIR .
  methods KEYS
    returning
      value(RETURNING) type STRINGTAB .
  methods GET_INT
    importing
      !KEY type STRING
    returning
      value(RETURNING) type INT4 .
  methods GET_FLOAT
    importing
      !KEY type STRING
    returning
      value(RETURNING) type F .
  methods GET_STRING
    importing
      !KEY type STRING
    returning
      value(RETURNING) type STRING .
  methods GET_BOOLEAN
    importing
      !KEY type STRING
    returning
      value(RETURNING) type ABAP_BOOL .
  methods GET_ARRAY
    importing
      !KEY type STRING
    returning
      value(RETURNING) type ref to YEA_JSON_ARRAY .
  methods GET_OBJECT
    importing
      !KEY type STRING
    returning
      value(RETURNING) type ref to YEA_JSON_OBJECT .
protected section.
private section.

  types:
    begin of __jkey,
      name type string,
      pair type ref to yea_json_pair,
    end of __jkey.
  types: __t_jkey type hashed table of __jkey with unique key name.
  data: _keys type __t_jkey.
ENDCLASS.



CLASS YEA_JSON_OBJECT IMPLEMENTATION.


  method ADD.
    insert value __jkey( name = pair->name( ) pair = pair ) into table _keys.
  endmethod.


  method GET.
    try.
      returning = me->_keys[ name = name ]-pair.
    catch cx_root.
    endtry.
  endmethod.


  method GET_ARRAY.
    try.
      returning = cast yea_json_array( me->get( key )->value( ) ).
    catch cx_root.
    endtry.
  endmethod.


  method GET_BOOLEAN.
    try.
      returning = cast yea_json_boolean( me->get( key )->value( ) )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method GET_FLOAT.
    try.
      returning = cast yea_json_number( me->get( key )->value( ) )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method GET_INT.
    try.
      returning = cast yea_json_number( me->get( key )->value( ) )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method GET_OBJECT.
    try.
      returning = cast yea_json_object( me->get( key )->value( ) ).
    catch cx_root.
    endtry.
  endmethod.


  method GET_STRING.
    try.
      returning = cast yea_json_string( me->get( key )->value( ) )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method HAS.
    try.
      read table me->_keys with table key name = key transporting no fields.
      if ( sy-subrc = 0 ).
        returning = abap_true.
      endif.
    catch cx_root.
    endtry.
  endmethod.


  method KEYS.
    loop at me->_keys assigning field-symbol(<k>).
      append <k>-name to returning.
    endloop.
  endmethod.


  method REMOVE.
    if ( pair is bound ).
      delete me->_keys where name = pair->name( ).
      check sy-subrc = 0.
      returning = abap_true.
    endif.
  endmethod.


  method YEA_JSON_VALUE~TYPE.
    returning = yea_json_types=>type_object.
  endmethod.
ENDCLASS.
