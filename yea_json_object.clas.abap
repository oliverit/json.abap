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
  methods PAIR
    importing
      !NAME type STRING
    returning
      value(RETURNING) type ref to YEA_JSON_PAIR .
  methods KEYS
    returning
      value(RETURNING) type STRINGTAB .
  methods INTEGER
    importing
      !KEY type STRING
    returning
      value(RETURNING) type INT4 .
  methods FLOAT
    importing
      !KEY type STRING
    returning
      value(RETURNING) type F .
  methods STRING
    importing
      !KEY type STRING
    returning
      value(RETURNING) type STRING .
  methods BOOLEAN
    importing
      !KEY type STRING
    returning
      value(RETURNING) type ABAP_BOOL .
  methods ARRAY
    importing
      !KEY type STRING
    returning
      value(RETURNING) type ref to YEA_JSON_ARRAY .
  methods OBJECT
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


  method ARRAY.
    try.
      returning = cast yea_json_array( me->pair( key )->value( ) ).
    catch cx_root.
    endtry.
  endmethod.


  method BOOLEAN.
    try.
      returning = cast yea_json_boolean( me->pair( key )->value( ) )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method FLOAT.
    try.
      returning = cast yea_json_number( me->pair( key )->value( ) )->get( ).
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


  method INTEGER.
    try.
      returning = cast yea_json_number( me->pair( key )->value( ) )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method KEYS.
    loop at me->_keys assigning field-symbol(<k>).
      append <k>-name to returning.
    endloop.
  endmethod.


  method OBJECT.
    try.
      returning = cast yea_json_object( me->pair( key )->value( ) ).
    catch cx_root.
    endtry.
  endmethod.


  method PAIR.
    try.
      returning = me->_keys[ name = name ]-pair.
    catch cx_root.
    endtry.
  endmethod.


  method REMOVE.
    if ( pair is bound ).
      delete me->_keys where name = pair->name( ).
      check sy-subrc = 0.
      returning = abap_true.
    endif.
  endmethod.


  method STRING.
    try.
      returning = cast yea_json_string( me->pair( key )->value( ) )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method yea_json_value~equal.
    if ( me = object ).
      returning = abap_true.
    endif.
  endmethod.


  method YEA_JSON_VALUE~TYPE.
    returning = yea_json_types=>type_object.
  endmethod.
ENDCLASS.
