class YEA_JSON_ARRAY definition
  public
  final
  create public .

public section.

  interfaces YEA_JSON_VALUE .

  methods APPEND
    importing
      !VALUE type ref to YEA_JSON_VALUE .
  methods REMOVE
    importing
      !VALUE type ref to YEA_JSON_VALUE
    returning
      value(RETURNING) type ABAP_BOOL .
  methods GET
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ref to YEA_JSON_VALUE .
  methods SIZE
    returning
      value(RETURNING) type INT4 .
  methods TO_STRING
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type STRING .
  methods TO_INT
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type INT4 .
  methods TO_FLOAT
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type F .
  methods TO_BOOLEAN
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ABAP_BOOL .
  methods TO_OBJECT
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ref to YEA_JSON_OBJECT .
  methods TO_ARRAY
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ref to YEA_JSON_ARRAY .
  protected section.
  private section.

    types: __lvalue type standard table of ref to yea_json_value.
    data: _values type __lvalue.

ENDCLASS.



CLASS YEA_JSON_ARRAY IMPLEMENTATION.


  method append.
    append value to _values.
  endmethod.


  method get.
    try.
        returning = _values[ index ].
      catch cx_root.
    endtry.
  endmethod.


  method remove.
    delete _values where table_line = value.
    check sy-subrc = 0.
    returning = abap_true.
  endmethod.


  method size.
    returning = lines( _values ).
  endmethod.


  method TO_ARRAY.
    try.
      data(idx) = index + 1.
      returning = cast yea_json_array( _values[ idx ] ).
    catch cx_root.
    endtry.
  endmethod.


  method TO_BOOLEAN.
    try.
      data(idx) = index + 1.
      returning = cast yea_json_boolean( _values[ idx ] )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method TO_FLOAT.
    try.
      data(idx) = index + 1.
      returning = cast yea_json_number( _values[ idx ] )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method TO_INT.
    try.
      data(idx) = index + 1.
      returning = cast yea_json_number( _values[ idx ] )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method TO_OBJECT.
    try.
      data(idx) = index + 1.
      returning = cast yea_json_object( _values[ idx ] ).
    catch cx_root.
    endtry.
  endmethod.


  method TO_STRING.
    try.
      data(idx) = index + 1.
      returning = cast yea_json_string( _values[ idx ] )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method yea_json_value~type.
    returning = yea_json_types=>type_array.
  endmethod.
ENDCLASS.
